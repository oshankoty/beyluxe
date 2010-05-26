unit WebCamViewerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SyncObjs, ClientThread, CommunicatorTypes, VideoHeader,
  GR32_Image, ExtCtrls, Menus, PreferencesUnit;

const
  WCM_DISPLAYFRAME = WM_USER + $201;
type
  TOnCloseCamViewer = procedure (Viewer: TObject) of object;
  TWebcamInputThread = class(TThread)
  private
    FClientThread: TClientThread;
    FOWner: TObject;
    FThreadTerminated: Boolean;
    FFrameList: TList;
    FFrameListCriticalSection: TCriticalSection;
    FFirstFrameTimeStamp: TDateTime;
//    FCurrentFrameTimeStamp: TDateTime;
    FFirstShowTime: TDateTime;
    FFirst: Boolean;

    FFrameWidth: Integer;
    FFrameHeight: Integer;
    procedure ProccesPacket(Packet: PCommunicatorPacket);
    procedure ExecuteCamFrameSetPacket(Packet: PFrameSetPacket);
  protected
    procedure Execute; override;
    procedure DoAction;
  public
    property ClientThread: TClientThread read FClientThread write FClientThread;
    property Owner: TObject read FOWner write FOWner;
    property ThreadTerminated: Boolean read FThreadTerMinated;
    property FrameListCriticalSection: TCriticalSection read FFrameListCriticalSection;
    property FrameList: TList read FFrameList;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

  TWebcamViewerForm = class(TForm)
    Image: TImage32;
    RepaintTimer: TTimer;
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    Size1: TMenuItem;
    Small1: TMenuItem;
    Medium1: TMenuItem;
    Larg1: TMenuItem;
    Alwaysontop1: TMenuItem;
    Close1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RepaintTimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Alwaysontop1Click(Sender: TObject);
    procedure Small1Click(Sender: TObject);
    procedure Medium1Click(Sender: TObject);
    procedure Larg1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Close1Click(Sender: TObject);
  private
    { Private declarations }
    m_bmpinfo: TBITMAPINFO;
    ClientThread: TClientThread;
    FWebcamPort: Word;
    InputThread: TWebcamInputThread;
    Closed: Boolean;
    DecodeBuffer: Pointer;
    FrameWidth: Integer;
    FrameHeight: Integer;
    FOnCloseCamViewer: TOnCloseCamViewer;
    FirstTimeGoingToDisplay: Boolean;
    DecodeBufferSize: Integer;
    DecoderHandle: Pointer;
    LastClientWidth: Integer;
    LastClientHeight: Integer;
    FCamUser: string;
    procedure DisplayFrame(var Msg: TMessage); message WCM_DISPLAYFRAME;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    property WebcamPort: Word read FWebcamPort write FWebcamPort;
    property OnCloseCamViewerForm: TOnCloseCamViewer read FOnCloseCamViewer write FOnCloseCamViewer;
    property CamUsername: string read FCamUser write FCamUser;
  end;

implementation

uses MainUnit, DateUtils;

{$R *.dfm}

{ TWebcamInputThread }

constructor TWebcamInputThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FFirst := True;
  FFrameList := TList.Create;
  FFrameListCriticalSection := TCriticalSection.Create;
end;

destructor TWebcamInputThread.Destroy;
begin
  FFrameListCriticalSection.Free;
  while FrameList.Count>0 do
  begin
    FreeMem(FrameList.Items[0]);
    FrameList.Delete(0);
  end;
  FFrameList.Free;
  inherited;
end;

procedure TWebcamInputThread.DoAction;
var
  Buffer: Pointer;
  //BufferSize: Integer;
  CamViewerWindow: TWebcamViewerForm;
begin
  CamViewerWindow := TWebcamViewerForm(FOWner);
  while ClientThread.InputBufferList.Count>0 do
  begin
    Buffer := ClientThread.InputBufferList.Items[0];
    //BufferSize := PCommunicatorPacket(Buffer).BufferSize;
    ProccesPacket(Buffer);
    FreeMem(Buffer);
    CamViewerWindow.ClientThread.InputCriticalSection.Enter;
    CamViewerWindow.ClientThread.InputBufferList.Delete(0);
    CamViewerWindow.ClientThread.InputCriticalSection.Leave;
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

procedure TWebcamInputThread.ExecuteCamFrameSetPacket(
  Packet: PFrameSetPacket);
var
  Buffer: Pointer;
begin
  if FFirst and (Packet.FrameType = 1) then
    Exit;
  GetMem(Buffer,Packet.BufferSize);
  CopyMemory(Buffer,Packet,Packet.BufferSize);
  FrameListCriticalSection.Enter;
  FFrameList.Add(Buffer);
  FrameListCriticalSection.Leave;
  if FFirst then
  begin
    FFirstFrameTimeStamp := Packet.TimeStamp;
    FFrameWidth := Packet.Width;
    FFrameHeight := Packet.Height;
    FFirstShowTime := Now;
    FFirst := False;
  end;
  //TBug
  try
    if MilliSecondsBetween(FFirstFrameTimeStamp,Packet.TimeStamp)>MilliSecondsBetween(FFirstShowTime,Now) then
      Sleep(MilliSecondsBetween(FFirstFrameTimeStamp,Packet.TimeStamp)-MilliSecondsBetween(FFirstShowTime,Now));
  except
  end;
  PostMessage(TWebcamViewerForm(FOWner).Handle,WCM_DISPLAYFRAME,0,0);
  //FLastFrameTimeStamp := Packet.TimeStamp;
  //FLastShowTimeStamp := Now;
end;

procedure TWebcamInputThread.ProccesPacket(Packet: PCommunicatorPacket);
begin
  case Packet.DataType of
  pdtCamFrameSet: ExecuteCamFrameSetPacket(PFrameSetPacket(Packet));
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

procedure TWebcamViewerForm.FormShow(Sender: TObject);
begin
  FirstTimeGoingToDisplay := True;
  ClientThread := TClientThread.Create(True);
  ClientThread.RemoteHost := MainForm.ServerIp;
  ClientThread.RemotePort := IntToStr(FWebcamPort);
  ClientThread.Connect;
  ClientThread.Resume;
  ClientThread.FreeOnTerminate := False;

	//m_bmpinfo.bmiHeader.biHeight := IMAGE_HEIGHT - 8;
//  DrawDibBegin(hdib,Canvas.Handle,-1,-1,@m_bmpInfo,IMAGE_WIDTH,IMAGE_HEIGHT,0);
	//m_bmpinfo.bmiHeader.biHeight := IMAGE_HEIGHT + 8;

  InputThread := TWebcamInputThread.Create(True);
  InputThread.Owner := Self;
  InputThread.ClientThread := ClientThread;
  InputThread.FreeOnTerminate := False;
  InputThread.Resume;
  LastClientWidth := ClientWidth;
  LastClientHeight := ClientHeight;
  RepaintTimer.Enabled := True;

  if MainForm.FSystemPreferences.ViewWebcamSize < 3 then
    Size1.Items[MainForm.FSystemPreferences.ViewWebcamSize].Click;
end;

procedure TWebcamViewerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RepaintTimer.Enabled := False;
  //TBUG  Thread and Timer must DeActive
  Closed := True;
  InputThread.Terminate;
  ClientThread.Terminate;

  while not InputThread.ThreadTerminated do
    Sleep(1);
  while not ClientThread.ThreadTerminated do
    Sleep(1);

  InputThread.Free;
  ClientThread.Free;
  if Assigned(OnCloseCamViewerForm) then
    FOnCloseCamViewer(Self);
  if DecodeBuffer<>nil then
    FreeMem(DecodeBuffer);
//  DrawDibEnd(hdib);
//  DrawDibClose(hdib);
  Action := caFree;
end;

procedure TWebcamViewerForm.DisplayFrame(var Msg: TMessage);
var
  SrcBuffer: Pointer;
  SrcBufferSize: Integer;
  Bits: Pointer;
//  DecodeBufferSize: Integer;
begin
  if Closed then
  begin
    Exit;
  end;
  if FirstTimeGoingToDisplay then
  begin
    FrameWidth := InputThread.FFrameWidth;
    FrameHeight := InputThread.FFrameHeight;
    DecodeBufferSize := FrameWidth * FrameHeight * 4;
    GetMem(DecodeBuffer,DecodeBufferSize);
    DecoderHandle := InitDeCompressor(FrameWidth,FrameHeight);
    Image.Bitmap.SetSize(InputThread.FFrameWidth,FrameHeight);
    FirstTimeGoingToDisplay := False;
  end;
  SrcBuffer := Pointer(Cardinal(InputThread.FrameList.Items[0])+SizeOf(TFrameSetPacket));
  SrcBufferSize := PFrameSetPacket(InputThread.FrameList.Items[0]).BufferSize - SizeOf(TFrameSetPacket);
  DecodeBufferSize := InputThread.FFrameWidth * InputThread.FFrameHeight * 4;
  DecodeFrameSet(DecoderHandle,SrcBuffer,DecodeBuffer,SrcBufferSize,DecodeBufferSize);
  Image.Canvas.Lock;
  Bits := Image.Bitmap.bits;
  Image.BeginUpdate;
  CopyMemory(Bits,DecodeBuffer,DecodeBufferSize);
  Image.Bitmap.FlipVert;
  Image.EndUpdate;
  Image.Canvas.Unlock;
  //MainForm.VCMCriticalSection.Enter;
  //MainForm.VCM.DeCompressFrameSet(SrcBuffer,SrcBufferSize,DecodeBuffer,DecodeBufferSize);
  //MainForm.VCMCriticalSection.Leave;
  //DrawDibDraw(hdib,Canvas.Handle,0,0,ClientWidth,ClientHeight,@m_bmpInfo,DecodeBuffer,0,0,IMAGE_WIDTH,IMAGE_HEIGHT,DDF_SAME_DRAW);
  //MainForm.Memo2.Lines.Add(DateTimeToStr(Now)+':'+IntToStr(MilliSecondOf(Now)));
  FreeMem(InputThread.FrameList.Items[0]);
  InputThread.FrameListCriticalSection.Enter;
  InputThread.FrameList.Delete(0);
  InputThread.FrameListCriticalSection.Leave;
end;

procedure TWebcamViewerForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := 0;
end;

procedure TWebcamViewerForm.RepaintTimerTimer(Sender: TObject);
begin
  Image.Repaint;
end;

procedure TWebcamViewerForm.FormResize(Sender: TObject);
begin
  if (FrameWidth>0) and (FrameHeight>0) and (ClientWidth>0) and (ClientHeight>0) then
  begin
    if ClientWidth>LastClientWidth then
      ClientHeight := Round((ClientWidth*FrameHeight)/FrameWidth)
    else
    if ClientHeight>LastClientHeight then
      ClientWidth := Round((ClientHeight*FrameWidth)/FrameHeight)
    else
    if ClientWidth<LastClientWidth then
      ClientHeight := Round((ClientWidth*FrameHeight)/FrameWidth)
    else
    if ClientHeight<LastClientHeight then
      ClientWidth := Round((ClientHeight*FrameWidth)/FrameHeight);
    LastClientWidth := ClientWidth;
    LastClientHeight := ClientHeight;
  end;
end;

procedure TWebcamViewerForm.Alwaysontop1Click(Sender: TObject);
begin
  if Alwaysontop1.Checked then
    SetWindowPos(Handle,HWND_TOPMOST,Left,Top, Width,Height,
                 SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE)
  else
    SetWindowPos(Handle,HWND_NOTOPMOST,Left,Top, Width,Height,
                 SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TWebcamViewerForm.Small1Click(Sender: TObject);
begin
ClientHeight := 116;
ClientWidth := 162;
MainForm.FSystemPreferences.ViewWebcamSize := 0;
end;

procedure TWebcamViewerForm.Medium1Click(Sender: TObject);
begin
ClientHeight := 240;
ClientWidth := 322;
MainForm.FSystemPreferences.ViewWebcamSize := 1;
end;

procedure TWebcamViewerForm.Larg1Click(Sender: TObject);
begin
ClientHeight := 364;
ClientWidth := 482;
MainForm.FSystemPreferences.ViewWebcamSize := 2;
end;

procedure TWebcamViewerForm.FormCreate(Sender: TObject);
begin
if MainForm.FSystemPreferences.ViewWebcamOnTop then
  begin
    SetWindowPos(Handle,HWND_TOPMOST,Left,Top, Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    Alwaysontop1.Checked := True;
  end
else
   begin
     SetWindowPos(Handle,HWND_NOTOPMOST,Left,Top, Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
     Alwaysontop1.Checked := False;
   end;
end;

procedure TWebcamViewerForm.Close1Click(Sender: TObject);
begin
Close;
end;

end.
