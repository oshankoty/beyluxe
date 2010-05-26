unit PlayThreadUnit;

interface

uses
  windows, DirectSound, ExtCtrls, ACMConverterUnit, ACMEncoderUnit, MSACM,
  Dialogs, mmSystem, SysUtils, Classes, SyncObjs, ConvUtils, CommunicatorTypes,
  ActiveX, LogThread, StdCtrls, StrUtils, math, Forms;

const
  vu_sec_divider  = 250;
  THREAD_DELAY = 30;
  WAVESAMPLERATE = 16000;
  PLAY_SILENCE_DISTANCE = 1;

type
  TSendVoiceBuffer = procedure (Buffer: Pointer; Size: Integer) of object;
  TPlayThread = class(TThread)
  private
    FInputCriticalSection: TCriticalSection;
    FInputMemoryStream: TMemoryStream;

    FWaveFormat: tWAVEFORMATEX;

//    DirectSoundFullDublex: IDirectSoundFullDuplex;

    DirectSoundCapture8: IDirectSoundCapture8;
    TempCaptureBuffer: IDirectSoundCaptureBuffer;
    CaptureBuffer: IDirectSoundCaptureBuffer8;
    CaptureBufferDSC: _DSCBUFFERDESC;



//    CaptureEffectDesc: DSCEFFECTDESC;
//    CaptureNoiseSuppress: IDirectSoundCaptureFXNoiseSuppress;
//    CaptureNoiseSuppressParams: DSCFXNoiseSuppress;

    CapBuffer1: Pointer;
    CapBuffer2: Pointer;
    CapLastPosition: Cardinal;
    CapCurrentPosition: Cardinal;
    CapBuffer1Size: Cardinal;
    CapBuffer2Size: Cardinal;

    ACMEncoder: TACMEncoder;
    ACMDecoder: TACMEncoder;

    PlayDirectSound: IDirectSound8;
    PlayDSBD: DSBUFFERDESC;

    PlayTmpSoundBuffer: IDirectSoundBuffer;
    PlayDirectSoundBuffer: IDirectSoundBuffer8;

    PlayDSBuffer1: Pointer;
    PlayDSBuffer2: Pointer;
    FPlayBytesAllocated1: Cardinal;
    FPlayBytesAllocated2: Cardinal;
    FPlayRecBufSize: Cardinal;
    FPlayLastWriteCursor: Cardinal;
    FPlaySilenceCursor: Cardinal;
    PlayFirstWrite: Boolean;
    BufForSend: Pointer;
    FSendVoiceBuffer: TSendVoiceBuffer;
    FirstTimeGetOutputData: Boolean;
    FirstTimeCounter: Integer;
    FLastIncomingDataTime: TDateTime;
    FPLayReady: Boolean;
    FRoomWindowHandle: HWND;
    FThreadTerminated: Boolean;
    FPlayDoorZadam: Boolean;
    FPLaySuspended: Boolean;
    FSilenceDistance: Integer;
    FSilenceLock: TCriticalSection;
{$IFDEF PLAYLOG}
    FPlayLogger: TLogger;
{$ENDIF}
    FPlayMeterValue: Single;
    FRecMeterValue: Single;
    FOutputVolume: Integer;
    FDevices: TStringList;
    FDevicesCapture: TStringList;
    FInitializeError: Boolean;
    FhModule: Cardinal;
    FDebugStrList: TStringList;
    function CreateCaptureObjects: Boolean;
    procedure DestroyCaptureObjects;
    procedure CreateObjects;
    procedure DestroyObjects;
    procedure SilencePlayBuffer;
    function GetMeterValue(BufferStart, BufferEnd, CurrPosition: Pointer): Single;
    procedure SetOutputVolume(const Value: Integer);
    procedure RemoveInvalidAudioDevices;
  protected
    procedure Execute; override;
  public
    destructor Destroy; override;
    constructor Create(CreateSuspended: Boolean);
    procedure AddPlayBuffer(Buffer: Pointer; BufferSize: Integer);
    property InputCriticalSection: TCriticalSection read FInputCriticalSection;
    property InputMemoryStream: TMemoryStream read FInputMemoryStream;
    property SendVoiceBufferProc: TSendVoiceBuffer read FSendVoiceBuffer write FSendVoiceBuffer;
    property RoomWindowHandle: HWND read FRoomWindowHandle write FRoomWindowHandle;
    property ThreadTerminated: Boolean read FThreadTerminated write FThreadTerminated;
    property PlayMeterValue: Single read FPlayMeterValue write FPlayMeterValue;
    property RecMeterValue: Single read FRecMeterValue write FRecMeterValue;
    property OutputVolume: Integer read FOutputVolume write SetOutputVolume;
    property Devices: TStringList read FDevices;
    property DevicesCaputer: TStringList read FDevicesCapture;
    property InitializeError: Boolean read FInitializeError;
    property DebugStrList: TStringList read FDebugStrList;
  end;

function DSEnumerate(lpGuid: PGUID; lpcstrDescription,
  lpcstrModule: PAnsiChar; lpContext: Pointer): BOOL; stdcall;

function DSCaptureEnumerate(lpGuid: PGUID; lpcstrDescription,
  lpcstrModule: PAnsiChar; lpContext: Pointer): BOOL; stdcall;


implementation

{ TPlayThread }

uses
  MainUnit, DateUtils, PreferencesUnit;

function DSEnumerate(lpGuid: PGUID; lpcstrDescription,
  lpcstrModule: PAnsiChar; lpContext: Pointer): BOOL;
begin
  TPlayThread(lpContext).FDevices.AddObject(lpcstrDescription,Pointer(lpGuid));
  Result := True;
end;

function DSCaptureEnumerate(lpGuid: PGUID; lpcstrDescription,
  lpcstrModule: PAnsiChar; lpContext: Pointer): BOOL;
begin
  TPlayThread(lpContext).FDevicesCapture.AddObject(lpcstrDescription,Pointer(lpGuid));
  Result := True;
end;

constructor TPlayThread.Create(CreateSuspended: Boolean);
begin
  FDebugStrList := TStringList.Create;
  FInputCriticalSection := TCriticalSection.Create;
  FSilenceLock := TCriticalSection.Create;
  FDevices := TStringList.Create;
  FDevicesCapture := TStringList.Create;
  DirectSoundEnumerate(DSEnumerate,Self);
  DirectSoundCaptureEnumerate(DSCaptureEnumerate,Self);
  RemoveInvalidAudioDevices;
  inherited;
end;

destructor TPlayThread.Destroy;
begin
  FDevices.Free;
  FDevicesCapture.Free;
  FSilenceLock.Free;
  FInputCriticalSection.Free;
  FDebugStrList.Free;
  inherited;
end;

procedure TPlayThread.AddPlayBuffer(Buffer: Pointer; BufferSize: Integer);
var
  PlayCurrentPosition: Cardinal;
  ResBuffer: Pointer;
  ResBufferSize: Cardinal;
  RPlayCursor: Cardinal;
  StartPlayAtTheEnd: Boolean;
begin
  if not MainForm.AudioEnable then
    Exit;
  if not FPLayReady then
    Exit;
  if BufferSize>8000 then
    Exit;
  StartPlayAtTheEnd := False;
  FirstTimeCounter := 0;
{$IFDEF PLAYLOG}
    FPlayLogger.AddToLogFile(IntToStr(BufferSize));
{$ENDIF}
  ACMDecoder.WriteBuffer(Buffer,BufferSize,ResBuffer,ResBufferSize);
  PlayDirectSoundBuffer.GetCurrentPosition(@RPlayCursor,@PlayCurrentPosition);
  if FirstTimeGetOutputData then
  begin
{$IFDEF PLAYLOG}
    //FPlayLogger.AddToLogFile(LeftStr(TimeToStr(Now),8)+':'+Format('%3d',[MilliSecondOf(Now)])+'  FirstTimeGetOutputData. Restarting play.');
{$ENDIF}
    FLastIncomingDataTime := Now;
    FPlayLastWriteCursor := PlayCurrentPosition;
    FirstTimeGetOutputData := False;
  end;
  FSilenceLock.Enter;
  try
    if not FPLaySuspended then
    begin

      //  If PlayCursor Exceed Our Write Cursor
      if FPlayLastWriteCursor<PlayCurrentPosition then
      begin
        if PlayCurrentPosition-FPlayLastWriteCursor<FPlayRecBufSize div 2 then
        begin
  {$IFDEF PLAYLOG}
          //FPlayLogger.AddToLogFile('>>>>'+LeftStr(TimeToStr(Now),8)+':'+Format('%3d',[MilliSecondOf(Now)])+'  PlayCurPos:'+IntToStr(PlayCurrentPosition)+' LastWritePos: '+IntToStr(FPlayLastWriteCursor)+' ResBufSize: '+IntToStr(ResBufferSize));
  {$ENDIF}
          //PlayDirectSoundBuffer.Stop;
          //Sleep(10);
          FPlayLastWriteCursor := PlayCurrentPosition;
          //FPLaySuspended := True;
        end;
      end
      else
      //  If PlayCursor Looped And Exceed Our Write Cursor
      if FPlayLastWriteCursor>PlayCurrentPosition then
      begin
        if FPlayLastWriteCursor-PlayCurrentPosition>FPlayRecBufSize div 2 then
        begin
  {$IFDEF PLAYLOG}
          //FPlayLogger.AddToLogFile('>>>>'+LeftStr(TimeToStr(Now),8)+':'+Format('%3d',[MilliSecondOf(Now)])+' PlayCurPos:'+IntToStr(PlayCurrentPosition)+' LastWritePos: '+IntToStr(FPlayLastWriteCursor)+' ResBufSize: '+IntToStr(ResBufferSize));
  {$ENDIF}
          //PlayDirectSoundBuffer.Stop;
          //Sleep(10);
          FPlayLastWriteCursor := PlayCurrentPosition;
          //FPLaySuspended := True;
        end;
      end;
    end
    else
      StartPlayAtTheEnd := True;

    if FPlayRecBufSize - FPlayLastWriteCursor>ResBufferSize then
    begin
      try
        CopyMemory(Pointer(Cardinal(PlayDSBuffer1)+Cardinal(FPlayLastWriteCursor)),ResBuffer,ResBufferSize);
      except
      end;
      FLastIncomingDataTime := Now;
      FPlayLastWriteCursor := FPlayLastWriteCursor + ResBufferSize;
  {$IFDEF PLAYLOG}
      //FPlayLogger.AddToLogFile(LeftStr(TimeToStr(Now),8)+':'+Format('%3d',[MilliSecondOf(Now)])+'    ResBufferSize='+IntToStr(ResBufferSize)+'    LastWritePos='+IntToStr(FPlayLastWriteCursor)+'  PlayCursor: '+IntToStr(PlayCurrentPosition));
  {$ENDIF}
      FPlayDoorZadam := False;
    end
    else
    begin
      try
        CopyMemory(Pointer(Cardinal(PlayDSBuffer1)+FPlayLastWriteCursor),ResBuffer,FPlayRecBufSize-FPlayLastWriteCursor);
        CopyMemory(PlayDSBuffer1,Pointer(Cardinal(ResBuffer)+(FPlayRecBufSize-FPlayLastWriteCursor)),ResBufferSize-(FPlayRecBufSize-FPlayLastWriteCursor));
      except
      end;
      FLastIncomingDataTime := Now;
      FPlayLastWriteCursor := ResBufferSize-(FPlayRecBufSize-FPlayLastWriteCursor);
  {$IFDEF PLAYLOG}
      //FPlayLogger.AddToLogFile(LeftStr(TimeToStr(Now),8)+':'+Format('%3d',[MilliSecondOf(Now)])+'****ResBufferSize='+IntToStr(ResBufferSize)+'    LastWritePos='+IntToStr(FPlayLastWriteCursor)+'  PlayCursor: '+IntToStr(PlayCurrentPosition));
  {$ENDIF}
      FPlayDoorZadam := True;
    end;

    if StartPlayAtTheEnd then
    begin
      //PlayDirectSoundBuffer.Play(0,0,DSBPLAY_LOOPING);
      FPLaySuspended := False;
    end;

    FPlaySilenceCursor := FPlayLastWriteCursor;
  finally
    FSilenceLock.Leave;
  end;
end;

procedure TPlayThread.CreateObjects;
var
  i: Integer;
  Res: HResult;
  DriverPtr: Pointer;
  hID: HACMDRIVERID;
  ACMRes: MMResult;
begin
  //CoInitializeEx(nil,COINIT_MULTITHREADED);
{$IFDEF PLAYLOG}
  FPlayLogger := TLogger.Create(False,'c:\PlayLog--'+IntToStr(GetTickCount)+'.txt');
{$ENDIF}
  FPlayRecBufSize := WAVESAMPLERATE*20;
  GetMem(BufForSend,FPlayRecBufSize);
  FWaveFormat.wFormatTag := WAVE_FORMAT_PCM;
  FWaveFormat.nChannels := 1;
  FWaveFormat.nSamplesPerSec := WAVESAMPLERATE;
  FWaveFormat.nAvgBytesPerSec := WAVESAMPLERATE*2;
  FWaveFormat.nBlockAlign := 2;
  FWaveFormat.wBitsPerSample := 16;
  FWaveFormat.cbSize := SizeOf(tWAVEFORMATEX);
  //DirectSoundCreate8(@DSDEVID_DefaultPlayback,PlayDirectSound,nil);
  Res := DirectSoundCreate8(PGUID(FDevices.Objects[MainForm.FSystemPreferences.AudioSoundDeviceIndex]),PlayDirectSound,nil);
  if Res = DS_OK then
  begin
    Res := PlayDirectSound.SetCooperativeLevel(MainForm.Handle, DSSCL_NORMAL);
    if Res = DS_OK then
    begin
      PlayDSBD.dwSize := SizeOf(PlayDSBD);
      PlayDSBD.dwFlags := DSBCAPS_CTRLVOLUME     OR
                          DSBCAPS_CTRLPAN        OR
                          DSBCAPS_CTRLFREQUENCY  OR
                          DSBCAPS_GLOBALFOCUS;

      PlayDSBD.dwBufferBytes := FPlayRecBufSize;//FAudioBufferSize;
      PlayDSBD.dwReserved := 0;
      PlayDSBD.lpwfxFormat := @FWaveFormat;
      Res := PlayDirectSound.CreateSoundBuffer(PlayDSBD, PlayTmpSoundBuffer, nil);
      if Res = DS_OK then
      begin
        Res := PlayTmpSoundBuffer.QueryInterface(IDirectSoundBuffer8, PlayDirectSoundBuffer);
        if Res = DS_OK then
        begin
          PlayTmpSoundBuffer := nil;
          Res := PlayDirectSoundBuffer.Lock(0,
          PlayDSBD.dwBufferBytes,
          PlayDSBuffer1,
          PDWord(FPlayBytesAllocated1),
          PlayDSBuffer2,
          PDWord(FPlayBytesAllocated2),
          0);
          if Res = DS_OK then
          begin

            FillMemory(PlayDSBuffer1,FPlayRecBufSize,0);

            FhModule := LoadLibrary(PChar(ExtractFilePath(Application.ExeName)+'speexw.acm'));
            if FhModule<>0 then
            begin
              FDebugStrList.Add('LoadLibrary returns: '+IntToHex(FhModule,8));
              DriverPtr := GetProcAddress(FhModule,'DriverProc');
              if DriverPtr<>nil then
              begin
                FDebugStrList.Add('GetProcAddress return: '+IntToHex(Cardinal(DriverPtr),8));
                ACMRes := acmDriverAdd(hID,FhModule,Integer(DriverPtr),0,ACM_DRIVERADDF_FUNCTION);
                case ACMRes of
                  MMSYSERR_INVALFLAG: FDebugStrList.Add('acmDriverAdd return: MMSYSERR_INVALFLAG');
                  MMSYSERR_INVALHANDLE: FDebugStrList.Add('acmDriverAdd return: MMSYSERR_INVALHANDLE');
                  MMSYSERR_INVALPARAM: FDebugStrList.Add('acmDriverAdd return: MMSYSERR_INVALPARAM');
                  MMSYSERR_NOMEM: FDebugStrList.Add('acmDriverAdd return: MMSYSERR_NOMEM');
                  MMSYSERR_NOTENABLED: FDebugStrList.Add('acmDriverAdd return: MMSYSERR_NOTENABLED');
                end;
                if ACMRes = 0 then
                begin
                  ACMEncoder := TACMEncoder.Create(41225,nil,hID);
                  FDebugStrList.Add('Enumerated Formats for Encoder:');
                  FDebugStrList.AddStrings(ACMEncoder.Items);
                  ACMEncoder.ItemIndex := ACMEncoder.Items.IndexOf('12.8 kBit/s, 16.0 kHz, Mono, Q4');
                  FDebugStrList.Add('ACMEncoder ItemIndex is '+IntToStr(ACMEncoder.ItemIndex));
                  ACMEncoder.SetBufferSize(FPlayRecBufSize);

                  Res := ACMEncoder.OpenCodec;
                  //if Res<>0 then
                  //if ACMEncoder.OpenCodec<>0 then
                    //ShowMessage('error opening codec. Error Code:'+IntToStr(Res));
                  if Res = 0 then
                  begin
                    ACMDecoder := TACMEncoder.Create(WAVE_FORMAT_PCM,ACMEncoder.DefaultDriver,hID);
                    for i := 0 to ACMDecoder.Items.Count -1 do
                    begin
                      if (PACMFormatDetails(ACMDecoder.Items.Objects[i]).pwfx.wFormatTag = FWaveFormat.wFormatTag)
                          and (PACMFormatDetails(ACMDecoder.Items.Objects[i]).pwfx.nChannels = FWaveFormat.nChannels)
                          and (PACMFormatDetails(ACMDecoder.Items.Objects[i]).pwfx.nSamplesPerSec = FWaveFormat.nSamplesPerSec)
                          and (PACMFormatDetails(ACMDecoder.Items.Objects[i]).pwfx.nAvgBytesPerSec = FWaveFormat.nAvgBytesPerSec)
                          and (PACMFormatDetails(ACMDecoder.Items.Objects[i]).pwfx.nBlockAlign = FWaveFormat.nBlockAlign)
                          and (PACMFormatDetails(ACMDecoder.Items.Objects[i]).pwfx.wBitsPerSample = FWaveFormat.wBitsPerSample) then
                      begin
                        ACMDecoder.ItemIndex := i;
                        break;
                      end;
                    end;
                    FDebugStrList.Add('ACMDecoder ItemIndex is '+IntToStr(ACMDecoder.ItemIndex));
                    ACMDecoder.SetBufferSize(8192);
                    //ACMDecoder.Items.SaveToFile('C:\Decoder.txt');

                    with PACMFormatDetails(ACMEncoder.Items.Objects[ACMEncoder.ItemIndex])^ do
                      Move(pwfx^, ACMDecoder.FACMConverter.InFormat^, cbwfx);

                    Res := ACMDecoder.OpenCodec;
                    if Res = 0 then
                    begin
                      //if Res<>0 then
                      //  ShowMessage('error opening codec. Error Code:'+IntToStr(Res));
                      PlayFirstWrite := True;

                      FSilenceDistance := PLAY_SILENCE_DISTANCE * FWaveFormat.nAvgBytesPerSec;
                      FPlaySilenceCursor := FSilenceDistance;
                      PlayDirectSoundBuffer.Play(0,0,DSBPLAY_LOOPING);
                      FirstTimeGetOutputData := True;
                    end
                    else
                    begin
                      FDebugStrList.Add('opencodec for decoder returns error: '+IntToHex(ACMRes,8));
                      FInitializeError := True;
                      PlayDirectSoundBuffer := nil;
                      PlayDirectSound := nil;
                    end;
                  end
                  else
                  begin
                    FDebugStrList.Add('opencodec for encoder returns error: '+IntToHex(ACMRes,8));
                    FInitializeError := True;
                    PlayDirectSoundBuffer := nil;
                    PlayDirectSound := nil;
                  end;
                end
                else
                begin
                  FDebugStrList.Add('acmDriverAdd returns an unknown error: '+IntToHex(ACMRes,8));
                  FInitializeError := True;
                  PlayDirectSoundBuffer := nil;
                  PlayDirectSound := nil;
                end;
              end
              else
              begin
                FDebugStrList.Add('GetProcAddress rerurns: '+IntToHex(Cardinal(DriverPtr),8));
                FInitializeError := True;
                PlayDirectSoundBuffer := nil;
                PlayDirectSound := nil;
              end;
            end
            else
            begin
              //  Unable To Lock Buffer //
              FDebugStrList.Add('Unable to Load Speexw.acm');
              FInitializeError := True;
              PlayDirectSoundBuffer := nil;
              PlayDirectSound := nil;
            end;
          end
          else
          begin
            //  Unable To Lock Buffer //
            FDebugStrList.Add('Unable to Lock Buffer');
            FDebugStrList.Add('Device: '+FDevices.Strings[0]);
            FInitializeError := True;
            PlayDirectSoundBuffer := nil;
            PlayDirectSound := nil;
          end;
        end
        else
        begin
          //  Unable To Query IDirectSoundBuffer8 //
          FDebugStrList.Add('Unable to Query DirectSoundBuffer8');
          FDebugStrList.Add('Device: '+FDevices.Strings[0]);
          FInitializeError := True;
          PlayTmpSoundBuffer := nil;
          PlayDirectSound := nil;
        end;
      end
      else
      begin
        // Unable To Create Sound Buffer //
        FDebugStrList.Add('Unable to create DirectSoundBuffer');
        FDebugStrList.Add('Device: '+FDevices.Strings[0]);
        FInitializeError := True;
        PlayDirectSound := nil;
      end;
    end
    else
    begin
      // Unable To Set Cooperative Level //
      FDebugStrList.Add('Unable to Set CooperativeLevel');
      FDebugStrList.Add('Device: '+FDevices.Strings[0]);
      FInitializeError := True;
      PlayDirectSound := nil;
    end;
  end
  else
  begin
    // Unable to Create DirectSound8 //
    FDebugStrList.Add('Unable To Create DirectSound8 Object On Device:'+FDevices.Strings[0]);
    FInitializeError := True;
  end;
end;

procedure TPlayThread.DestroyObjects;
begin
  if PlayDirectSoundBuffer<>nil then
  begin
    PlayDirectSoundBuffer.Unlock(PlayDSBuffer1,FPlayRecBufSize,PlayDSBuffer2,0);
  end;
  if PlayDirectSoundBuffer<> nil then
    PlayDirectSoundBuffer := nil;
  if PlayDirectSound<> nil then
    PlayDirectSound := nil;

{
  CaptureBuffer.Stop;
  Res := CaptureBuffer.Unlock(CapBuffer1,FPlayRecBufSize,nil,0);
  if Res<>DS_OK then
  begin
    RaiseConversionError('Cannot Unlock capture Buffer');
  end;
  if CaptureBuffer<>nil then
   CaptureBuffer := nil;
  if DirectSoundCapture8<>nil then
   DirectSoundCapture8 := nil;
}
  if CaptureBuffer<>nil then
    DestroyCaptureObjects;

  ACMDecoder.CloseCodec;
  ACMDecoder.Free;

  ACMEncoder.CloseCodec;
//  TestFileStream.Free;
//  TestFileStream2.Free;
  ACMEncoder.Free;
  FreeMem(BufForSend);
{$IFDEF PLAYLOG}
  FPlayLogger.Terminate;
{$ENDIF}
end;

procedure TPlayThread.Execute;
var
  BufPtr: Pointer;
  TmpBuffer: Pointer;
  TmpBufferUsed: Cardinal;
  BufSizeForSend: Cardinal;
  PlayCurrPos: Cardinal;
  CapCurPos4Meter: Cardinal;
  CurrentVolume: Integer;
  RecordStarted: Boolean;
begin
  inherited;
  RecordStarted := False;
  CurrentVolume := FOutputVolume;
  if not MainForm.AudioEnable then
  begin
    FThreadTerminated := True;
    Exit;
  end;
  CreateObjects;
  if FInitializeError then
  begin
    FThreadTerminated := True;
    MainForm.AudioEnable := False;
    Exit;
  end;
  FPLayReady := True;
  while not Terminated do
  begin
    // Create and initialize DirectSound Objects
    Sleep(10);

    if CurrentVolume<>FOutputVolume then
    begin
      PlayDirectSoundBuffer.SetVolume(FOutputVolume);
      CurrentVolume := FOutputVolume;
    end;
    if FLastIncomingDataTime <> 0 then
      if MilliSecondsBetween(Now,FLastIncomingDataTime)>3000 then
      begin
        FirstTimeGetOutputData := True;
        FLastIncomingDataTime := 0;
        PostMessage(FRoomWindowHandle,WCM_RemoveMicIcon,0,0);
      end;

//    Sleep(1);
    SilencePlayBuffer;
//    Sleep(1);

    if (RoomWindowHandle<>0) and (MainForm.ActiveRoomWindow<>nil) and (not MainForm.ActiveRoomWindow.MuteButton.Down) then
    begin
      // note that GetCurrentPosition generated an exception in ghazall PC //
      PlayDirectSoundBuffer.GetCurrentPosition(@PlayCurrPos,nil);
      FPlayMeterValue := GetMeterValue(PlayDSBuffer1,Pointer(Cardinal(PlayDSBuffer1)+FPlayRecBufSize),Pointer(Cardinal(PlayDSBuffer1)+PlayCurrPos));
    end
    else
      FPlayMeterValue := -100;

   { if MainForm.AudioTestDialog then
    begin
     MainForm.AudioTestDialog := True;
    end; }

    if Assigned(FSendVoiceBuffer) and (MainForm.ActiveRoomWindow<>nil) and (MainForm.ActiveRoomWindow.Streaming) then  // do if needed.
    begin
      if not RecordStarted then
      begin
        RecordStarted := True;
        CreateCaptureObjects;
        CaptureBuffer.Start(DSCBSTART_LOOPING);
        CaptureBuffer.GetCurrentPosition(nil,@CapCurrentPosition);
        CapLastPosition := CapCurrentPosition;
        Sleep(10);
      end;
      CaptureBuffer.GetCurrentPosition(nil,@CapCurrentPosition);
      CapCurrentPosition := CapCurrentPosition mod CapBuffer1Size;

      CapCurPos4Meter := CapCurrentPosition;
      if CapCurPos4Meter<FWaveFormat.nAvgBytesPerSec div vu_sec_divider then
        CapCurPos4Meter := FPlayRecBufSize- ((FWaveFormat.nAvgBytesPerSec div vu_sec_divider)-CapCurPos4Meter)
      else
        CapCurPos4Meter := CapCurPos4Meter - FWaveFormat.nAvgBytesPerSec div vu_sec_divider;

      RecMeterValue := GetMeterValue(CapBuffer1,Pointer(Cardinal(CapBuffer1)+FPlayRecBufSize),Pointer(Cardinal(CapBuffer1)+CapCurPos4Meter));

      if CapCurrentPosition>CapLastPosition then
      begin
        if CapCurrentPosition-CapLastPosition<FWaveFormat.nSamplesPerSec div 2 then
          Continue;
        BufPtr := Pointer(Cardinal(CapBuffer1)+CapLastPosition);
        ACMEncoder.WriteBuffer(BufPtr,CapCurrentPosition-CapLastPosition,TmpBuffer,TmpBufferUsed);
        CopyMemory(BufForSend,TmpBuffer,TmpBufferUsed);
        if Assigned(FSendVoiceBuffer) then FSendVoiceBuffer(BufForSend,TmpBufferUsed);
      end
      else
      if CapCurrentPosition<CapLastPosition then
      begin
        if (CapBuffer1Size-CapLastPosition)+CapCurrentPosition<FWaveFormat.nSamplesPerSec div 2 then
          Continue;
        BufPtr := Pointer(Cardinal(CapBuffer1)+CapLastPosition);
        ACMEncoder.WriteBuffer(BufPtr,CapBuffer1Size-CapLastPosition,TmpBuffer,TmpBufferUsed);
        CopyMemory(BufForSend,TmpBuffer,TmpBufferUsed);
        BufSizeForSend := TmpBufferUsed;
        BufPtr := CapBuffer1;
        ACMEncoder.WriteBuffer(BufPtr,CapCurrentPosition,TmpBuffer,TmpBufferUsed);
        CopyMemory(Pointer(Cardinal(BufForSend)+BufSizeForSend),TmpBuffer,TmpBufferUsed);
        if Assigned(FSendVoiceBuffer) then FSendVoiceBuffer(BufForSend,BufSizeForSend+TmpBufferUsed);
      end;
      CapLastPosition := CapCurrentPosition;
    end
    else
    begin
      RecMeterValue := -100;
      if RecordStarted then
        DestroyCaptureObjects;
      RecordStarted := False;
    end;
  end;
  DestroyObjects;
  FThreadTerminated := True;
end;

procedure TPlayThread.SilencePlayBuffer;
var
  CurrentPos: Cardinal;
  TotalUnNeededDistance: Integer;
  BytesToSilence: Cardinal;
begin
  FSilenceLock.Enter;
  PlayDirectSoundBuffer.GetCurrentPosition(nil,@CurrentPos);
  try
    if CurrentPos>FPlaySilenceCursor then
      TotalUnNeededDistance := FPlayRecBufSize - CurrentPos + FPlaySilenceCursor
    else
      TotalUnNeededDistance := FPlaySilenceCursor - CurrentPos;
  except
    ShowMessage('CurrentPos = '+IntToStr(CurrentPos)+'    FPlaySilenceCursor = '+IntToStr(FPlaySilenceCursor));
    Exit;
  end;
  if TotalUnNeededDistance>32000 then
    TotalUnNeededDistance := 32000;
  BytesToSilence := FSilenceDistance - TotalUnNeededDistance;

  if FPlaySilenceCursor+BytesToSilence>FPlayRecBufSize then
  begin
    FillMemory(Pointer(Cardinal(PlayDSBuffer1)+FPlaySilenceCursor),FPlayRecBufSize-FPlaySilenceCursor,0);
    FPlaySilenceCursor := BytesToSilence-(FPlayRecBufSize-FPlaySilenceCursor);
    FillMemory(PlayDSBuffer1,FPlaySilenceCursor,0);
  end
  else
  begin
    FillMemory(Pointer(Cardinal(PlayDSBuffer1)+FPlaySilenceCursor),BytesToSilence,0);
    FPlaySilenceCursor := FPlaySilenceCursor + BytesToSilence;
  end;
  FSilenceLock.Leave;
end;

function TPlayThread.GetMeterValue(BufferStart, BufferEnd,
  CurrPosition: Pointer): Single;
var
  SamplesNum: Cardinal;
  TmpSamplesNum: Cardinal;
  Count: Cardinal;
  BufPtr: Pointer;
  Sample: SmallInt;
  RealSample: Double;
  MeterValue: Double;
  DebugStr1,DebugStr2: string;
begin
  SamplesNum := FWaveFormat.nSamplesPerSec div vu_sec_divider;
  if SamplesNum<=0 then
  begin
    Result := -100;
    Exit;
  end;
  MeterValue := 0;
  CurrPosition := Pointer(Cardinal(CurrPosition) and $fffffffe);
  BufPtr := CurrPosition;
  if ((Cardinal(BufferEnd)-Cardinal(BufPtr)) div FWaveFormat.nBlockAlign)>=SamplesNum then
  begin
    for Count := 0 to SamplesNum-1 do
    begin
      Sample := PSmallInt(Bufptr)^;
      RealSample := Sample/32768;
      MeterValue := MeterValue + RealSample * RealSample;
      Inc(Cardinal(BufPtr),2);  // 2 = SizeOf(SmallInt)
    end;
  end
  else
  begin
    TmpSamplesNum := (Cardinal(BufferEnd)-Cardinal(BufPtr)) div 2;
    if TmpSamplesNum = 0 then
    begin
      DebugStr1 := '  Parameters:: BufferStart=' + IntToHex(Cardinal(BufferStart),8);
      DebugStr1 := DebugStr1 + '  BufferEnd=' + IntToHex(Cardinal(BufferEnd),8);
      DebugStr1 := DebugStr1 + '  CurrPosition=' + IntToHex(Cardinal(CurrPosition),8);
      DebugStr2 := '  BufPtr='+IntToHex(Cardinal(BufPtr),9)+'   Line Number 490';
{$IFDEF PLAYLOG}
      FPlayLogger.AddToLogFile(DebugStr1);
      FPlayLogger.AddToLogFile(DebugStr2);
{$ENDIF}
      Result := 0;
      Exit;
    end;
    for Count := 0 to TmpSamplesNum-1 do
    begin
      Sample := PSmallInt(Bufptr)^;
      RealSample := Sample/32768;
      MeterValue := MeterValue + RealSample * RealSample;
      Inc(Cardinal(BufPtr),2);
    end;
    TmpSamplesNum := SamplesNum - (Cardinal(BufferEnd)-Cardinal(CurrPosition)) div 2;
    BufPtr := BufferStart;
    if TmpSamplesNum = 0 then
    begin
      DebugStr1 := '  Parameters:: BufferStart=' + IntToHex(Cardinal(BufferStart),8);
      DebugStr1 := DebugStr1 + '  BufferEnd=' + IntToHex(Cardinal(BufferEnd),8);
      DebugStr1 := DebugStr1 + '  CurrPosition=' + IntToHex(Cardinal(CurrPosition),8);
      DebugStr2 := '  BufPtr='+IntToHex(Cardinal(BufPtr),9)+'   Line Number 509';
{$IFDEF PLAYLOG}
      FPlayLogger.AddToLogFile(DebugStr1);
      FPlayLogger.AddToLogFile(DebugStr2);
{$ENDIF}
      Result := 0;
      Exit;
    end;
    for Count := 0 to TmpSamplesNum-1 do
    begin
      Sample := PSmallInt(Bufptr)^;
      RealSample := Sample/32768;
      MeterValue := MeterValue + RealSample * RealSample;
      Inc(Cardinal(BufPtr),2);
    end;
  end;
  MeterValue := MeterValue / SamplesNum;

  if MeterValue>0 then
    Result := 20 * Log10(MeterValue)
  else
    Result := -100;

end;

procedure TPlayThread.SetOutputVolume(const Value: Integer);
begin
  FOutputVolume := Value;
  //PlayDirectSoundBuffer.SetVolume(FOutputVolume);
end;

function TPlayThread.CreateCaptureObjects: Boolean;
var
  Res: Integer;
  ErrStr: string;
begin
  //TADD
  //  Res := DirectSoundCaptureCreate8(@DSDEVID_DefaultCapture,DirectSoundCapture8,nil);
   Res := DirectSoundCaptureCreate8(PGUID(FDevicesCapture.Objects[MainForm.FSystemPreferences.AudioSoundCaptureDeviceIndex]),DirectSoundCapture8,nil);


  if Res<>DS_OK then
  begin
    MainForm.AudioEnable := False;
    //raise Exception.Create('Unable to initialize audio.');
    //RaiseConversionError('Cannot Create DirectSoundBuffer: '+IntToStr(Res));
    Result := False;
    Exit;
  end;
  DirectSoundCapture8.Initialize(nil);

  CaptureBufferDSC.dwSize := SizeOf(_DSCBUFFERDESC);
  CaptureBufferDSC.dwFlags := DSCBCAPS_WAVEMAPPED;
  CaptureBufferDSC.dwBufferBytes := FPlayRecBufSize;
  CaptureBufferDSC.dwReserved := 0;
  CaptureBufferDSC.lpwfxFormat := @FWaveFormat;
  CaptureBufferDSC.dwFXCount := 0;
  CaptureBufferDSC.lpDSCFXDesc := nil;
  //CaptureBufferDSC.dwFXCount := 1;
  //CaptureBufferDSC.lpDSCFXDesc := @CaptureEffectDesc;

  Res := DirectSoundCapture8.CreateCaptureBuffer(CaptureBufferDSC,TempCaptureBuffer,nil);
  if Res<>DS_OK then
  begin
    case Res of
    DSERR_INVALIDPARAM:  ErrStr := 'DSERR_INVALIDPARAM';
    DSERR_BADFORMAT:     ErrStr := 'DSERR_BADFORMAT';
    DSERR_GENERIC:       ErrStr := 'DSERR_GENERIC';
    DSERR_NODRIVER:      ErrStr := 'DSERR_NODRIVER';
    DSERR_OUTOFMEMORY:   ErrStr := 'DSERR_OUTOFMEMORY';
    DSERR_UNINITIALIZED: ErrStr := 'DSERR_UNINITIALIZED';
    end;
    DirectSoundCapture8 := nil;
    MainForm.AudioEnable := False;
    //RaiseConversionError('Cannot Create DirectSoundCapture: '+ErrStr);
    Result := False;
    Exit;
  end;
  Res := TempCaptureBuffer.QueryInterface(IID_IDirectSoundCaptureBuffer8,CaptureBuffer);
  if Res<>DS_OK then
  begin
    CaptureBuffer := nil;
    DirectSoundCapture8 := nil;
    MainForm.AudioEnable := False;
    //RaiseConversionError('Cannot Query IDirectSoundCaptureBuffer8');
    Result := False;
    Exit;
  end;
  TempCaptureBuffer := nil;

  CapBuffer1Size := FPlayRecBufSize;
  CapBuffer2Size := 0;
  Res := CaptureBuffer.Lock(
  0,
  FPlayRecBufSize,
  CapBuffer1,
  PDWord(CapBuffer1Size),
  CapBuffer2,
  PDWord(CapBuffer2Size),
  0);
  if Res<>DS_OK then
  begin
    MainForm.AudioEnable := False;
    CaptureBuffer := nil;
    DirectSoundCapture8 := nil;
    Result := False;
    Exit;
    //RaiseConversionError('Cannot LockBuffer');
  end;
  Result := True;
  CapLastPosition := 0;
end;

procedure TPlayThread.DestroyCaptureObjects;
var
  Res: Integer;
begin
  CaptureBuffer.Stop;
  Res := CaptureBuffer.Unlock(CapBuffer1,FPlayRecBufSize,nil,0);
  if Res<>DS_OK then
  begin
    RaiseConversionError('Cannot Unlock capture Buffer');
  end;
  if CaptureBuffer<>nil then
   CaptureBuffer := nil;
  if DirectSoundCapture8<>nil then
   DirectSoundCapture8 := nil;
end;

procedure TPlayThread.RemoveInvalidAudioDevices;
var
  i: Integer;
  TmpDirectSound8: IDirectSound8;
  TmpDirectSoundCapture8: IDirectSoundCapture8;
begin
  i := 0;
  while i < FDevices.Count do
  begin
    if DirectSoundCreate8(PGUID(FDevices.Objects[i]),TmpDirectSound8,nil) = DS_OK then
    begin
      TmpDirectSound8 := nil;
      Inc(i);
    end
    else
      FDevices.Delete(i);
  end;
  // Capture Device
  i := 0;
  while i < FDevicesCapture.Count do
  begin
    if DirectSoundCaptureCreate8(PGUID(FDevicesCapture.Objects[i]),TmpDirectSoundCapture8,nil) = DS_OK then
    begin
      TmpDirectSoundCapture8 := nil;
      Inc(i);
    end
    else
      FDevicesCapture.Delete(i);
  end;

end;

end.
