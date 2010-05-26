unit ACMEncoderUnit;

interface

uses
  Classes, MSACM, MMSystem, ACMConverterUnit, Windows, SysUtils;

type
  TACMEncoder = class
  private
    FFormatTag: Word;
    FItems: TStringList;
    FItemIndex: Integer;
    FStream: TStream;
    FTemporaryFormat: TACMWaveFormat;
    FDriverIDToAccept: HACMDRIVERID;
    FhModule: Cardinal;
    FDefaultDriverID: HACMDRIVERID;
    FDefaultDriver: HACMDRIVER;
    procedure SetItemIndex(const Value: Integer);
    function GetInFormat: PACMWaveFormat;
    function GetTemporaryFormat: PACMWaveFormat;
  public
    FACMConverter: TACMConverter;
    constructor Create(FormatTag: Word; DefaultDrv: HACMDRIVER; DriverID: HACMDRIVERID); virtual;
    destructor Destroy; override;
    function OpenCodec: Integer;
    function CloseCodec: Integer;
    function WriteBuffer(Buffer: Pointer; SrcBufferUsed: Cardinal; var DestBuffer: Pointer; var DestBufferUsed: Cardinal): Integer;
    function SetBufferSize(BufferSize: Cardinal): Boolean;
    function GetBufferSize: Cardinal;
    property InFormat: PACMWaveFormat read GetInFormat;
    property TemporaryFormat: PACMWaveFormat read GetTemporaryFormat;
    property Items: TStringList read FItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    property Stream: TStream read FStream write FStream;
    property DefaultDriverID: HACMDRIVERID read FDefaultDriverID write FDefaultDriverID;
    property DefaultDriver: HACMDRIVER read FDefaultDriver write FDefaultDriver;
  end;

implementation

uses Math;

function FormatEnumProc(hACMDrvId: HACMDRIVERID;
                        ACMFmtDet: PACMFormatDetails;
                        dwInstance: Cardinal;
                        fdwSupport: Cardinal): LongBool; stdcall;
var
  ACMFormat: PACMFormatDetails;
begin
  Result := true;
  if dwInstance <> 0 then
    with TACMEncoder(dwInstance) do
    begin
      if ACMFmtDet.dwFormatTag = FFormatTag then begin
        if Items.IndexOf(ACMFmtDet.szFormat) >= 0 then Exit;
        GetMem(ACMFormat, SizeOf(TACMFormatDetails));
        Move(ACMFmtDet^, ACMFormat^, SizeOf(TACMFormatDetails));
        GetMem(ACMFormat.pwfx, ACMFormat.cbwfx);
        Move(ACMFmtDet.pwfx^, ACMFormat.pwfx^, ACMFormat.cbwfx);

        //if TACMEncoder(dwInstance).FDriverIDToAccept<>nil then
        //  Items.AddObject(ACMFormat.szFormat+' '+FloatToStr(ACMFmtDet.pwfx^.nAvgBytesPerSec*8/1000)+' kbit/s', TObject(ACMFormat))
        //else
          Items.AddObject(ACMFormat.szFormat, TObject(ACMFormat));
      end;
    end;
end;

function DriverEnumProc(hACMDrvId: HACMDRIVERID;
                        dwInstance: Cardinal;
                        fdwSupport: Cardinal): LongBool; stdcall;
var
  ACMFmtDet : TACMFormatDetails;
  WaveFormat : TACMWaveFormat;
  hACMDrv : HACMDriver;
	Details: TACMDRIVERDETAILS;
	fmtDetails: TACMFORMATTAGDETAILS;
  i : Cardinal;
begin
  if dwInstance <> 0 then
  begin
    if (TACMEncoder(dwInstance).FDriverIDToAccept<>nil) then
      if (TACMEncoder(dwInstance).FDriverIDToAccept<>hACMDrvId) then
      begin
        Result := True;
        Exit;
      end;
    with TACMEncoder(dwInstance) do
    begin
      if fdwSupport and ACMDRIVERDETAILS_SUPPORTF_CODEC <> 0 then
      begin
        Details.cbStruct := SizeOf(TACMDRIVERDETAILS);
        acmDriverDetails(hACMDrvId, details, 0);
        acmDriverOpen(hACMDrv, hACMDrvId, 0);
        for i := 0 to details.cFormatTags do
        begin
          FillChar(fmtDetails, SizeOf(fmtDetails), 0);
          fmtDetails.cbStruct := SizeOf(TACMFORMATTAGDETAILS);
          fmtDetails.dwFormatTagIndex := i;
          acmFormatTagDetails(hACMDrv, fmtDetails, ACM_FORMATTAGDETAILSF_INDEX);
          if fmtDetails.dwFormatTag = FFormatTag then
          begin
            FillChar(WaveFormat, SizeOf(TACMWaveFormat), 0);
            FillChar(ACMFmtDet, SizeOf(TACMFormatDetails), 0);
//            hACMDrv := nil;
//            acmDriverOpen(hACMDrv, hACMDrvId, 0);
            FillChar(WaveFormat, SizeOf(TACMWaveFormat), 0);
//            WaveFormat.Format.cbSize := SizeOf(TACMWaveFormat) - SizeOf(TWaveFormatEx);
//            WaveFormat.Format.wFormatTag := FFormatTag;
            ACMFmtDet.cbStruct := SizeOf(TACMFormatDetails);
            ACMFmtDet.pWFX := @WaveFormat;
            ACMFmtDet.cbWFX := SizeOf(TACMWaveFormat);
            ACMFmtDet.dwFormatTag := FFormatTag;
            acmFormatEnum(hACMDrv, ACMFmtDet, FormatEnumProc, dwInstance, 0{ACM_FORMATENUMF_INPUT}); // ACM_FORMATENUMF_INPUT Cause to disable audio playback on RDP
          end;
        end;
        acmDriverClose(hACMDrv, 0);
      end;
    end;
  end;
  Result := True;
end;

{ TACMEncoder }

function TACMEncoder.CloseCodec: Integer;
begin
  Result := FACMConverter.CloseStream;
end;

constructor TACMEncoder.Create(FormatTag: Word; DefaultDrv: HACMDRIVER; DriverID: HACMDRIVERID);
begin
  FItems := TStringList.Create;
  FACMConverter := TACMConverter.Create;
  FFormatTag := FormatTag;
  FDriverIDToAccept := nil;
  if DefaultDrv<>nil then
  begin
    FACMConverter.ACMDriver := DefaultDrv;
  end
  else
  begin
    FACMConverter.DriverID := DriverID;
    FDriverIDToAccept := DriverID;
  end;
  acmDriverEnum(DriverEnumProc, Integer(Self), 0{ACM_DRIVERENUMF_NOLOCAL});
  ItemIndex := 0;
end;

destructor TACMEncoder.Destroy;
var
  i: Integer;
begin
  if FDriverIDToAccept<>nil then
    FreeLibrary(FhModule);
  FACMConverter.Free;
  with FItems do
  begin
    for i := 0 to Count-1 do
    begin
      FreeMem(PACMFormatDetails(Pointer(Objects[i])).pwfx);
      FreeMem(Pointer(Objects[i]));
    end;
    Free;
  end;
  inherited;
end;

function TACMEncoder.GetBufferSize: Cardinal;
begin
  Result := FACMConverter.GetInputBufferSize;
end;

function TACMEncoder.GetInFormat: PACMWaveFormat;
begin
  Result := FACMConverter.InFormat;
end;

function TACMEncoder.GetTemporaryFormat: PACMWaveFormat;
begin
  Result := @FTemporaryFormat;
end;

function TACMEncoder.OpenCodec: Integer;
begin
  Result := FACMConverter.OpenStream;
  DefaultDriver := FACMConverter.ACMDriver;
end;

function TACMEncoder.SetBufferSize(BufferSize: Cardinal): Boolean;
begin
  Result := True;
  if GetBufferSize = BufferSize then Exit;
  Result := FACMConverter.SetInputBufferSize(BufferSize);
end;

procedure TACMEncoder.SetItemIndex(const Value: Integer);
begin
  if InRange(Value, 0, Items.Count-1) then
    FItemIndex := Value
  else
    FItemIndex := -1;
  if FItemIndex >= 0 then
    with PACMFormatDetails(FItems.Objects[FItemIndex])^ do
      Move(pwfx^, FACMConverter.OutFormat^, cbwfx);
end;


function TACMEncoder.WriteBuffer(Buffer: Pointer; SrcBufferUsed: Cardinal; var DestBuffer: Pointer; var DestBufferUsed: Cardinal): Integer;
begin
//  Move(Buffer^, FACMConverter.InBuffer^, FACMConverter.GetInputBufferSize);
  Move(Buffer^, FACMConverter.InBuffer^, SrcBufferUsed);
  Result := FACMConverter.Convert(SrcBufferUsed);
  //Result := Stream.Write(FACMConverter.OutBuffer^, Result);
  DestBuffer := FACMConverter.OutBuffer;
  DestBufferUsed := Result;
end;

end.
