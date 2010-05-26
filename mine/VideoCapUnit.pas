unit VideoCapUnit;

interface

uses
  Windows, VFW, Classes, Dialogs, Forms, SysUtils;

const
  IMAGE_WIDTH = 176;
  IMAGE_HEIGHT = 144;

type
  TVideoCapture = class(TObject)
  private
//    FBitmapInfo: TBitmapInfo;
    FDriverIndex: Integer;
    FVideoWindowHandle: HWND;
    FOwner: TObject;
    procedure SetDriverIndex(const Value: Integer);
    procedure SetVideoWindowHandle(const Value: HWND);
    function GetFormatSize(bmp: BITMAPINFO): Integer;
    function GetImageSize(bmp: BITMAPINFO): Integer;
    function SetCapturePara: Boolean;
  public
    m_bmpinfo: TBITMAPINFO;
    constructor Create(AOwner: TObject);
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure GetDriverList(DriverList: TStringList);

    function AllocateMemory(var BmpInfo: PBITMAPINFO): Integer;
    function Initialize: Boolean;
    function UnInitialize: Boolean;
    property DRiverIndex: Integer read FDriverIndex write SetDriverIndex;
    property VideoWindowHandle: HWND read FVideoWindowHandle write SetVideoWindowHandle;
  end;

function OnCaptureVideo(mWnd:HWND; lpVHdr:PVIDEOHDR):LongInt; stdcall;

implementation

{ TVideoCap }

uses
  MainUnit, MyWebCamUnit, DateUtils;

function TVideoCapture.GetFormatSize(bmp: BITMAPINFO): Integer;
var
  Size: Integer;
begin
  if bmp.bmiHeader.biSize<>0 then
    Size := bmp.bmiHeader.biSize
  else
    Size := sizeof(BITMAPINFOHEADER);
	Result := Size;
end;

function TVideoCapture.GetImageSize(bmp: BITMAPINFO): Integer;
var
  size: Integer;
  head: BITMAPINFOHEADER;
begin
  head := bmp.bmiHeader;
	if head.biSizeImage=0 then
		size := Round((head.biWidth * head.biHeight * head.biBitCount)/8)
	else
	  size := head.biSizeImage;

  Result := size;

end;

function TVideoCapture.AllocateMemory(var BmpInfo: PBITMAPINFO): Integer;
var
  Size1,Size2,Size: Integer;
  tbmp: BITMAPINFO;
//  str: array [0..200] of char;
begin

	capGetVideoFormat(FVideoWindowHandle,@tbmp,sizeof(BITMAPINFO));

	size1 := getFormatSize ( tbmp );
	size2 := getImageSize ( tbmp );
	size := size1 + size2;


	//bmpinfo := (BITMAPINFO *) new BYTE[size];
  GetMem(BmpInfo,size);

	FillMemory(bmpinfo,sizeof(BITMAPINFO),0);

	capGetVideoFormat(FVideoWindowHandle,bmpinfo,sizeof( BITMAPINFO));
	Result := size1;

end;

function TVideoCapture.SetCapturePara: Boolean;
var
  CapParams: TCaptureParms;
begin
	capCaptureGetSetup(FVideoWindowHandle,@CapParams,sizeof(CapParams));

	CapParams.fAbortLeftMouse := FALSE;
	CapParams.fAbortRightMouse := FALSE;
	CapParams.fYield := True;
	CapParams.fCaptureAudio := False;
	CapParams.wPercentDropForError := 50;

	if capCaptureSetSetup(FVideoWindowHandle,@CapParams,sizeof(CapParams)) = False then
  begin
    ShowMessage('Unable to Setup Cature.');
	  Result := False;
    Exit
  end;
	// Set Video Format

	capGetVideoFormat(FVideoWindowHandle,@m_bmpinfo,sizeof(m_bmpinfo));
	m_bmpinfo.bmiHeader.biWidth := IMAGE_WIDTH;
	m_bmpinfo.bmiHeader.biHeight := IMAGE_HEIGHT;
  m_bmpinfo.bmiHeader.biCompression := BI_RGB;
	m_bmpinfo.bmiHeader.biBitCount := 24;
	m_bmpinfo.bmiHeader.biSizeImage := (IMAGE_WIDTH*IMAGE_HEIGHT*24) div 8;

	if not capSetVideoFormat(FVideoWindowHandle,@m_bmpinfo,sizeof(m_bmpinfo)) then
  begin
    ShowMessage('Unable to Setup Desired Format.');
    Result := False;
    Exit;
  end;
	Result := True;
end;

constructor TVideoCapture.Create(AOwner: TObject);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TVideoCapture.Destroy;
begin

  inherited;
end;

procedure TVideoCapture.GetDriverList(DriverList: TStringList);
var
  i: Integer;
  DrvName: array[0..80] of char;
  DrvVer: array[0..80] of char;
begin
  DriverList.Clear;
  for i:= 0 to 9 do
    if capGetDriverDescription(i,DrvName,80,DrvVer,80) then
      DriverList.Add(DrvName+' '+DrvVer)
    else
      Break;
end;

procedure TVideoCapture.SetDriverIndex(const Value: Integer);
begin
  FDriverIndex := Value;
end;

procedure TVideoCapture.SetVideoWindowHandle(const Value: HWND);
begin
  FVideoWindowHandle := Value;
end;

procedure TVideoCapture.Start;
begin
  capCaptureSequenceNoFile(FVideoWindowHandle);
end;

procedure TVideoCapture.Stop;
begin
	capCaptureStop(FVideoWindowHandle);
	capCaptureAbort(FVideoWindowHandle);
end;

function TVideoCapture.Initialize: Boolean;
begin
  FVideoWindowHandle := capCreateCaptureWindow('Capture',WS_POPUP,0,0,1,1,0,0);
	//connect callback functions
	capSetUserData(FVideoWindowHandle,Integer(FOwner));

	//Change destroy functions also........

  capSetCallbackOnVideoStream(FVideoWindowHandle,OnCaptureVideo);

	//capGetDriverDescription(FDriverIndex,devname,100,devversion,100);

	//sprintf(str,"\n Driver name = %s version = %s ",devname,devversion);
	//log.WriteString(str);

	// Connect to webcam driver
	if not capDriverConnect(FVideoWindowHandle,FDriverIndex) then
	begin

		// Device may be open already or it may not have been
		// closed properly last time.
		//AfxMessageBox("Unable to open Video Capture Device");
		//log.WriteString("\n Unable to connect driver to the window");
		//m_capwnd=NULL;
		Result := False;
    Exit
	end;

	// Set the capture parameters
	if SetCapturePara = False then
	begin
    //log.WriteString("\n Setting capture parameters failed");
    capDriverDisconnect(FVideoWindowHandle);
    ShowMessage('Unable To Set Capture Parameters.');
    Result := False;
    Exit;
	end;
  Result := True;
end;

{**
*    Invoked when the video frame is captured by the driver
*
*
*}

function OnCaptureVideo(mWnd:HWND; lpVHdr:PVIDEOHDR):LongInt; stdcall;
var
  Form: TMyCamForm;
begin
  Form := TMyCamForm(capGetUserData(mwnd));
  if Form<>nil then
    Form.SendVideo(lpVHdr.lpData,lpVHdr.dwBytesUsed);
  Result := 1;
end;

function TVideoCapture.UnInitialize: Boolean;
var
  Res: Boolean;
  StartWaitForDC: TDateTime;
begin
  StartWaitForDC := Now;
  Res := False;
  while (not Res) and (MilliSecondsBetween(Now,StartWaitForDC)<5000) do
  begin
    Res := capDriverDisconnect(FVideoWindowHandle);
    Application.ProcessMessages;
  end;
  Result := True;
end;

end.
