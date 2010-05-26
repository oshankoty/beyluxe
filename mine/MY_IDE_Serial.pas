unit My_IDE_Serial;

interface

uses
  Windows, SysUtils, CMClasses;

const
	IDENTIFY_BUFFER_SIZE       = 512;
	DFP_RECEIVE_DRIVE_DATA = $0007c088;
	IDE_ID_FUNCTION            = $EC; // Returns ID sector for ATA.

type
	TIDERegs = packed record
		bFeaturesReg     : BYTE; // Used for specifying SMART "commands".
		bSectorCountReg  : BYTE; // IDE sector count register
		bSectorNumberReg : BYTE; // IDE sector number register
		bCylLowReg       : BYTE; // IDE low order cylinder value
		bCylHighReg      : BYTE; // IDE high order cylinder value
		bDriveHeadReg    : BYTE; // IDE drive/head register
		bCommandReg      : BYTE; // Actual IDE command.
		bReserved        : BYTE; // reserved for future use.  Must be zero.
	end;
	TSendCmdInParams = packed record
		cBufferSize  : DWORD;                // Buffer size in bytes
		irDriveRegs  : TIDERegs;             // Structure with drive register values.
		bDriveNumber : BYTE;                 // Physical drive number to send command to (0,1,2,3).
		bReserved    : Array[0..2] of Byte;  // Reserved for future expansion.
		dwReserved   : Array[0..3] of DWORD; // For future use.
		bBuffer      : Array[0..0] of Byte;  // Input buffer.
	end;
	TDriverStatus = packed record
		bDriverError : Byte;                 // Error code from driver, or 0 if no error.
		bIDEStatus   : Byte;                 // Contents of IDE Error register. Only valid when bDriverError is SMART_IDE_ERROR.
		bReserved    : Array[0..1] of Byte;  // Reserved for future expansion.
		dwReserved   : Array[0..1] of DWORD; // Reserved for future expansion.
	end;
	TSendCmdOutParams = packed record
		cBufferSize  : DWORD;               // Size of bBuffer in bytes
		DriverStatus : TDriverStatus;       // Driver status structure.
		bBuffer      : Array[0..0] of BYTE; // Buffer of arbitrary length in which to store the data read from the drive.
	end;
	USHORT = Word;
	TIdSector = packed record
		wGenConfig                 : USHORT;
		wNumCyls                   : USHORT;
		wReserved                  : USHORT;
		wNumHeads                  : USHORT;
		wBytesPerTrack             : USHORT;
		wBytesPerSector            : USHORT;
		wSectorsPerTrack           : USHORT;
		wVendorUnique              : Array[0..2] of USHORT;
		sSerialNumber              : Array[0..19] of CHAR;
		wBufferType                : USHORT;
		wBufferSize                : USHORT;
		wECCSize                   : USHORT;
		sFirmwareRev               : Array[0..7] of CHAR;
		sModelNumber               : Array[0..39] of CHAR;
		wMoreVendorUnique          : USHORT;
		wDoubleWordIO              : USHORT;
		wCapabilities              : USHORT;
		wReserved1                 : USHORT;
		wPIOTiming                 : USHORT;
		wDMATiming                 : USHORT;
		wBS                        : USHORT;
		wNumCurrentCyls            : USHORT;
		wNumCurrentHeads           : USHORT;
		wNumCurrentSectorsPerTrack : USHORT;
		ulCurrentSectorCapacity    : ULONG;
		wMultSectorStuff           : USHORT;
		ulTotalAddressableSectors  : ULONG;
		wSingleWordDMA             : USHORT;
		wMultiWordDMA              : USHORT;
		bReserved                  : Array[0..127] of BYTE;
	end;
	PIdSector = ^TIdSector;

  TIDEInfo = record
    ModelNumber: string;
    FirmwareRev: string;
    SerialNumber: string;
  end;
  function DirectIdentify(var IDEInfo: TIDEInfo): Boolean;

implementation

var OSVersionInfo: TOSVersionInfo;

//---------------------------------------------------------------------
// Change the WORD array to a BYTE array
//---------------------------------------------------------------------
procedure ChangeByteOrder( var Data; Size : Integer );
var ptr : PChar;
		i : Integer;
		c : Char;
begin
	ptr := @Data;
	for i := 0 to (Size shr 1)-1 do
	begin
		c := ptr^;
		ptr^ := (ptr+1)^;
		(ptr+1)^ := c;
		Inc(ptr,2);
	end;
end;

procedure PrintIdSectorInfo( IdSector : TIdSector; var IDEInfo: TIDEInfo );
var
  szOutBuffer: array [0..40] of Char;
  i: Integer;
begin
  {$I crypt_start.inc}
  with IdSector do
  begin
    ChangeByteOrder( sModelNumber, SizeOf(sModelNumber) ); // Change the WORD array to a BYTE array
    szOutBuffer[SizeOf(sModelNumber)] := #0;
    StrLCopy( szOutBuffer, sModelNumber, SizeOf(sModelNumber) );
    IDEInfo.ModelNumber := szOutBuffer;
    {for i := 0 to StrLen(szOutBuffer) do
      if szOutBuffer[i]<>#32 then
      begin
        IDEInfo.ModelNumber := PChar(@szOutBuffer[i]);
        break;
      end;
    }
    ChangeByteOrder( sFirmwareRev, SizeOf(sFirmwareRev) );
    szOutBuffer[SizeOf(sFirmwareRev)] := #0;
    StrLCopy( szOutBuffer, sFirmwareRev, SizeOf(sFirmwareRev) );
    IDEInfo.FirmwareRev := szOutBuffer;

    ChangeByteOrder( sSerialNumber, SizeOf(sSerialNumber) );
    szOutBuffer[SizeOf(sSerialNumber)] := #0;
    StrLCopy( szOutBuffer, sSerialNumber, SizeOf(sSerialNumber) );
    for i := 0 to StrLen(szOutBuffer) do
      if szOutBuffer[i]<>#32 then
      begin
        IDEInfo.SerialNumber := PChar(@szOutBuffer[i]);
        break;
      end;
  end;
  {$I crypt_end.inc}
end;

//-------------------------------------------------------------
// SmartIdentifyDirect
//
// FUNCTION: Send an IDENTIFY command to the drive bDriveNum = 0-3
// bIDCmd = IDE_ID_FUNCTION or IDE_ATAPI_ID
//
// Note: work only with IDE device handle.
function SmartIdentifyDirect( hDevice : THandle; bDriveNum : Byte; bIDCmd : Byte; var IdSector : TIdSector; var IdSectorSize : LongInt ) : BOOL;
const BufferSize = SizeOf(TSendCmdOutParams)+IDENTIFY_BUFFER_SIZE-1;
var SCIP : TSendCmdInParams;
		Buffer : Array [0..BufferSize-1] of Byte;
		SCOP : TSendCmdOutParams absolute Buffer;
		dwBytesReturned : DWORD;
begin
  {$I crypt_start.inc}
	FillChar(SCIP,SizeOf(TSendCmdInParams)-1,#0);
	FillChar(Buffer,BufferSize,#0);
	dwBytesReturned := 0;
	IdSectorSize := 0;
	// Set up data structures for IDENTIFY command.
	with SCIP do
	begin
		cBufferSize  := IDENTIFY_BUFFER_SIZE;
		bDriveNumber := bDriveNum;
		with irDriveRegs do
		begin
			bFeaturesReg     := 0;
			bSectorCountReg  := 1;
			bSectorNumberReg := 1;
			bCylLowReg       := 0;
			bCylHighReg      := 0;
			bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
			bCommandReg      := bIDCmd;	// The command can either be IDE identify or ATAPI identify.
		end;
	end;
	Result := DeviceIoControl( hDevice, DFP_RECEIVE_DRIVE_DATA, @SCIP, SizeOf(TSendCmdInParams)-1, @SCOP, BufferSize, dwBytesReturned, nil );
	if Result then
	begin
		IdSectorSize := dwBytesReturned-SizeOf(TSendCmdOutParams)+1;
		if IdSectorSize<=0 then IdSectorSize := 0 else System.Move(SCOP.bBuffer,IdSector,IdSectorSize);
	end;
  {$I crypt_end.inc}
end;

function GetPhysicalDriveHandle( DriveNum : Byte; DesireAccess : ACCESS_MASK ) : THandle;
var
  s : String;
const
  PhysicalDriveStr: array[0..16] of byte = ($66,$66,$38,$66,$5A,$72,$83,$7D,$73,$6D,$6B,$76,$4E,$7C,$73,$80,$6F);
  SmartvsdStr:array[0..11] of byte = ($66,$66,$38,$66,$5D,$57,$4B,$5C,$5E,$60,$5D,$4E); //\\.\SMARTVSD
begin
  {$I crypt_start.inc}
	OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
	GetVersionEx(OSVersionInfo);
	if OSVersionInfo.dwPlatformId=VER_PLATFORM_WIN32_NT then // Windows NT, Windows 2000
		begin
			Str(DriveNum,s); // avoid SysUtils
			Result := CreateFile(PChar(Hex2DecString(PhysicalDriveStr)+s), DesireAccess, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0 );
		end
	else // Windows 95 OSR2, Windows 98
		Result := CreateFile(PChar(Hex2DecString(SmartvsdStr)), 0, 0, nil, CREATE_NEW, 0, 0 );
  {$I crypt_end.inc}
end;

function DirectIdentify(var IDEInfo: TIDEInfo): Boolean;
var
  hDevice : THandle;
  nIdSectorSize : LongInt;
  aIdBuffer : array [0..IDENTIFY_BUFFER_SIZE-1] of Byte;
  IdSector : TIdSector absolute aIdBuffer;
begin
  {$I crypt_start.inc}
  FillChar(aIdBuffer,SizeOf(aIdBuffer),#0);
  hDevice := GetPhysicalDriveHandle( 0, GENERIC_READ or GENERIC_WRITE );
  if hDevice=INVALID_HANDLE_VALUE then
  begin
    Result := False;
    Exit;
  end
  else
  begin
    if not SmartIdentifyDirect( hDevice, 0, IDE_ID_FUNCTION, IdSector, nIdSectorSize ) then
        Result := False
    else
    begin
      Result := True;
      PrintIdSectorInfo(IdSector,IDEInfo);
    end;
    CloseHandle(hDevice);
  end;
  {$I crypt_end.inc}
end;

end.
