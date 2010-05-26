unit ClientThread;

interface

uses
  Windows, SysUtils, Sockets, syncobjs, classes, DateUtils, IdTCPClient;

type
  // The serverthread is a descendant of the
  // TServerClientThread
  TClientThread = class(TThread)
  private
    FInputCriticalSection: TCriticalSection;
    FOutputCriticalSection: TCriticalSection;
    FThreadTerminated: Boolean;
    FTCPClient: TTcpClient;
    FRemoteHost: string;
    FRemotePort: string;
    FThreadStarted: Boolean;
    FLastSentTime: TDateTime;
    FOwnerHandle: HWND;
    procedure SetRemoteHost(const Value: string);
    procedure SetRemotePort(const Value: string);
    function AttempToRead(Buffer: Pointer; Size: Integer): Integer;
    function AttempToWrite(Buffer: Pointer; Size: Integer): Integer;
  public
    OutputBufferList: TList;
    InputBufferList: TList;
    procedure Execute; override;
    // The ClientExecute overrides the
    // TServerClientThread.ClientExecute
    // and contains the actual code that is
    // executed when the thread is started
    function Connect: Boolean;
    function Connected: Boolean;
    procedure Disconnect;
    procedure SendBuffer(Buffer: Pointer; BufferLength: Integer);
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    property InputCriticalSection: TCriticalSection read FInputCriticalSection write FInputCriticalSection;
    property OutputCriticalSection: TCriticalSection read FOutputCriticalSection write FOutputCriticalSection;
    property ThreadTerminated: Boolean read FThreadTerminated;
    property ThreadStarted: Boolean read FThreadStarted;
    property RemoteHost: string read FRemoteHost write SetRemoteHost;
    property RemotePort: string read FRemotePort write SetRemotePort;
    property LastSentTime: TDateTime read FLastSentTime write FLastSentTime;
    property OwnerHandle: HWND read FOwnerHandle write FOwnerHandle;
  end;

implementation

uses
  CommunicatorTypes, MainUnit, IdTCPConnection;

{ TClientThread }

procedure TClientThread.Execute;
var
  RetryCount: Integer;
  Sent: Boolean;
  Buffer: Pointer;
  BufferSize: Integer;
  LocalBuffer: Pointer;
  HeaderBuffer: array [0..10] of Byte;
  RWCount: Integer;
begin
  inherited;
  FreeOnTerminate := False;
  FThreadStarted := True;
  Priority := tpLower;
  while (not Terminated) and (FTCPClient.Connected) do
  begin
    // read and proccess incoming data
    Sleep(1);
    if FTCPClient.WaitForData(250) then
    begin
      RWCount := AttempToRead(@HeaderBuffer,9);
      if RWCount = 9 then
      begin
        BufferSize := PCommunicatorPacket(@HeaderBuffer).BufferSize;
        if BufferSize = 0 then
          Continue;
        GetMem(LocalBuffer,BufferSize);
        CopyMemory(LocalBuffer,@HeaderBuffer,9);
        if BufferSize>9 then
          AttempToRead(Pointer(Cardinal(LocalBuffer)+9),BufferSize-9);
        FInputCriticalSection.Enter;
        InputBufferList.Add(LocalBuffer);
        FInputCriticalSection.Leave;
      end
      else
      begin
        FTCPClient.Close;
        Terminate;
        //FThreadTerminated := True;
      end;
    end;
      // Send pending data buffers
    while OutputBufferList.Count>0 do
    begin
      Sent := False;
      RWCount := 0;
      for RetryCount := 0 to 1 do
      begin
        Buffer := OutputBufferList.items[0];
        BufferSize := PCommunicatorPacket(Buffer).BufferSize;
        //RWCount := FTCPClient.SendBuf(Buffer^,BufferSize);
        if RWCount>0 then
          RWCount := RWCount + AttempToWrite(Pointer(Cardinal(Buffer)+Cardinal(RWCount)),BufferSize-RWCount)
        else
          RWCount := AttempToWrite(Buffer,BufferSize);
        if RWCount = BufferSize then
        begin
          FreeMem(Buffer);
          FOutputCriticalSection.Enter;
          OutputBufferList.Delete(0);
          FOutputCriticalSection.Leave;
          Sent := True;
          Break;
        end;
      end;
      if not Sent then
      begin
        FTCPClient.Close;
        FThreadTerminated := True;
        PostMessage(OwnerHandle,WCM_Disconnected,0,0);
        Exit;
      end;
    end;
  end;
  if FTCPClient.Connected then
    FTCPClient.Disconnect;
  FThreadTerminated := True;
end;

constructor TClientThread.Create(CreateSuspended: Boolean);
begin
  FTCPClient := TTcpClient.Create(nil);
  FTCPClient.RemoteHost := '82.99.200.246';
  FTCPClient.RemotePort := '5010';
  FTCPClient.BlockMode := bmBlocking;
  FInputCriticalSection := TCriticalSection.Create;
  FOutputCriticalSection := TCriticalSection.Create;
  InputBufferList := TList.Create;
  OutputBufferList := TList.Create;
  inherited Create(CreateSuspended);
end;

destructor TClientThread.Destroy;
begin
  while OutputBufferList.Count>0 do
  begin
    FreeMem(OutputBufferList.Items[0]);
    OutputBufferList.Delete(0);
  end;
  OutputBufferList.Free;
  while InputBufferList.Count>0 do
  begin
    FreeMem(InputBufferList.Items[0]);
    InputBufferList.Delete(0);
  end;
  InputBufferList.Free;

  FOutputCriticalSection.Free;
  FInputCriticalSection.Free;
  if FTCPClient.Connected then
    FTCPClient.Disconnect;
  FTCPClient.Free;
  inherited;
end;

procedure TClientThread.SendBuffer(Buffer: Pointer; BufferLength: Integer);
var
  LocalBuffer: Pointer;
begin
  if BufferLength = 0 then Exit;
  GetMem(LocalBuffer,BufferLength);
  CopyMemory(LocalBuffer,Buffer,BufferLength);
  FOutputCriticalSection.Enter;
  OutputBufferList.Add(LocalBuffer);
  FOutputCriticalSection.Leave;
  FLastSentTime := Now;
end;

function TClientThread.Connect: Boolean;
begin
  Result := FTCPClient.Connect;
end;

procedure TClientThread.Disconnect;
begin
  FTCPClient.Disconnect;
end;

function TClientThread.Connected: Boolean;
begin
  Result := FTCPClient.Connected;
end;

procedure TClientThread.SetRemoteHost(const Value: string);
begin
  FRemoteHost := Value;
  FTCPClient.RemoteHost := FRemoteHost;
end;

procedure TClientThread.SetRemotePort(const Value: string);
begin
  FRemotePort := Value;
  FTCPClient.RemotePort := FRemotePort;
end;

function TClientThread.AttempToRead(Buffer: Pointer;
  Size: Integer): Integer;
var
  RWCount: Integer;
  RWCount1: Integer;
  ReadStartTime: TDateTime;
begin
  ReadStartTime := Now;
  RWCount := FTCPClient.ReceiveBuf(Buffer^,Size);

  while RWCount<Size do
  begin
    if FTCPClient.WaitForData(100) then
    begin
      if RWCount<0 then
      begin
        Result := 0;
        Exit;
      end;
      RWCount1 := FTCPClient.ReceiveBuf(Pointer(Cardinal(Buffer)+Cardinal(RWCount))^,Size-RWCount);
      RWCount := RWCount + RWCount1;
    end;
    if MilliSecondsBetween(Now,ReadStartTime)>3000 then
      break;
  end;
  Result := RWCount;
end;

function TClientThread.AttempToWrite(Buffer: Pointer;
  Size: Integer): Integer;
var
  RWCount: Integer;
  RWCount1: Integer;
  WriteStartTime: TDateTime;
begin
  WriteStartTime := Now;
  RWCount := FTCPClient.SendBuf(Buffer^,Size);

  while RWCount<Size do
  begin
    Sleep(2);
    if RWCount<0 then
    begin
      Result := 0;
      Exit;
    end;
    RWCount1 := FTCPClient.SendBuf(Pointer(Cardinal(Buffer)+Cardinal(RWCount))^,Size-RWCount);
    RWCount := RWCount + RWCount1;
    if MilliSecondsBetween(Now,WriteStartTime)>1500 then
      break;
  end;
  Result := RWCount;
end;

end.
