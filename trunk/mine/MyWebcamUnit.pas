unit MyWebcamUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SyncObjs, ClientThread, CommunicatorTypes, DateUtils,
  DSPack, Menus, DSUtil, DirectShow9, VideoHeader, StdCtrls, PreferencesUnit;

type
  TFormCloseEvent = procedure of object;

  TWebcamInputThread = class(TThread)
  private
    FClientThread: TClientThread;
    FOWner: TObject;
    FThreadTerminated: Boolean;
    FJoinLeftCamList: TStringList;
    FJoinLeftCamCriticalSection: TCriticalSection;
    procedure ProccesPacket(Packet: PCommunicatorPacket);
    procedure ExecuteCamUserJoinLeftPacket(Packet: PCommunicatorPacket);
  protected
    procedure Execute; override;
    procedure DoAction;
  public
    property ClientThread: TClientThread read FClientThread write FClientThread;
    property Owner: TObject read FOWner write FOWner;
    property ThreadTerminated: Boolean read FThreadTerMinated;
    property JoinLeftCriticalSection: TCriticalSection read FJoinLeftCamCriticalSection;
    property JoinLeftCamList: TStringList read FJoinLeftCamList;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

  TMyCamForm = class(TForm)
    VideoWindow: TVideoWindow;
    FilterGraph: TFilterGraph;
    MainMenu1: TMainMenu;
    Devices: TMenuItem;
    Filter: TFilter;
    SampleGrabber: TSampleGrabber;
    View1: TMenuItem;
    Alwaysontop1: TMenuItem;
    Size1: TMenuItem;
    Small1: TMenuItem;
    Medium1: TMenuItem;
    Larg1: TMenuItem;
    Setting1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SampleGrabberBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Small1Click(Sender: TObject);
    procedure Medium1Click(Sender: TObject);
    procedure Larg1Click(Sender: TObject);
    procedure Alwaysontop1Click(Sender: TObject);
    procedure Setting1Click(Sender: TObject);
  private
    { Private declarations }
    FUpLoadStarted: Boolean;
    IgnoreThis: Boolean;
//    AvgBytesDecoded: Cardinal;
    AvgFramePerSec: Cardinal;
    ClientThread: TClientThread;
    FWebcamPort: Word;
    InputThread: TWebcamInputThread;
    InBuffer: Pointer;
    InterFrameCounter: Integer;
    FPublishCode: string;
    FCamFrameSetPacket: PFrameSetPacket;
    FFormCloseEvent: TFormCloseEvent;
    FirstTimeGoingToView: Boolean;

    FFrameWidth: Integer;
    FFrameHeight: Integer;
    EncoderHandle: Pointer;
    Buf1: Pointer;
    BFrameCount: Integer;
    LastEncodeTime: TDateTime;
    procedure SendUploadRequestPacket;
    procedure OnSelectDevice(sender: TObject);
    function SetVideoProperties(pVideoCapture: IBaseFilter):Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    property WebcamPort: Word read FWebcamPort write FWebcamPort;
    property PublishCode: string read FPublishCode write FPublishCode;
    property OnFormCloseEvent: TFormCloseEvent read FFormCloseEvent write FFormCloseEvent;
  end;

var
  MyCamForm: TMyCamForm;
  SysDev: TSysDevEnum;

implementation

uses MainUnit;

{$R *.dfm}

procedure TMyCamForm.FormCreate(Sender: TObject);
var
  i: integer;
  Device: TMenuItem;
begin
  GetMem(FCamFrameSetPacket,20000);
  FCamFrameSetPacket.Signature := PACKET_SIGNATURE;
  FCamFrameSetPacket.Version := PACKET_VERSION;
  FCamFrameSetPacket.DataType := pdtCamFrameSet;
  FirstTimeGoingToView := True;
  SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  if SysDev.CountFilters > 0 then
    for i := 0 to SysDev.CountFilters - 1 do
    begin
      Device := TMenuItem.Create(Devices);
      Device.Caption := SysDev.Filters[i].FriendlyName;
      Device.Tag := i;
      Device.OnClick := OnSelectDevice;
      Devices.Add(Device);
    end;

end;

procedure TMyCamForm.FormDestroy(Sender: TObject);
begin
  if Buf1=nil then
    Exit;
  FreeMem(Buf1);
  FreeMem(FCamFrameSetPacket);
//  FVideoCapture.Free;
end;

procedure TMyCamForm.OnSelectDevice(sender: TObject);
var
  MediaType: _AMMediaType;
begin
  MainForm.FSystemPreferences.myWebcamDeviceIndex := TMenuItem(Sender).tag;
  FilterGraph.ClearGraph;
  FilterGraph.Active := False;
  Filter.BaseFilter.Moniker := SysDev.GetMoniker(TMenuItem(Sender).tag);
  //SampleGrabber.SampleGrabber.SetMediaType()
  FilterGraph.Active := true;
  if MainForm.FSystemPreferences.myWebcamAuto then
     SetVideoProperties(Filter as iBaseFilter);
  with FilterGraph as ICaptureGraphBuilder2 do
  //TBug Try must First
  try
    RenderStream(@PIN_CATEGORY_PREVIEW, nil, Filter as IBaseFilter, SampleGrabber as IBaseFilter, VideoWindow as IbaseFilter);
    FilterGraph.Play;
  except
    ShowMessage('Unable to use specified device!')
  end;
//  StartTime := Now;
end;

procedure TMyCamForm.SampleGrabberBuffer(sender: TObject;
  SampleTime: Double; pBuffer: Pointer; BufferLen: Integer);
var
  hr         : HRESULT;
  BMIHeader  : TBitmapInfoHeader;
  AMediaType : TAMMediaType;
  OutBufSize: Integer;
  IFrame: Boolean;
begin
  IFrame := True;
  if FFrameWidth = 0 then
  begin
    hr := SampleGrabber.SampleGrabber.GetConnectedMediaType(AMediaType);
    if (hr <> S_OK) then exit;
    //PVideoInfoHeader2(Amediatype.pbFormat)^.bmiHeader.
    if IsEqualGUID(AMediaType.majortype, MEDIATYPE_Video) then
    begin
      case Amediatype.formattype.D1 of
        $05589F80: BMIHeader := PVideoInfoHeader(Amediatype.pbFormat)^.bmiHeader;
        $F72A76A0: BMIHeader := PVideoInfoHeader2(Amediatype.pbFormat)^.bmiHeader;
      end;
    end;

    FFrameWidth := BMIHeader.biWidth;
    FFrameHeight := BMIHeader.biHeight;
    EncoderHandle := InitCompressor(FFrameWidth,FFrameHeight);
    GetMem(Buf1,FFrameWidth*FFrameHeight*4);
  end;
  if EncoderHandle<>nil then
  begin
    if MilliSecondsBetween(Now,LastEncodeTime)<60 then
      Exit;
    if BFrameCount = 0 then
      IFrame := True
    else
      IFrame := False;

    OutBufSize := FFrameWidth*FFrameHeight*4;

    EncodeFrameSet(EncoderHandle,pBuffer,Buf1,BufferLen,OutBufSize,IFrame);
    if IFrame then
      FCamFrameSetPacket.FrameType := 0      // 1 is normal Frame and 0 id I Frame
    else
      FCamFrameSetPacket.FrameType := 1;

    LastEncodeTime := Now;

    if IFrame then
      IFrame := False;
    if not IFrame then
      Inc(BFrameCount);
    if BFrameCount = 5 then
      BFrameCount := 0;

    if FUpLoadStarted and (OutBufSize<70000) then
    begin
      FCamFrameSetPacket.Width := FFrameWidth;
      FCamFrameSetPacket.Height := FFrameHeight;
      FCamFrameSetPacket.BufferSize := SizeOf(TFrameSetPacket)+OutBufSize;

      CopyMemory(Pointer(Cardinal(FCamFrameSetPacket)+SizeOf(TFrameSetPacket)),Buf1,OutBufSize);
      //FCamFrameSetPacket.FrameType := FrameType;
      FCamFrameSetPacket.TimeStamp := Now;
      ClientThread.SendBuffer(FCamFrameSetPacket,FCamFrameSetPacket.BufferSize);
    end;
  end;
end;


procedure TMyCamForm.FormShow(Sender: TObject);
begin

  ClientThread := TClientThread.Create(True);
  ClientThread.RemoteHost := MainForm.ServerIp;
  ClientThread.RemotePort := IntToStr(FWebcamPort);
  ClientThread.Connect;
  ClientThread.Resume;

  InputThread := TWebcamInputThread.Create(True);
  InputThread.Owner := Self;
  InputThread.ClientThread := ClientThread;
  InputThread.FreeOnTerminate := True;
  InputThread.Resume;

  SendUploadRequestPacket;

  if SysDev.CountFilters > MainForm.FSystemPreferences.myWebcamDeviceIndex then
    OnSelectDevice(Devices.Items[MainForm.FSystemPreferences.myWebcamDeviceIndex]);
  if MainForm.FSystemPreferences.myWebcamMyCamSize < 3 then
    Size1.Items[MainForm.FSystemPreferences.myWebcamMyCamSize].Click;

  if MainForm.FSystemPreferences.myWebcamAlwayonTop then
    begin
        SetWindowPos(Handle,HWND_TOPMOST,Left,Top, Width,Height,
                     SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
      Alwaysontop1.Checked := True;
    end
  else
    begin
      SetWindowPos(Handle,HWND_NOTOPMOST,Left,Top, Width,Height,
                   SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
      Alwaysontop1.Checked := False;
    end;
end;

procedure TMyCamForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  ClientThread.Terminate;
  InputThread.Terminate;
  // Its necessary to stop filtergraph before freeing
  // clientthread otherwise it may call samplegrabberbuffer
  // and there will be exception due calling freed object
  FilterGraph.Stop;
  FilterGraph.Active := False;
  while not ClientThread.ThreadTerminated do
  begin
    Sleep(10);
    Inc(i);
    if i=30 then
      break;
  end;
  ClientThread.Free;
  if Assigned(FFormCloseEvent) then
    FFormCloseEvent;
end;

{ TWebcamInputThread }

constructor TWebcamInputThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FJoinLeftCamList := TStringList.Create;
  FJoinLeftCamCriticalSection := TCriticalSection.Create;
end;

destructor TWebcamInputThread.Destroy;
begin
  FJoinLeftCamCriticalSection.Free;
  FJoinLeftCamList.Free;
  inherited;
end;

procedure TWebcamInputThread.DoAction;
var
  Buffer: Pointer;
  BufferSize: Integer;
  MyCamWindow: TMyCamForm;
begin
  MyCamWindow := TMyCamForm(FOWner);
  while ClientThread.InputBufferList.Count>0 do
  begin
    Buffer := ClientThread.InputBufferList.Items[0];
    BufferSize := PCommunicatorPacket(Buffer).BufferSize;
    CopyMemory(MyCamWindow.InBuffer,Buffer,BufferSize);
    FreeMem(Buffer);
    ProccesPacket(MyCamWindow.InBuffer);
    MyCamWindow.ClientThread.InputCriticalSection.Enter;
    MyCamWindow.ClientThread.InputBufferList.Delete(0);
    MyCamWindow.ClientThread.InputCriticalSection.Leave;
  end;
end;

procedure TWebcamInputThread.Execute;
begin
  inherited;
  while not Terminated do
  begin
    Sleep(1);
    DoAction;
  end;
  FThreadTerminated := True;
end;

procedure TWebcamInputThread.ExecuteCamUserJoinLeftPacket(
  Packet: PCommunicatorPacket);
begin

end;

procedure TWebcamInputThread.ProccesPacket(Packet: PCommunicatorPacket);
begin
  case Packet.DataType of
  pdtCamSessionJoinLeft: ExecuteCamUserJoinLeftPacket(PCommunicatorPacket(Packet));
//  pdtUserJoinLeftRoom: ExecuteUserJoinLeftRoomPacket(PUserJoinLeftRoomPacket(Packet));
//  pdtGroupMessage: ExecuteGroupMessagePacket(PGroupMessagePacket(Packet));
//  pdtGroupVoicePacket: ExecuteGroupVoicePacket(PGroupVoicePacket(Packet));
//  pdtReqNextVCPacket: ExecuteReqNextVCPacket(PCommunicatorPacket(Packet));
//  pdtMicGrantedPacket: ExecuteMicGrantedPacket(Packet);
//  pdtRaiseHandPacket: ExecuteRaiseHandPacket(PRaiseHandPacket(Packet));
//  pdtRoomUserStatChange: ExecuteRaiseHandPacket(PRaiseHandPacket(Packet));
//  pdtMicFreePacket: ExecuteMicFreePacket(Packet);
  end;
end;

procedure TMyCamForm.SendUploadRequestPacket;
var
  Packet: TCamUploadRequestPacket;
begin
  //SampleGrabber.OnBuffer
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtCamUploadRequest;
  Packet.BufferSize := SizeOf(TCamUploadRequestPacket);
  Packet.LoginSession := 0;
  StrCopy(Packet.UserName,PChar(MainForm.MyNickName));
  StrCopy(Packet.PublisherCode,PChar(FPublishCode));
  ClientThread.SendBuffer(@Packet,SizeOf(TCamUploadRequestPacket));
  FUpLoadStarted := True;
end;

procedure TMyCamForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TMyCamForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  ShowFilterPropertyPage(Handle,Filter as IBaseFilter);
end;

procedure TMyCamForm.Small1Click(Sender: TObject);
begin
MyCamForm.ClientHeight := 120;
MyCamForm.ClientWidth := 160;
MainForm.FSystemPreferences.myWebcamMyCamSize := 0;
end;

procedure TMyCamForm.Medium1Click(Sender: TObject);
begin
MyCamForm.ClientHeight := 240;
MyCamForm.ClientWidth := 320;
MainForm.FSystemPreferences.myWebcamMyCamSize := 1;
end;

procedure TMyCamForm.Larg1Click(Sender: TObject);
begin
MyCamForm.ClientHeight := 360;
MyCamForm.ClientWidth := 480;
MainForm.FSystemPreferences.myWebcamMyCamSize := 2;
end;

procedure TMyCamForm.Alwaysontop1Click(Sender: TObject);
begin

if Alwaysontop1.Checked then
  SetWindowPos(Handle,HWND_TOPMOST,Left,Top, Width,Height,
               SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE)
else
  SetWindowPos(Handle,HWND_NOTOPMOST,Left,Top, Width,Height,
               SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

end;

procedure TMyCamForm.Setting1Click(Sender: TObject);
begin
  PreferencesForm.Show;
  PreferencesForm.WebcamToolBringup;
  if MainForm.Left > 500 then
   PreferencesForm.Left := MainForm.Left - 300
  else
   PreferencesForm.Left := MainForm.Left + 100;
   
  PreferencesForm.ItemsListBox.ItemIndex := 5;

end;

function TMyCamForm.SetVideoProperties(pVideoCapture: IBaseFilter):Boolean;
var
  hr:HRESULT;
  pStreamConfig: IAMStreamConfig;
  pAM_Media: PAMMediaType;
  pvih: PVIDEOINFOHEADER;
  pICGP2: ICaptureGraphBuilder2;
begin

  pICGP2 := FilterGraph as ICaptureGraphBuilder2;
  hr := pICGP2.FindInterface(@PIN_CATEGORY_CAPTURE, nil, pVideoCapture,
                             IID_IAMStreamConfig, pStreamConfig);

  if (SUCCEEDED(hr)) then begin

    pStreamConfig.GetFormat(pAM_Media);
    pvih := pAM_Media.pbFormat ;
    pAM_Media.subtype := MEDIASUBTYPE_RGB24;
    pvih.bmiHeader.biWidth := 320;
    pvih.bmiHeader.biHeight := 240;
    pvih.AvgTimePerFrame := 10000000 div 15;
    pStreamConfig.SetFormat(pAM_Media^);
    DeleteMediaType(pAM_Media);
    pStreamConfig := nil;
  end;

end;

end.
