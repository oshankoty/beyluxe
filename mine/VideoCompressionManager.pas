unit VideoCompressionManager;

interface

uses
  Windows;

const
  VideoDll = 'HCVideo.dll';
type
  TVideoInitialize = function: Boolean; stdcall;
  TVideoUnInitialize = function: Boolean; stdcall;
  TVideoDeCompressFrameSet = function (Data: Pointer; DataSize: Integer; RGBData: Pointer; RGBDataSize: Integer): Boolean; stdcall;
  TVideoCompressFrameSet = function(FrameType: Integer; Data: Pointer; Size: Integer; var OutBuf: Cardinal; var OutSize: Integer): Boolean; stdcall;

  TVideoCompressionManager = class(TObject)
  private
    FModuleHandle: THandle;
    FDllInitialize: TVideoInitialize;
    FDllUnInitialize: TVideoUnInitialize;
    FDllCompressFrame: TVideoCompressFrameSet;
    FDllDeCompressFrame: TVideoDeCompressFrameSet;
  public
    function LoadDll: Integer;
    constructor Create;
    destructor Destroy; override;
    function Initialize: Boolean;
    function UnInitialize: Boolean;
    function CompressFrameSet(FrameType: Integer; Data: Pointer; DataSize: Integer; var RGBData: Pointer; var RGBDataSize: Integer): Boolean;
    function DeCompressFrameSet(Data: Pointer; DataSize: Integer; RGBData: Pointer; RGBDataSize: Integer): Boolean;
  end;

implementation

{ TVideoCompressionManager }

function TVideoCompressionManager.CompressFrameSet(FrameType: Integer; Data: Pointer;
  DataSize: Integer; var RGBData: Pointer; var RGBDataSize: Integer): Boolean;
begin
  Result := False;
  if @FDllCompressFrame<>nil then
    Result := FDllCompressFrame(FrameType,Data,DataSize,Cardinal(RGBData),RGBDataSize);
end;

constructor TVideoCompressionManager.Create;
begin
  inherited;

end;

function TVideoCompressionManager.DeCompressFrameSet(Data: Pointer;
  DataSize: Integer; RGBData: Pointer; RGBDataSize: Integer): Boolean;
begin
  Result := False;
  if @FDllDeCompressFrame<>nil then
    Result := FDllDeCompressFrame(Data,DataSize,RGBData,RGBDataSize);
end;

destructor TVideoCompressionManager.Destroy;
begin

  inherited;
end;

function TVideoCompressionManager.Initialize: Boolean;
begin
  Result := False;
  if @FDllInitialize<>nil then
    Result := FDllInitialize;
end;

function TVideoCompressionManager.LoadDll: Integer;
begin
  FModuleHandle := LoadLibrary(VideoDll);
  if FModuleHandle = 0 then
  begin
    Result := -1;
    Exit;
  end;
  FDllInitialize := GetProcAddress(FModuleHandle,'Initialize');
  FDllUnInitialize := GetProcAddress(FModuleHandle,'UnInitialize');
  FDllCompressFrame := GetProcAddress(FModuleHandle,'CompressFrameSet');
  FDllDeCompressFrame := GetProcAddress(FModuleHandle,'DeCompressFrameSet');
  if (@FDllInitialize<>nil) and (@FDllUnInitialize<>nil) and
     (@FDllCompressFrame<>nil) and (@FDllDeCompressFrame<>nil) then
    Result := 0
  else
    Result := -2;
end;

function TVideoCompressionManager.UnInitialize: Boolean;
begin
  Result := False;
  if @FDllUnInitialize<>nil then
    Result := FDllUnInitialize;
  FreeLibrary(FModuleHandle);
end;

end.
