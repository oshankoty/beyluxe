unit LogThread;

interface

uses
  Windows, Classes, SysUtils, SyncObjs;

type
  TLogger = Class(TThread)
  private
    FStringList: TStringList;
    FLogFileStream: TFileStream;
    FCriticalSection: TCriticalSection;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; FileName: string);
    destructor Destroy; override;
    procedure AddToLogFile(Msg: string);
  end;

implementation

{ TLogger }

constructor TLogger.Create(CreateSuspended: Boolean; FileName: string);
begin
  FStringList := TStringList.Create;
  FLogFileStream := TFileStream.Create(FileName,fmCreate or fmShareDenyNone,fmShareDenyNone);
  FCriticalSection := TCriticalSection.Create;
  inherited Create(CreateSuspended);
end;

destructor TLogger.Destroy;
begin
  FCriticalSection.Free;
  FLogFileStream.Free;
  FStringList.Free;
  inherited;
end;

procedure TLogger.AddToLogFile(Msg: string);
begin
  FCriticalSection.Enter;
  FStringList.Add(Msg+ #13 + #10);
  FCriticalSection.Leave;
end;

procedure TLogger.Execute;
var
  StrToWrite: PChar;
begin
  inherited;
  Priority := tpTimeCritical;
  FreeOnTerminate := True;
  while not Terminated do
  begin
    Sleep(1);
    while FStringList.Count>0 do
    begin
      StrToWrite := PChar(FStringList.Strings[0]);
      FLogFileStream.Write(StrToWrite^,StrLen(StrToWrite));
      FCriticalSection.Enter;
      FStringList.Delete(0);
      FCriticalSection.Leave;
    end;
  end;
end;

end.
