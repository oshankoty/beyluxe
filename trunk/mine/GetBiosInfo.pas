unit GetBiosInfo;

interface

uses
  Windows, SysUtils, BiosHelp;

const
  RES_MAINICON_ID = 1;
  UuidNone: array[0..15] of Byte = (
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00);
  UuidUnset: array[0..15] of Byte = (
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);
  DateOffset = Pointer($000FFFF5);

type
  PSmBiosEntryPoint = ^TSmBiosEntryPoint;
  TSmBiosEntryPoint = packed record
    AnchorString  : array [0..3] of AnsiChar;
    Checksum      : Byte;
    Length        : Byte;
    MajorVersion  : Byte;
    MinorVersion  : Byte;
    MaxStructSize : Word;
    Revision      : Byte;
    FormattedArea : array [0..4] of Byte;
    Intermediate  : packed record
      AnchorString: array [0..4] of AnsiChar;
      Checksum    : Byte;
      TableLength : Word;
      TableAddress: Longword;
      NumStructs  : Word;
      Revision    : Byte;
    end;
  end;

  PDmiHeader = ^TDmiHeader;
  TDmiHeader = packed record
    Type_ : Byte;
    Length: Byte;
    Handle: Word;
  end;

  PDmiType0 = ^TDmiType0;
  TDmiType0 = packed record
    Header         : TDmiHeader;
    Vendor         : Byte;
    Version        : Byte;
    StartingSegment: Word;
    ReleaseDate    : Byte;
    BiosRomSize    : Byte;
    Characteristics: Int64;
    ExtensionBytes : array [0..1] of Byte;
  end;

  PDmiType1 = ^TDmiType1;
  TDmiType1 = packed record
    Header      : TDmiHeader;
    Manufacturer: Byte;
    ProductName : Byte;
    Version     : Byte;
    SerialNumber: Byte;
    UUID        : array [0..15] of Byte;
    WakeUpType  : Byte;
  end;

  TBiosInfo = class(TObject)
  private
    Dump: TRomBiosDump;
    SmEP: TSmBiosEntryPoint;
    Addr: Pointer;
    TEnd: Cardinal;
    Dmi0: TDmiType0;
    Dmi1: TDmiType1;
    FReleaseDate: string;
    FROMBiosVersion: string;
    FBiosVendor: string;
    FBiosVersion: string;
    FBiosReleaseDate: string;
    FBiosStartAddress: string;
    FROMBiosSize: string;
    FManufacturer: string;
    FSystemVersion: string;
    FProductName: string;
    FSerialNumber: string;
    FUniversalUniqueID: string;
    FWakeUpType: string;
    function SmBiosGetEntryPoint(var Dump: TRomBiosDump;
      out SmEP: TSmBiosEntryPoint): PSmBiosEntryPoint;
    function SmBiosGetNextEntry(var Dump: TRomBiosDump;
      Entry: Pointer): Pointer;
    function SmBiosGetString(var Dump: TRomBiosDump; Entry: Pointer;
      Index: Byte): string;
    function GetBiosInfo: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property ReleaseDate: string read FReleaseDate ;
    property ROMBiosVersion: string read FROMBiosVersion;
    property BiosVendor: string read FBiosVendor;
    property BiosVersion: string read FBiosVersion;
    property BiosReleaseDate: string read FBiosReleaseDate;
    property BiosStartAddress: string read FBiosStartAddress;
    property ROMBiosSize: string read FROMBiosSize;
    property Manufacturer: string read FManufacturer;
    property ProductName: string read FProductName;
    property SystemVersion: string read FSystemVersion;
    property SerialNumber: string read FSerialNumber;
    property UniversalUniqueID: string read FUniversalUniqueID;
    property WakeUpType: string read FWakeUpType;
  end;

implementation

{ TBiosInfo }

constructor TBiosInfo.Create;
begin
  inherited;
  GetBiosInfo;
end;

destructor TBiosInfo.Destroy;
begin

  inherited;
end;

function TBiosInfo.GetBiosInfo: Boolean;
var
  Loop: Integer;
begin
  if not DumpRomBios(Dump, rdmAutomatic, 5000) then
  begin
    Result := False;
    Exit;
  end;

  // find SMBIOS Entry Point Structure
  if SmBiosGetEntryPoint(Dump, SmEP) = nil then
  begin
    FReleaseDate :=  PChar(GetRomDumpAddr(Dump, DateOffset));
    Result := False;
    Exit;
  end
  else
  begin
    // display SMBIOS Version
    FROMBiosVersion := IntToStr(SmEP.MajorVersion) + '.' + IntToStr(SmEP.MinorVersion);

    // validate table address
    if (SmEP.Intermediate.TableAddress >= RomBiosDumpBase) and
      (SmEP.Intermediate.TableAddress <= RomBiosDumpEnd) then
    with SmEP do
    begin

      // scan through the table
      Addr := Pointer(Intermediate.TableAddress);
      TEnd := Intermediate.TableAddress + Intermediate.TableLength;
      repeat

        // read DMI header
        ReadRomDumpBuffer(Dump, Addr, Dmi0.Header, SizeOf(TDmiHeader));

        // BIOS Information
        if Dmi0.Header.Type_ = 0 then
        begin
          // read the full entry
          ReadRomDumpBuffer(Dump, Addr, Dmi0, SizeOf(TDmiType0));
          // validate length
          if Dmi0.Header.Length < $12 then
          begin
            Addr := SmBiosGetNextEntry(Dump, Addr);
            Continue;
          end;
            // build info text
          FBiosVendor := SmBiosGetString(Dump, Addr, Dmi0.Vendor);
          FBiosVersion := SmBiosGetString(Dump, Addr, Dmi0.Version);
          FBiosReleaseDate := SmBiosGetString(Dump, Addr, Dmi0.ReleaseDate);
          //FBiosStartAddress := 'BIOS Start Address: ' +
          //  IntToHex(Dmi0.StartingSegment, 4) + ':0000 (' +
          //  IntToStr(($10000 - Dmi0.StartingSegment) div 64) + ' KB)';
          //FROMBiosSize := IntToStr((Dmi0.BiosRomSize + 1) * 64) + ' KB';
        end

        // System Information
        else if Dmi0.Header.Type_ = 1 then
        begin
          // read the full entry
          ReadRomDumpBuffer(Dump, Addr, Dmi1, SizeOf(TDmiType1));
          // validate length
          if Dmi1.Header.Length < $08 then
          begin
            Addr := SmBiosGetNextEntry(Dump, Addr);
            Continue;
          end;
          // build info text
          FManufacturer := SmBiosGetString(Dump, Addr, Dmi1.Manufacturer);
          FProductName := SmBiosGetString(Dump, Addr, Dmi1.ProductName);
          FSystemVersion := SmBiosGetString(Dump, Addr, Dmi1.Version);
          FSerialNumber := SmBiosGetString(Dump, Addr, Dmi1.SerialNumber);
          if (Dmi1.Header.Length >= $19) then
          begin
            if CompareMem(@Dmi1.UUID, @UuidNone, SizeOf(Dmi1.UUID)) then
              FUniversalUniqueID := '<not present>'
            else
            if CompareMem(@Dmi1.UUID, @UuidUnset, SizeOf(Dmi1.UUID)) then
              FUniversalUniqueID := '<not set>'
            else
            begin
              for Loop := 0 to 7 do
                FUniversalUniqueID := FUniversalUniqueID + IntTohex(Dmi1.UUID[Loop], 2) + ' ';
              for Loop := 8 to 15 do
                FUniversalUniqueID := FUniversalUniqueID + IntTohex(Dmi1.UUID[Loop], 2) + ' ';
            end;
            {
            case Dmi1.WakeUpType of
              0: FWakeUpType := 'Reserved';
              1: FWakeUpType := 'Other';
              2: FWakeUpType := 'Unknown';
              3: FWakeUpType := 'APM Timer';
              4: FWakeUpType := 'Modem Ring';
              5: FWakeUpType := 'LAN Remote';
              6: FWakeUpType := 'Power Switch';
              7: FWakeUpType := 'PCI PME#';
              8: FWakeUpType := 'AC Power Restored';
            else
              FWakeUpType := '<unknown> (' +
                IntToStr(Dmi1.WakeUpType) + ')';
            end;
            }
          end;
        end;

        // next entry
        Addr := SmBiosGetNextEntry(Dump, Addr);
        if Addr = nil then
          Break;

      // until end-of-table-entry found or end of table reached
      until (Dmi0.Header.Type_ = $7F) or (Cardinal(Addr) >= TEnd);

    end;
  end;
end;

function TBiosInfo.SmBiosGetEntryPoint(var Dump: TRomBiosDump;
  out SmEP: TSmBiosEntryPoint): PSmBiosEntryPoint;
var
  Addr: Pointer;
  Loop: Integer;
  Csum: Byte;
begin
  Result := nil;
  Addr := Pointer(RomBiosDumpBase - $10);
  while Cardinal(Addr) < RomBiosDumpEnd - SizeOf(TSmBiosEntryPoint) do
  begin
    Inc(Cardinal(Addr), $10);
    if PLongword(GetRomDumpAddr(Dump, Addr))^ = $5F4D535F then  // '_SM_'
    begin
      ReadRomDumpBuffer(Dump, Addr, SmEP, SizeOf(TSmBiosEntryPoint));
      if SmEP.Length < $1F then
        Continue;
      if SmEP.Length > SizeOf(TSmBiosEntryPoint) then
        Continue;
{$R-}
      Csum := 0;
      for Loop := 0 to SmEP.Length - 1 do
        Csum := Csum + PByteArray(@SmEP)^[Loop];
      if Csum <> 0 then
        Continue;
{$R+}
      if SmEP.Intermediate.AnchorString <> '_DMI_' then
        Continue;
{$R-}
      Csum := 0;
      for Loop := 0 to SizeOf(SmEP.Intermediate) - 1 do
        Csum := Csum + PByteArray(@SmEP.Intermediate)^[Loop];
      if Csum <> 0 then
        Continue;
{$R+}
      Result := Addr;
      Break;
    end;
  end;
end;

function TBiosInfo.SmBiosGetNextEntry(var Dump: TRomBiosDump; Entry: Pointer): Pointer;
var
  Head: TDmiHeader;
begin
  Result := nil;
  ReadRomDumpBuffer(Dump, Entry, Head, SizeOf(TDmiHeader));
  if (Head.Type_ <> $7F) and (Head.Length <> 0) then
  begin
    Result := Pointer(Cardinal(Entry) + Head.Length);
    while PWord(GetRomDumpAddr(Dump, Result))^ <> 0 do
      Inc(Cardinal(Result));
    Inc(Cardinal(Result), 2);
    while PByte(GetRomDumpAddr(Dump, Result))^ = 0 do
      Inc(Cardinal(Result));
  end;
end;

function TBiosInfo.SmBiosGetString(var Dump: TRomBiosDump; Entry: Pointer;
  Index: Byte): string;
var
  Head: TDmiHeader;
  Addr: Pointer;
  Loop: Integer;
begin
  Result := '';
  ReadRomDumpBuffer(Dump, Entry, Head, SizeOf(TDmiHeader));
  if Head.Length <> 0 then
  begin
    Addr := Pointer(Cardinal(Entry) + Head.Length);
    for Loop := 1 to Index - 1 do
      Inc(Cardinal(Addr), Length(PChar(GetRomDumpAddr(Dump, Addr))) + 1);
    Result := StrPas(PChar(GetRomDumpAddr(Dump, Addr)));
  end;
end;

end.
