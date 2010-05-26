unit ACMConverterUnit;

interface

uses
  Classes, Messages, Windows, SysUtils, MSACM, MMSystem;

type
  EACMConverter = class(Exception);

  PACMWaveFormat = ^TACMWaveFormat;
  TACMWaveFormat = packed record
    case integer of
      0 : (Format : TWaveFormatEx);
      1 : (RawData : Array[0..512] of byte);
  end;

  TACMConverter = class
  private
    FActive: Boolean;
    FInBuffer: Pointer;
    FOutBuffer: Pointer;
    FInputBufferSize: DWord;
    FOutputBufferSize: DWord;
    FStreamHandle: HACMStream;
    FStreamHeader: TACMStreamHeader;
    FInFormat: TACMWaveFormat;
    FOutFormat: TACMWaveFormat;
    FOrgSrcLength: Cardinal;
    FDriverID: HACMDRIVERID;
    FACMDriver: HACMDRIVER;
    function GetInBuffer: Pointer;
    function GetOutBuffer: Pointer;
    function GetOutputBufferSize: Cardinal;
    function GetInFormat: PACMWaveFormat;
    function GetOutFormat: PACMWaveFormat;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function OpenStream: Integer;
    function CloseStream: Integer;
    function Convert(SrcBufferUsed: Cardinal): Cardinal;

    function SetInputBufferSize(Value: Cardinal): Boolean;
    function GetInputBufferSize: Cardinal;

    property InBuffer: Pointer read GetInBuffer;
    property OutBuffer: Pointer read GetOutBuffer;
    property OutputBufferSize: Cardinal read GetOutputBufferSize;
    property InFormat: PACMWaveFormat read GetInFormat;
    property OutFormat: PACMWaveFormat read GetOutFormat;
    property DriverID: HACMDRIVERID read FDriverID write FDriverID;
    property ACMDriver: HACMDRIVER read FACMDriver write FACMDriver;
  end;

implementation
{ TACMConvertor }

function TACMConverter.CloseStream: Integer;
begin
  Result := 0;
  if not FActive then Exit;
  FActive := False;
  FStreamHeader.cbSrcLength := FOrgSrcLength;
  Result := acmStreamUnPrepareHeader(FStreamHandle, FStreamHeader, 0);
  if Result <> 0 then Exit;
  FreeMem(FInBuffer);
  FreeMem(FOutBuffer);
  Result := acmStreamClose(FStreamHandle, 0);
  if Result <> 0 then Exit;
end;


function TACMConverter.Convert(SrcBufferUsed: Cardinal): Cardinal;
begin
  FillChar(FOutBuffer^, OutputBufferSize, 0);
  FStreamHeader.cbSrcLength := SrcBufferUsed;
  acmStreamConvert(FStreamHandle,FStreamHeader, ACM_STREAMCONVERTF_BLOCKALIGN);
  acmStreamReset(FStreamHandle, 0);
  Result := FStreamHeader.cbDstLengthUsed;
end;

constructor TACMConverter.Create;
begin
  inherited;
  FStreamHandle := nil;
  FInputBufferSize := 2048;
  with FInFormat.Format do begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := 1;
    nSamplesPerSec := 16000;
    nAvgBytesPerSec := 16000*2;
    nBlockAlign := 2;
    wbitspersample := 16;
    cbSize := 0;
  end;
  FOutFormat := FInFormat;
end;

destructor TACMConverter.Destroy;
begin
  inherited;
end;

function TACMConverter.GetInBuffer: Pointer;
begin
  if FActive then Result := FInBuffer
  else Result := nil;
end;

function TACMConverter.GetInFormat: PACMWaveFormat;
begin
  Result := @FInFormat;
end;

function TACMConverter.GetInputBufferSize: Cardinal;
begin
  Result := FInputBufferSize;
end;

function TACMConverter.GetOutBuffer: Pointer;
begin
  if FActive then Result := FOutBuffer
  else Result := nil;
end;

function TACMConverter.GetOutFormat: PACMWaveFormat;
begin
  Result := @FOutFormat;
end;

function TACMConverter.GetOutputBufferSize: Cardinal;
begin
  if FActive then Result := FOutputBufferSize
  else Result := 0;
end;

function TACMConverter.OpenStream: Integer;
begin
  Result := 0;
  if FActive then Exit;
  if FACMDriver=nil then
    acmDriverOpen(FACMDriver,FDriverID,0);
  Result := acmStreamOpen(FStreamhandle,FACMDriver, FInFormat.Format, FOutFormat.Format, nil, 0, 0, 0);
  if Result <> 0 then Exit;
  Result := acmStreamSize(FStreamHandle, FInputBufferSize, FOutputBufferSize, ACM_STREAMSIZEF_SOURCE);
  if Result <> 0 then Exit;
  GetMem(FInBuffer, FInputBufferSize);
  GetMem(FOutBuffer, FOutputBufferSize);
  try
    with FStreamHeader do begin
      cbStruct := SizeOf(TACMStreamHeader);
      fdwStatus := 0;
      dwUser := 0;
      pbSrc := FInBuffer;
      cbSrcLength := FInputBufferSize;
      cbSrcLengthUsed := 0;
      dwSrcUser := 0;
      pbDst := FOutBuffer;
      cbDstLength := FOutputBufferSize;
      cbDstLengthUsed := 0;
      dwDstUser := 0;
    end;
    FOrgSrcLength := FStreamHeader.cbSrcLength;
    Result := acmStreamPrepareHeader(FStreamHandle, FStreamHeader, 0);
  except
    Freemem(FInBuffer);
    Freemem(FOutBuffer);
    Result := -1;
  end;
  if Result <> 0 then Exit;
  FActive := True;
end;

function TACMConverter.SetInputBufferSize(Value: Cardinal): Boolean;
begin
  Result := not FActive;
  if Result then FInputBufferSize := Value;
end;

end.
