unit CMClasses;

interface

uses
  Windows, SysUtils, Types, Classes, Controls, Graphics, ComCtrls, ImgList,
  Forms, Registry, ShellAPI, StrUtils;

type
	TCPUID	= array[1..4] of Longint;
	TVendor	= array [0..11] of char;

  TItemDblClick = procedure (Item: Integer) of object;
  TWinVersion = (wvUnknown, wvWin95, wvWin98, wvWin98SE, wvWinNT, wvWinME, wvWin2000, wvWinXP, wvWinVista) ;
  TUserSetting = record
    GroupBold: Boolean;
    GroupItalic: Boolean;
    GroupUnderLine: Boolean;
    GroupColor: TColor;
    GroupFontSize: Byte;
    GroupJoinNotify: Boolean;
    GroupLeftNotify: Boolean;

    PMBold: Boolean;
    PMItalic: Boolean;
    PMUnderLine: Boolean;
    PMColor: TColor;
    PMFontSize: Byte;
  end;

  TFriendListSubClassInfo = class(TObject)
  public
    StatusStr: string;
    Icon: Byte;
  end;

  TFriendList = class(TObject)
  private
    { Private declarations }
//    FStatusList: TStringList;
    function GetIndexOfFriend(Name: string): Integer;
    function GetCount: Integer;
    function GetIconIndex(BuddyIndex: Integer): Byte;
    procedure SetIconIndex(BuddyIndex: Integer; const Value: Byte);
  protected

  public
    { Public declarations }
    FFriendList: TStringList;
    property FirendList: TStringList read FFriendList;
    //property StatusList: TStringList read FStatusList;
    property Icons[BuddyIndex: Integer]: Byte read GetIconIndex write SetIconIndex;
    property IndexOf[BudyName: string]: Integer read GetIndexOfFriend;
    property Count: Integer read GetCount;
    procedure Add(BudyName, Status: string; Icon: Integer);
    procedure Clear;
    function Remove(Index: Integer): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TSystemSetting = record
    AutoStartup: Boolean;
    WindowX: Integer;
    WindowY: Integer;
    DefaultPMBehavior: Byte;
    DefaultRoomBehavior: Byte;
    DefaultTheme: Byte;
    ArchiveEnabled: Boolean;
    AutoRemoveArchive: Boolean;
  end;

const
	ID_BIT	=	$200000;			// EFLAGS ID bit

function BrowseURL(const URL: string): Boolean;
function CorrectHTMLCode(HTMLCode: string): string;
function CorrectHTMLLinks(HTMLCode: string): string;
function Hex2DecString(HexaByte:array of byte): string;
function WebColor(DelphiColor: TColor): Integer;
function IsDigit(Ch: Char): Boolean;
function IsAlph(Ch: Char): Boolean;
function IsSeperator(Ch: Char): Boolean;
function GetCPUIDText: string;

implementation

{ TFriendList }
{$R *.Res}

uses
  MainUnit;

function IsCPUID_Available : Boolean; register;
asm
	PUSHFD							{direct access to flags no possible, only via stack}
  POP     EAX					{flags to EAX}
  MOV     EDX,EAX			{save current flags}
  XOR     EAX,ID_BIT	{not ID bit}
  PUSH    EAX					{onto stack}
  POPFD								{from stack to flags, with not ID bit}
  PUSHFD							{back to stack}
  POP     EAX					{get back to EAX}
  XOR     EAX,EDX			{check if ID bit affected}
  JZ      @exit				{no, CPUID not availavle}
  MOV     AL,True			{Result=True}
@exit:
end;

function GetCPUID : TCPUID; assembler; register;
asm
  PUSH    EBX         {Save affected register}
  PUSH    EDI
  MOV     EDI,EAX     {@Resukt}
  MOV     EAX,1
  DW      $A20F       {CPUID Command}
  STOSD			          {CPUID[1]}
  MOV     EAX,EBX
  STOSD               {CPUID[2]}
  MOV     EAX,ECX
  STOSD               {CPUID[3]}
  MOV     EAX,EDX
  STOSD               {CPUID[4]}
  POP     EDI					{Restore registers}
  POP     EBX
end;

function GetCPUVendor : TVendor; assembler; register;
asm
  PUSH    EBX					{Save affected register}
  PUSH    EDI
  MOV     EDI,EAX			{@Result (TVendor)}
  MOV     EAX,0
  DW      $A20F				{CPUID Command}
  MOV     EAX,EBX
  XCHG		EBX,ECX     {save ECX result}
  MOV			ECX,4
@1:
  STOSB
  SHR     EAX,8
  LOOP    @1
  MOV     EAX,EDX
  MOV			ECX,4
@2:
  STOSB
  SHR     EAX,8
  LOOP    @2
  MOV     EAX,EBX
  MOV			ECX,4
@3:
  STOSB
  SHR     EAX,8
  LOOP    @3
  POP     EDI					{Restore registers}
  POP     EBX
end;

procedure TFriendList.Add(BudyName, Status: string; Icon: Integer);
var
  StatSubClass: TFriendListSubClassInfo;
begin
  StatSubClass := TFriendListSubClassInfo.Create;
  StatSubClass.StatusStr := Status;
  StatSubClass.Icon := Icon;
  FFriendList.AddObject(BudyName,StatSubClass);
end;

procedure TFriendList.Clear;
var
  i: Integer;
begin
  for i := 0 to FFriendList.Count - 1 do
    TFriendListSubClassInfo(FFriendList.Objects[i]).Free;
  FFriendList.Clear;
//  FStatusList.Clear;
end;

constructor TFriendList.Create;
begin
  inherited Create;
  FFriendList := TStringList.Create;
//  FStatusList := TStringList.Create;
end;

destructor TFriendList.Destroy;
begin
//  FStatusList.Free;
  while FFriendList.Count>0 do
    Remove(0);
  FFriendList.Free;
  inherited;
end;

function TFriendList.GetCount: Integer;
begin
  Result := FFriendList.Count;
end;

function TFriendList.GetIconIndex(BuddyIndex: Integer): Byte;
begin
  Result := TFriendListSubClassInfo(FFriendList.Objects[BuddyIndex]).Icon;
end;

function TFriendList.GetIndexOfFriend(Name: string): Integer;
begin
  Result := FFriendList.IndexOf(Name);
end;

function TFriendList.Remove(Index: Integer): Boolean;
begin
  if (Index>-1) and (Index<FFriendList.Count) then
  begin
    FFriendList.Objects[Index].Free;
    FFriendList.Delete(Index);
  end;
  Result := False;
end;

procedure TFriendList.SetIconIndex(BuddyIndex: Integer; const Value: Byte);
begin
  TFriendListSubClassInfo(FFriendList.Objects[BuddyIndex]).Icon := Value;
end;

function BrowseURL(const URL: string): Boolean;
var
   Browser: string;
begin
  Result := True;
  Browser := '';
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    Access := KEY_QUERY_VALUE;
    if OpenKey('\Software\Clients\StartMenuInternet', False) then
      Browser := ReadString('') ;
    CloseKey;
    RootKey := HKEY_LOCAL_MACHINE;
    Access := KEY_QUERY_VALUE;
    if OpenKey('\Software\Clients\StartMenuInternet\'+Browser+ '\shell\open\command', False) then
      Browser := ReadString('');
    CloseKey;
  finally
    Free;
  end;

  if MainForm.SystemPreferences.OpenInNewBrowser then
  begin
    if Browser = '' then
    begin
      ShellExecute(0, 'open', PChar(URL),nil,nil, SW_SHOWNORMAL);
      Exit;
    end;
    ShellExecute(0, 'open', PChar(Browser), PChar(URL), nil, SW_SHOW) ;
  end
  else
    ShellExecute(0, 'open', PChar(URL),nil,nil, SW_SHOWNORMAL);
end;

function CorrectHTMLCode(HTMLCode: string): string;
begin
  while Pos('</font>',HTMLCode)>0 do
    Delete(HTMLCode,Pos('</font>',HTMLCode),7);
  HTMLCode := StringReplace(HTMLCode,'&auml;','?',[rfReplaceAll]);
  Result := HTMLCode;
end;

function Hex2DecString(HexaByte:array of byte): string;
var
  i: Integer;
begin
  for i := 0 to Length(HexaByte) - 1 do
    Result := Result + Chr(hexaByte[i]-10);
end;

function CorrectHTMLLinks(HTMLCode: string): string;
var
  Str: string;
  LinkStr: string;
  StartLinkPos: Integer;
  EndLinkPos: Integer;
  OutLinkStr: string;
  nbspPos: Integer;
  LessThanPos: Integer;
  SPacePos: Integer;
begin
  Str := StringReplace(HTMLCode,#160,#32,[rfReplaceAll]);
  StartLinkPos := Pos('http://',LowerCase(Str));
  if StartLinkPos = 0 then
    StartLinkPos := Pos('www.',LowerCase(Str));
  if StartLinkPos>0 then
  begin
    EndLinkPos := 0;
    SPacePos := PosEX(' ',Str,StartLinkPos);
    LessThanPos := PosEX('<',Str,StartLinkPos);
    nbspPos := PosEX('&nbsp',Str,StartLinkPos);
    if SPacePos>0 then
      EndLinkPos := SPacePos
    else
    if nbspPos>0 then
      EndLinkPos := nbspPos
    else
    if LessThanPos>0 then
      EndLinkPos := LessThanPos;

    if EndLinkPos>0 then
    begin
      if (LessThanPos<EndLinkPos) and (LessThanPos>0) then
        EndLinkPos := LessThanPos;
      if (nbspPos<EndLinkPos) and (nbspPos>0) then
        EndLinkPos := nbspPos;
      if (SPacePos<EndLinkPos) and (SPacePos>0) then
        EndLinkPos := SPacePos;
    end;
    if EndLinkPos = 0 then
      EndLinkPos := Length(Str)+1;
    LinkStr := Copy(Str,StartLinkPos,EndLinkPos-StartLinkPos);
    OutLinkStr := StringReplace(Str,LinkStr,'<a href="'+LinkStr+'">'+LinkStr+'</a>',[rfReplaceAll]);
    Result := OutLinkStr;
  end
  else
    Result := HTMLCode;
end;

function WebColor(DelphiColor: TColor): Integer;
begin
  Result := (DelphiColor and $FF00) or ((DelphiColor and $FF) shl 16) or ((DelphiColor and $FF0000) shr 16);
end;

function IsAlph(Ch: Char): Boolean;
begin
  Result := ((Byte(Ch)>64) and (Byte(Ch)<91)) or ((Byte(Ch)>96) and (Byte(Ch)<123))
end;

function IsDigit(Ch: Char): Boolean;
begin
  Result := (Byte(Ch)>$2F) and (Byte(Ch)<$3A)
end;

function IsSeperator(Ch: Char): Boolean;
begin
  Result := (Ch=' ') or (Ch='_') or (Ch='-') or (Ch='.')
end;

function GetWinVersion: TWinVersion;
var
   osVerInfo: TOSVersionInfo;
   majorVersion, minorVersion: Integer;
begin
   Result := wvUnknown;
   osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo) ;
   if GetVersionEx(osVerInfo) then
   begin
     minorVersion := osVerInfo.dwMinorVersion;
     majorVersion := osVerInfo.dwMajorVersion;
     case osVerInfo.dwPlatformId of
       VER_PLATFORM_WIN32_NT:
       begin
         if majorVersion <= 4 then
           Result := wvWinNT
         else if (majorVersion = 5) and (minorVersion = 0) then
           Result := wvWin2000
         else if (majorVersion = 5) and (minorVersion = 1) then
           Result := wvWinXP
         else if (majorVersion = 6) then
           Result := wvWinVista;
       end;
       VER_PLATFORM_WIN32_WINDOWS:
       begin
         if (majorVersion = 4) and (minorVersion = 0) then
           Result := wvWin95
         else if (majorVersion = 4) and (minorVersion = 10) then
         begin
           if osVerInfo.szCSDVersion[1] = 'A' then
             Result := wvWin98SE
           else
             Result := wvWin98;
         end
         else if (majorVersion = 4) and (minorVersion = 90) then
           Result := wvWinME
         else
           Result := wvUnknown;
       end;
     end;
   end;
end;

function GetCPUIDText: string;
var
  CPUID : TCPUID;
  I     : Integer;
  S			: TVendor;
begin
  Result := '';
	for I := Low(CPUID) to High(CPUID)  do CPUID[I] := -1;
    if IsCPUID_Available then
    begin
      CPUID	:= GetCPUID;
      Result := Result + IntToHex(CPUID[1],8);
      Result := Result + IntToHex(CPUID[2],8);
      Result := Result + IntToHex(CPUID[3],8);
      Result := Result + IntToHex(CPUID[4],8);
    end
end;

end.
