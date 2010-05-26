{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
unit Recorder;

interface

uses
  SysUtils, Classes, mmSystem, windows, messages, SyncObjs,
  amixer, math;

const
    vu_sec_divider  = 500;
    KTrans          = 1;
    DEVICE_NAME     ='SoundMAX Digital Audio';

type
  TCallBackProc = procedure (Buffer: Pointer; BufferSize: Integer) of object;
  TWaveInProc   = Procedure (hwo: HWAVEOUT;uMsg:UINT; dwInstance:Cardinal;dwParam1:Cardinal;dwParam2:Cardinal); stdcall;
  pWaveInProc  = ^TWaveInProc;
  pCallBackProc = ^TCallBackProc;
  TRecorder = class
  private
    DeviceID     : Integer;
    ChGain       : Byte;
    GainCof      : Single;
    FWaveInHandle: HWAVEIN;
    FWaveFormat: tWAVEFORMATEX;
    FWaveInHeader: array [0..3] of WAVEHDR;
    FBuffer: array [0..3] of Pointer;
    FRes: MMResult;
    FBufferPrepared: Boolean;
    FBufferSize: Cardinal;
    FStoped: Boolean;
    WindowHandle: HWND;
    FCallBackProc: TCallBackProc;
    FEventObject: THANDLE;
    FBufferIndex: Integer;
    FMixerObject: TAudioMixer;
    FMicConnection: Cardinal;
    FMicDestination: Cardinal;
    FMicVolume: Integer;
    FMute: Boolean;
    FRightMeterValue: Single;
    FLeftMeterValue: Single;
    FOnRecVolumeChange: TNotifyEvent;
    procedure GetMeterValue(BufferStart, BufferEnd, CurrPosition: Pointer);
    procedure RecieveAudioData(WaveHeader: PWaveHdr);
    procedure SafeDestroy;
    procedure FindMicDestinationAndConnection;
    procedure ReadMicSetting;
    procedure SetMicVolume(const Value: Integer);
    procedure AudioMixerControlChange(Sender: TObject; MixerH,  ID: Integer);
    procedure SetMute(const Value: Boolean);
    function  GetDeviceCount:Cardinal;
    function  GetDeviceName(DeviceID : Cardinal):String;
  protected

  public
//    DataWriteBuffer :TWriteBuffer ;
    procedure Start;
    procedure Stop;
    procedure SetChGain(Value:Byte);
    procedure SetCallBackProc(Proc: TCallBackProc);
    function SetBuffersFormat(BitPerSample: Cardinal; SamplePerSec: Cardinal; Channels: Cardinal): Boolean;
    property LeftMeterValue: Single read FLeftMeterValue;
    property RightMeterValue: Single read FRightMeterValue;
    property BufferSize: Cardinal read FBufferSize write FBufferSize;
    property MicVolume: Integer read FMicVolume write SetMicVolume;
    property Mute: Boolean read FMute write SetMute;
    property OnRecVolumeChange: TNotifyEvent read FOnRecVolumeChange;
    constructor Create;
    destructor destroy;override;
  published
  end;

Procedure WaveInProc(hwo: HWAVEOUT;uMsg:UINT; dwInstance:Cardinal;dwParam1:Cardinal;dwParam2:Cardinal); stdcall;

Var
  Counter   : Integer;
  ST,ET     : TDateTime;

implementation

uses DateUtils;
//==============================================================================
constructor TRecorder.Create;
Var
  I,DevCount   : Cardinal;
begin
  inherited Create;
  FEventObject:=CreateEvent(nil,True,False,'Record Event');
  FMixerObject := TAudioMixer.Create(nil);
  FindMicDestinationAndConnection;
  ReadMicSetting;
  FBufferSize := 512;
  FStoped     := true;
  GainCof     := 1;
  FMixerObject.OnControlChange := AudioMixerControlChange;
  FLeftMeterValue := -100;
  FRightMeterValue := -100;

  DeviceID:=-1;
  DevCount:=GetDeviceCount;
  For I:=0 To DevCount-1 Do
     if GetDeviceName(I)=DEVICE_NAME then
        begin
          DeviceID:=I;
          Break;
        end;
  if DeviceID=-1 then
    DeviceID:=WAVE_MAPPER;
end;
//==============================================================================
destructor TRecorder.destroy;
begin
  SafeDestroy;
  CloseHandle(FEventObject);
  DeallocateHWnd(WindowHandle);
  FMixerObject.Free;
  inherited;

end;
//==============================================================================
procedure TRecorder.RecieveAudioData(WaveHeader: PWaveHdr);
var
  tmpPtr: Pointer;
begin
  if assigned(FCallBackProc) then
    with WaveHeader^ do
      if dwBytesRecorded >0 then
        begin
          FCallBackProc(lpData,dwBytesRecorded);
        end
      else
        Exit;
  if not FStoped then
  begin
    waveInUnprepareHeader(FWaveInHandle,WaveHeader,SizeOf(WaveHdr));
    tmpPtr := WaveHeader.lpData;
    ZeroMemory(WaveHeader,SizeOf(WaveHdr));
    WaveHeader.dwBufferLength := FBufferSize;
    WaveHeader.lpData := tmpPtr;
    waveInPrepareHeader(FWaveInHandle,WaveHeader,SizeOf(WaveHdr));
    waveInAddBuffer(FWaveInHandle,WaveHeader,SizeOf(WaveHdr));
  end;
end;
//==============================================================================
procedure TRecorder.SafeDestroy;
var
  i  : Integer;
begin
  if FBufferPrepared then
    begin
      if FBuffer[0]<>nil then
        begin
          FreeMem(FBuffer[0]);
          FBuffer[0] := nil;
        end;
      for i := 0 to 3 do
        begin
         waveInUnprepareHeader(FWaveInHandle,@FWaveInHeader[i],SizeOf(WAVEHDR));
         FBuffer[i] := nil;
        end;
      FBufferPrepared := False;
    end;
  if FWaveInHandle<>0 then
    begin
      waveInClose(FWaveInHandle);
    end;
end;
//==============================================================================
procedure TRecorder.SetCallBackProc(Proc: TCallBackProc);
begin
  FCallBAckProc := Proc;
end;
//==============================================================================
procedure TRecorder.Start;
begin
  Counter:=0;
  FBufferIndex := 0;
  FRes := waveInStart(FWaveInHandle);
  FStoped := False;
  if FRes<>MMSYSERR_NOERROR then
    Exit;
end;
//==============================================================================
procedure TRecorder.Stop;
begin
  if not FStoped then
  begin
    FStoped := True;
    SetEvent(FEventObject);
    Sleep(100);
    waveInReset(FWaveInHandle);
    FLeftMeterValue :=  -100;
    FRightMeterValue := -100;
    waveInStop(FWaveInHandle);
    SafeDestroy;
  end;

end;
//==============================================================================
function TRecorder.SetBuffersFormat(BitPerSample, SamplePerSec,
  Channels: Cardinal): Boolean;
var
  i: Cardinal;
  WaveInPro:pWaveInProc;
begin
  Result := True;
  with FWaveFormat do
  begin
    wFormatTag :=WAVE_FORMAT_PCM;
    nChannels := Channels;
    nSamplesPerSec  := SamplePerSec;
    wBitsPerSample  := BitPerSample;
    nAvgBytesPerSec := SamplePerSec * Channels * BitPerSample div 8;
    nBlockAlign := Channels * BitPerSample div 8;
    cbSize:=0;
  end;
  FMixerObject.MixerId := 0;
  FindMicDestinationAndConnection;
  ReadMicSetting;
  WaveInPro:=@WaveInProc;
  FRes := waveInOpen(@FWaveInHandle,WAVE_MAPPER,@FWaveFormat,Cardinal(WaveInPro),Cardinal(Self),CALLBACK_FUNCTION);
  ///if FRes<>MMSYSERR_NOERROR Then
    ///MessageBox(0,'Error','Test',MB_OK);

  ///GetMem(FBuffer[0],FBufferSize*4);

  for i := 0 to 3 do
  begin
    //GetMem(FBuffer[i],FBufferSize);
    ///FBuffer[i] := Pointer(Cardinal(FBuffer[0])+i*FBufferSize);
    GetMem(FBuffer[i],FBufferSize);
    with FWaveInHeader[i] do
    begin
      lpData := FBuffer[i];
      dwBufferLength := FBufferSize;
      dwBytesRecorded := 0;
      dwFlags := 0;
      dwLoops := 0;
      lpNext := nil;
      reserved := 0;
    end;
    FRes := waveInPrepareHeader(FWaveInHandle,@FWaveInHeader[i],SizeOf(WaveHdr));
    ///if FRes<>MMSYSERR_NOERROR then
      ///MessageBox(0,'Error','test',MB_OK);
    FRes:=waveInAddBuffer(FWaveInHandle,@FWaveInHeader[i],SizeOf(WaveHdr));
    ///if FRes<>MMSYSERR_NOERROR then
      ///MessageBox(0,'Error','test',MB_OK);
  end;
  FBufferPrepared := True;
end;
//==============================================================================
procedure TRecorder.SetMute(const Value: Boolean);
begin
  FMute := Value;
  SetMicVolume(FMicVolume);
end;
//==============================================================================
procedure TRecorder.AudioMixerControlChange(Sender: TObject; MixerH,
  ID: Integer);
begin
  ReadMicSetting;
  if assigned(FOnRecVolumeChange) then
    FOnRecVolumeChange(Self);
end;
//==============================================================================
procedure TRecorder.GetMeterValue(BufferStart, BufferEnd,
  CurrPosition: Pointer);
var
  SamplesNum: Cardinal;
  TmpSamplesNum: Cardinal;
  Count: Cardinal;
  BufPtr: Pointer;
  Sample: SmallInt;
  Sample8: ShortInt;
  RealSample: Double;
  Is16Bit: Boolean;
  LMeterValue: Double;
  RMeterValue: Double;
  BlockAlign: Cardinal;
begin
  SamplesNum := FWaveFormat.nSamplesPerSec div vu_sec_divider;
  if SamplesNum<=0 then
    Exit;
  FLeftMeterValue  := 0;
  FRightMeterValue := 0;
  LMeterValue := 0;
  RMeterValue := 0;
  Is16Bit    := FWaveFormat.wBitsPerSample = 16;
  BlockAlign := FWaveFormat.nBlockAlign;
  BufPtr := Pointer(Cardinal(BufferStart)+(((Cardinal(CurrPosition)-Cardinal(BufferStart)) div BlockAlign)*BlockAlign));
  if ((Cardinal(BufferEnd)-Cardinal(BufPtr{CurrPosition})) div BlockAlign)>=SamplesNum then
  begin
    for Count := 0 to SamplesNum-1 do
    begin
      if Is16Bit then
      begin
        Sample := PSmallInt(Bufptr)^;
        RealSample := (Sample * GainCof)/32768;
        LMeterValue := LMeterValue + RealSample * RealSample;
        Inc(Cardinal(BufPtr),2);  // 2 = SizeOf(SmallInt)
        Sample := PSmallInt(Bufptr)^;
        RealSample := (Sample * GainCof)/32768;
        Inc(Cardinal(BufPtr),2);  // 2 = SizeOf(SmallInt)
        RMeterValue := RMeterValue + RealSample * RealSample;
      end
      else
      begin
        Sample8 := PShortInt(Bufptr)^ xor ShortInt($80);
        RealSample := Sample8/128;
        Inc(Cardinal(BufPtr));
        LMeterValue := LMeterValue + RealSample * RealSample;
        Sample8 := PShortInt(Bufptr)^ xor ShortInt($80);
        RealSample := Sample8/128;
        Inc(Cardinal(BufPtr));
        RMeterValue := RMeterValue + RealSample * RealSample;
      end;
    end;
  end
  else
  begin
    TmpSamplesNum := (Cardinal(BufferEnd)-Cardinal(CurrPosition)) div BlockAlign;
    for Count := 0 to TmpSamplesNum-1 do
    begin
      if Is16Bit then
      begin
        Sample := PSmallInt(Bufptr)^;
        RealSample := (Sample * GainCof)/32768;
        Inc(Cardinal(BufPtr),2);
        LMeterValue := LMeterValue + RealSample * RealSample;
        Sample := PSmallInt(Bufptr)^;
        RealSample := (Sample * GainCof)/32768;
        Inc(Cardinal(BufPtr),2);
        RMeterValue := RMeterValue + RealSample * RealSample;
      end
      else
      begin
        Sample8 := PShortInt(Bufptr)^ xor ShortInt($80);
        RealSample := Sample8/128;
        Inc(Cardinal(BufPtr));
        LMeterValue := LMeterValue + RealSample * RealSample;
        Sample8 := PShortInt(Bufptr)^ xor ShortInt($80);
        RealSample := Sample8/128;
        Inc(Cardinal(BufPtr));
        RMeterValue := RMeterValue + RealSample * RealSample;
      end;
    end;
    TmpSamplesNum := SamplesNum - (Cardinal(BufferEnd)-Cardinal(CurrPosition)) div BlockAlign;
    BufPtr := BufferStart;
    for Count := 0 to TmpSamplesNum-1 do
    begin
      if Is16Bit then
      begin
        Sample := PSmallInt(Bufptr)^;
        RealSample := (Sample * GainCof)/32768;
        Inc(Cardinal(BufPtr),2);
        LMeterValue := LMeterValue + RealSample * RealSample;
        Sample := PSmallInt(Bufptr)^;
        RealSample := (Sample*GainCof)/32768;
        Inc(Cardinal(BufPtr),2);
        RMeterValue := RMeterValue + RealSample * RealSample;
      end
      else
      begin
        Sample8 := PShortInt(Bufptr)^ xor ShortInt($80);
        RealSample := Sample8/128;
        Inc(Cardinal(BufPtr));
        LMeterValue := LMeterValue + RealSample * RealSample;
        Sample8 := PShortInt(Bufptr)^ xor ShortInt($80);
        RealSample := Sample8/128;
        Inc(Cardinal(BufPtr));
        RMeterValue := RMeterValue + RealSample * RealSample;
      end;
    end;
  end;
  LMeterValue := LMeterValue / SamplesNum;
  RMeterValue := RMeterValue / SamplesNum;

  if LMeterValue>0 then
    FLeftMeterValue := 20 * Log10(LMeterValue)
  else
    FLeftMeterValue := -100;
  if RMeterValue>0 then
    FRightMeterValue := 20 * Log10(RMeterValue)
  else
    FRightMeterValue := -100;
end;
//==============================================================================
procedure TRecorder.FindMicDestinationAndConnection;
var
  i: Integer;
  j: Integer;
  ComponentType: Cardinal;
begin
  FMixerObject.MixerId := 0;
  for i := 0 to FMixerObject.Destinations.Count-1 do
  begin
    if FMixerObject.Destinations.Destination[i].Data.Target.dwType=MIXERLINE_TARGETTYPE_WAVEIN then
    begin
      for j := 0 to FMixerObject.Destinations.Destination[i].Connections.Count-1 do
      begin
        ComponentType := FMixerObject.Destinations.Destination[i].Connections[j].Data.dwComponentType;
        if (ComponentType = MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE) then
        begin
          FMicDestination := i;
          FMicConnection := j;
          Exit;
        end;
      end;
    end;
  end;
end;
//==============================================================================
procedure TRecorder.ReadMicSetting;
var
  Value: Integer;
  Mute: Integer;
  Stereo: Boolean;
  VolDisabled: Boolean;
  MuteDisabled: Boolean;
  MuteIsSelect: Boolean;
begin
  FMixerObject.GetVolume(FMicDestination,FMicConnection,Value,Value,Mute,Stereo,VolDisabled,MuteDisabled,MuteIsSelect);
  FMicVolume := Value;
end;
//==============================================================================
procedure TRecorder.SetMicVolume(const Value: Integer);
begin
  FMicVolume := Value;
  if FMute then
    FMixerObject.SetVolume(FMicDestination,FMicConnection,0,0,1)
  else
    FMixerObject.SetVolume(FMicDestination,FMicConnection,Value,Value,1)
end;
//==============================================================================
{procedure TRecorder.Execute;
var
  Result: Cardinal;
  TimeStruct: MMTIME;
begin
  inherited;
  ZeroMemory(@TimeStruct,SizeOf(MMTIME));
  TimeStruct.wType := TIME_BYTES;
  while not Terminated do
    begin
      Result := WaitForSingleObject(FEventObject,1);
      if (Result<>WAIT_TIMEOUT)	then
      begin
        ResetEvent(FEventObject);
        RecieveAudioData(@FWaveInHeader[FBufferIndex]);
        Inc(FBufferIndex);
        if FBufferIndex = 4 then
          FBufferIndex := 0;
      end;
      if (FBufferPrepared) and (not FStoped) then
      begin
        GetMeterValue(FBuffer[FBufferIndex],Pointer(Cardinal(FBuffer[FBufferIndex])+BufferSize*4),FBuffer[FBufferIndex]);
      end;
       if(FStoped) then
        Sleep(100);
    end;
end; }
//==============================================================================
procedure WaveInProc(hwo: HWAVEOUT; uMsg: UINT; dwInstance,
  dwParam1, dwParam2: Cardinal);
var
  Rec       : TRecorder;
  BufIndex  : integer;
begin
  Case uMsg Of
    WIM_DATA:
      begin
        Rec:=TRecorder(dwInstance);
        Rec.RecieveAudioData(@Rec.FWaveInHeader[Rec.FBufferIndex]);
        BufIndex:=Rec.FBufferIndex;
        Rec.FBufferIndex :=(Rec.FBufferIndex +1) Mod 4;
        if (Rec.FBufferPrepared) and (not Rec.FStoped) then
          Rec.GetMeterValue(Rec.FBuffer[BufIndex],Pointer(Cardinal(Rec.FBuffer[BufIndex])+Rec.BufferSize),Rec.FBuffer[BufIndex]{Pointer(BufPos+Cardinal(FBuffer[0]))});
    end;
    MM_WIM_OPEN:;
    MM_WIM_CLOSE:;
  End;
end;
//==============================================================================
procedure TRecorder.SetChGain(Value: Byte);
begin
  ChGain:=Value;
  if(ChGain<>0) then
    GainCof:=Power(10,(ChGain-255)/200) * KTrans
  else
    GainCof:=0;
end;
//==============================================================================
function TRecorder.GetDeviceCount: Cardinal;
begin
  Result := waveInGetNumDevs;
end;
//==============================================================================
function TRecorder.GetDeviceName(DeviceID: Cardinal): String;
Var
  Caps  : WAVEINCAPS;
begin
  waveInGetDevCaps(DeviceID,@Caps,SizeOf(WAVEINCAPS));
  Result:=Caps.szPname;
end;
//==============================================================================
end.
