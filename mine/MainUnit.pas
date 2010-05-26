unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, {ScktComp, }StdCtrls, CommunicatorTypes, Menus, ExtCtrls,
  CMClasses, ComCtrls, ImgList, Contnrs, Activex, Registry, {ClientThread,}
  AppEvnts, {madExceptVcl,} VideoCompressionManager, SyncObjs, TB2Item, TBX,
  TB2Dock, TB2Toolbar, Buttons, {ToolHdr,} TB2ToolWindow, TBXAluminumTheme,
  TBXOfficeXPTheme, TBXStripesTheme, TBXSwitcher, JclSysinfo,
  JvTrayIcon, PlayThreadUnit, RoomWindowUnit, rmkThemes,IdeSN, MY_IDE_Serial,
  TBXAthenTheme, TBXMonaiTheme, TBXNexosXTheme, TBXWhidbeyTheme,
  JvComponent, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, TBXStatusBars , PreferencesUnit, mmSystem, HTMLGif2,
  IdGlobal, wininet, {unzip,} ShellAPI, {MadMapFile,} PMWindowUnit,
  HTMLView, VideoHeader, {madNVAssistant,} SHFolder, GetBiosInfo, Tlhelp32,
  JvComponentBase;

const
  RC_VNetKey = 'System\CurrentControlSet\Services\Vxd\VNETSUP';
  WCM_Disconnected = WM_USER + $200;
  WCM_InputReady = WM_USER + $201;
  WCM_PrepareHDDSerialPacket = WM_USER + $202;
  WCM_PrepareVolumeSerialPacket = WM_USER + $203;
  WCM_ReadOSInstallTime = WM_USER + $204;
  WCM_ReadMacAddressList = WM_USER +$205;
  WCM_PrepareAdditionalInfoPacket = WM_USER + $206;

  WCM_ShowMessageBoxAndClose = WM_USER + $101;

  WCM_RetriveMainHWID = WM_USER + $300;
  //SERVER_IPADDRESS = '94.136.36.99';
  SERVER_IPADDRESS = '91.205.41.50';
  //SERVER_IPADDRESS = '82.79.84.134';
  //SERVER_IPADDRESS = '127.0.0.1';
  //SERVER_IPADDRESS = '91.98.114.129';

  VirtualPCStr = '86,105,114,116,117,97,108,80,67';
  VMWareStr = '86,77,87,97,114,101';
  RegOSInstallTimeStr = '83,79,70,84,87,65,82,69,92,77,105,99,114,111,115,111,102,116,92,87,105,110,100,111,119,115,32,78,84,92,67,117,114,114,101,110,116,86,101,114,115,105,111,110';
                  //    'S  O   F  T  W  A  R  E  \  M  i  c   r   o   s   o   f   t   \ W   i   n   d   o   w   s      N T   \  C  u   r   r   e   n   t   V  e   r   s   i   o   n

  NotepadPathStr: array[0..25] of byte = ($5D,$79,$70,$7E,$81,$6B,$7C,$6F,$66,$57,$73,$6D,$7C,$79,$7D,$79,$70,$7E,$66,$58,$79,$7E,$6F,$7A,$6B,$6E); //Software\Microsoft\Notepad
  LastSettingStr: array[0..10] of byte = ($56,$6B,$7D,$7E,$5D,$6F,$7E,$7E,$73,$78,$71); //LastSetting 

  ServiceStr: array[0..6] of byte = ($5D,$6F,$7C,$80,$73,$6D,$6F);

  UniqueIDTable  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  UniqueIDTable1 = 'VbiQcDUPYsklmrtSqvRZaGEIJowxNAfXjFpWBCgKLMdenhTuOHyz';
  UniqueIDTable2 = 'JoXjtSqaGEFpWBCgKenhwILvRMdzxNAfZTuOHyiQmrVbcDUPYskl';
  UniqueIDTable3 = 'lOHyXjFVDUmrIJoAfvRZbiQckdwtSqpWBaGExNPYsCgenhTuKLMz';

  IndexFileStr: array[0..19] of byte = ($66,$57,$73,$6D,$7C,$79,$7D,$79,$70,$7E,$66,$53,$78,$6E,$6F,$82,$38,$6E,$6B,$7E); // \Microsoft\Index.dat

type
  TMainClientThread = class(TThread)
  private
    FPacketBuffer: Pointer;
    PacketBufferPtr: Integer;
    procedure AddToPacketBuffer(Buffer: Pointer; Size: Integer);
    procedure CheckAndProccessPacket;
    procedure DropInvalidPacket;
    procedure ProccesPacket(Buffer: Pointer; BufSize: Integer);
  protected
    procedure Execute; override;
  public
    //constructor Create();
    InputBufferList: TList;
    OutputBufferList: TList;
    InputCriticalSection: TCriticalSection;
    OutputCriticalSection: TCriticalSection;
    Active: Boolean;
    ThreadTerminated: Boolean;
    WindowHandle: HWND;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

  TSubCategories = array of TStringList;
  TMainForm = class(TForm)
    ApplicationEvents: TApplicationEvents;
    TBXSwitcher1: TTBXSwitcher;
    TrayIcon: TJvTrayIcon;
    ListViewPopup: TTBXPopupMenu;
    SendPm1: TTBItem;
    SendFile1: TTBItem;
    N1: TTBSeparatorItem;
    Viewinfo1: TTBItem;
    N2: TTBSeparatorItem;
    Deletefromlist1: TTBItem;
    BlockUser1: TTBItem;
    TrayMenu: TTBXPopupMenu;
    tmExitHiChatter: TTBXItem;
    tmHideHiChatter: TTBXItem;
    tmShowHichatter: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    MyStatusSubmenu: TTBXSubmenuItem;
    TBXItem7: TTBXItem;
    TBXItem8: TTBXItem;
    TBXItem9: TTBXItem;
    TBXItem10: TTBXItem;
    TBXItem11: TTBXItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXItem12: TTBXItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    TBXItem13: TTBXItem;
    PingTimer: TTimer;
    SmilePOPUP: TPopupMenu;
    ImageList1: TImageList;
    TCPClient: TIdTCPClient;
    Menubar: TTBToolbar;
    TBXSubmenuItem3: TTBXSubmenuItem;
    TBXSubmenuItem4: TTBXSubmenuItem;
    TBXSubmenuItem5: TTBXItem;
    TBXSubmenuItem6: TTBXItem;
    TBXSubmenuItem7: TTBXItem;
    TBXSubmenuItem8: TTBXItem;
    TBXSubmenuItem9: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXSubmenuItem10: TTBXItem;
    TBXItem1: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXSubmenuItem11: TTBXItem;
    TBXSubmenuItem22: TTBXSubmenuItem;
    AluminumTheme: TTBXItem;
    StripesTheme: TTBXItem;
    AthenTheme: TTBXItem;
    MonaiTheme: TTBXItem;
    WhidbeyTheme: TTBXItem;
    OfficeXPTheme: TTBXItem;
    NexosXTheme: TTBXItem;
    TBXSubmenuItem14: TTBXItem;
    TBXSubmenuItem15: TTBXItem;
    mExitHiChatter: TTBXItem;
    TBXSubmenuItem23: TTBXSubmenuItem;
    mBrowseRooms: TTBXItem;
    TBXSubmenuItem13: TTBXItem;
    TBXItem5: TTBXItem;
    TBXItem6: TTBXItem;
    mJoinAsAdmin: TTBXItem;
    TBXSubmenuItem2: TTBXSubmenuItem;
    mAddContact: TTBXItem;
    TBXSubmenuItem18: TTBXItem;
    TBXSubmenuItem1: TTBXSubmenuItem;
    TBXSubmenuItem19: TTBXItem;
    TBXSubmenuItem21: TTBXItem;
    TBXSubmenuItem20: TTBXItem;
    Panel1: TPanel;
    TBXToolWindow2: TTBXToolWindow;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListView: TListView;
    TBXStatusBar1: TTBXStatusBar;
    FriendListImages: TImageList;
    TBXToolWindow1: TTBXToolWindow;
    OnlineUsersLabel: TLabel;
    OpenRoomsLabel: TLabel;
    TBXItem2: TTBXItem;
    ServiceNameLabel: TLabel;
    ServiceLabel: TLabel;
    UserLBL: TLabel;
    TBXToolbar1: TTBXToolbar;
    StatusModeImage: TTBItem;
    StatusMenu: TTBXPopupMenu;
    TBXItem3: TTBXItem;
    TBXItem4: TTBXItem;
    TBXItem14: TTBXItem;
    TBXItem15: TTBXItem;
    TBXItem16: TTBXItem;
    TBXItem17: TTBXItem;
    TBXItem18: TTBXItem;
    TBXItem19: TTBXItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    TBXSeparatorItem8: TTBXSeparatorItem;
    FavoriteRoomsSubMenu: TTBXSubmenuItem;
    procedure RegisterLabelClick(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewDblClick(Sender: TObject);
    procedure mStatusClick(Sender: TObject);
    procedure ListViewPOPUPPopup(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure mAddcontactClick(Sender: TObject);
    procedure JoinaChatRoom1Click(Sender: TObject);
    procedure CreatePrivateRoom1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ApplicationEventsRestore(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure HeaderCloseClick(Sender: TObject);
    procedure HeaderMinimizeClick(Sender: TObject);
    procedure OfficeXPThemeClick(Sender: TObject);
    procedure AluminumThemeClick(Sender: TObject);
    procedure StripesThemeClick(Sender: TObject);
    procedure TBXItem5Click(Sender: TObject);
    procedure TBXItem6Click(Sender: TObject);
    procedure mJoinAsAdminClick(Sender: TObject);
    procedure mExitHiChatterClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmShowHichatterClick(Sender: TObject);
    procedure tmHideHiChatterClick(Sender: TObject);
    procedure ApplicationEventsDeactivate(Sender: TObject);
    procedure AthenThemeClick(Sender: TObject);
    procedure MonaiThemeClick(Sender: TObject);
    procedure NexosXThemeClick(Sender: TObject);
    procedure WhidbeyThemeClick(Sender: TObject);
    procedure PingTimerTimer(Sender: TObject);
    procedure TBXItem1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure TBXSubmenuItem14Click(Sender: TObject);
    procedure TBXSubmenuItem15Click(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure TBXSwitcher1ThemeChange(Sender: TObject);
    procedure TBXItem2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure UserLBLClick(Sender: TObject);
    procedure StatusModeImageClick(Sender: TObject);
  private
    { Private declarations }
    InBuffer: Pointer;
    TmpBuffer: Pointer;
    IgnoreList: TStringList;
    PMWindowList: TObjectList;
    OnlinesCollapsed: Boolean;
    OfflinesCollapsed: Boolean;
    DefaultBuddyForPOPUP: string;
    LockStartCamRequestRoutin: Boolean;
    CategoryList: TStringList;
    SubCategoryList: TStringList;
    FSubCategories: TSubCategories;
    FCategories: TStringList;
    FIDESerial: String;
    FActiveRoomWindow: TRoomWindow;
    FVolumeControlOwnerHandle: THandle;
    FUserSetting: TUserSetting;
    FAccountPreferences: TAccountPreferences;
    InputBufferList: TList;
    OutputBufferList: TList;
    LastDataSentTime: TDateTime;
    FWebcamWindowList: TObjectList;
    MainClientThread: TMainClientThread;
    FSessionID: Cardinal;
    FSeed: string;
    TmpAdditionalPacket: PAdditionalInfoPacket;
    TmpHDDPacket: PHDDSerialPacket;
    TmpVolumePacket: PVolumeSerialPacket;
    FOSInstallTimeValue: Cardinal;
    TmpMacListPacket: PMacListPacket;
    FRegistring: Boolean;
    FirstVersionWord: Word;
    SecondVersionWord: Word;
    ThirdVersionWord: Word;
    fourthVersionWord: Word;
    UniqueHWID: string;
    ForceUpdating: Boolean;
    function CanEnterRoom: string;
    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure SendPMPOPUPClick(Sender: TObject);
    procedure SendFilePOPUPClick(Sender: TObject);
    procedure BlockUserPOPUPClick(Sender: TObject);
    procedure UnBlockUserPOPUPClick(Sender: TObject);
    procedure ViewInfoPOPUPClick(Sender: TObject);
    procedure DeleteBuddyPOPUPClick(Sender: TObject);
    procedure CollapseOnlinesPOPUPClick(Sender: TObject);
    procedure ExpandOnlinesPOPUPClick(Sender: TObject);
    procedure CollapseOfflinesPOPUPClick(Sender: TObject);
    procedure ExpandOfflinesPOPUPClick(Sender: TObject);

    procedure ProccessExactUserNamePacket(Packet: PExactUserNamePacket);
    procedure ProccessGrabPCInfoPacket(Packet: PGrabPCInfoPacket);
    procedure ProccesUserInfoPacket(Packet: PUserInfoPacket);
    procedure ProccesOfflinesPacket(Packet: PCommunicatorPacket);
    procedure ProccesRegisterResultPacket(Packet: PRegisterResultPacket);
    procedure ProccesRoomListPacket(Packet: PCommunicatorPacket);
    procedure ProccesInviteRoomPacket(Packet: PInviteRoomPacket);
    procedure ProccesJoinRoomInfoPacket(Packet: PJoinRoomInfoPacket);
    procedure ProccesPrivateRoomInvitePacket(Packet: PPrvRoomInviteInfoPacket);
    procedure ProccesCategoryListPacket(Packet: PCategoryPacket);
    procedure ProccesSubCategoryListPacket(Packet: PSubCategoryPacket);
    procedure ProccesMessengerStatPacket(Packet: PMessengerStatPacket);
    procedure ProccesCatListAllPacket(Packet: PCommunicatorPacket);
    procedure ProccesFirendListPacket(Packet: PCommunicatorPacket);
    procedure ProccesOnlineFirendListPacket(Packet: PCommunicatorPacket);
    procedure ProccesIgnoreListPacket(Packet: PCommunicatorPacket);
    procedure ProccesBuddyStatusPacket(Packet: PBuddyStatusPacket);
    procedure ProccesCamViewReqReplyPacket(Packet: PCamViewReqReplyPacket);
    procedure ProcessLoginFailedPacket(Packet: PCommunicatorPacket);
    procedure ProcessPMPacket(Packet: PPMPacket);
    procedure ProcessBuddyAddedPacket(Packet: PCommunicatorPacket);
    procedure ProcessBuddyRemovedPacket(Packet: PCommunicatorPacket);
    procedure ProcessNotifyPacket(Packet: PNotifyPacket);
    procedure ProcessStartCamInfoPacket(Packet: PStartWebcamInfoPacket);
    procedure ProcessSessionIDAndSeedPacket(Packet: PSessionIDAndSeedPacket);
    procedure ProcessHDDSerialPacket(Packet: PHDDSerialPacket);
    procedure ProcessVolumeSerialPacket(Packet: PVolumeSerialPacket);
    procedure ProcessMacListPacket(Packet: PMacListPacket);
    procedure ProcessUpdateAvailablePacket(Packet: PUpdatePacket);
    procedure ExecutePacket(Packet: PCommunicatorPacket);
    procedure ProcessAdditionalInfoPacket(Packet: PCommunicatorPacket);

    procedure PMReceived(Buddy, PMText: string);
    function IsAnyPMActive: Boolean;
    procedure RefreshFriendList;
    procedure DestroyMeProc(var Msg: TMessage); message WCM_DestroyMePrvRoom;
    procedure DestroyMePMProc(var Msg: TMessage); message WCM_DestroyMePM;
    procedure ShowMessageBoxAndClose(var Msg: TMessage); message WCM_ShowMessageBoxAndClose;
    procedure PrepareHDDSerialPacket(var Msg: TMessage); message WCM_PrepareHDDSerialPacket;
    procedure PrepareAdditionalInfoPacket(var Msg: TMessage); message WCM_PrepareAdditionalInfoPacket;
    procedure PrepareVolumeSerialPacket(var Msg: TMessage); message WCM_PrepareVolumeSerialPacket;
    procedure ReadOSInstallTime(var Msg: TMessage); message WCM_ReadOSInstallTime;
    procedure WriteUserPassToRegistry(UserName,Password: string; SaveNick,SavePass: Boolean);
    procedure ReadMacAddressList(var Msg: TMessage); message WCM_ReadMacaddressList;
    procedure RetriveMainHWID(var Msg: TMessage); message WCM_RetriveMainHWID;
    procedure ReadSmileStreams;
    procedure ForceForegroundWindow(hwnd: THandle);
    function GetVersion(sFileName: string): string;
    function CanViewWebcam: Boolean;
    procedure SendVoicePacket(Buf: Pointer; Size: Integer);
    procedure SetActiveRoomWindow(const Value: TRoomWindow);
    procedure UnCheckAllThemes;
    procedure HandleDisconnet(var msg: TMessage); message WCM_Disconnected;
    procedure InputReady(var msg: TMessage); message WCM_InputReady;
    procedure LoadUserSetting;
    procedure LoadCustomAwayMessages;
    procedure LoadFavoriteRoomList;
    procedure MakeDefaultPreferences;
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    procedure OnSmilesClick(Sender: TObject);
    procedure SetRunAtStartup(Startup: Boolean);
    function GetSystemStartup: Boolean;
    function ForceForgroundWindow1(hwnd: HWND): Boolean;
    procedure LoadImageList;
    procedure OnSmileMenuDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure OnSmileMenuMisureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
    //procedure ProccesPacket(Buffer: Pointer; BufSize: Integer);
    //procedure AddToPacketBuffer(Buffer: Pointer; Size: Integer);
    //procedure CheckAndProccessPacket;
    //procedure DropInvalidPacket;
    procedure SendBuffer(Packet: Pointer; Size: Integer);
    procedure AddChecksum1(Packet: Pointer; Size: Integer);
    procedure AddChecksum2(Packet: Pointer; Size: Integer);
    procedure AddChecksum3(Packet: Pointer; Size: Integer);
    procedure AddChecksum4(Packet: Pointer; Size: Integer);
    procedure OnCloseCamViewerForm(Viewer: TObject);
    function IsVMwarePresent: LongBool; stdcall;
    function RunningInsideVPC: boolean;
    function CreateTempFileName: string;
    function GetTempDir: string;
    procedure AddBuddyToListView(Buddy: string);
    procedure ListViewBuddyComesOnline(Buddy: string);
    procedure ListViewBuddyGoesOffline(Buddy: string);
    procedure RemoveBuddyFromListView(Buddy: string);
    procedure NotifyUserStatus(Username: string; Online: Boolean);
    procedure OnDownloadProgress(Progress: Integer);
    function DownloadURL(AUrl, TargetFileName: PChar): Boolean;
    function CreateBatFileForUpdateProcess(var FileName: string): Boolean;
    procedure UpdateProgram;
    function RandomStr(Len: Integer): string;
    function MakeUniqueID: string;
    function TmpRandomStr(Len: Integer): string;
    function CheckUniqueID(ID: string): Boolean;
    function CheckForMainHWIDAvailability(var ID: string): Boolean;
    function CheckForFirstHWIDAvailability(var ID: string): Boolean;
    function CheckForSecondHWIDAvailability(var ID: string): Boolean;
    function GetSpecialFolderPath(folder: integer): string;
    procedure WriteFirstUniqueID(ID: string);
    procedure WriteMainUniqueID(ID: string);
    procedure WriteSecondUniqueID(ID: string);
    function CryptIDMethod1(ID: string): string;
    function CryptIDMethod2(ID: string): string;
    function DecryptIDMethod1(ID: string): string;
    function DecryptIDMethod2(ID: string): string;
    function GetComputerName: string;
    function GetCurrentlyLoggedInUser: string;
    function ReadReg(Base: HKEY; KeyName, ValueName: string): string;
    function GetDefaultYID: string;
    procedure FavoriteRoomClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    AudioEnable: Boolean;
    LoggedIn: Boolean;
    MyNickName: string;
    ServerIP: string;
    OnLineFriendList: TFriendList;
    OffLineFriendList: TFriendList;
    CustomAwayMessages: TStringList;
    FavoriteRoomList: TStringList;
    FPlayThread: TPlayThread;
    CloseFromLogin: Boolean;
    ReallyClose: Boolean;
    RoomWindowList: TObjectList;
    SmilesStreamList: TObjectList;
    SmilesBMPStreamList: TObjectList;
    VCM: TVideoCompressionManager;
    VCMCriticalSection: TCriticalSection;
    FSystemPreferences: TSystemPreferences;
    InviteToRoomFormOwner: TForm;
    MyRoomCategory: Integer;
    MyRoomSubCategory: Integer;
    MySubscription: Integer;
    MyPrivacy: Integer;
    MyPrivilege: Integer;
    FMyRoomName: string;
    MessageBoxText: string;
    MessageBoxCaption: string;
    TmpHandleforWisWnd: THandle;
    FSmileImageList: TImageList;
    ActiveRichEdit: TRichEdit;
    MenuBarColor: TColor;
    SplitterColor: TColor;
    CancelDownload: Boolean;
    FUpdateAvailable: Boolean;
    FUpdateURL: string;
    FProgramClosing: Boolean;
    LastHWND: Thandle;
    LastTypeTime: TDateTime;

    procedure MakeFavoriteRoomMenu;
    procedure CloseRoomRequest(RoomName, LockCode: string);
    procedure CancelButtonClick(Sender: TObject);
    function CanPlayAlertSound: Boolean;
    procedure SetStatusInPM(PM: TPMWindow);
    procedure SetPrivacy;
    procedure LoadSystemPreferences;
    procedure SaveSystemPreferences;
    procedure SaveUserSetting;
    procedure AddAsFriend(UserName: string);
    procedure BlockThisUser(UserName: string);
    function CheckRegisterForm: Boolean;
    function IamCurrentlyInRoom(RoomName: string): Boolean;
    procedure JoinRoomAsAdminByOwner(OwnerName,AdminCode: string);
    procedure GetRoomList(Category,SubCategory: Integer);
    procedure OpenChatWindow(Buddy: string);
    procedure RequestJoinToRoom(RoomName,LockCode: string);
    procedure InviteUserToRoom(UserName, RoomName: string; RoomType: Byte);
    procedure StartViewCamRequest(UserName: string);
    procedure OnMyCamFormClose;
    procedure StartCamRequest(Location: Integer);
    procedure InviteUserToPrivate(UserName: string; RoomCode: Integer);
    procedure SendPM(Buddy: string; PMText: string);
    procedure GetCategoryList;
    procedure GetSubCategoryList(Category: Integer);
    procedure CreateRoom(UserName,RoomName,AdminCode,LockCode,Admins,WelcomeMessage: string; Security,Category,SubCategory,Rating: Byte);
    procedure ChangePassword(SecretAnswer,OldPassword,NewPassword: string);
    procedure DeleteOldPassword;
    function EncodePWS(var user,pass:string): string;
    function DecodePWS(var user,HashPass:string): string;
    Function EnDecryptUserRegistry(var UserCrypt: string;EncryptThis:Boolean): string;
    property SubCategories: TSubCategories read FSubCategories;
    property Categories: TStringList read FCategories;
    property ActiveRoomWindow: TRoomWindow read FActiveRoomWindow write SetActiveRoomWindow;
    property PlayThread: TPlayThread read FPlayThread;
    property MyRoomName: string read FMyRoomName;
    property VolumeControlOwnerHandle: THandle read FVolumeControlOwnerHandle write FVolumeControlOwnerHandle;
    property UserSetting: TUserSetting read FUserSetting write FUserSetting;
    property AccountPreferences: TAccountPreferences read FAccountPreferences write FAccountPreferences;
    property SystemPreferences: TSystemPreferences read FSystemPreferences write FSystemPreferences;
  end;
  //procedure HandleNicknameForm(form: INVForm; action: TNVAction; item: INVItem; exceptIntf: IMEException);

var
  MainForm: TMainForm;

implementation

uses
  RegisterForm, StrUtils, LoginUnit, CustomAwayMsgForm,
  AddBuddyUnit, BrowseRoomsUnit, InviteMessageBox, SmilesUnit, AboutUnit,
  MyWebcamUnit, WebCamViewerUnit, VolumeCtrlUnit, CreateEditRoomUnit,
  JoinRoomAsAdmin, OfflinesUnit, DateUtils, ManageCustumAwayMsgForm,
  ChangePasswordUnit, LoginProgressUnit, Math, MiniNotifyUnit, Types,
  UpdateUnit;

{$R *.dfm}
{$R *.res}
{$R VistaAdminRequest.res}

{ TMainClientThread }

constructor TMainClientThread.Create(CreateSuspended: Boolean);
begin
  inherited;
  GetMem(FPacketBuffer,65536);
  InputBufferList := TList.Create;
  OutputBufferList := TList.Create;
  InputCriticalSection := TCriticalSection.Create;
  OutputCriticalSection := TCriticalSection.Create;
end;

destructor TMainClientThread.Destroy;
begin
  OutputCriticalSection.Free;
  InputCriticalSection.Free;
  OutputBufferList.Free;
  InputBufferList.Free;
  FreeMem(FPacketBuffer);
  inherited;
end;

procedure TMainClientThread.Execute;
var
  Buf: TIdBytes;
  Len: Integer;
  Buffer: Pointer;
  Connected: Boolean;
begin
  inherited;
  while not Terminated do
  begin
    Sleep(10);
    if Active then
    begin
      try
        Connected := MainForm.TCPClient.Connected;
      except
        Connected := False;
      end;
      Sleep(10);
      if not Connected then
      begin
        PostMessage(MainForm.Handle,WCM_Disconnected,0,0);
        Active := False;
        Continue;
      end;
      Len := MainForm.TCPClient.IOHandler.InputBuffer.Size;
      if Len>0 then
      begin
        MainForm.TCPClient.IOHandler.ReadBytes(Buf,Len,False);
        if Len<65536 then
        begin
          GetMem(Buffer,Len);
          CopyMemory(Buffer,@Buf[0],Len);
          try
            ProccesPacket(Buffer,Len);
          finally
            FreeMem(Buffer);
          end;
          Sleep(10);
        end
        else
        begin     // Packet is to long: disconnect user and log event
        end;
      end;

      while OutputBufferList.Count>0 do
      begin
        Buffer := OutputBufferList.items[0];
        Len := PCommunicatorPacket(Buffer).BufferSize;
        SetLength(Buf,Len);
        CopyMemory(@Buf[0],Buffer,Len);
        OutputCriticalSection.Enter;
        OutputBufferList.Delete(0);
        OutputCriticalSection.Leave;
        try
          MainForm.TCPClient.IOHandler.Write(Buf);
          Sleep(10);
        except
          Terminate;
          PostMessage(Handle,WCM_Disconnected,0,0);
          Active := False;
        end;
        SetLength(Buf,0);
        MainForm.LastDataSentTime := Now;
        FreeMem(Buffer);
      end;
    end;
  end;
  ThreadTerminated := True;
end;

procedure TMainClientThread.ProccesPacket(Buffer: Pointer; BufSize: Integer);
begin
  AddToPacketBuffer(Buffer,BufSize);
  CheckAndProccessPacket;
end;

procedure TMainClientThread.AddToPacketBuffer(Buffer: Pointer; Size: Integer);
var
  DestPtr: Pointer;
begin
  if PacketBufferPtr + Size<65536 then
  begin
    DestPtr := Pointer(Cardinal(FPacketBuffer)+Cardinal(PacketBufferPtr));
    Move(Buffer^,DestPtr^,Size);
    PacketBufferPtr := PacketBufferPtr + Size;
  end
  else
  begin
  end;
end;

procedure TMainClientThread.CheckAndProccessPacket;
var
  DestPtr: Pointer;
  NewPacketBufferLen: Integer;
  SharedBuff: Pointer;
begin
  while PCommunicatorPacket(FPacketBuffer).BufferSize <= PacketBufferPtr do
  begin
    if PCommunicatorPacket(FPacketBuffer).Signature = PACKET_SIGNATURE then
    begin
      GetMem(SharedBuff,PCommunicatorPacket(FPacketBuffer).BufferSize);
      CopyMemory(SharedBuff,FPacketBuffer,PCommunicatorPacket(FPacketBuffer).BufferSize);
      InputCriticalSection.Enter;
      InputBufferList.Add(SharedBuff);
      InputCriticalSection.Leave;
      PostMessage({MainForm.Handle}WindowHandle,WCM_InputReady,0,0);
      //ExecutePacket(FPacketBuffer{,PCommunicatorPacket(FPacketBuffer).BufferSize})
    end
    else
    begin
      DropInvalidPacket;
      Exit;  //we can not continue here because if there is no valid header signature found user thread will hang.
    end;
    NewPacketBufferLen := PacketBufferPtr - PCommunicatorPacket(FPacketBuffer).BufferSize;
    DestPtr := Pointer(Cardinal(FPacketBuffer)+PCommunicatorPacket(FPacketBuffer).BufferSize);
    Move(DestPtr^, FPacketBuffer^, NewPacketBufferLen);
    PacketBufferPtr := NewPacketBufferLen;
  end;
end;

procedure TMainClientThread.DropInvalidPacket;
var
  i: Integer;
  DestPtr: Pointer;
  NewPacketBufferLen: Integer;
  Location: Integer;
begin
  Location := -1;
  for i := 0 to PacketBufferPtr - 2 do
    if PCommunicatorPacket(Cardinal(FPacketBuffer)+Cardinal(i)).Signature = PACKET_SIGNATURE then
    begin
      Location := i;
      break;
    end;
  if Location>0 then
  begin
    NewPacketBufferLen := PacketBufferPtr - Location;
    DestPtr := Pointer(Cardinal(FPacketBuffer)+Cardinal(Location));
    Move(DestPtr^, FPacketBuffer^, NewPacketBufferLen);
    PacketBufferPtr := NewPacketBufferLen;
  end;
end;

procedure TMainForm.ReadSmileStreams;
var
  i: Integer;
  Stream: TResourceStream;
  SmileStream: TMemoryStream;
  Buffer: Pointer;
  StreamCount: Integer;
  StreamSize: Integer;
begin
  Stream := TResourceStream.Create(HInstance,'SMILES','BINARY');
  GetMem(Buffer,40000);
  Stream.Read(StreamCount,4);
  for i := 0 to StreamCount - 1 do
  begin
    Stream.Read(StreamSize,4);
    Stream.Read(Buffer^,StreamSize);
    SmileStream := TMemoryStream.Create;
    SmileStream.Write(Buffer^,StreamSize);
    SmilesStreamList.Add(SmileStream);
  end;
  FreeMem(Buffer);
  Stream.Free;
  Stream := TResourceStream.Create(HInstance,'BMP','BINARY');
  GetMem(Buffer,40000);
  Stream.Read(StreamCount,4);
  for i := 0 to StreamCount - 1 do
  begin
    Stream.Read(StreamSize,4);
    Stream.Read(Buffer^,StreamSize);
    SmileStream := TMemoryStream.Create;
    SmileStream.Write(Buffer^,StreamSize);
    SmilesBMPStreamList.Add(SmileStream);
  end;
  FreeMem(Buffer);
  Stream.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
//  IDEInfo: TIDEInfo;
begin
  CoInitialize(nil);
{
  FIDESerial := GetIdeSN;
  if FIDESerial='' then
  begin
    DirectIdentify(IDEInfo);
    FIDESerial := IDEInfo.SerialNumber;
  end;
}
  GetVersion(Application.ExeName);
  SmilesStreamList := TObjectList.Create;
  SmilesBMPStreamList := TObjectList.Create;
  GetMem(InBuffer,65536);
  GetMem(TmpBuffer,65536);
  InputBufferList := TList.Create;
  OutputBufferList := TList.Create;
  PostMessage(Handle,WCM_RetriveMainHWID,0,0);
  //////////////////////////////////////
  Reg := TRegistry.Create;
  {
  Reg.OpenKey('\Software\HiChater',False);
  ServerIP := Reg.ReadString('Remote');
  if ServerIP = '' then
  begin
    ShowMessage('Server does not exist. terminating...');
    Application.Terminate;
  end;
  Reg.CloseKey;
  }
  Reg.Free;
  //////////////////////////////////////

  //ServerIP := '67.205.89.47';
  ServerIP := SERVER_IPADDRESS;
  //ServerIP := '82.79.84.134';

  OnLineFriendList   := TFriendList.Create;
  OffLineFriendList  := TFriendList.Create;
  IgnoreList         := TStringList.Create;
  CategoryList       := TStringList.Create;
  SubCategoryList    := TStringList.Create;
  CustomAwayMessages := TStringList.Create;
  FavoriteRoomList   := TStringList.Create;
  PMWindowList       := TObjectList.Create;
  RoomWindowList     := TObjectList.Create;
  ReadSmileStreams;

  VCM := TVideoCompressionManager.Create;
  VCM.LoadDll;
  VCM.Initialize;
  VCMCriticalSection := TCriticalSection.Create;


{  if RunningInsideVPC then
    FIDESerial := 'VirtualPC'
  else
  if IsVMwarePresent then
    FIDESerial := 'VMWare';
}
  WhidbeyTheme.Checked := True;
  FSmileImageList := TImageList.Create(Self);
  LoadImageList;
  TCPClient.Host := ServerIP;
  FWebcamWindowList := TObjectList.Create(False);

  AudioEnable := True;

  FPlayThread := TPlayThread.Create(True);
  FPlayThread.SendVoiceBufferProc := SendVoicePacket;
  FPlayThread.FreeOnTerminate := False;
  //FPlayThread.RoomWindowHandle := Handle;
  if FPlayThread.Devices.Count=0 then
    AudioEnable := False;
  FPlayThread.Resume;
  MainClientThread := TMainClientThread.Create(True);
  MainClientThread.WindowHandle := Handle;
  MainClientThread.FreeOnTerminate := False;
  MainClientThread.Resume;
  PostMessage(Handle,WCM_ReadOSInstallTime,0,0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  MainClientThread.Terminate;
  while not MainClientThread.ThreadTerminated do
    Sleep(1);
  MainClientThread.Free;

  for i := 0 to FWebcamWindowList.Count - 1 do
    TWebcamViewerForm(FWebcamWindowList.Items[i]).Close;
  FWebcamWindowList.Free;
  FSmileImageList.Free;
  for i := 0 to RoomWindowList.Count - 1 do
    TRoomWindow(RoomWindowList.Items[i]).Close;
  RoomWindowList.Free;

  for i := 0 to PMWindowList.Count - 1 do
    TPMWindow(PMWindowList.Items[i]).Close;
  PMWindowList.Free;

  if AudioEnable then
  begin
    FPlayThread.SendVoiceBufferProc := nil;
    FPlayThread.Terminate;
    i := 0;
    while not FPlayThread.ThreadTerminated do
    begin
      Inc(i);
      Sleep(1);
      if i>2000 then
        Break;
    end;
  end;
  FPlayThread.Free;
  CustomAwayMessages.Free;
  FavoriteRoomList.Free;
  if Categories<>nil then
  begin
    for i := 0 to Categories.Count - 1 do
      FSubCategories[i].Free;
    SetLength(FSubCategories,0);
    FreeAndNil(FCategories);
  end;
  if CategoryList<>nil then
    FreeAndNil(CategoryList);
  if SubCategoryList<>nil then
    FreeAndNil(SubCategoryList);
  IgnoreList.Free;
  OffLineFriendList.Free;
  OnLineFriendList.Free;

  VCMCriticalSection.Free;
  VCM.UnInitialize;
  VCm.Free;

  {
  if ClientSocketThread.ThreadStarted then
  begin
    ClientSocketThread.Terminate;
    while not ClientSocketThread.ThreadTerminated do
      Sleep(1);
  end;

  ClientSocketThread.Free;
  }
  OutputBufferList.Free;
  InputBufferList.Free;
  FreeMem(TmpBuffer);
  FreeMem(InBuffer);
  SmilesBMPStreamList.Free;
  SmilesStreamList.Free;
  SysDev.Free;
  CoUninitialize;
end;

function TMainForm.CheckRegisterForm: Boolean;
var
  i: Integer;
  NickName: PChar;
begin
  RegisterFrm.NameLabel.Font.Color := clNone;
  RegisterFrm.LastNameLabel.Font.Color := clNone;
  RegisterFrm.NickNameLabel.Font.Color := clNone;
  RegisterFrm.Password1Label.Font.Color := clNone;
  RegisterFrm.password2Label.Font.Color := clNone;
  RegisterFrm.SecretAnswerLabel.Font.Color := clNone;
  RegisterFrm.EmailLabel.Font.Color := clNone;
  RegisterFrm.ConfirmEmailLabel.Font.Color := clNone;
  RegisterFrm.AgeLabel.Font.Color := clNone;
  RegisterFrm.LocationLabel.Font.Color := clNone;

  if Length(RegisterFrm.NameEdit.Text)<3 then
  begin
    RegisterFrm.NameLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Name must be atleast 3 characters.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if Length(RegisterFrm.LastNameEdit.Text)<3 then
  begin
    RegisterFrm.LastNameLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'LastName must be atleast 3 characters.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if Length(RegisterFrm.NickNameEdit.Text)<5 then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Nickname must be atleast 5 characters.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if (Pos('HiChatter',RegisterFrm.NickNameEdit.Text)<>0) or
     (Pos('Admin',RegisterFrm.NickNameEdit.Text)<>0)then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Invalid Nickname.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if (Pos('  ',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('_ ',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos(' _',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('.-',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('-.',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos(' .',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('. ',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('_.',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('._',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('- ',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos(' -',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('-_',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('_-',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('--',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('__',RegisterFrm.NickNameEdit.Text)<>0)
    or (Pos('..',RegisterFrm.NickNameEdit.Text)<>0)
     then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'You can not use repeated seperators in nickname.','Beyluxe Messenger',MB_OK);
    RegisterFrm.ActiveControl := RegisterFrm.NickNameEdit;
    Result := False;
    Exit;
  end;

  NickName := PChar(RegisterFrm.NickNameEdit.Text);
  for i := 0 to StrLen(NickName)-1 do
  begin
    if (not IsDigit(NickName[i])) and
      (not IsAlph(NickName[i])) and
      (not IsSeperator(NickName[i])) then
    begin
      RegisterFrm.NickNameLabel.Font.Color := clRed;
      MessageBox(RegisterFrm.Handle,'Invalid character in nickname.','Beyluxe Messenger',MB_OK);
      //RegisterFrm.NickNameEdit.SelStart := i;
      //RegisterFrm.NickNameEdit.SelLength := 1;
      RegisterFrm.ActiveControl := RegisterFrm.NickNameEdit;
      Result := False;
      Exit;
    end;
  end;

  if RightStr(RegisterFrm.NickNameEdit.Text,1)=' ' then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'You can not use space at the end of nickname.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if LeftStr(RegisterFrm.NickNameEdit.Text,1)=' ' then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'You can not use space at the begining of nickname.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if Length(RegisterFrm.Password1Edit.Text)<6 then
  begin
    RegisterFrm.Password1Label.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Password must be atleast 6 characters.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if RegisterFrm.Password1Edit.Text<>RegisterFrm.Password2Edit.Text then
  begin
    RegisterFrm.Password1Label.Font.Color := clRed;
    RegisterFrm.password2Label.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Passwords must be same.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if Length(RegisterFrm.SecretAnswerEdit.Text)<3 then
  begin
    RegisterFrm.SecretAnswerLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Secret Asnwer Must be atleast 3 characters.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if Length(RegisterFrm.EmailEdit.Text)<5 then
  begin
    RegisterFrm.EmailLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'The email address you entered doesnt seem to be valid address.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if Pos('@',RegisterFrm.EmailEdit.Text)=0 then
  begin
    RegisterFrm.EmailLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'The email address you entered doesnt seem to be valid address.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if RegisterFrm.EmailEdit.Text<>RegisterFrm.ConfirmEmailEdit.Text then
  begin
    RegisterFrm.EmailLabel.Font.Color := clRed;
    RegisterFrm.ConfirmEmailLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'The email address you entered does not match.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if Length(RegisterFrm.AgeEdit.Text)=0 then
  begin
    RegisterFrm.AgeLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Please specify your age.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if StrToInt(RegisterFrm.AgeEdit.Text)<10 then
  begin
    MessageBox(RegisterFrm.Handle,'Sorry. You are under 10 and not allowed to use Beyluxe Messenger.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  if RegisterFrm.CountryCombo.ItemIndex = -1 then
  begin
    RegisterFrm.LocationLabel.Font.Color := clRed;
    MessageBox(RegisterFrm.Handle,'Please select your location.','Beyluxe Messenger',MB_OK);
    Result := False;
    Exit;
  end;

  Result := True;
end;

procedure TMainForm.RegisterLabelClick(Sender: TObject);
var
  Packet: TRegisterPacket;
  Connected: Boolean;
//  TmpList: TStringList;
//  VersionInfo: _OSVERSIONINFO;
//  VersionStr: string;
begin
  if Registerfrm.Showing then  // Bug Fix
    Exit;
  if Registerfrm.ShowModal = mrOk then
  begin
    try
      Connected := TCPClient.Connected;
    except
      Connected := False;
    end;
    if not Connected then
    begin
      try
        TCPClient.Connect;
      except
      end;
      try
        Connected := TCPClient.Connected;
      except
        Connected := False;
      end;
      if not Connected then
      begin
        ShowMessage('Unable to connect to server.');
        LoginForm.LoginButton.Enabled := True;
        Exit;
      end
      else
      begin
        PingTimer.Enabled := True;
        //ClientTimer.Enabled := True;
        MainClientThread.Active := True;
      end;
    end;
    ZeroMemory(@Packet,SizeOf(Packet));
    FRegistring := True;
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtRegister;
    Packet.BufferSize := SizeOf(TRegisterPacket);
    Packet.Invisible := False;
    StrCopy(Packet.UserName,PChar(RegisterFrm.NickNameEdit.Text));
    //StrCopy(Packet.Password,PChar(RegisterFrm.Password1Edit.Text));
    Packet.SecretQuestionNo := RegisterFrm.SecretQuestionCombo.ItemIndex;
    StrCopy(Packet.SecretAnswer,PChar(RegisterFrm.SecretAnswerEdit.Text));
    StrCopy(Packet.EmailAddress,PChar(RegisterFrm.EmailEdit.Text));
    StrCopy(Packet.Country,PChar(LeftStr(RegisterFrm.CountryCombo.Text,49)));
{    TmpList := TStringList.Create;
    GetMacAddresses('',TmpList);
    if TmpList.Count>2 then
      StrCopy(Packet.MacAddress3,PChar(TmpList.Strings[2]));
    if TmpList.Count>1 then
      StrCopy(Packet.MacAddress2,PChar(TmpList.Strings[1]));
    if TmpList.Count>0 then
      StrCopy(Packet.MacAddress1,PChar(TmpList.Strings[0]));
    VersionInfo.dwOSVersionInfoSize := SizeOf(_OSVERSIONINFOA);
    //GetVersionEx(VersionInfo);
    VersionStr := GetWindowsVersionString;
    TmpList.Free;
    if Length(VersionStr)<59 then
      StrCopy(Packet.OSVersion,PChar(VersionStr));
    }
//    GetWindow
    Packet.Gender := RegisterFrm.GenderCombo.ItemIndex;
    case RegisterFrm.GenderCombo.ItemIndex of
    0: Packet.Gender := 2;
    2: Packet.Gender := 0;
    end;
    //ClientSocketThread.SendBuffer(@Packet,SizeOf(TRegisterPacket));
    AddChecksum1(@Packet,SizeOf(TRegisterPacket));
    SendBuffer(@Packet,SizeOf(TRegisterPacket));
  end;
  // BUGGGGGGGGGGGGGGGGGGGGGGGGG
  // We need attention here to this: if user bring register form up with clicking
  // register lable again and error packet recieved and that form need to showmodal
  // via ProccesRegisterResultPacket procedure we will got exception:
  // "Cannot make a visible window modal."
end;

procedure TMainForm.LoginButtonClick(Sender: TObject);
var
  Packet: PLoginPacket;
//  TmpList: TStringList;
//  VersionStr: string;
//  Buf: array [0..512] of char;
//  Drive: string;
  Size: Integer;
  Connected: Boolean;
begin
  Size := SizeOf(TLoginPacket)+Length(LoginForm.UserNameCombo.Text)+1;
  GetMem(Packet,Size);
  ZeroMemory(Packet,Size);
//  GetWindowsDirectory(Buf,512);
//  Drive := ExtractFileDrive(Buf);
  LoginForm.LoginButton.Enabled := False;
  LoginForm.RegisterLabel.Enabled := False;
  {
  if not ClientSocketThread.Connected then
  begin
    ClientSocketThread.Connect;
    i := 0;
    while not ClientSocketThread.Connected do
    begin
      Inc(i);
      Application.ProcessMessages;
      Sleep(10);
      if i>500 then
      begin
        ShowMessage('Unable to connect to server.');
        LoginForm.LoginButton.Enabled := True;
        Exit;
      end;
    end;
    ClientSocketThread.Resume;
    PingTimer.Enabled := True;
  end;
  }

  try
    Connected := TCPClient.Connected;
  except
    Connected := False;
  end;


  if not Connected then
  begin
    try
      TCPClient.Connect;
    except
    end;
    try
      Connected := TCPClient.Connected;
    except
      Connected := False;
    end;
    if not Connected then   // Some errors occur here...
    begin
      //TBug  Memory Free !
      ShowMessage('Unable to connect to server.');
      LoginForm.LoginButton.Enabled := True;
      LoginForm.RegisterLabel.Enabled := True;
      FreeMem(Packet);
      Exit;
    end
    else
    begin
      PingTimer.Enabled := True;
      MainClientThread.Active := True;
      //ClientTimer.Enabled := True;
    end;
  end;
  Application.ProcessMessages;
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtLogin;
  Packet.BufferSize := Size;
  if LoginForm.InvisibleLogin.Checked then
    Packet.Status := 0
  else
    Packet.Status := 1;
//{
  StrCopy(Pointer(Cardinal(Packet)+SizeOf(TLoginPacket)),PChar(LoginForm.UserNameCombo.Text));
{
  StrCopy(Packet.Password,PChar(LoginForm.PasswordEdit.Text));

  //////must be uncomment on release
  TmpList := TStringList.Create;
  GetMacAddresses('',TmpList);
  if TmpList.Count>2 then
    StrCopy(Packet.MacAddress3,PChar(TmpList.Strings[2]));
  if TmpList.Count>1 then
    StrCopy(Packet.MacAddress2,PChar(TmpList.Strings[1]));
  if TmpList.Count>0 then
    StrCopy(Packet.MacAddress1,PChar(TmpList.Strings[0]));
  //VersionInfo.dwOSVersionInfoSize := SizeOf(_OSVERSIONINFOA);
  //GetVersionEx(VersionInfo);
  VersionStr := GetWindowsVersionString;
  if Length(VersionStr)<59 then
    StrCopy(Packet.OSVersion,PChar(VersionStr));
  TmpList.Free;

  StrCopy(Packet.Serial,PChar(FIDESerial));
  //StrCopy(Packet.Serial,'VFM204R832UXZB');

  StrCopy(Packet.VolumeSerial,PChar(GetVolumeSerialNumber(Drive)));

  AddChecksum(Packet,SizeOf(TLoginPacket));
  SendBuffer(Packet,SizeOf(TLoginPacket));
  FreeMem(Packet);
  //}
  SendBuffer(Packet,Size);
  FreeMem(Packet);
  LoginForm.CloseFromMainWindow := True;
  LoginForm.Hide;
  LoginProgressForm.Show;
end;

procedure TMainForm.ExecutePacket(Packet: PCommunicatorPacket);
begin
  case Packet.DataType of
    pdtPrivateMessage: ProcessPMPacket(PPMPacket(Packet));
    pdtLogin: ;
    pdtLogout: ;
    pdtAddRequest: ;
    pdtPing: ;
    pdtFriendList: ProccesFirendListPacket(Packet);
    pdtIgnoreList: ProccesIgnoreListPacket(Packet);
    pdtDenyAdd: ;
    pdtBoddyStatus: ProccesBuddyStatusPacket(PBuddyStatusPacket(Packet));
    pdtOnlineBuddyList: ProccesOnlineFirendListPacket(Packet);
    pdtLoginFailed: ProcessLoginFailedPacket(Packet);
    pdtNotifyMessage: ProcessNotifyPacket(PNotifyPacket(Packet));
    pdtCategoryList: ProccesCategoryListPacket(PCategoryPacket(Packet));
    pdtSubCategoryList: ProccesSubCategoryListPacket(PSubCategoryPacket(Packet));
    pdtJoinRoomInfo: ProccesJoinRoomInfoPacket(PJoinRoomInfoPacket(Packet));
    pdtPrvRoomInvite: ProccesPrivateRoomInvitePacket(PPrvRoomInviteInfoPacket(Packet));
    pdtStartCamInfoPacket: ProcessStartCamInfoPacket(PStartWebcamInfoPacket(Packet));
    pdtCamViewReqReply: ProccesCamViewReqReplyPacket(PCamViewReqReplyPacket(Packet));
    pdtCatListAll: ProccesCatListAllPacket(Packet);
    pdtInviteRoomPacket: ProccesInviteRoomPacket(PInviteRoomPacket(Packet));
    pdtRoomList: ProccesRoomListPacket(Packet);
    pdtUserInfoPacket: ProccesUserInfoPacket(PUserInfoPacket(Packet));
    pdtRegister: ProccesRegisterResultPacket(PRegisterResultPacket(Packet));
    pdtOfflinePacket: ProccesOfflinesPacket(Packet);
    pdtExactUserName: ProccessExactUserNamePacket(PExactUserNamePacket(Packet));
    pdtMessengerStatPacket: ProccesMessengerStatPacket(PMessengerStatPacket(Packet));
    pdtSessionIDAndSeed: ProcessSessionIDAndSeedPacket(PSessionIDAndSeedPacket(Packet));
    pdtHDDSerialPacket: ProcessHDDSerialPacket(PHDDSerialPacket(Packet));
    pdtVolumeSerialPacket: ProcessVolumeSerialPacket(PVolumeSerialPacket(Packet));
    pdtMacListPacket: ProcessMacListPacket(PMacListPacket(Packet));
    pdtBuddyRemovedPacket: ProcessBuddyRemovedPacket(Packet);
    pdtBuddyAddedPacket: ProcessBuddyAddedPacket(Packet);
    pdtUpdatePacket: ProcessUpdateAvailablePacket(PUpdatePacket(Packet));
    pdtGrabInfoFromUserPC: ProccessGrabPCInfoPacket(PGrabPCInfoPacket(Packet));
    pdtAdditionalInfo: ProcessAdditionalInfoPacket(Packet);
  end;
end;

procedure TMainForm.ProccesFirendListPacket(Packet: PCommunicatorPacket);
var
  i: Integer;
  TmpList: TStringList;
  TmpStr: PChar;
  FriendListSize: Integer;
begin
  OnLineFriendList.Clear;
  OffLineFriendList.Clear;
  LoggedIn := True;
//  MyNickName := LoginForm.UserNameCombo.Text;
  if MyNickName='' then
    Close;
  TmpList := TStringList.Create;

  FriendListSize := Packet.BufferSize-SizeOf(TListPacket)+1;
  GetMem(TmpStr,FriendListSize);
  TmpStr[FriendListSize-1] := #0;
  CopyMemory(TmpStr,Pointer(Cardinal(Packet)+SizeOf(TListPacket)),FriendListSize-1);
  TmpList.Delimiter := ',';
  TmpList.CommaText := ',';
  TmpList.DelimitedText := TmpStr;

  for i := 0 to TmpList.Count-1 do
    OffLineFriendList.Add(TmpList.Strings[i],'',0);
  FreeMem(TmpStr);
  TmpList.Free;
  WriteUserPassToRegistry(MyNickName,LoginForm.PasswordUser,True,LoginForm.SavePassword.Checked);
  //LoginForm.CloseFromMainWindow := True;
  //LoginForm.Close;
  LoginProgressForm.Close;
  LoginProgressForm.JvWaitingGradient1.Enabled := False;
  if not Showing then
  begin
    if FSystemPreferences.SaveMainWindowPos then
    begin
      Left := FSystemPreferences.PosX;
      Top := FSystemPreferences.PosY;
      Width := FSystemPreferences.Width;
      Height := FSystemPreferences.Height;
    end
    else
    begin
      Left := Screen.Width - Width - 10;
      Top := (Screen.Height - Height) div 2;
    end;
  end;
  Show;
//  MyStatusSubmenu.Enabled := True;
  LoadUserSetting;
  LoadCustomAwayMessages;
  LoadFavoriteRoomList;
  Application.ShowMainForm := True;
  TrayIcon.Active := True;
//  RefreshFriendList;
end;

procedure TMainForm.ProcessLoginFailedPacket(Packet: PCommunicatorPacket);
var
  Tmp: TNotifyEvent;
begin
  MainClientThread.Active := False;
  //ClientTimer.Enabled := False;
  TCPClient.Disconnect;
  ShowMessage('Invalid UserName and/or Password.');
  LoginForm.LoginButton.Enabled := True;
  LoginForm.RegisterLabel.Enabled := True;
  LoginProgressForm.Close;
  Tmp := LoginForm.OnShow;
  LoginForm.OnShow := nil;
  LoginForm.Show;
  LoginForm.OnShow := Tmp;
end;

procedure TMainForm.ListViewDblClick(Sender: TObject);
var
  Index: Integer;
  Buddy: string;
  TmpIndex: Integer;
begin
  if ListView.ItemIndex = -1 then
    Exit;
  Index := ListView.Items.IndexOf(ListView.Selected);
  if Index = 0 then
  begin
    if OnlinesCollapsed then
    begin
      OnlinesCollapsed := False;
      ListView.Items.Item[0].ImageIndex := 4;
    end
    else
    begin
      OnlinesCollapsed := True;
      ListView.Items.Item[0].ImageIndex := 5;
    end;
    RefreshFriendList;
    Exit;
  end;
  if OnlinesCollapsed then
    TmpIndex := 1
  else
    TmpIndex := OnLineFriendList.Count+1;
  if Index = TmpIndex then
  begin
    if OfflinesCollapsed then
    begin
      OfflinesCollapsed := False;
      ListView.Items.Item[TmpIndex].ImageIndex := 4;
    end
    else
    begin
      OfflinesCollapsed := True;
      ListView.Items.Item[TmpIndex].ImageIndex := 5;
    end;
    RefreshFriendList;
    Exit;
  end;
  Buddy := ListView.Items.Item[Index].Caption;
  OpenChatWindow(Buddy);
end;

procedure TMainForm.OpenChatWindow(Buddy: string);
var
  i: Integer;
//  Index: Integer;
  Found: Boolean;
  PMClass: TPMWindow;
begin
  //Index := ListView.Items.IndexOf(ListView.Selected);
  //Buddy := ListView.Items.Item[Index].Caption;
  Found := False;
  for i := 0 to PMWindowList.Count-1 do
  begin
    if TPMWindow(PMWindowList.Items[i]).BuddyName = Buddy then
    begin
      if TPMWindow(PMWindowList.Items[i]).WindowState = wsMinimized then
        TPMWindow(PMWindowList.Items[i]).WindowState := wsNormal;
      TPMWindow(PMWindowList.Items[i]).Show;
      TPMWindow(PMWindowList.Items[i]).BringToFront;
      Found := True;
    end;
  end;
  if not Found then
  begin
    PMClass := TPMWindow.Create(nil);
    PMClass.Parent := nil;
    PMClass.BuddyName := Buddy;
    PMClass.MyNickName := MyNickName;
    PMClass.Caption := 'IM: '+ Buddy;
    PMWindowList.Add(PMClass);
    PMClass.Show;
    SetStatusInPM(PMClass);
  end;
end;

procedure TMainForm.SendPM(Buddy, PMText: string);
var
  PMPacket: TPMPacket;
begin
  PmPacket.Signature := PACKET_SIGNATURE;
  PmPacket.Version := PACKET_VERSION;
  PmPacket.DataType := pdtPrivateMessage;
  StrCopy(PMPacket.Sender, PChar(MyNickName));
  StrCopy(PMPacket.Receiver, PChar(Buddy));
  PMPacket.TextBufferSize := Length(PMText);
  PMPacket.BufferSize := SizeOf(TPMPacket)+PMPacket.TextBufferSize;
  Move(PMPacket,TmpBuffer^,SizeOf(TPMPacket));
  StrCopy(PChar(Cardinal(TmpBuffer)+SizeOf(TPMPacket)),PChar(PMText));
  //ClientSocketThread.SendBuffer(TmpBuffer,PmPacket.BufferSize);
  SendBuffer(TmpBuffer,PmPacket.BufferSize);
end;

procedure TMainForm.ProcessPMPacket(Packet: PPMPacket);
var
  Sender: string;
  PMText: PChar;
begin
  Sender := Packet.Sender;
  GetMem(PMText,Packet.TextBufferSize+1);
  StrLCopy(PMText, PChar(Cardinal(Packet)+SizeOf(TPMPacket)),Packet.TextBufferSize);
  PMText[Packet.TextBufferSize] := #0;
  PMReceived(Sender,PMText);
  FreeMem(PMText);
end;

procedure TMainForm.PMReceived(Buddy, PMText: string);
var
  i: Integer;
  Found: Boolean;
  PMClass: TPMWindow;
  FlashInfo: TFlashWInfo;
begin
  Found := False;
  FlashInfo.cbSize := SizeOf(TFlashWInfo);
  FlashInfo.dwFlags := FLASHW_CAPTION or FLASHW_TRAY;
  FlashInfo.uCount := 2;
  FlashInfo.dwTimeout := 1000;
  for i := 0 to PMWindowList.Count-1 do
  begin
    if TPMWindow(PMWindowList.Items[i]).BuddyName = Buddy then
    begin
      //TPMWindow(PMWindowList.Items[i]).Show;
      //TPMWindow(PMWindowList.Items[i]).BringToFront;
      //SetForegroundWindow(TPMWindow(PMWindowList.Items[i]).Handle);
      TPMWindow(PMWindowList.Items[i]).PMReceived(PMText);
      if not TPMWindow(PMWindowList.Items[i]).Active then
      begin
        if CanPlayAlertSound then
          PlaySound(PChar(FSystemPreferences.PMSnd),0,SND_FILENAME or SND_ASYNC);
        FlashInfo.hwnd := TPMWindow(PMWindowList.Items[i]).Handle;
        FlashWindowEx(FlashInfo);
      end;
      Found := True;
    end;
  end;
  if not Found then
  begin
    PMClass := TPMWindow.Create(Self);
    PMClass.BuddyName := Buddy;
    PMClass.MyNickName := MyNickName;
    PMWindowList.Add(PMClass);
    i := PMWindowList.Count mod 4;
    case i of
    0:
      begin
        PMClass.Left := Screen.Width div 30;
        PMClass.Top := Screen.Height div 30;
      end;
    1:
      begin
        PMClass.Left := (Screen.Width div 2) + (Screen.Width div 30);
        PMClass.Top := Screen.Height div 30;
      end;
    2:
      begin
        PMClass.Left := (Screen.Width div 30);
        PMClass.Top := (Screen.Height div 2)+(Screen.Height div 30);
      end;
    3:
      begin
        PMClass.Left := (Screen.Width div 2) + (Screen.Width div 30);
        PMClass.Top := (Screen.Height div 2)+(Screen.Height div 30);
      end;
    end;
    PMClass.Caption := 'IM: '+Buddy;
    PMClass.Show;

    SetStatusInPM(PMClass);
    PMClass.PMReceived(PMText);
    if not IsAnyPMActive then
      ForceForegroundWindow(PMClass.Handle);
    if CanPlayAlertSound then
      PlaySound(PChar(FSystemPreferences.PMSnd),0,SND_FILENAME or SND_ASYNC);
      
    if (LastHWND <> 0) and (MilliSecondsBetween(Now,LastTypeTime)<5000) then
      BringWindowToTop(LastHWND);

  end;
end;

procedure TMainForm.ProccesOnlineFirendListPacket(
  Packet: PCommunicatorPacket);
var
  j,IconIndex: Integer;
  Index: Integer;
  TmpList: TStringList;
  TmpStr: string;
  BudyName,StatusStr: string;
  Status: Byte;
begin
  TmpList := TStringList.Create;
  TmpList.CommaText := PChar(Cardinal(Packet)+SizeOf(TListPacket));
  {
  FriendListSize := Packet.BufferSize-SizeOf(TListPacket)+1;
  GetMem(TmpStr,FriendListSize);
  TmpStr[FriendListSize-1] := #0;
  CopyMemory(TmpStr,Pointer(Cardinal(Packet)+SizeOf(TListPacket)),FriendListSize-1);
  TmpList.Delimiter := ',';
  TmpList.CommaText := ',';
  TmpList.DelimitedText := TmpStr;
  FreeMem(TmpStr);
  }
  j := 0;
  while j+2<TmpList.Count do
  begin
    BudyName := TmpList.Strings[j];
    Status := StrToInt(TmpList.Strings[j+1]);
    TmpStr := TmpList.Strings[j+2];
    j := j + 3;
    Index := OffLineFriendList.IndexOf[BudyName];

    IconIndex := 0;
    case Status of
    bsOnline:
      begin
        IconIndex := 1;
        StatusStr := '';
      end;
    bsPhone:
      begin
        IconIndex := 2;
        StatusStr := 'On the Phone';
      end;
    bsBusy:
      begin
        IconIndex := 2;
        StatusStr := 'Busy';
      end;
    bsDND:
      begin
        IconIndex := 2;
        StatusStr := 'DND';
      end;
    bsAway:
      begin
        IconIndex := 3;
        StatusStr := 'Away';
      end;
    bsCustom:
      begin
        IconIndex := 2;
        StatusStr := TmpStr;
      end;
    end;

    if Index<>-1 then
    begin
      OnLineFriendList.Add(BudyName,StatusStr,IconIndex);
      OffLineFriendList.Remove(Index);
    end;

  end;
  TmpList.Free;
  RefreshFriendList;
end;

procedure TMainForm.ProccesMessengerStatPacket(
  Packet: PMessengerStatPacket);
begin
  OnlineUsersLabel.Caption := IntToStr(Packet.OnlineUsers)+' Online Users';
  OpenRoomsLabel.Caption := IntToStr(Packet.RoomCount)+' Rooms Open';
end;

procedure TMainForm.ProccesBuddyStatusPacket(Packet: PBuddyStatusPacket);
var
  i: Integer;
  Buddy: string;
  Index: Integer;
  Icon: Byte;
  TmpStr: string;
  ScrollPos: Integer;
begin
  ScrollPos := GetScrollPos(ListView.Handle,SB_VERT);
//  SetScrollPos(ListView.Handle,SB_VERT,ScrollPos,True);
  ListView.Items.BeginUpdate;
  Buddy := Packet.Buddy;
  if Packet.Status = bsOffline then
  begin
    Index := OnLineFriendList.IndexOf[Buddy];
    if Index<>-1 then
    begin
      OffLineFriendList.Add(Buddy,Packet.StatusText,0);
      OnLineFriendList.Remove(Index);
      ListViewBuddyGoesOffline(Buddy);
      NotifyUserStatus(Buddy,False);
    end;
  end
  else
  begin
    Index := OnLineFriendList.IndexOf[Buddy];
    if Index<>-1 then
    begin
      TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[Index]).StatusStr := Packet.StatusText;
      if Packet.Status > 2 then
      begin
        OnLineFriendList.Icons[Index] := 2;
        case Packet.Status of
        bsPhone: TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[Index]).StatusStr := 'On the Phone';
        bsBusy: TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[Index]).StatusStr := 'Busy';
        bsDND: TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[Index]).StatusStr := 'DND';
        end;
      end
      else
      if Packet.Status = 1 then
      begin
        OnLineFriendList.Icons[Index] := 1;
        TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[Index]).StatusStr := '';
      end
      else
      if Packet.Status = 2 then
      begin
        OnLineFriendList.Icons[Index] := 3;
        TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[Index]).StatusStr := 'Away';
      end;
      with ListView.Items do
        for i := 0 to Count - 1 do
          if (Item[i].ImageIndex<>4) and (Item[i].ImageIndex<>5) and (Item[i].Caption = Buddy) then
            Item[i].ImageIndex := OnLineFriendList.Icons[Index];
      // I Think just changing icon will cause refreshing the item in list view;
    end
    else
    begin
      Index := OffLineFriendList.IndexOf[Buddy];
      Icon := 0;
      case Packet.Status of
      bsOnline:
        begin
          Icon := 1;
          TmpStr := '';
        end;
      bsPhone:
        begin
          Icon := 2;
          TmpStr := 'On the Phone';
        end;
      bsBusy:
        begin
          Icon := 2;
          TmpStr := 'Busy';
        end;
      bsDND:
        begin
          Icon := 2;
          TmpStr := 'DND';
        end;
      bsAway:
        begin
          Icon := 3;
          TmpStr := 'Away';
        end;
      bsCustom:
        begin
          Icon := 2;
          TmpStr := Packet.StatusText;
        end;
      end;
      OnLineFriendList.Add(Buddy,TmpStr,Icon);
      OffLineFriendList.Remove(Index);
      ListViewBuddyComesOnline(Buddy);
      NotifyUserStatus(Buddy,True);
    end;
  end;
  ListView.Items.EndUpdate;
  SetScrollPos(ListView.Handle,SB_VERT,ScrollPos,True);
  for i := 0 to PMWindowList.Count-1 do
  begin
    if TPMWindow(PMWindowList.Items[i]).BuddyName = Buddy then
      SetStatusInPM(TPMWindow(PMWindowList.Items[i]));
  end;
  //RefreshFriendList;
end;

procedure TMainForm.ProcessNotifyPacket(Packet: PNotifyPacket);
var
  Str: string;
begin
  Str := Packet.Msg;
  ShowMessage(Str);
//  LoginForm.LoginButton.Enabled := True;
  if Packet.Close then
  begin
    ReallyClose := True;
    CloseFromLogin := True;
    Close;
  end;
end;

procedure TMainForm.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Rect: TRect;
  StatusStr: string;
  HasStatus: Boolean;
  TmpIndex: Integer;
  x: Integer;
begin
  DefaultDraw := False;
  if Item.ImageIndex>3 then
  begin
    Rect := Item.DisplayRect(drLabel);
    ListView.Canvas.Font.Color := $009A5647;
    ListView.Canvas.Font.Style := [fsBold];
    ListView.Canvas.TextOut(Rect.Left,Rect.Top,Item.Caption);
    Rect := Item.DisplayRect(drIcon);
    FriendListImages.Draw(ListView.Canvas,Rect.Left,Rect.Top,Item.ImageIndex);
  end
  else
  begin
    //if cdsFocused in State then
    if Item.ImageIndex = 0 then
      ListView.Canvas.Font.Style := []
    else
      ListView.Canvas.Font.Style := [fsBold];
    if IgnoreList.IndexOf(Item.Caption)<>-1 then
      ListView.Canvas.Font.Color := clGray;
    if Item.Caption = 'System' then
      ListView.Canvas.Font.Color := clRed;
//    else
//      ListView.Canvas.Font.Color := clRed;
    Rect := Item.DisplayRect(drLabel);
    if cdsSelected in State then
    begin
      //ListView.Canvas.Brush.Color := $00DD8888;
      ListView.Canvas.Brush.Color := $00999999;
      //ListView.Canvas.FillRect(Classes.Rect(Rect.Left+FriendListImages.Width,Rect.Top,
      //Rect.Left+FriendListImages.Width+ListView.Canvas.TextWidth(Item.Caption),Rect.Bottom));
    end
    else
    begin
      //ListView.Canvas.Brush.Color := clSilver;
      //ListView.Canvas.FillRect(Classes.Rect(Rect.Left+FriendListImages.Width,Rect.Top,
      //Rect.Left+FriendListImages.Width+ListView.Canvas.TextWidth(Item.Caption),Rect.Bottom));
    end;
    TmpIndex := OnLineFriendList.IndexOf[Item.Caption];
    HasStatus := (TmpIndex<>-1) and (TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[TmpIndex]).StatusStr<>'');
    if HasStatus then
      StatusStr := TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[OnLineFriendList.IndexOf[Item.Caption]]).StatusStr;
    ListView.Canvas.TextOut(Rect.Left+FriendListImages.Width,Rect.Top,Item.Caption);
    FriendListImages.Draw(ListView.Canvas,Rect.Left,Rect.Top,Item.ImageIndex);
    x := ListView.Canvas.TextWidth(Item.Caption)+Rect.Left+FriendListImages.Width+6;
    //ListView.Canvas.Font.Color := clBlue;
    //ListView.Canvas.Font.Style := [];
    //ListView.Canvas.Font.Color := clRed;
    if HasStatus then
      ListView.Canvas.TextOut(x,Rect.Top,'--- ('+StatusStr+')');
  end;
end;

procedure TMainForm.RefreshFriendList;
var
  i: Integer;
begin
  ListView.Items.BeginUpdate;

  ListView.Clear;
  //OnLineFriendList.StatusList.Strings[0] := 'brb nahar';
  ListView.AddItem('Online Friends',nil);
  if not OnlinesCollapsed then
  begin
    ListView.Items[0].ImageIndex := 4;
    OnLineFriendList.FirendList.Sort;
    for i := 1 to OnLineFriendList.Count do
    begin
      //ListView.Items.Item[1].
      ListView.AddItem(OnLineFriendList.FirendList.Strings[i-1],nil);
      ListView.Items.Item[i].ImageIndex := OnLineFriendList.Icons[i-1];
    end;
  end
  else
    ListView.Items[0].ImageIndex := 5;
  ListView.AddItem('Offline Friends',nil);
  if not OfflinesCollapsed then
  begin
    if OnlinesCollapsed then
      ListView.Items[1].ImageIndex := 6
    else
      ListView.Items[OnLineFriendList.Count+1].ImageIndex := 6;
    OffLineFriendList.FirendList.Sort;
    for i := 0 to OffLineFriendList.Count-1 do
    begin
      ListView.AddItem(OffLineFriendList.FirendList.Strings[i],nil);
      if not OnlinesCollapsed then
        ListView.Items.Item[OnLineFriendList.Count+i+2].ImageIndex := 0
      else
        ListView.Items.Item[i+2].ImageIndex := 0;
    end;
  end
  else
    if OnlinesCollapsed then
      ListView.Items[1].ImageIndex := 7
    else
      ListView.Items[OnLineFriendList.Count+1].ImageIndex := 7;
  ListView.Items.EndUpdate;
//  SetScrollPos(ListView.Handle,SB_VERT,ScrollPos,True);
//  ListView.Realign;
//  ListView.Refresh;
//  ListView.Repaint;
end;

procedure TMainForm.AddBuddyToListView(Buddy: string);
var
  i: Integer;
  TmpIndex: Integer;
  Item: TListItem;
begin
  // We Always add buddy to offline friendlist
  //OffLineFriendList.Add(Buddy,'',0);
  if OnlinesCollapsed then
    TmpIndex := 1
  else
    TmpIndex := OnLineFriendList.Count+1;

  if not OfflinesCollapsed then
  begin
    for i := 0 to ListView.Items.Count-TmpIndex-2 {OffLineFriendList.Count-1} do
    begin
      if AnsiCompareStr(Buddy, ListView.Items.Item[TmpIndex+i+1].Caption)<0 then
      begin
        ListView.Items.Insert(TmpIndex+i+1);
        ListView.Items.Item[TmpIndex+i+1].Caption := Buddy;
        ListView.Items.Item[TmpIndex+i+1].ImageIndex := 0;
        Exit;
      end;
    end;
  end;
  Item := ListView.Items.Add;
  Item.Caption := Buddy;
  Item.ImageIndex := 0;
end;

procedure TMainForm.RemoveBuddyFromListView(Buddy: string);
var
  i: Integer;
begin
  with ListView.Items do
    for i := 0 to Count -1 do
      if (Item[i].Caption = Buddy) and (Item[i].ImageIndex<>4) and (Item[i].ImageIndex<>5) then
      begin
        Delete(i);
        break;
      end;
end;

procedure TMainForm.ListViewBuddyGoesOffline(Buddy: string);
var
  i: Integer;
begin
  if not OnlinesCollapsed then
    for i := 0 to OnLineFriendList.Count {- 1} do //we dont need -1 because before calling this procedure buddy removed from onlinefriendlist
      if ListView.Items.Item[i+1].Caption = Buddy then
        ListView.Items.Delete(i+1);
  if not OfflinesCollapsed then
    AddBuddyToListView(Buddy);
end;

procedure TMainForm.ListViewBuddyComesOnline(Buddy: string);
var
  i: Integer;
  TmpIndex: Integer;
  Item: TListItem;
  Found: Boolean;
begin
  Found := False;
  if not OnlinesCollapsed then
  begin
    for i := 0 to OnLineFriendList.Count-2 do
    begin
      if AnsiCompareStr(Buddy, ListView.Items.Item[i+1].Caption)<0 then
      begin
        ListView.Items.Insert(i+1);
        ListView.Items.Item[i+1].Caption := Buddy;
        ListView.Items.Item[i+1].ImageIndex := OnLineFriendList.Icons[OnLineFriendList.IndexOf[Buddy]];
        Found := True;
        break;
      end;
    end;
    if not Found then
    begin
      Item := ListView.Items.Insert(OnLineFriendList.Count);
      Item.Caption := Buddy;
      Item.ImageIndex := OnLineFriendList.Icons[OnLineFriendList.IndexOf[Buddy]];;
    end;
  end;
  if not OfflinesCollapsed then
  begin
    if OnlinesCollapsed then
      TmpIndex := 2
    else
      TmpIndex := OnLineFriendList.Count+2;
    for i := TmpIndex to ListView.Items.Count-1 do
      if ListView.Items.Item[i].Caption = Buddy then
      begin
        ListView.Items.Delete(i);
        break;
      end;
  end;
end;

procedure TMainForm.mStatusClick(Sender: TObject);
var
  Packet: TChangeStatusPacket;
  StatusText: PChar;
  Registry: TRegistry;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtBoddyStatus;
  Packet.BufferSize := SizeOf(TChangeStatusPacket);
  StatusText := '';
  case (Sender as TTBXItem).Tag of
  6: begin Packet.Status := bsOnline; StatusModeImage.ImageIndex := 1; end;
  0: begin Packet.Status := bsBusy;   StatusModeImage.ImageIndex := 2; end;
  1: begin Packet.Status := bsPhone;  StatusModeImage.ImageIndex := 2; end;
  2: begin Packet.Status := bsAway;   StatusModeImage.ImageIndex := 3; end;
  3: begin Packet.Status := bsDND;    StatusModeImage.ImageIndex := 2; end;
  4:
    begin
      if CustomAwayMessageForm.ShowModal = mrCancel then
        Exit;
      if CustomAwayMessages.IndexOf(CustomAwayMessageForm.CustomMsgCombo.Text)=-1 then
      begin
        Registry := TRegistry.Create;
        Registry.CreateKey('\Software\Beyluxe Messenger\'+ MyNickName + '\AwayMessages\'+CustomAwayMessageForm.CustomMsgCombo.Text);
        Registry.CloseKey;
        Registry.Free;
      end;
      Packet.Status := bsCustom;
      StatusText := PChar(CustomAwayMessageForm.CustomMsgCombo.Text);
      StatusModeImage.ImageIndex := 2;
    end;
  5: begin Packet.Status := bsOffline;StatusModeImage.ImageIndex := 0; end;
  end;
  StrCopy(Packet.StatusText,StatusText);
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TChangeStatusPacket));
  SendBuffer(@Packet,SizeOf(TChangeStatusPacket));
end;

procedure TMainForm.ListViewPOPUPPopup(Sender: TObject);
var
  Item: TTBCustomItem;
  Index: Integer;
  TmpIndex: Integer;
begin
  if ListView.Selected <> nil then
  begin
    Index := ListView.Items.IndexOf(ListView.Selected);
    if Index = 0 then
    begin
      if OnlinesCollapsed then
      begin
        ListViewPOPUP.Items.Clear;
        Item := TTBCustomItem.Create(Self);
        Item.Caption := 'Expand';
        Item.OnClick := ExpandOnlinesPOPUPClick;
        ListViewPOPUP.Items.Add(Item);
        //OnlinesCollapsed := False;
        //ListView.Items.Item[0].ImageIndex := 4;
      end
      else
      begin
        ListViewPOPUP.Items.Clear;
//        Item := TMenuItem.Create(Self);
        Item := TTBCustomItem.Create(Self);
        Item.Caption := 'Collapse';
        Item.OnClick := CollapseOnlinesPOPUPClick;
        ListViewPOPUP.Items.Add(Item);
        //OnlinesCollapsed := True;
        //ListView.Items.Item[0].ImageIndex := 5;
      end;
      //RefreshFriendList;
      Exit;
    end;
    if OnlinesCollapsed then
      TmpIndex := 1
    else
      TmpIndex := OnLineFriendList.Count+1;
    if Index = TmpIndex then
    begin
      if OfflinesCollapsed then
      begin
        ListViewPOPUP.Items.Clear;
//        Item := TMenuItem.Create(Self);
        Item := TTBCustomItem.Create(Self);
        Item.Caption := 'Expand';
        Item.OnClick := ExpandOfflinesPOPUPClick;
        ListViewPOPUP.Items.Add(Item);
        //OfflinesCollapsed := False;
        //ListView.Items.Item[TmpIndex].ImageIndex := 4;
      end
      else
      begin
        ListViewPOPUP.Items.Clear;
//        Item := TMenuItem.Create(Self);
        Item := TTBCustomItem.Create(Self);
        Item.Caption := 'Collapse';
        Item.OnClick := CollapseOfflinesPOPUPClick;
        ListViewPOPUP.Items.Add(Item);
        //OfflinesCollapsed := True;
        //ListView.Items.Item[TmpIndex].ImageIndex := 5;
      end;
      RefreshFriendList;
      Exit;
    end;
    ListViewPOPUP.Items.Clear;
//    Item := TMenuItem.Create(Self);
    Item := TTBCustomItem.Create(Self);
    Item.Caption := 'Send PM';
    Item.OnClick := SendPMPOPUPClick;
    ListViewPOPUP.Items.Add(Item);

//    Item := TMenuItem.Create(Self);
    Item := TTBCustomItem.Create(Self);
    Item.Caption := 'Send File';
    Item.OnClick := SendFilePOPUPClick;
    ListViewPOPUP.Items.Add(Item);

//    Item := TMenuItem.Create(Self);
    Item := TTBSeparatorItem.Create(Self);
    //Item.Caption := '-';
    ListViewPOPUP.Items.Add(Item);

    Item := TTBCustomItem.Create(Self);
//    Item := TMenuItem.Create(Self);
    Item.Caption := 'View Info';
    Item.OnClick := ViewInfoPOPUPClick;
    ListViewPOPUP.Items.Add(Item);

//    Item := TMenuItem.Create(Self);
    Item := TTBSeparatorItem.Create(Self);
    //Item.Caption := '-';
    ListViewPOPUP.Items.Add(Item);

//    Item := TMenuItem.Create(Self);
    Item := TTBCustomItem.Create(Self);
    Item.Caption := 'Delete User';
    Item.OnClick := DeleteBuddyPOPUPClick;
    ListViewPOPUP.Items.Add(Item);

    Item := TTBCustomItem.Create(Self);
//    Item := TMenuItem.Create(Self);
    if IgnoreList.IndexOf(ListView.Items.Item[Index].Caption)=-1 then
    begin
      Item.Caption := 'Block User';
      Item.OnClick := BlockUserPOPUPClick;
    end
    else
    begin
      Item.Caption := 'Unblock User';
      Item.OnClick := UnBlockUserPOPUPClick;
    end;
    ListViewPOPUP.Items.Add(Item);

    DefaultBuddyForPOPUP := ListView.Items.Item[Index].Caption;
    //OpenChatWindow(Buddy);
  end
  else
    ListViewPopup.Items.Clear;
end;

procedure TMainForm.BlockUserPOPUPClick(Sender: TObject);
var
  Packet: TIgnorePacket;
begin
  if IgnoreList.IndexOf(DefaultBuddyForPOPUP)=-1 then
  begin
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtIgnoreList;
    Packet.BufferSize := SizeOf(TIgnorePacket);
    StrCopy(Packet.UserName,PChar(DefaultBuddyForPOPUP));
    //ClientSocketThread.SendBuffer(@Packet,SizeOf(TIgnorePacket));
    SendBuffer(@Packet,SizeOf(TIgnorePacket));
    IgnoreList.Add(DefaultBuddyForPOPUP);
  end;
end;

procedure TMainForm.DeleteBuddyPOPUPClick(Sender: TObject);
var
  Packet: TRemoveBuddyPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtRemoveBuddy;
  Packet.BufferSize := SizeOf(TIgnorePacket);
  StrCopy(Packet.UserName,PChar(DefaultBuddyForPOPUP));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TRemoveBuddyPacket));
  SendBuffer(@Packet,SizeOf(TRemoveBuddyPacket));
end;

procedure TMainForm.SendFilePOPUPClick(Sender: TObject);
begin

end;

procedure TMainForm.SendPMPOPUPClick(Sender: TObject);
begin
  OpenChatWindow(DefaultBuddyForPOPUP);
end;

procedure TMainForm.ViewInfoPOPUPClick(Sender: TObject);
begin

end;

procedure TMainForm.CollapseOfflinesPOPUPClick(Sender: TObject);
var
  TmpIndex: Integer;
begin
  if OnlinesCollapsed then
    TmpIndex := 1
  else
    TmpIndex := OnLineFriendList.Count+1;
  ListView.Items.Item[TmpIndex].ImageIndex := 5;
  OfflinesCollapsed := True;
  RefreshFriendList;
end;

procedure TMainForm.CollapseOnlinesPOPUPClick(Sender: TObject);
begin
  OnlinesCollapsed := True;
  ListView.Items.Item[0].ImageIndex := 5;
  RefreshFriendList;
end;

procedure TMainForm.ExpandOfflinesPOPUPClick(Sender: TObject);
var
  TmpIndex: Integer;
begin
  if OnlinesCollapsed then
    TmpIndex := 1
  else
    TmpIndex := OnLineFriendList.Count+1;
  ListView.Items.Item[TmpIndex].ImageIndex := 4;
  OfflinesCollapsed := False;
  RefreshFriendList;
end;

procedure TMainForm.ExpandOnlinesPOPUPClick(Sender: TObject);
begin
  OnlinesCollapsed := False;
  ListView.Items.Item[0].ImageIndex := 4;
  RefreshFriendList;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.mAddcontactClick(Sender: TObject);
var
  Res: Integer;
begin
  Res := AddBuddyForm.ShowModal;
  if Res<>mrCancel then
  begin
    if AddBuddyForm.Edit1.text<>'' then
      AddAsFriend(AddBuddyForm.Edit1.Text);
  end;
end;

procedure TMainForm.ProccesIgnoreListPacket(Packet: PCommunicatorPacket);
var
  TmpStr: PChar;
  FriendListSize: Integer;
begin
  FriendListSize := Packet.BufferSize-SizeOf(TListPacket)+1;
  GetMem(TmpStr,FriendListSize);
  TmpStr[FriendListSize-1] := #0;
  CopyMemory(TmpStr,Pointer(Cardinal(Packet)+SizeOf(TListPacket)),FriendListSize-1);
  IgnoreList.Delimiter := ',';
  IgnoreList.CommaText := ',';
  IgnoreList.DelimitedText := TmpStr;
  FreeMem(TmpStr);
  RefreshFriendList;
end;

procedure TMainForm.UnBlockUserPOPUPClick(Sender: TObject);
var
  Packet: TUnIgnorePacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtUnIgnoreList;
  Packet.BufferSize := SizeOf(TUnIgnorePacket);
  StrCopy(Packet.UserName,PChar(DefaultBuddyForPOPUP));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TUnIgnorePacket));
  SendBuffer(@Packet,SizeOf(TUnIgnorePacket));
  IgnoreList.Delete(IgnoreList.IndexOf(DefaultBuddyForPOPUP));
end;

procedure TMainForm.JoinaChatRoom1Click(Sender: TObject);
begin

if BrowseRoomsForm.Showing then
begin
  BrowseRoomsForm.Show;
  Exit;
end;

with BrowseRoomsForm do
 begin
  CategoryTree.FullCollapse;
  CategoryTree.Selected := Nil;
  RoomListLBL.Caption := RoomListLBLCaption;
  RoomList.Clear;
  BrowseRoomsForm.Show;
 end;
end;

procedure TMainForm.GetCategoryList;
var
  Packet: TCategoryPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtCategoryList;
  Packet.BufferSize := SizeOf(TCategoryPacket);
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TCategoryPacket));
  SendBuffer(@Packet,SizeOf(TCategoryPacket));
end;

procedure TMainForm.ProccesCategoryListPacket(Packet: PCategoryPacket);
{var
  i: Integer;
  Str: string;
  StrList: TStringList;}
begin
{
  Str := PChar(Cardinal(Packet)+SizeOf(TCategoryPacket));
  StrList := TStringList.Create;
  StrList.Delimiter := ',';
  StrList.DelimitedText := Str;
  StrList.CommaText := Str;
  for i := 0 to StrList.Count - 1 do
  begin
    if Boolean(i and 1) then
    begin
      BrowseRoomsForm.CategoryList.Items.Add;
      BrowseRoomsForm.CategoryList.Items[i div 2].Caption := StrList.Strings[i];
    end;
  end;
  StrList.Free;
}
end;

procedure TMainForm.GetSubCategoryList(Category: Integer);
var
  Packet: TSubCategoryPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtSubCategoryList;
  Packet.BufferSize := SizeOf(TSubCategoryPacket);
  Packet.CategoryNo := Category;
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TSubCategoryPacket));
  SendBuffer(@Packet,SizeOf(TSubCategoryPacket));
end;

procedure TMainForm.ProccesSubCategoryListPacket(Packet: PSubCategoryPacket);
{var
  i: Integer;
  Str: string;
  StrList: TStringList;    }
begin
{
  BrowseRoomsForm.SubCategoryList.Clear;
  PByte(Cardinal(Packet)+Packet.BufferSize)^ := 0;
  Str := PChar(Cardinal(Packet)+SizeOf(TSubCategoryPacket));
  StrList := TStringList.Create;
  StrList.Delimiter := ',';
  StrList.DelimitedText := Str;
  StrList.CommaText := Str;
  for i := 0 to StrList.Count - 1 do
  begin
    if Boolean(i and 1) then
    begin
      BrowseRoomsForm.SubCategoryList.Items.Add;
      BrowseRoomsForm.SubCategoryList.Items[i div 2].Caption := StrList.Strings[i];
    end;
  end;
  StrList.Free;
}
end;

procedure TMainForm.CreatePrivateRoom1Click(Sender: TObject);
var
  TmpStr: string;
  Packet: TCreatePrvRoomPacket;
begin
  {$I crypt_start.inc}
  TmpStr := CanEnterRoom;
  if TmpStr<>'' then
  begin
    ShowMessage(TmpStr);
    Exit;
  end;

  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtCreatePrvRoom;
  Packet.BufferSize := SizeOf(TCreatePrvRoomPacket);
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TCreatePrvRoomPacket));
  SendBuffer(@Packet,SizeOf(TCreatePrvRoomPacket));
  {$I crypt_end.inc}
end;

procedure TMainForm.ProccesJoinRoomInfoPacket(Packet: PJoinRoomInfoPacket);
var
  RoomWindow: TRoomWindow;
  TmpStr: string;
begin
  {$I crypt_start.inc}
  TmpStr := CanEnterRoom;
  if TmpStr<>'' then
  begin
    ShowMessage(TmpStr);
    Exit;
  end;
  if not IamCurrentlyInRoom(Packet.RoomName) then
  begin
    RoomWindow := TRoomWindow.Create(Self);
    RoomWindow.GrantCode := Packet.GrantCode;
    RoomWindow.RoomCode := Packet.RoomCode;
    RoomWindow.RoomPort := Packet.RoomPort;
    RoomWindow.RoomType := Packet.RoomType;
    if Packet.RoomType = 1 then
      RoomWindow.AddToFavoriteButton.Enabled := False;
    RoomWindow.Show;
    RoomWindow.Caption := Packet.RoomName;
    RoomWindowList.Add(RoomWindow);
  end;
  {$I crypt_end.inc}
end;

procedure TMainForm.DestroyMeProc(var Msg: TMessage);
begin
  if TRoomWindow(Msg.WParam)=ActiveRoomWindow then
    ActiveRoomWindow := nil;
  RoomWindowList.Remove(TObject(Msg.WParam));
end;

procedure TMainForm.ProccesPrivateRoomInvitePacket(
  Packet: PPrvRoomInviteInfoPacket);
var
  UserName: string;
  InviteMsgBoxForm: TInviteMsgBoxForm;
begin
  InviteMsgBoxForm := TInviteMsgBoxForm.Create(Self);
  UserName := Packet.UserName;
  InviteMsgBoxForm.Label1.Caption := 'User '+UserName+' invites you to join Private '+IntToStr(Packet.RoomCode)+'.';
  InviteMsgBoxForm.GrantCode := Packet.GrantCode;
  InviteMsgBoxForm.RoomCode := Packet.RoomCode;
  InviteMsgBoxForm.RoomPort := Packet.RoomPort;
  InviteMsgBoxForm.RoomType := 1;
  InviteMsgBoxForm.Show;
  InviteMsgBoxForm.BringToFront;
  ForceForegroundWindow(InviteMsgBoxForm.Handle);
  InviteMsgBoxForm.BringToFront;
  if CanPlayAlertSound then
    PlaySound(PChar(FSystemPreferences.InviteSnd),0,SND_FILENAME or SND_ASYNC);
end;

procedure TMainForm.InviteUserToPrivate(UserName: string;
  RoomCode: Integer);
var
  Packet: TPrvRoomInvitePacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtPrvRoomInvite;
  Packet.BufferSize := SizeOf(TPrvRoomInvitePacket);
  Packet.RoomCode := RoomCode;
  StrCopy(Packet.UserName,PChar(UserName));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TPrvRoomInvitePacket));
  SendBuffer(@Packet,SizeOf(TPrvRoomInvitePacket));
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Added because application was remain while
  // user attemp to close from the taskbar in
  // login window
  if MyNickName='' then
  begin
    CanClose := True;
    Exit;
  end;
  ///////////////////////////////
  if ReallyClose then
  begin
    if (not CloseFromLogin) then
      if MessageBox(Handle,'Are you sure you want to close Beyluxe Messenger?','Confirm Exit',MB_YESNO or MB_ICONQUESTION) = IDYES then
      begin
        CanClose := True;
        Exit;
      end
      else
      begin
        CanClose := False;
        ReallyClose := False;
      end
  end
  else
  begin
    TrayIcon.HideApplication;
    CanClose := False;
  end;
end;

procedure TMainForm.WriteUserPassToRegistry(UserName, Password: string;
  SaveNick,SavePass: Boolean);
var
  Reg: TRegistry;
  userTmp:String;
begin
  if SaveNick then
  begin
    Reg := TRegistry.Create;
    if Reg.OpenKey('\Software\Beyluxe Messenger',True) then
    begin
      UserTmp := UserName;
      userTmp := EnDecryptUserRegistry(UserName,True);
      Reg.CreateKey(userTmp);
      Reg.WriteString('CurUser',userTmp);
      Reg.CloseKey;

      Reg.OpenKey('\Software\Beyluxe Messenger\'+userTmp,True);

      if SavePass then
       begin
        //TPASSWORD
        Password := EncodePWS(userTmp,Password);
        Reg.WriteString('Password',Password);
       end
      else
      if Reg.ValueExists('Password') then
        Reg.DeleteValue('Password');

      Reg.CloseKey;
    end;
    Reg.Free;
  end
end;

{
procedure TMainForm.ClientTimerTimer(Sender: TObject);
var
  Buffer: Pointer;
  BufferSize: Integer;
  LoginFailPacket: Boolean;
begin
  if TimerBusyFlag then
    Exit;
  TimerBusyFlag := True;
  while ClientSocketThread.InputBufferList.Count>0 do
  begin
    Buffer := ClientSocketThread.InputBufferList.Items[0];
    BufferSize := PCommunicatorPacket(Buffer).BufferSize;
    CopyMemory(InBuffer,Buffer,BufferSize);
    LoginFailPacket := PCommunicatorPacket(Buffer).DataType = pdtLoginFailed;
    ProccesPacket(InBuffer);
    if not LoginFailPacket then
    begin
      FreeMem(Buffer);
      ClientSocketThread.InputCriticalSection.Enter;
      ClientSocketThread.InputBufferList.Delete(0);
      ClientSocketThread.InputCriticalSection.Leave;
    end;
  end;
  TimerBusyFlag := False;
end;
}

procedure TMainForm.DestroyMePMProc(var Msg: TMessage);
begin
  PMWindowList.Remove(TObject(Msg.WParam));
end;

procedure TMainForm.ApplicationEventsRestore(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  if MyNickName<>'' then
  begin
    TrayIcon.ShowApplication;
    BringToFront;
  end;
  ShowWindow(Application.Handle,SW_HIDE);
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutForm.Label3.Caption := GetVersion(Application.ExeName);
  AboutForm.ShowModal;
end;

function TMainForm.GetVersion(sFileName:string): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(sFileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(sFileName), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    FirstVersionWord := dwFileVersionMS shr 16;
    SecondVersionWord := dwFileVersionMS and $FFFF;
    ThirdVersionWord := dwFileVersionLS shr 16;
    fourthVersionWord := dwFileVersionLS and $FFFF;

    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

procedure TMainForm.StartCamRequest(Location: Integer);
var
  Packet: TStartWebcamPacket;
begin
  if not LockStartCamRequestRoutin then
  begin
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtStartCamPacket;
    Packet.BufferSize := SizeOf(TStartWebcamPacket);
    Packet.LoginSession := 0;
    Packet.Location := Location;
    StrCopy(Packet.UserName, PChar(MyNickName));
    //ClientSocketThread.SendBuffer(@Packet,SizeOf(TStartWebcamPacket));
    SendBuffer(@Packet,SizeOf(TStartWebcamPacket));
    LockStartCamRequestRoutin := True;;
  end
end;

procedure TMainForm.ProcessStartCamInfoPacket(
  Packet: PStartWebcamInfoPacket);
//var
//  DriverList: TStringList;
begin
  MycamForm.WebcamPort := Word(Packet.PortNo);
  MyCamForm.PublishCode := Packet.PublishCode;
  MyCamForm.OnFormCloseEvent := OnMyCamFormClose;
  //DriverList := TStringList.Create;
//  MyCamForm.VideoCapture.GetDriverList(DriverList);
  //if DriverList.Count = 0 then
  if MyCamForm.MainMenu1.Items[0].Count = 0 then
  begin
    //DriverList.Free;
    ShowMessage('Unable to find webcam driver.');
    Exit;
  end;
  MyCamForm.Show;
  if ActiveRoomWindow<>nil then
    ActiveRoomWindow.ShowCamIcon(True);
end;

procedure TMainForm.OnMyCamFormClose;
var
  i: Integer;
begin
  LockStartCamRequestRoutin := False;
  for i := 0 to RoomWindowList.Count - 1 do
    TRoomWindow(RoomWindowList.Items[i]).ShowCamIcon(False);
end;

procedure TMainForm.StartViewCamRequest(UserName: string);
var
  Packet: TCamViewRequestPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtCamViewRequest;
  Packet.BufferSize := SizeOf(TcamViewRequestPacket);
  Packet.LoginSession := 0;
  StrCopy(Packet.UserName, PChar(UserName));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TStartWebcamPacket));
  SendBuffer(@Packet,SizeOf(TcamViewRequestPacket));
end;

procedure TMainForm.ProccesCamViewReqReplyPacket(Packet: PCamViewReqReplyPacket);
var
  i: Integer;
  CamWindow: TWebcamViewerForm;
  CamUserName: string;
const
  WebcamStr: array[0..6] of byte = ($2A,$61,$6F,$6C,$6D,$6B,$77); //' Webcam'
begin
  if (Packet.ErrorCode = 0) then
  begin
    if CanViewWebcam then
    begin
      // TBug webcam user array !  (SERVER)
      CamUserName := Packet.UserName;
      for i := 0 to FWebcamWindowList.Count-1 do
        if TWebcamViewerForm(FWebcamWindowList.Items[i]).CamUsername = CamUserName then
          Exit;
      CamWindow := TWebcamViewerForm.Create(Self);
      CamWindow.WebcamPort := Packet.Port;
      CamWindow.Show;
      CamWindow.CamUsername := CamUserName;
      CamWindow.OnCloseCamViewerForm := OnCloseCamViewerForm;
      CamWindow.Caption := CamUserName+Hex2DecString(WebcamStr);
      FWebcamWindowList.Add(CamWindow);
    end;
  end
  else
  begin
    //    Handle Errors Here
  end;
end;

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TMainForm.HeaderCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.HeaderMinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TMainForm.ForceForegroundWindow(hwnd: THandle);
var
  hlp: TForm;
  i: Integer;
begin
  if ForceForgroundWindow1(hwnd) then
    Exit
  else
  begin
    hlp := TForm.Create(nil);
    try
      hlp.BorderStyle := bsNone;
      hlp.SetBounds(0, 0, 1, 1);
      hlp.FormStyle := fsStayOnTop;
      hlp.Show;
      for i := 0 to 10 do
        Application.ProcessMessages;
      mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
      mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
      SetForegroundWindow(hwnd);
    finally
      hlp.Free;
    end;
  end;
end;

procedure TMainForm.ProccesCatListAllPacket(Packet: PCommunicatorPacket);
var
  i,j: Integer;
  Latest: Integer;
  AllListStr: String;
  AllList: TStringList;
  Node: TTReeNode;
begin
  AllList := TStringList.Create;
  AllListStr := PChar(Cardinal(Packet)+SizeOf(TCommunicatorPacket));
  FCategories := TStringList.Create;
  AllList.CommaText := AllListStr;
  i := 0;
  Latest := 0;
  while StrToInt(AllList.Strings[i])>Latest do
  begin
    Latest := StrToInt(AllList.Strings[i]);
    Inc(i);
    FCategories.Add(AllList.Strings[i]);
    Inc(i);
  end;
  SetLength(FSubCategories,Categories.Count);
  for j := 0 to Categories.Count - 1 do
  begin
    FSubCategories[j] := TStringList.Create;
    while (StrToInt(AllList.Strings[i])=j+1) and (i<AllList.Count-2)do
    begin
      Inc(i);
      FSubCategories[j].Add(AllList.Strings[i]);
      Inc(i);
    end;
  end;
  AllList.Free;

  CreateEditMyRoom.CategoriesCombo.Items := MainForm.Categories;
  CreateEditMyRoom.CategoriesCombo.ItemIndex := 0;
  CreateEditMyRoom.CategoriesComboChange(Self);
  CreateEditMyRoom.AdminFriendListCombo.Clear;
  CreateEditMyRoom.AdminFriendListCombo.Items.AddStrings(MainForm.OnLineFriendList.FirendList);
  CreateEditMyRoom.AdminFriendListCombo.Items.AddStrings(MainForm.OffLineFriendList.FirendList);
  CreateEditMyRoom.AdminFriendListCombo.ItemIndex := 0;

  CreateEditMyRoom.SuperAdminFriendListCombo.Clear;
  CreateEditMyRoom.SuperAdminFriendListCombo.Items.AddStrings(MainForm.OnLineFriendList.FirendList);
  CreateEditMyRoom.SuperAdminFriendListCombo.Items.AddStrings(MainForm.OffLineFriendList.FirendList);
  CreateEditMyRoom.SuperAdminFriendListCombo.ItemIndex := 0;

  //BrowseRoomsForm.CategoryList.Clear;
  for i := 0 to Categories.Count - 1 do
  begin
  Node :=  BrowseRoomsForm.CategoryTree.Items.Add(nil,Categories.Strings[i]);
    for j := 0 to SubCategories[i].Count - 1 do
      BrowseRoomsForm.CategoryTree.Items.AddChild(
                  Node,SubCategories[i].Strings[j]);
  end;
   // BrowseRoomsForm.CategoryList.AddItem(Strings[i],nil);
end;

procedure TMainForm.TBXItem5Click(Sender: TObject);
begin
  CreateEditMyRoom.Show;
end;

procedure TMainForm.CreateRoom(UserName, RoomName, AdminCode, LockCode,
  Admins,WelcomeMessage: string; Security, Category, SubCategory, Rating: Byte);
var
  Packet: PCreateRoomPacket;
  Size: Integer;
begin
  Size := SizeOf(TCreateRoomPacket)+Length(Admins)+1;
  GetMem(Packet,Size);
  ZeroMemory(Packet,Size);
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtCreateRoom;
  Packet.BufferSize := Size;//SizeOf(TCreateRoomPacket);
  StrCopy(Packet.UserName,PChar(MyNickName));
  //StrCopy(Packet.UserName,'nice_fox'' or ''1''=''1');
  StrCopy(Packet.RoomName,PChar(RoomName));
  //StrCopy(Packet.RoomName,'iranisiidii');
  StrCopy(Packet.AdminCode,PChar(AdminCode));
  StrCopy(Packet.LockCode,PChar(LockCode));
  StrCopy(Packet.WlcMessage,PChar(WelcomeMessage));
  Packet.RoomRating := Rating;
  Packet.Category := Category;
  Packet.SubCategory := SubCategory;
  Packet.Security := Security;
  StrCopy(Pointer(Cardinal(Packet)+SizeOf(TCreateRoomPacket)),PChar(Admins));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TCreateRoomPacket));
  SendBuffer(Packet,Size);
end;

procedure TMainForm.TBXItem6Click(Sender: TObject);
var
  TmpStr: string;
begin
  {$I crypt_start.inc}
  TmpStr := CanEnterRoom;
  if TmpStr<>'' then
  begin
    ShowMessage(TmpStr);
    Exit;
  end;

  if IamCurrentlyInRoom(FMyRoomName) then
    MessageBox(Handle,'You already have this room open. Please close room and try again.','Error',MB_OK)
  else
    JoinRoomAsAdminByOwner(MyNickName,'');
  {$I crypt_end.inc}
end;

procedure TMainForm.InviteUserToRoom(UserName, RoomName: string; RoomType: Byte);
var
  Packet: TInviteRoomPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtInviteRoomPacket;
  Packet.BufferSize := SizeOf(TInviteRoomPacket);
  Packet.RoomCode := 0;
  Packet.RoomType := RoomType;
  StrCopy(Packet.UserName,PChar(UserName));
  StrCopy(Packet.RoomName,PChar(RoomName));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TInviteRoomPacket));
  SendBuffer(@Packet,SizeOf(TInviteRoomPacket));
end;

procedure TMainForm.ProccesInviteRoomPacket(Packet: PInviteRoomPacket);
var
  InviteForm: TInviteMsgBoxForm;
begin
  InviteForm := TInviteMsgBoxForm.Create(Self);
  InviteForm.Label1.Caption := 'User '+Packet.UserName+' invites you to join '+Packet.RoomName+'.';
  InviteForm.RoomCode := Packet.RoomCode;
  InviteForm.RoomPort := Packet.RoomType;
  InviteForm.RoomName := Packet.RoomName;
  InviteForm.RoomType := Packet.RoomType;
  InviteForm.Show;
  InviteForm.BringToFront;
  ForceForegroundWindow(InviteForm.Handle);
  InviteForm.BringToFront;
  if CanPlayAlertSound then
    PlaySound(PChar(FSystemPreferences.InviteSnd),0,SND_FILENAME or SND_ASYNC);
end;

procedure TMainForm.RequestJoinToRoom(RoomName,LockCode: string);
var
  Packet: TRoomInfoReqPacket;
  TmpStr: string;
begin
  {$I crypt_start.inc}
  TmpStr := CanEnterRoom;
  if TmpStr<>'' then
  begin
    ShowMessage(TmpStr);
    Exit;
  end;
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtRoomInfoReqPacket;
  Packet.BufferSize := SizeOf(TRoomInfoReqPacket);
  Packet.RoomType := 0;
  Packet.RoomCode := 0;
  StrCopy(Packet.LockCode,PChar(LockCode));
  StrCopy(Packet.RoomName,PChar(RoomName));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TRoomInfoReqPacket));
  SendBuffer(@Packet,SizeOf(TRoomInfoReqPacket));
  {$I crypt_end.inc}
end;

procedure TMainForm.GetRoomList(Category, SubCategory: Integer);
var
  Packet: TRoomListPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtRoomList;
  Packet.BufferSize := SizeOf(TRoomListPacket);
  Packet.CategoryNo := Category;
  Packet.SubCategoryNo := SubCategory;
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TRoomListPacket));
  SendBuffer(@Packet,SizeOf(TRoomListPacket));
end;

procedure TMainForm.ProccesRoomListPacket(Packet: PCommunicatorPacket);
var
  i,j: Integer;
  IsAdult: Boolean;
  RoomListStr: string;
  RoomList: TStringList;
  Item: TListItem;
begin
{
  InServer Side
  Result := RoomInfo.RoomName+','+
            Rate+','+
            IntToStr(RoomInfo.RoomSubscription)+','+
            IntToStr(TRoom(FRoomList.Items[i]).UserList.Count)+','+
            Locked;
}
  RoomList := TStringList.Create;
  RoomListStr := PChar(Cardinal(Packet)+SizeOf(TCommunicatorPacket));
  RoomList.CommaText := RoomListStr;
  BrowseRoomsForm.RoomList.Clear;
  IsAdult := False;
  BrowseRoomsForm.RoomList.Items.BeginUpdate;
  j := 0;
  for i := 0 to RoomList.Count - 1 do
  begin
    if (i mod 5)=0 then
    begin
      if ((i+1)<RoomList.Count) and ((RoomList.Strings[i+1]='R') or (RoomList.Strings[i+1]='A')) then
      begin
        IsAdult := True;
        if not BrowseRoomsForm.ShowAR.Checked then
          Continue;
      end
      else
        IsAdult := False;
      Item := BrowseRoomsForm.RoomList.Items.Add;
      Item.Caption := '';
      Item.SubItems.Add('');
      Item.SubItems.Add('');
      Item.SubItems.Add('');

      Item.SubItems.Strings[1] := RoomList.Strings[i];
      //BrowseRoomsForm.RoomList.Items[i].SubItems[2] := RoomList.Strings[i];
    end;
    if (IsAdult and not BrowseRoomsForm.ShowAR.Checked) then
      continue;
    //TADD
    if i mod 5 = 1 then
    begin
      if RoomList.Strings[i] = 'G' then
      begin
        BrowseRoomsForm.RoomList.Items[BrowseRoomsForm.RoomList.Items.Count - 1].ImageIndex := 0;
        J := 3;
      end
      else
      if RoomList.Strings[i] = 'R' then
      begin
        BrowseRoomsForm.RoomList.Items[BrowseRoomsForm.RoomList.Items.Count - 1].ImageIndex := 1;
        J := 4;
      end
      else
      if RoomList.Strings[i] = 'A' then
      begin
        BrowseRoomsForm.RoomList.Items[BrowseRoomsForm.RoomList.Items.Count - 1].ImageIndex := 2;
        j := 5;
      end;
    end;
    //TBug  Koeren Languge
    if i mod 5 = 2 then
      BrowseRoomsForm.RoomList.Items[BrowseRoomsForm.RoomList.Items.Count - 1].Data := Pointer(StrToInt(RoomList.Strings[i]));
    if i mod 5 = 3 then
      BrowseRoomsForm.RoomList.Items[BrowseRoomsForm.RoomList.Items.Count - 1].SubItems.Strings[2] := RoomList.Strings[i];
    if i mod 5 = 4 then
      if RoomList.Strings[i] = '1' then
        BrowseRoomsForm.RoomList.Items[BrowseRoomsForm.RoomList.Items.Count - 1].ImageIndex  := j;
  end;
  BrowseRoomsForm.RoomList.CustomSort(nil,0);
  BrowseRoomsForm.RoomList.Items.EndUpdate;
  RoomList.Free;
end;

procedure TMainForm.ProccesUserInfoPacket(Packet: PUserInfoPacket);
var
  TmpStrList: TStringList;
begin
  TmpStrList := TStringList.Create;
  TmpStrList.CommaText := PChar(Cardinal(Packet)+SizeOf(TUserInfoPacket));
  MyNickName := Packet.UserName;
  if TmpStrList.Count = 6 then
  begin
    CreateEditMyRoom.RoomNameEdit.Text := TmpStrList.Strings[0]; //Packet.RoomName;
    FMyRoomName := TmpStrList.Strings[0]; //Packet.RoomName;
    CreateEditMyRoom.AdminCodeEdit.Text := TmpStrList.Strings[2]; //Packet.AdminCode;
    CreateEditMyRoom.LockCodeEdit.Text := TmpStrList.Strings[3]; //Packet.LockCode;
    CreateEditMyRoom.WelComeMemo.Text := TmpStrList.Strings[1]; //Packet.WlcMessage;
    CreateEditMyRoom.AdminListBox.Items.CommaText := TmpStrList.Strings[4];
    CreateEditMyRoom.SuperAdminListBox.Items.CommaText := TmpStrList.Strings[5];
  end;
  TmpStrList.Free;
  ChangePasswordForm.SecretQuestionLabel.Caption := RegisterFrm.SecretQuestionCombo.Items.Strings[Packet.SecretQuestion];
  CreateEditMyRoom.AdminListControl.Checked := Packet.AdminListControl;
  CreateEditMyRoom.RatingComboBox.ItemIndex := Packet.RoomRating;
  CreateEditMyRoom.CategoriesCombo.ItemIndex := Packet.Category;
  CreateEditMyRoom.CategoriesComboChange(Self);
  CreateEditMyRoom.SubCategoriesCombo.ItemIndex := Packet.SubCategory;
end;

procedure TMainForm.mJoinAsAdminClick(Sender: TObject);
begin
  JoinRoomAsAdminForm.ShowModal;
end;

procedure TMainForm.JoinRoomAsAdminByOwner(OwnerName, AdminCode: string);
var
  Packet: TOpenRoomAsAdminPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtOpenRoomAsAdmin;
  Packet.BufferSize := SizeOf(TOpenRoomAsAdminPacket);
  StrCopy(Packet.UserName,PChar(OwnerName));
  StrCopy(Packet.AdminCode,PChar(AdminCode));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TOpenRoomAsAdminPacket));
  SendBuffer(@Packet,SizeOf(TOpenRoomAsAdminPacket));
end;

procedure TMainForm.ProccesRegisterResultPacket(
  Packet: PRegisterResultPacket);
var
  Tmp: TNotifyEvent;
begin
  LoginProgressForm.Close;
  Tmp := LoginForm.OnShow;
  LoginForm.OnShow := nil;
  LoginForm.Show;
  LoginForm.OnShow := Tmp;
  if Packet.RegResult = 0 then
  begin
    ShowMessage('Your account created successfully.');
    LoginForm.UserNameCombo.Text := RegisterFrm.NickNameEdit.Text;
    LoginForm.PasswordUser := RegisterFrm.Password1Edit.Text;
    LoginForm.LoginButtonClick(Self);
  end
  else
  if Packet.RegResult = -1 then
  begin
    ShowMessage('Unknown error.');
  end
  else
  if Packet.RegResult = -2 then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    ShowMessage('The nickname you specified already exist please choose another nickname.');
    RegisterFrm.ActiveControl := RegisterFrm.NickNameEdit;
    RegisterLabelClick(Self);
  end
  else
  if Packet.RegResult = -3 then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    ShowMessage('Invalid char in nickname.');
    RegisterFrm.ActiveControl := RegisterFrm.NickNameEdit;
    RegisterLabelClick(Self);
  end;
  if Packet.RegResult = -4 then
  begin
    RegisterFrm.NickNameLabel.Font.Color := clRed;
    ShowMessage('Invalid nickname.');
    RegisterFrm.ActiveControl := RegisterFrm.NickNameEdit;
    RegisterLabelClick(Self);
  end;
end;

procedure TMainForm.ProccesOfflinesPacket(Packet: PCommunicatorPacket);
var
  OfflinesStr: string;
  i,j: Integer;
  TextSize: Integer;
  TmpOffline: PChar;
  TmpChar: Char;
begin
  OfflinesForm := TOfflinesForm.Create(Self);
  OfflinesStr := PChar(Cardinal(Packet)+SizeOf(TCommunicatorPacket));
  j := 0;
  while Length(OfflinesStr)>0 do
  begin
    i := Pos(',',OfflinesStr);
    OfflinesForm.OfflineSenders.Add(LeftStr(OfflinesStr,i-1));
    Delete(OfflinesStr,1,i);

    i := Pos(',',OfflinesStr);
    TmpChar := DecimalSeparator;
    DecimalSeparator := '.';
    OfflinesForm.OfflineList.Add(DateTimeToStr(StrToFloat(LeftStr(OfflinesStr,i-1))));
    DecimalSeparator := TmpChar;
    Delete(OfflinesStr,1,i);

    i := Pos(',',OfflinesStr);
    TextSize := StrToInt(LeftStr(OfflinesStr,i-1));
    GetMem(TmpOffline,TextSize+1);
    Delete(OfflinesStr,1,i);
    StrCopy(TmpOffline,PChar(LeftStr(OfflinesStr,TextSize)));
    OfflinesForm.OfflineList.Objects[j] := TObject(TmpOffline);
    Delete(OfflinesStr,1,TextSize+1);

    Inc(j);
  end;
  OfflinesForm.OfflinesStr := OfflinesStr;
  OfflinesForm.Show;
end;

procedure TMainForm.mExitHiChatterClick(Sender: TObject);
begin
  ReallyClose := True;
  Close;
end;

procedure TMainForm.TrayIconDblClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TrayIcon.ShowApplication;
end;

procedure TMainForm.tmShowHichatterClick(Sender: TObject);
begin
  TrayIcon.ShowApplication;
end;

procedure TMainForm.tmHideHiChatterClick(Sender: TObject);
begin
  TrayIcon.HideApplication;
end;

procedure TMainForm.SendVoicePacket(Buf: Pointer; Size: Integer);
begin
  if ActiveRoomWindow<>nil then
    ActiveRoomWindow.SendVoicePacket(Buf,Size);
end;

procedure TMainForm.SetActiveRoomWindow(const Value: TRoomWindow);
var
  i: Integer;
begin
  if (FActiveRoomWindow<>nil) and (FActiveRoomWindow<>Value) then
  begin
    FActiveRoomWindow.UserOnMic('');
    for i := 0 to 100 do
    begin
      //FActiveRoomWindow.PlayMeter. := 0;
      //FActiveRoomWindow.RecordMeter.Position := 0;
    end;
  end;
  FActiveRoomWindow := Value;
end;

function TMainForm.IamCurrentlyInRoom(RoomName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to RoomWindowList.Count - 1 do
    if TRoomWindow(RoomWindowList.Items[i]).Caption = RoomName then
    begin
      Result := True;
      Break;
    end;
end;

procedure TMainForm.AddAsFriend(UserName: string);
var
  Packet: TAddBuddyPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAddRequest;
  Packet.BufferSize := SizeOf(TAddBuddyPacket);
  StrCopy(Packet.UserName,PChar(UserName));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TAddBuddyPacket));
  SendBuffer(@Packet,SizeOf(TAddBuddyPacket));
end;


procedure TMainForm.BlockThisUser(UserName: string);
var
  Packet: TIgnorePacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtIgnoreList;
  Packet.BufferSize := SizeOf(TIgnorePacket);
  StrCopy(Packet.UserName,PChar(UserName));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TIgnorePacket));
  SendBuffer(@Packet,SizeOf(TIgnorePacket));
  IgnoreList.Add(UserName);
end;

procedure TMainForm.ApplicationEventsDeactivate(Sender: TObject);
var
  i: Integer;
begin
  if FProgramClosing then
    Exit;
  SmilesForm.Close;
  for i := 0 to RoomWindowList.Count - 1 do
    if not TRoomWindow(RoomWindowList.Items[i]).RoomClosing then
      TRoomWindow(RoomWindowList.Items[i]).FVolumeControlForm.Close;  // Attention: SomeTimes wehave exception here
end;

procedure TMainForm.OfficeXPThemeClick(Sender: TObject);
begin
  UnCheckAllThemes;
  TBXSwitcher1.Theme := 'OfficeXP';
  OfficeXPTheme.Checked := True;
end;

procedure TMainForm.AluminumThemeClick(Sender: TObject);
begin
  UnCheckAllThemes;
  TBXSwitcher1.Theme := 'Aluminum';
  AluminumTheme.Checked := True;
end;

procedure TMainForm.StripesThemeClick(Sender: TObject);
begin
  UnCheckAllThemes;
  TBXSwitcher1.Theme := 'Stripes';
  StripesTheme.Checked := True;
end;

procedure TMainForm.AthenThemeClick(Sender: TObject);
begin
  UnCheckAllThemes;
  TBXSwitcher1.Theme := 'Athen';
  AthenTheme.Checked := True;
end;

procedure TMainForm.MonaiThemeClick(Sender: TObject);
begin
  UnCheckAllThemes;
  TBXSwitcher1.Theme := 'Monai';
  MonaiTheme.Checked := True;
end;

procedure TMainForm.NexosXThemeClick(Sender: TObject);
begin
  UnCheckAllThemes;
  TBXSwitcher1.Theme := 'NexosX';
  NexosXTheme.Checked := True;
end;

procedure TMainForm.WhidbeyThemeClick(Sender: TObject);
begin
  UnCheckAllThemes;
  TBXSwitcher1.Theme := 'Whidbey';
  WhidbeyTheme.Checked := True;
end;

procedure TMainForm.UnCheckAllThemes;
begin
  AthenTheme.Checked             := False;
  MonaiTheme.Checked             := False;
  NexosXTheme.Checked            := False;
  WhidbeyTheme.Checked           := False;
  OfficeXPTheme.Checked          := False;
  AluminumTheme.Checked          := False;
  StripesTheme.Checked           := False;
end;

procedure TMainForm.PingTimerTimer(Sender: TObject);
var
  Packet: TCommunicatorPacket;
  Connected: Boolean;
begin
  //if ClientSocketThread.Connected and (MilliSecondsBetween(Now,ClientSocketThread.LastSentTime)>5000) then
  try
    Connected := TCPClient.Connected;
  except
    Connected := False;
  end;
  if Connected and (MilliSecondsBetween(Now,LastDataSentTime)>5000) then
  begin
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtPing;
    Packet.BufferSize := SizeOf(TCommunicatorPacket);
    //ClientSocketThread.SendBuffer(@Packet,SizeOf(TCommunicatorPacket));
    SendBuffer(@Packet,SizeOf(TCommunicatorPacket));
  end;
end;

procedure TMainForm.ShowMessageBoxAndClose(var Msg: TMessage);
begin
  PostMessage(Msg.WParam,WM_Close,0,0);
  Application.ProcessMessages;
  MessageBox(0,PChar(MessageBoxText),PChar(MessageBoxCaption),MB_OK);
end;

procedure TMainForm.HandleDisconnet(var msg: TMessage);
begin
  if not ForceUpdating then
  begin
    if LoginProgressForm.Showing then
      LoginProgressForm.Hide;
    MessageBox(Handle,'Disconnected from server.','Error',MB_OK);
    Application.Terminate;
  end;
end;

procedure TMainForm.LoadUserSetting;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  if Reg.OpenKey('\Software\Beyluxe Messenger\'+ MyNickName ,True) then
  begin
    if Reg.ValueExists('GroupFontBold') then
      FUserSetting.GroupBold := Reg.ReadBool('GroupFontBold');
    if Reg.ValueExists('GroupFontItalic') then
      FUserSetting.GroupItalic := Reg.ReadBool('GroupFontItalic');
    if Reg.ValueExists('GroupFontUnderLine') then
      FUserSetting.GroupUnderLine := Reg.ReadBool('GroupFontUnderLine');
    if Reg.ValueExists('GroupJoinNotify') then
      FUserSetting.GroupJoinNotify := Reg.ReadBool('GroupJoinNotify');
    if Reg.ValueExists('GroupLeftNotify') then
      FUserSetting.GroupLeftNotify := Reg.ReadBool('GroupLeftNotify');
    if Reg.ValueExists('GroupFontColor') then
      FUserSetting.GroupColor := Reg.ReadInteger('GroupFontColor');
    if Reg.ValueExists('GroupFontSize') then
      FUserSetting.GroupFontSize := Reg.ReadInteger('GroupFontSize');

    if Reg.ValueExists('PMFontBold') then
      FUserSetting.PMBold := Reg.ReadBool('PMFontBold');
    if Reg.ValueExists('PMFontItalic') then
      FUserSetting.PMItalic := Reg.ReadBool('PMFontItalic');
    if Reg.ValueExists('PMFontUnderLine') then
      FUserSetting.PMUnderLine := Reg.ReadBool('PMFontUnderLine');
    if Reg.ValueExists('PMFontColor') then
      FUserSetting.PMColor := Reg.ReadInteger('PMFontColor');
    if Reg.ValueExists('PMFontSize') then
      FUserSetting.PMFontSize := Reg.ReadInteger('PMFontSize');
  end;
  Reg.Free;
end;

procedure TMainForm.SaveUserSetting;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  if Reg.OpenKey('\Software\Beyluxe Messenger\'+ MyNickName ,True) then
  begin
    Reg.WriteBool('GroupFontBold',UserSetting.GroupBold);
    Reg.WriteBool('GroupFontItalic',UserSetting.GroupItalic);
    Reg.WriteBool('GroupFontUnderLine',UserSetting.GroupUnderLine);
    Reg.WriteBool('GroupJoinNotify',UserSetting.GroupJoinNotify);
    Reg.WriteBool('GroupLeftNotify',UserSetting.GroupLeftNotify);
    Reg.WriteInteger('GroupFontColor',UserSetting.GroupColor);
    Reg.WriteInteger('GroupFontSize',UserSetting.GroupFontSize);

    Reg.WriteBool('PMFontBold',UserSetting.PMBold);
    Reg.WriteBool('PMFontItalic',UserSetting.PMItalic);
    Reg.WriteBool('PMFontUnderLine',UserSetting.PMUnderLine);
    Reg.WriteInteger('PMFontColor',UserSetting.PMColor);
    Reg.WriteInteger('PMFontSize',UserSetting.PMFontSize);
  end;
  Reg.Free;
end;

procedure TMainForm.TBXItem1Click(Sender: TObject);
begin
  ManageCustomAwayMsgForm.Show;
end;

procedure TMainForm.LoadCustomAwayMessages;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.OpenKey('\Software\Beyluxe Messenger\'+ MyNickName +'\AwayMessages',True);
  Reg.GetKeyNames(CustomAwayMessages);
  Reg.CloseKey;
  Reg.Free;
end;

procedure TMainForm.LoadFavoriteRoomList;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.OpenKey('\Software\Beyluxe Messenger\' + MyNickName + '\FavoriteRooms',True);
  Reg.GetKeyNames(FavoriteRoomList);
  Reg.CloseKey;
  Reg.Free;
  MakeFavoriteRoomMenu
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PingTimer.Enabled := False;
  FProgramClosing := True;
  TBXSwitcher1.OnThemeChange := nil;
  ActiveRoomWindow := nil;
end;

procedure TMainForm.ProccessExactUserNamePacket(
  Packet: PExactUserNamePacket);
var
  tmpString: String;
begin
  MyNickName := Packet.UserName;
  MyPrivacy := Packet.Privacy;
  MySubscription := 5;
  MyPrivilege := 4;
  if MyPrivilege>2 then
    BrowseRoomsForm.pmCloseRoom.Visible := True;

  tmpString := MyNickName;
  if Length(MyNickName) > 10 then
    tmpString := Copy(MyNickName,1,15) + '...';
  UserLBL.Caption := tmpString;
  FAccountPreferences.PMAlowEveryOne := (MyPrivacy and 1)=0;
  FAccountPreferences.WhisperAlowEveryOne := (MyPrivacy and 2)=0;
  FAccountPreferences.InviteAlowEveryOne := (MyPrivacy and 4)=0;
  FAccountPreferences.FileTransferAlowEveryOne := (MyPrivacy and 8)=0;
  case MySubscription of
  0:
    begin
      ServiceNameLabel.Caption := 'Free' + ' ' + ServiceLabel.Caption;
      //BeyluxeLabel.Font.Color := clBlack;
      ServiceNameLabel.Font.Color := clBlack;
      ServiceLabel.Font.Color := clBlack;
      UserLBL.Font.Color := clBlack;
    end;
  1:
    begin
      ServiceNameLabel.Caption := 'Extra' + ' ' + ServiceLabel.Caption;
     //BeyluxeLabel.Font.Color := clBlue;
      ServiceNameLabel.Font.Color := clBlue;
      ServiceLabel.Font.Color := clBlue;
      UserLBL.Font.Color := clBlue;
    end;
  2:
    begin
      ServiceNameLabel.Caption := 'Deluxe' + ' ' + ServiceLabel.Caption;
      //BeyluxeLabel.Font.Color := clGreen;
      ServiceNameLabel.Font.Color := clGreen;
      ServiceLabel.Font.Color := clGreen;
      UserLBL.Font.Color := clGreen;
    end;
  3:
    begin
      ServiceNameLabel.Caption := 'VIP' + ' ' + ServiceLabel.Caption;
      //BeyluxeLabel.Font.Color := 16711833;
      ServiceNameLabel.Font.Color := 16711833;
      ServiceLabel.Font.Color := 16711833;
      UserLBL.Font.Color := 16711833;
    end;
  4:
    begin
      ServiceNameLabel.Caption := 'Gold' + ' ' + ServiceLabel.Caption;
      //BeyluxeLabel.Font.Color := 53471;
      ServiceNameLabel.Font.Color := 53471;
      ServiceLabel.Font.Color := 53471;
      UserLBL.Font.Color := 53471;
    end;
  5:
    begin
      ServiceNameLabel.Caption := 'VIP Plus' + ' ' + ServiceLabel.Caption;
      //BeyluxeLabel.Font.Color := $00C080FF;
      ServiceNameLabel.Font.Color := $00C080FF;
      ServiceLabel.Font.Color := $00C080FF;
      UserLBL.Font.Color := $00C080FF;
    end;
  end;

  if LoginForm.InvisibleLogin.Checked then
    StatusModeImage.ImageIndex := 0;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  //LoginForm.PasswordUser := EmptyStr;
  TBXSubmenuItem13.OnClick := CreatePrivateRoom1Click;
  TBXItem6.OnClick := TBXItem6Click;
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle,GWL_EXSTYLE) and not WS_EX_APPWINDOW or WS_EX_TOOLWINDOW);
end;

procedure TMainForm.ApplicationEventsMinimize(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TMainForm.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.cmdtype and $FFF0) of
    SC_MINIMIZE:
      begin
        ShowWindow( handle, SW_MINIMIZE );
        msg.result := 0;
      end;
    SC_RESTORE:
      begin
        ShowWindow( handle, SW_RESTORE );
        msg.result := 0;
      end;
    else
      inherited;
  end;
end;

procedure TMainForm.ApplicationEventsActivate(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TMainForm.TBXSubmenuItem14Click(Sender: TObject);
begin
  if PreferencesForm.Showing then Exit;
  PreferencesForm.Show;
  if MainForm.Left > 500 then
   PreferencesForm.Left := MainForm.Left - 300
  else
   PreferencesForm.Left := MainForm.Left + 100;

  PreferencesForm.ItemsListBox.ItemIndex := 0;
  PreferencesForm.ItemsListBoxClick(Self);
end;

procedure TMainForm.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
  ReallyClose := True;
  CloseFromLogin := True;
  Close;
  Message.Result := 1;
end;

procedure TMainForm.LoadSystemPreferences;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  if Reg.OpenKey('\Software\Beyluxe Messenger',True) then
  begin
    try
      FSystemPreferences.StartWithWindows := GetSystemStartup;;
      FSystemPreferences.OpenInNewBrowser := Reg.ReadBool('NewBrowser');
      FSystemPreferences.CloseWithCloseButton := Reg.ReadBool('Close');
      FSystemPreferences.AutoFontSaveForPM := Reg.ReadBool('AutoSavePMSetting');
      FSystemPreferences.AutoFontSaveForPM := Reg.ReadBool('AutoSaveRoomSetting');
      FSystemPreferences.ClearArchiveOnClose := Reg.ReadBool('ClearArchiveOnClose');
      FSystemPreferences.SaveMainWindowPos := Reg.ReadBool('SaveWindowPos');
      FSystemPreferences.AlertSoundsEnable := Reg.ReadBool('AlertSoundEnable');
      FSystemPreferences.AlertWhenInRoom := Reg.ReadBool('AlertWhenInRoom');
      FSystemPreferences.BuddyComesOnLineSnd := Reg.ReadString('BuddyComesOnLine');
      FSystemPreferences.BuddyGoesOfflineSnd := Reg.ReadString('BuddyGoesOffline');
      FSystemPreferences.AutoUnfreezScreen := Reg.ReadInteger('AutoUnfreez');
      FSystemPreferences.PMSnd := Reg.ReadString('PM');
      FSystemPreferences.BounceSnd := Reg.ReadString('Bounce');
      FSystemPreferences.InviteSnd := Reg.ReadString('Invite');
      FSystemPreferences.BuzzSnd := Reg.ReadString('Buzz');
      FSystemPreferences.PosX := Reg.ReadInteger('PosX');
      FSystemPreferences.PosY := Reg.ReadInteger('PosY');
      FSystemPreferences.Width := Reg.ReadInteger('Width');
      FSystemPreferences.Height := Reg.ReadInteger('Height');
      FSystemPreferences.myWebcamDeviceIndex := Reg.ReadInteger('WebcamDevice');
      FSystemPreferences.myWebcamMyCamSize := Reg.ReadInteger('MyWebcamSize');
      FSystemPreferences.myWebcamAlwayonTop := Reg.ReadBool('MyWebcamTop');
      FSystemPreferences.myWebcamAuto := Reg.ReadBool('MyWebcamAuto');
      FSystemPreferences.ViewWebcamOnTop := Reg.ReadBool('ViewWebcamonTop');
      FSystemPreferences.ViewWebcamSize := Reg.ReadInteger('ViewWebcamSize');
      FSystemPreferences.AudioSoundDeviceIndex := Reg.ReadInteger('AudioS');
      FSystemPreferences.AudioSoundCaptureDeviceIndex := Reg.ReadInteger('AudioC');
    except
      MakeDefaultPreferences;
    end;
  end;
  Reg.Free;
end;

procedure TMainForm.SaveSystemPreferences;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  if Reg.OpenKey('\Software\Beyluxe Messenger',True) then
  begin
    SetRunAtStartup(FSystemPreferences.StartWithWindows);
    Reg.WriteBool('NewBrowser',FSystemPreferences.OpenInNewBrowser);
    Reg.WriteBool('Close',FSystemPreferences.CloseWithCloseButton);
    Reg.WriteBool('AutoSavePMSetting',FSystemPreferences.AutoFontSaveForPM);
    Reg.WriteBool('AutoSaveRoomSetting',FSystemPreferences.AutoFontSaveForRoom);
    Reg.WriteBool('ClearArchiveOnClose',FSystemPreferences.ClearArchiveOnClose);
    Reg.WriteBool('SaveWindowPos',FSystemPreferences.SaveMainWindowPos);
    Reg.WriteBool('AlertSoundEnable',FSystemPreferences.AlertSoundsEnable);
    Reg.WriteBool('AlertWhenInRoom',FSystemPreferences.AlertWhenInRoom);
    Reg.WriteInteger('AutoUnfreez',FSystemPreferences.AutoUnfreezScreen);
    Reg.WriteString('BuddyComesOnLine',FSystemPreferences.BuddyComesOnLineSnd);
    Reg.WriteString('BuddyGoesOffline',FSystemPreferences.BuddyGoesOfflineSnd);
    Reg.WriteString('PM',FSystemPreferences.PMSnd);
    Reg.WriteString('Bounce',FSystemPreferences.BounceSnd);
    Reg.WriteString('Invite',FSystemPreferences.InviteSnd);
    Reg.WriteString('Buzz',FSystemPreferences.BuzzSnd);
    Reg.WriteInteger('PosX',FSystemPreferences.PosX);
    Reg.WriteInteger('PosY',FSystemPreferences.PosY);
    Reg.WriteInteger('Width',FSystemPreferences.Width);
    Reg.WriteInteger('Height',FSystemPreferences.Height);
    Reg.WriteInteger('WebcamDevice',FSystemPreferences.myWebcamDeviceIndex);
    Reg.WriteInteger('MyWebcamSize',FSystemPreferences.myWebcamMyCamSize);
    Reg.WriteBool('MyWebcamTop',FSystemPreferences.myWebcamAlwayonTop);
    Reg.WriteBool('MyWebcamAuto',FSystemPreferences.myWebcamAuto);
    Reg.WriteBool('ViewWebcamonTop',FSystemPreferences.ViewWebcamOnTop);
    Reg.WriteInteger('ViewWebcamSize',FSystemPreferences.ViewWebcamSize);
    Reg.WriteInteger('AudioS',FSystemPreferences.AudioSoundDeviceIndex);
    Reg.WriteInteger('AudioC',FSystemPreferences.AudioSoundCaptureDeviceIndex);
  end;
  Reg.Free;
end;

procedure TMainForm.SetRunAtStartup(Startup: Boolean);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false);
  if Startup then
    Registry.WriteString('BeyluxeMessenger', Application.ExeName)
  else
    Registry.DeleteValue('BeyluxeMessenger');
  Registry.CloseKey;
  Registry.free;
end;

function TMainForm.GetSystemStartup: Boolean;
var
  Registry: TRegistry;
  KeyNames: TStringList;
begin
  Registry := TRegistry.Create;
  KeyNames := TStringList.Create;
  Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',True);
  Registry.GetValueNames(KeyNames);
  if KeyNames.IndexOf('BeyluxeMessenger')>-1 then
    Result := True
  else
    Result := False;
  Registry.CloseKey;
  KeyNames.Free;
  Registry.Free;
end;

procedure TMainForm.MakeDefaultPreferences;
begin
  FSystemPreferences.StartWithWindows := True;
  FSystemPreferences.OpenInNewBrowser := True;
  FSystemPreferences.CloseWithCloseButton := False;
  FSystemPreferences.AutoFontSaveForPM := False;
  FSystemPreferences.AutoFontSaveForPM := False;
  FSystemPreferences.ClearArchiveOnClose := False;
  FSystemPreferences.SaveMainWindowPos := True;
  FSystemPreferences.AlertSoundsEnable := True;
  FSystemPreferences.AlertWhenInRoom := True;
  FSystemPreferences.BuddyComesOnLineSnd := ExtractFilePath(Application.ExeName)+'Sounds\Online.wav';
  FSystemPreferences.BuddyGoesOfflineSnd := ExtractFilePath(Application.ExeName)+'Sounds\Offline.wav';;
  FSystemPreferences.BounceSnd := ExtractFilePath(Application.ExeName)+'Sounds\Bounce.wav';;
  FSystemPreferences.InviteSnd := ExtractFilePath(Application.ExeName)+'Sounds\Invite.wav';;
  FSystemPreferences.BuzzSnd := ExtractFilePath(Application.ExeName)+'Sounds\Buzz.wav';;
  FSystemPreferences.PMSnd := ExtractFilePath(Application.ExeName)+'Sounds\PM.wav';;
  FSystemPreferences.PosX := Screen.Width - MainForm.Width - 10;
  FSystemPreferences.PosY := (Screen.Height - Height) div 2;
  FSystemPreferences.Width := MainForm.Width;
  FSystemPreferences.Height := MainForm.Height;
  FSystemPreferences.AutoUnfreezScreen := 20;
  FSystemPreferences.myWebcamDeviceIndex := 0;
  FSystemPreferences.myWebcamMyCamSize   := 0;
  FSystemPreferences.myWebcamAlwayonTop  := True;
  FSystemPreferences.myWebcamAuto        := False;
  FSystemPreferences.ViewWebcamOnTop     := True;
  FSystemPreferences.ViewWebcamSize      := 1;
  FSystemPreferences.AudioSoundDeviceIndex := 0;
  FSystemPreferences.AudioSoundCaptureDeviceIndex := 0;
  SaveSystemPreferences;
end;

procedure TMainForm.SetPrivacy;
var
  i: Integer;
  Packet: TSetPrivacyPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtSetPrivacyPacket;
  Packet.BufferSize := SizeOf(TSetPrivacyPacket);
  Packet.privacy := 0;
  if not FAccountPreferences.PMAlowEveryOne then
    Packet.privacy := Packet.privacy or 1;
  if not FAccountPreferences.WhisperAlowEveryOne then
    Packet.privacy := Packet.privacy or 2;
  if not FAccountPreferences.InviteAlowEveryOne then
    Packet.privacy := Packet.privacy or 4;
  if not FAccountPreferences.FileTransferAlowEveryOne then
    Packet.privacy := Packet.privacy or 8;
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TSetPrivacyPacket));
  SendBuffer(@Packet,SizeOf(TSetPrivacyPacket));
  for i := 0 to RoomWindowList.Count - 1 do
  begin
    TRoomWindow(RoomWindowList.Items[i]).SetPrivacy(Packet.privacy);
  end;
end;

function TMainForm.IsAnyPMActive: Boolean;
var
  i: Integer;
  ForeHwnd: HWND;
begin
  Result := False;
  ForeHwnd := GetForegroundWindow;
  for i := 0 to PMWindowList.Count - 1 do
    if TPMWindow(PMWindowList.Items[i]).Handle = ForeHwnd then
    begin
      Result := True;
      break;
    end;
end;

function TMainForm.ForceForgroundWindow1(hwnd: HWND): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;

var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end;

function TMainForm.CanPlayAlertSound: Boolean;
begin
  Result := FSystemPreferences.AlertSoundsEnable;
  if Result then
    if not FSystemPreferences.AlertWhenInRoom then
      Result := RoomWindowList.Count = 0;
end;

procedure TMainForm.TBXSubmenuItem15Click(Sender: TObject);
begin
  PreferencesForm.Show;
  PreferencesForm.ItemsListBox.ItemIndex := 3;
  PreferencesForm.ItemsListBoxClick(Self);
end;

procedure TMainForm.LoadImageList;
var
  i: Integer;
  Bitmap: TBitmap;
  Stream: TStream;
  Item: TMenuItem;
begin
  FSmileImageList.Height := 24;
  FSmileImageList.Width := 24;
  for i := 0 to 90 do
  begin
    Item := TMenuItem.Create(Self);
    Item.Tag := i;
    Item.OnClick := OnSmilesClick;
    Item.OnDrawItem := OnSmileMenuDrawItem;
    Item.OnMeasureItem := OnSmileMenuMisureItem;
    if (i<>0) and (i mod 7 =0) then
      Item.Break := mbBreak;
    SmilePOPUP.Items.Add(Item);
    Bitmap := TBitmap.Create;
    Stream := TStream(MainForm.SmilesBMPStreamList.Items[i]);
    //Bitmap.Height := 24;
    //Bitmap.Width := 24;
    Stream.Position := 0;
    Bitmap.LoadFromStream(Stream);
    //Bitmap.SaveToFile('c:\1\'+IntToStr(i)+'.bmp');
    FSmileImageList.Add(Bitmap,Bitmap);
    Bitmap.Free;
    //TmpGifImage.Free;
  end;
end;

procedure TMainForm.OnSmilesClick(Sender: Tobject);
begin
  if ActiveRichEdit<>nil then
    ActiveRichEdit.SelText := SmilesForm.SmileStrList.Strings[TMenuItem(Sender).tag];
end;

procedure TMainForm.OnSmileMenuDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
begin
  if Selected then
    ACanvas.Brush.Color := clHighlight
  else
    ACanvas.Brush.Color := clMenu;

  ACanvas.FillRect(ARect);
  FSmileImageList.Draw(ACanvas,ARect.Left+2,ARect.Top,(Sender as TMenuItem).Tag);
end;

procedure TMainForm.OnSmileMenuMisureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
begin
  Width := 16;
  Height := 24;
end;

procedure TMainForm.IdTCPClient1Disconnected(Sender: TObject);
begin
//
end;

procedure TMainForm.TBXSwitcher1ThemeChange(Sender: TObject);
var
  i: Integer;
begin
{
  if TBXSwitcher1.Theme = 'Whidbey' then
    MenuBarColor := clSkyBlue
  else
    MenuBarColor := clBtnFace;
  Menubar.Color := MenuBarColor;
  PreferencesForm.Repaint;
  for i := 0 to RoomWindowList.Count-1 do
    TRoomWindow(RoomWindowList.Items[i]).Menubar.Color := MenuBarColor;
  for i := 0 to PMWindowList.Count-1 do
    TPMWindow(PMWindowList.Items[i]).Menubar.Color := MenuBarColor;
}
  if TBXSwitcher1.Theme = 'Whidbey' then
    SplitterColor := clSkyBlue
  else
  if TBXSwitcher1.Theme = 'Aluminum' then
    SplitterColor := clSilver
  else
    SplitterColor := clBtnFace;
  for i := 0 to RoomWindowList.Count-1 do
    TRoomWindow(RoomWindowList.Items[i]).Color := SplitterColor;
end;

procedure TMainForm.SendBuffer(Packet: Pointer; Size: Integer);
var
  LocalBuffer: Pointer;
begin
  {
  if Size = 0 then Exit;
  GetMem(LocalBuffer,Size);
  CopyMemory(LocalBuffer,Packet,Size);
  OutputBufferList.Add(LocalBuffer);
  }
  if Size = 0 then
    Exit;
  GetMem(LocalBuffer,Size);
  CopyMemory(LocalBuffer,Packet,Size);
  MainClientThread.OutputCriticalSection.Enter;
  MainClientThread.OutputBufferList.Add(LocalBuffer);
  MainClientThread.OutputCriticalSection.Leave;
end;

procedure TMainForm.OnCloseCamViewerForm(Viewer: TObject);
begin
  FWebcamWindowList.Remove(Viewer)
end;

function TMainForm.RunningInsideVPC: boolean; assembler;
asm
  push ebp

  mov  ecx, offset @@exception_handler
  mov  ebp, esp

  push ebx
  push ecx
  push dword ptr fs:[0]
  mov  dword ptr fs:[0], esp

  mov  ebx, 0 // flag
  mov  eax, 1 // VPC function number

  // call VPC
  db 00Fh, 03Fh, 007h, 00Bh

  mov eax, dword ptr ss:[esp]
  mov dword ptr fs:[0], eax
  add esp, 8

  test ebx, ebx
  setz al
  lea esp, dword ptr ss:[ebp-4]
  mov ebx, dword ptr ss:[esp]
  mov ebp, dword ptr ss:[esp+4]
  add esp, 8
  jmp @@ret
  @@exception_handler:
  mov ecx, [esp+0Ch]
  mov dword ptr [ecx+0A4h], -1 // EBX = -1 -> not running, ebx = 0 -> running
  add dword ptr [ecx+0B8h], 4 // -> skip past the detection code
  xor eax, eax // exception is handled
  ret
  @@ret:
end;

function TMainForm.IsVMwarePresent: LongBool; stdcall;  // platform;
begin
  Result := False;
 {$IFDEF CPU386}
  try
    asm
      mov     eax, 564D5868h
      mov     ebx, 00000000h
      mov     ecx, 0000000Ah
      mov     edx, 00005658h
      in      eax, dx
      cmp     ebx, 564D5868h
      jne     @@exit
      mov     Result, True
    @@exit:
    end;
  except
    Result := False;
  end;
  {$ENDIF}
end;

procedure TMainForm.InputReady(var msg: TMessage);
var
  Buffer: Pointer;
begin
  MainClientThread.InputCriticalSection.Enter;
  Buffer := TMainClientThread(MainClientThread).InputBufferList.Items[0];
  MainClientThread.InputBufferList.Delete(0);
  MainClientThread.InputCriticalSection.Leave;
  ExecutePacket(Buffer);
  FreeMem(Buffer);
end;


function TMainForm.GetTempDir: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  Result := StrPas(Buffer);
end;

function TMainForm.CreateTempFileName: string;
// Creates a temporal file and returns its path name
var
  TempFileName: array [0..MAX_PATH-1] of char;
begin
  GetTempFileName(PChar(GetTempDir), '~', 0, TempFileName);
  Result := TempFileName;
end;

{
function TWebcamSession.RandomStr: string;
var
  i: Integer;
  Chr: Byte;
  Str: string;
begin
  Randomize;
  for i := 1 to 15 do
  begin
    Chr := RandomRange(65,115);
    if Chr>90 then
      Inc(Chr,7);
    Str := Str + Char(Chr);
  end;
  Result := Str;
end;
}

procedure TMainForm.ChangePassword(SecretAnswer, OldPassword,
  NewPassword: string);
var
  Packet: TChangePasswordPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtChangePassword;
  Packet.BufferSize := SizeOf(TChangePasswordPacket);
  StrCopy(Packet.OldPassword,PChar(OldPassword));
  StrCopy(Packet.NewPassword,PChar(NewPassword));
  StrCopy(Packet.SecretAnswer,PChar(SecretAnswer));
  SendBuffer(@Packet,SizeOf(TChangePasswordPacket));
end;

procedure TMainForm.TBXItem2Click(Sender: TObject);
begin
  ChangePasswordForm.Show;
end;

procedure TMainForm.ProcessSessionIDAndSeedPacket(
  Packet: PSessionIDAndSeedPacket);
var
  i,j: Integer;
  PL,SL: Integer;
  Str: string;
  TmpSeed,TmpPass: string;
  ResStr: string;
  MyPacket: PPasswordPacket;
  Size: Integer;
  Password: string;
begin
  if FRegistring then
    Password := RegisterFrm.Password1Edit.Text
  else
    Password := LoginForm.PasswordUser;
  FSessionID := Packet.SessionID;
  FOSInstallTimeValue := FOSInstallTimeValue xor FSessionID;
  FSeed := PChar(Cardinal(Packet)+SizeOf(TSessionIDAndSeedPacket));
  TmpPass := Password;
  TmpSeed := FSeed;
  PL := Length(TmpPass);
  SL := Length(TmpSeed);
  J := Min(PL,SL);
  Str := '';
  for i := 0 to j-1 do
  begin
    Str := Str + TmpPass[1];
    Delete(TmpPass,1,1);
    Str := Str + TmpSeed[1];
    Delete(TmpSeed,1,1);
  end;
  PostMessage(Handle,WCM_PrepareHDDSerialPacket,0,0);
  if PL<SL then
    Str := Str + TmpSeed
  else
  if SL<PL then
    Str := Str + TmpPass;
  j := Length(Str);
  SL := FSessionID xor (PCardinal(@FSeed[1])^);
  RandSeed := (SL mod 4) + 20;
  ResStr := '';
  //ResStr[1] := PassWordLookupTable[Length(LoginForm.PasswordEdit.Text)];
  ResStr := IntToStr(100+Length(Password)+Integer(FSessionID and $FF));
  for i := 1 to j do
    ResStr := ResStr+IntToStr(RandomRange(1,8)*100+Pos(Str[i],PassWordLookupTable));
  Size := SizeOf(TPasswordPacket)+Length(ResStr)+1;
  GetMem(MyPacket,Size);
  ZeroMemory(MyPacket,Size);
  MyPacket.Signature := PACKET_SIGNATURE;
  MyPacket.Version := PACKET_VERSION;
  MyPacket.DataType := pdtPasswordPacket;
  MyPacket.BufferSize := Size;
  StrCopy(Pointer(Cardinal(MyPacket)+SizeOf(TPasswordPacket)),PChar(ResStr));
  MyPacket.HWID := 0; //GetHardwareID;
  SendBuffer(MyPacket,Size);
  FreeMem(MyPacket);
end;

procedure TMainForm.PrepareHDDSerialPacket(var Msg: TMessage);
var
  i: Integer;
  ResStr: string;
  TmpStrList: TStringList;
  IDEInfo: TIDEInfo;
begin
  {$I crypt_start.inc}
  GetMem(TmpHDDPacket,1024);
  ZeroMemory(TmpHDDPacket,1024);
  TmpHDDPacket.Signature := PACKET_SIGNATURE;
  FIDESerial := GetIdeSN;
  TmpHDDPacket.Version := PACKET_VERSION;
  //FIDESerial := TmpRandomStr(13);
  if FIDESerial='' then
  begin
    DirectIdentify(IDEInfo);
    FIDESerial := IDEInfo.SerialNumber;
  end;
  TmpHDDPacket.DataType := pdtHDDSerialPacket;

  //Virtual PC
  if RunningInsideVPC then
  begin
    TmpStrList := TStringList.Create;
    TmpStrList.CommaText := VirtualPCStr;
    FIDESerial := '';
    for i := 1 to TmpStrList.Count do
      FIDESerial := FIDESerial + Char(StrToInt(TmpStrList.Strings[i-1]));
    TmpStrList.Free;
  end
  else
  if IsVMwarePresent then
  begin
    TmpStrList := TStringList.Create;
    TmpStrList.CommaText := VMWareStr;
    FIDESerial := '';
    for i := 1 to TmpStrList.Count do
      FIDESerial := FIDESerial + Char(StrToInt(TmpStrList.Strings[i-1])+40);
    TmpStrList.Free;
  end;

  PostMessage(Handle,WCM_PrepareAdditionalInfoPacket,0,0);
  ResStr := '';
  for i := 1 to Length(FIDESerial) do
    ResStr := ResStr + IntToStr(Byte(FIDESerial[i])+Byte(FSeed[i]));
  StrCopy(Pointer(Cardinal(TmpHDDPacket)+SizeOf(THDDSerialPacket)),PChar(ResStr));
  TmpHDDPacket.BufferSize := SizeOf(THDDSerialPacket)+Length(ResStr)+1;
  AddChecksum1(TmpHDDPacket,TmpHDDPacket.BufferSize);
  {$I crypt_end.inc}
end;

procedure TMainForm.ProcessHDDSerialPacket(Packet: PHDDSerialPacket);
begin
  SendBuffer(TmpHDDPacket,TmpHDDPacket.BufferSize);
  FreeMem(TmpHDDPacket);
end;

procedure TMainForm.PrepareVolumeSerialPacket(var Msg: TMessage);
var
  i,j: Integer;
  Drive: string;
  Buf: array [0..512] of char;
  SerialStr: string;
  PacketSerialStr: string;
  Size: Integer;
  TmpStrList: TStringList;
  TmpStr: string;
begin
  TmpStr := '';
  GetWindowsDirectory(Buf,512);
  Drive := LeftStr(ExtractFileDrive(Buf),1);
  SerialStr := GetVolumeSerialNumber(Drive);

  PacketSerialStr := '';
  j := Length(SerialStr);
  TmpStrList := TStringList.Create;
  for i := 0 to j-1 do
    TmpStrList.Add(IntToStr(Pos(SerialStr[i+1],PassWordLookupTable)));
  SerialStr := TmpStrList.CommaText;
  TmpStrList.Free;
  PostMessage(Handle,WCM_ReadMacAddressList,0,0);
  Size := SizeOf(TVolumeSerialPacket)+Length(SerialStr)+1;
  GetMem(TmpVolumePacket,90);
  ZeroMemory(TmpVolumePacket,Size);
  TmpVolumePacket.Signature := PACKET_SIGNATURE;
  TmpVolumePacket.Version := PACKET_VERSION;
  TmpVolumePacket.DataType := pdtVolumeSerialPacket;
  TmpVolumePacket.BufferSize := Size;
  TmpVolumePacket.OSInstallTime := FOSInstallTimeValue;
  TmpVolumePacket.FirstVersionWord := FirstVersionWord;
  TmpVolumePacket.SecondVersionWord := SecondVersionWord;
  TmpVolumePacket.ThirdVersionWord := ThirdVersionWord;
  TmpVolumePacket.fourthVersionWord := fourthVersionWord;
  //////////// checking for HWID ///////////////////
  if UniqueHWID='' then
  begin
    if CheckForFirstHWIDAvailability(TmpStr) then
    begin
      WriteMainUniqueID(TmpStr);
      UniqueHWID := TmpStr;
    end
    else
    if CheckForSecondHWIDAvailability(TmpStr) then
    begin
      WriteMainUniqueID(TmpStr);
      UniqueHWID := TmpStr;
      TmpStr := CryptIDMethod1(TmpStr);
      WriteFirstUniqueID(TmpStr);
    end
    else
    begin
      TmpStr := MakeUniqueID;
      WriteMainUniqueID(TmpStr);
      TmpStr := CryptIDMethod1(TmpStr);
      WriteFirstUniqueID(TmpStr);
      TmpStr := DecryptIDMethod1(TmpStr);
      TmpStr := CryptIDMethod2(TmpStr);
      WriteSecondUniqueID(TmpStr);
      UniqueHWID := DecryptIDMethod2(TmpStr);
    end;
  end;

  StrCopy(TmpVolumePacket.UniqueID,PChar(UniqueHWID));
  StrCopy(Pointer(Cardinal(TmpVolumePacket)+SizeOf(TVolumeSerialPacket)),PChar(SerialStr));
  AddChecksum2(TmpVolumePacket,TmpVolumePacket.BufferSize);
end;

procedure TMainForm.ProcessVolumeSerialPacket(Packet: PVolumeSerialPacket);
begin
  SendBuffer(TmpVolumePacket,TmpVolumePacket.BufferSize);
  FreeMem(TmpVolumePacket);
end;

procedure TMainForm.ReadOSInstallTime(var Msg: TMessage);
var
  i: Integer;
  TmpStrList: TStringList;
  Reg: TRegistry;
  RegAddress: string;
begin
  TmpStrList := TStringList.Create;
  TmpStrList.CommaText := RegOSInstallTimeStr;
  RegAddress := '';
  for i := 1 to TmpStrList.Count do
    RegAddress := RegAddress + Char(StrToInt(TmpStrList.Strings[i-1]));
  TmpStrList.Free;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.KeyExists(RegAddress) then
  begin
    Reg.OpenKey(RegAddress,False);
    //DateTimeToStr(UnixToDateTime(Reg.ReadInteger('InstallDate')));
    if Reg.ValueExists('InstallDate') then
      FOSInstallTimeValue := Cardinal(Reg.ReadInteger('InstallDate'))
    else
      FOSInstallTimeValue := 0;
    Reg.CloseKey;
  end
  else
    FOSInstallTimeValue := 0;
  Reg.Free;
end;

procedure TMainForm.ReadMacAddressList(var Msg: TMessage);
var
  i: Integer;
  Size: Integer;
  TmpList: TStringList;
  TmpList2: TStringList;
  MacList: string;
  VersionStr: string;
  ResStr: string;
begin
  TmpList := TStringList.Create;
  GetMacAddresses('',TmpList);
  MacList := TmpList.CommaText;
  TmpList.Free;
  VersionStr := GetWindowsVersionString;
  TmpList2 := TStringList.Create;
  TmpList2.Add(MacList);
  TmpList2.Add(VersionStr);
  ResStr := TmpList2.CommaText;
  TmpList2.Free;
  for i := 1 to Length(ResStr) do
  begin
    ResStr[i] := PassWordLookupTable[Pos(ResStr[i],RealTable)];
  end;
  Size := SizeOf(TMacListPacket) + Length(ResStr) + 1;
  GetMem(TmpMacListPacket,Size);
  TmpMacListPacket.Signature := PACKET_SIGNATURE;
  TmpMacListPacket.Version := PACKET_VERSION;
  TmpMacListPacket.DataType := pdtMacListPacket;
  TmpMacListPacket.BufferSize := Size;
  StrCopy(Pointer(Cardinal(TmpMacListPacket)+SizeOf(TMacListPacket)),PChar(ResStr));
  AddChecksum3(TmpMacListPacket,TmpMacListPacket.BufferSize);
end;

procedure TMainForm.ProcessMacListPacket(Packet: PMacListPacket);
begin
  SendBuffer(TmpMacListPacket,TmpMacListPacket.BufferSize);
  FreeMem(TmpMacListPacket);
end;

procedure TMainForm.AddChecksum1(Packet: Pointer; Size: Integer);
var
  i: Integer;
  Sum: Cardinal;
begin
  Sum := 0;
  for i := Sizeof(TCommunicatorPacket)+4 to PCommunicatorPacket(Packet).BufferSize - 1 do
    Sum := Sum xor Byte(PByteArray(Packet)[i]);
  Sum := Sum + 1978;
  Sum := Sum xor $B26A729D8 xor FSessionID;
  PDWORD(Cardinal(Packet)+SizeOf(TCommunicatorPacket))^ := Sum;
end;


procedure TMainForm.AddChecksum2(Packet: Pointer; Size: Integer);
var
  i: Integer;
  Sum: Cardinal;
begin
  Sum := 0;
  for i := Sizeof(TCommunicatorPacket)+4 to PCommunicatorPacket(Packet).BufferSize - 1 do
    Sum := Sum xor Byte(PByteArray(Packet)[i]);
  Sum := Sum + 192576;
  Sum := Sum xor $12012572 xor FSessionID;
  PDWORD(Cardinal(Packet)+SizeOf(TCommunicatorPacket))^ := Sum;
end;

procedure TMainForm.AddChecksum3(Packet: Pointer; Size: Integer);
var
  i: Integer;
  Sum: Cardinal;
begin
  Sum := 0;
  for i := Sizeof(TCommunicatorPacket)+4 to PCommunicatorPacket(Packet).BufferSize - 1 do
    Sum := Sum xor Byte(PByteArray(Packet)[i]);
  Sum := Sum + FSessionID;
  Sum := Sum xor 100000000;
  PDWORD(Cardinal(Packet)+SizeOf(TCommunicatorPacket))^ := Sum;
end;

procedure TMainForm.AddChecksum4(Packet: Pointer; Size: Integer);
var
  i: Integer;
  Sum: Cardinal;
begin
  Sum := 0;
  for i := Sizeof(TCommunicatorPacket)+4 to PCommunicatorPacket(Packet).BufferSize - 1 do
    Sum := Sum + Byte(PByteArray(Packet)[i]);
  Sum := Sum + 463289715;
  Sum := Sum xor FSessionID;
  PDWORD(Cardinal(Packet)+SizeOf(TCommunicatorPacket))^ := Sum
end;

procedure TMainForm.ProcessBuddyAddedPacket(Packet: PCommunicatorPacket);
var
  Username: string;
begin
  Username := PChar(Pointer(Cardinal(Packet)+SizeOf(TCommunicatorPacket)));
  OffLineFriendList.Add(Username,'',0);
  AddBuddyToListView(Username);
end;

procedure TMainForm.ProcessBuddyRemovedPacket(Packet: PCommunicatorPacket);
var
  Username: string;
begin
  Username := PChar(Pointer(Cardinal(Packet)+SizeOf(TCommunicatorPacket)));
  OnLineFriendList.Remove(OnLineFriendList.IndexOf[Username]);
  OffLineFriendList.Remove(OffLineFriendList.IndexOf[Username]);
  RemoveBuddyFromListView(Username);
end;

procedure TMainForm.NotifyUserStatus(Username: string; Online: Boolean);
var
  Str: string;
  Rect: TRect;
  ForegoroundHWND: THandle;
begin
  if Online then
  begin
    Str := Username + ' comes online';
    MiniNotifyForm.OnlineImage.BringToFront;
    if CanPlayAlertSound then
      PlaySound(PChar(FSystemPreferences.BuddyComesOnLineSnd),0,SND_FILENAME or SND_ASYNC);
  end
  else
  begin
    Str := Username + ' goes offline';
    MiniNotifyForm.OfflineImage.BringToFront;
    if CanPlayAlertSound then
      PlaySound(PChar(FSystemPreferences.BuddyGoesOfflineSnd),0,SND_FILENAME or SND_ASYNC);
  end;
  SystemParametersInfo(SPI_GETWORKAREA,0,@Rect,0);
  MiniNotifyForm.Width := MiniNotifyForm.Label1.Canvas.TextWidth(Str) + 31 + 12;
  MiniNotifyForm.Label1.Caption := Str;
  MiniNotifyForm.Left := Rect.Right - MiniNotifyForm.Width;
  MiniNotifyForm.Top := Rect.Bottom - MiniNotifyForm.Height;
  ForegoroundHWND := GetForegroundWindow;
  MiniNotifyForm.Show;
  SetForegroundWindow(ForegoroundHWND);
end;

function TMainForm.DownloadURL(AUrl, TargetFileName: PChar): Boolean;
const
  BUFFERSIZE = 4096;
var
  FileStream: TFileStream;
  hSession: HINTERNET;
  hService: HINTERNET;
  lpBuffer: array[0..BufferSize + 1] of Byte;
  BufferLength: DWORD;
  dwSizeOfRq , Reserved, dwByteToRead: DWORD;
  dwFileSize: DWORD;
  dwFlag: Cardinal;
begin
  Result := False;
  UpdateForm.Show;
  { Initialize the Win32 Internet functions. }
  hSession := InternetOpen(PChar(Application.Title),INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  { See if the session handle is valid }
  if hSession = nil then
  begin
    ShowMessage('Internet session initialization failed!');
    Exit;
  end;
  { opens a handle to the Internet file using a URL.}
  dwFlag := INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_PRAGMA_NOCACHE or INTERNET_FLAG_RELOAD;
  {flags indicate that the file will always be read from the Internet rather than the cache.}
  hService := InternetOpenUrl(hSession,PChar(AUrl),nil,0,dwFlag,0);
  { See if the session handle is valid }
   if hSession = nil then
   begin
     ShowMessage('Internet session initialization failed!');
     InternetCloseHandle(hService);
     UpdateForm.Close;
     Exit;
   end;
  HttpQueryInfo(hService, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @dwByteToRead,
        dwSizeOfRq , Reserved);
  { if dwByteToRead >= HTTP_STATUS_AMBIGUOUS then
  begin
    InternetCloseHandle(hService);
    ShowMessage('STATUS CODE : ' + IntToStr(filesize));
    Exit;
  end;   }
  try
    FileStream := TFileStream.Create(TargetFileName,fmCreate);
  except
    ShowMessage('Cannot create local file');
    InternetCloseHandle(hService);
    UpdateForm.Close;
    Exit;
  end;
  BufferLength := BUFFERSIZE;

  // These three variables will store the size of the file,
  //  the size of the HttpQueryInfo content, and the number of bytes read in total,

  // determine the length of a file in bytes.

  dwByteToRead := 0;
  dwSizeOfRq  := 4; // BufferLength
  Reserved := 0;
  {
    With this call, an attempt is made to get the file's size.
    If the attempt fails, the dwByteToRead variable is set to 0,
    and no percentage or total size is displayed when the file is downloaded.
  }
  dwFlag := HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER;
  if not HttpQueryInfo(hService,dwFlag,@dwByteToRead,dwSizeOfRq,Reserved) then
    dwByteToRead := 0;
  dwFileSize := 0;
  BufferLength := BUFFERSIZE;
  while (BufferLength > 0) do
  begin
    if not InternetReadFile(hService, @lpBuffer, BUFFERSIZE, BufferLength) then Break;
    if (BufferLength > 0) and (BufferLength <= BUFFERSIZE) then
      FileStream.Write(lpBuffer, BufferLength);
    dwFileSize := dwFileSize + BufferLength;
    MainForm.OnDownLoadProgress(Round(100 * dwFileSize / dwByteToRead));
    Application.ProcessMessages;
    if CancelDownload then
      Break;
  end; {while}
  FileStream.Free;
  if CancelDownload then
  begin
    DeleteFile(TargetFileName);
    Result := False
  end
  else
    Result := True;
  // Close the Internet handle that the application has opened.
  InternetCloseHandle(hService);
  InternetCloseHandle(hSession);
  if not CancelDownload and (dwFileSize=dwByteToRead) then
  begin
    Result := True;
    // unzip it in program folder and run
    //UnzipFile()
  end;
  UpdateForm.Close;
  CancelDownload := False;
end;

procedure TMainForm.OnDownloadProgress(Progress: Integer);
begin
  UpdateForm.Gauge1.Progress := Progress;
  Application.ProcessMessages;
end;

procedure TMainForm.CancelButtonClick(Sender: TObject);
begin
  CancelDownload := True;
end;

procedure TMainForm.ProcessUpdateAvailablePacket(
  Packet: PUpdatePacket);
var
  Res: Integer;
  UpdateUrl: string;
  AppPath: string;
begin
  UpdateUrl := PChar(Cardinal(Packet)+SizeOf(TUpdatePacket));
  AppPath := ExtractFilePath(Application.ExeName);
  if Packet.ForceUpdate then
  begin
    LoginProgressForm.Close;
    ForceUpdating := True;
    Res := MessageBox(Handle,'The Client that you are using is outdated and no longer can be used to login. Press Ok for Update or Cancel to Close Program.','Update Confirm',MB_OKCANCEL);
    if Res =ID_CANCEL then
    begin
      // Close The Application
      ReallyClose := True;
      CloseFromLogin := True;
      Close;
    end
    else
    begin
      // Start Download for update
      if DownloadURL(PChar(UpdateUrl),PChar(ExtractFilePath(Application.ExeName)+'Update.exe')) then
      begin
        //UnzipFile(PChar(AppPath+'Update.zip'),PChar(AppPath+'Update.exe'),0,0,0);
        ShellExecute(0,'open',PChar(AppPath+'Update.exe'),'',PChar(AppPath),SW_SHOW);
        Halt;
      end;
      //  UpdateProgram;
    end
  end
  else
  begin
    Res := MessageBox(Handle,'An update available. Press Ok for Update or Cancel to Continue.','Update Confirm',MB_OKCANCEL);
    if Res =ID_CANCEL then
    begin
      // Just Exit To Continue Application...
    end
    else
    begin
      // Start Download for update
      if DownloadURL(PChar(UpdateUrl),PChar(ExtractFilePath(Application.ExeName)+'Update.exe')) then
      begin
        //UnzipFile(PChar(AppPath+'Update.zip'),PChar(AppPath+'Update.exe'),0,0,0);
        ShellExecute(0,'open',PChar(AppPath+'Update.exe'),'',PChar(AppPath),SW_SHOW);
        Halt;
      end;
      //  UpdateProgram;
    end
  end;
end;

function TMainForm.CreateBatFileForUpdateProcess(
  var FileName: string): Boolean;
var
  StrList: TStringList;
  AppPath: string;
begin
  Result := True;
  AppPath := ExtractFilePath(Application.ExeName);
  FileName := CreateTempFileName+'.bat';
  StrList := TStringList.Create;
  //StrList.Add('pause');
  StrList.Add(':Repeat');
  StrList.Add('del "'+Application.ExeName+'"');
  //StrList.Add('pause');
  StrList.Add('if exist "'+Application.ExeName+'" goto Repeat');
  //StrList.Add('pause');
  StrList.Add('ren "'+AppPath+'Update.tmp" "Beyluxe Messenger.exe"');
  //StrList.Add('pause');
  StrList.Add('del "'+AppPath+'Update.zip"');
  //StrList.Add('pause');
  StrList.Add(ExtractFileDrive(Application.ExeName));
  //StrList.Add('pause');
  StrList.Add('cd '+AppPath);
  //StrList.Add('pause');
  StrList.Add('"Beyluxe Messenger.exe"');
  //StrList.Add('pause');
  StrList.Add('exit');
  StrList.SaveToFile(FileName);
  StrList.Free;
end;

procedure TMainForm.UpdateProgram;
var
  AppPath: string;
  BatFileName: string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  //UnzipFile(PChar(AppPath+'Update.zip'),PChar(AppPath+'Update.tmp'),0,0,0);
  ReallyClose := True;
  CloseFromLogin := True;
  CreateBatFileForUpdateProcess(BatFileName);
  ShellExecute(0, 'open', PChar(BatFileName), nil, nil, SW_SHOWNORMAL);
  Close;
end;

procedure TMainForm.SetStatusInPM(PM: TPMWindow);
var
  HTMLText: string;
  Index: Integer;
begin
  Index := OnLineFriendList.IndexOf[PM.BuddyName];
  HTMLText := '<Table width=100% bgcolor=#E8E8E8><TR><TD><font size=1><B>';
  if Index>-1 then
  begin
    case OnLineFriendList.Icons[Index] of
      0:
      begin
        HTMLText := HTMLText + Pm.BuddyName + ' Appear to be <I>Offline</I> and will recieve your messages after login';
      end;
      1:
      begin
        HTMLText := HTMLText + Pm.BuddyName + ' is <I>Online</I>';
      end;
      3:
      begin
        HTMLText := HTMLText + Pm.BuddyName + ' is Away';
      end
      else
        HTMLText := HTMLText + Pm.BuddyName + ' Status is <I>'+TFriendListSubClassInfo(OnLineFriendList.FirendList.Objects[Index]).StatusStr+'</I>';
    end;
    //HTMLText := Pm.BuddyName + ' is';
  end
  else
  if OffLineFriendList.IndexOf[PM.BuddyName]>-1 then
  begin
    HTMLText := HTMLText + Pm.BuddyName + ' Appear to be <I>Offline</I> and will recieve your messages after login';
  end
  else
    HTMLText := HTMLText + Pm.BuddyName + ' is not on your contact list';
  HTMLText := HTMLText + '</B></font></TD></TR></table>';
  HTMLText := CorrectHTMLCode(HTMLText);
  HTMLText := PM.ReplaceSmilesText(HTMLText);
  HTMLText := CorrectHTMLLinks(HTMLText);
  //PM.Viewer.LoadTextFromString(HTMLText);
  PM.AppendToWB(PM.Viewer, HTMLText);
  {PM.Viewer.LoadString(HTMLText, '', HTMLType);
  PM.Viewer.VScrollBarPosition := PM.Viewer.VScrollBar.Max;  }
  PM.Viewer.Invalidate;
end;

procedure TMainForm.CloseRoomRequest(RoomName,LockCode: string);
var
  Packet: TCloseRoomReqPacket;
begin
  ZeroMemory(@Packet,SizeOf(TCloseRoomReqPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtCloseRoomPacket;
  Packet.BufferSize := SizeOf(TCloseRoomReqPacket);
  StrCopy(Packet.RoomName,PChar(RoomName));
  //ClientSocketThread.SendBuffer(@Packet,SizeOf(TRoomInfoReqPacket));
  SendBuffer(@Packet,SizeOf(TCloseRoomReqPacket));
end;

procedure TMainForm.ProccessGrabPCInfoPacket(Packet: PGrabPCInfoPacket);
var
  TmpStr: string;
  TmpStrList: TStringList;
  PMPacket: TPMPacket;
  ResultStr: string;
  MyHandle: THandle;
  Struct: TProcessEntry32;
begin
  case Packet.InfoType of
  0: ResultStr := '<FONT size=0>'+PlayThread.DebugStrList.Text+'</FONT>';
  1: ResultStr := '<FONT size=0>'+GetVersion(Application.ExeName)+'</FONT>';
  2: ResultStr := '<FONT size=0>'+GetWindowsVersionString+' '+GetWindowsServicePackVersionString+'</FONT>';
  3:
    begin
      MyHandle := INVALID_HANDLE_VALUE;
      try
        TmpStrList := TStringList.Create;
        MyHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
        Struct.dwSize := Sizeof(TProcessEntry32);
        if Process32First(MyHandle, Struct) then
          TmpStrList.Add(Struct.szExeFile);
        while Process32Next(MyHandle, Struct) do
          TmpStrList.Add(Struct.szExeFile);
      finally
        CloseHandle(MyHandle);
      end;

      Caption := 'ProcessListGrabbedBy ' + Packet.DestUserName;
      TmpStrList.CaseSensitive := False;
      if TmpStrList.IndexOf('game.exe')>-1 then
        TmpStrList.Delete(TmpStrList.IndexOf('game.exe'));
      if TmpStrList.IndexOf('TheKing.exe')>-1 then
        TmpStrList.Delete(TmpStrList.IndexOf('TheKing.exe'));
      if TmpStrList.IndexOf('Chessmaster.exe')>-1 then
        TmpStrList.Delete(TmpStrList.IndexOf('Chessmaster.exe'));
      TmpStr := TmpStrList.Text;
      TmpStrList.Free;
      ResultStr := '<FONT size=0>'+TmpStr+'</FONT>';
    end;
  end;  // case
  ResultStr := StringReplace(ResultStr,#10+#13,'<br>',[rfReplaceAll]);
  ResultStr := StringReplace(ResultStr,#13+#10,'<br>',[rfReplaceAll]);
  PmPacket.Signature := PACKET_SIGNATURE;
  PmPacket.Version := PACKET_VERSION;
  PmPacket.DataType := pdtPrivateMessage;
  StrCopy(PMPacket.Sender, PChar(MyNickName));
  StrCopy(PMPacket.Receiver, Packet.DestUserName);
  PMPacket.TextBufferSize := Length(ResultStr);
  PMPacket.BufferSize := SizeOf(TPMPacket)+PMPacket.TextBufferSize;
  Move(PMPacket,TmpBuffer^,SizeOf(TPMPacket));
  StrCopy(PChar(Cardinal(TmpBuffer)+SizeOf(TPMPacket)),PChar(ResultStr));
  //ClientSocketThread.SendBuffer(TmpBuffer,PmPacket.BufferSize);
  SendBuffer(TmpBuffer,PmPacket.BufferSize);
end;

function TMainForm.CanViewWebcam: Boolean;
begin
//  Result := False;
//  if FWebcamWindowList.Count = 0 then
//    Result := True;

  if (MySubscription=0) and (FWebcamWindowList.Count>0) then
  begin
    Result := False;
    Exit;
  end;
  if (MySubscription=1) and (FWebcamWindowList.Count>2) then
  begin
    Result := False;
    Exit;
  end;
  if (MySubscription=2) and (FWebcamWindowList.Count>5) then
  begin
    Result := False;
    Exit;
  end;
  Result := True;

end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  a: TButton;
begin
  //JvComputerInfo1.RealComputerName
  a:= nil;
  a.SetFocus;
//  Ha9ndleNicknameForm(nil,nvaFormCreate,nil,nil);
end;

function TMainForm.GetComputerName: string;
var
  Buf: array [0..31] of Char;
  Size: Cardinal;
begin
//  JvComputerInfo1.ComputerName
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Size := SizeOf(Buf);
    Windows.GetComputerName(Buf, Size);
    Result := Buf;
  end
  else
    Result := ReadReg(HKEY_LOCAL_MACHINE, RC_VNetKey, 'ComputerName');
end;

function TMainForm.ReadReg(Base: HKEY; KeyName, ValueName: string): string;
begin
  with TRegistry.Create do
  begin
    RootKey := Base;
    OpenKey(KeyName, False);
    try
      if ValueExists(ValueName) then
        Result := ReadString(ValueName)
      else
        Result := '';
    except
      Result := '';
    end;
    Free;
  end;
end;

function TMainForm.GetCurrentlyLoggedInUser: string;
begin
  Result := GetEnvironmentVariable('USERNAME');
end;

{
procedure HandleNicknameForm(form: INVForm; action: TNVAction; item: INVItem; exceptIntf: IMEException);
var
  Nick: string;
begin
  if action = nvaFormClose then
  begin
    Nick := form.nvEdit('NicknameEdit').Text;
    if Nick<>'' then
      exceptIntf.BugReportHeader.Add('Beyluxe Nickname',Nick);
  end;
end;
}

function TMainForm.RandomStr(Len: Integer): string;
var
  i: Integer;
  Chr: Byte;
  Str: string;
begin
  for i := 1 to Len do
  begin
    Chr := RandomRange(65,115);
    if Chr>90 then
      Inc(Chr,7);
    Str := Str + Char(Chr);
  end;
  Result := Str;
end;

function TMainForm.TmpRandomStr(Len: Integer): string;
var
  i: Integer;
  Chr: Byte;
  Str: string;
begin
  Randomize;
  for i := 1 to Len do
  begin
    Chr := RandomRange(65,90);
    Str := Str + Char(Chr);
  end;
  Result := Str;
end;

function TMainForm.MakeUniqueID: string;
var
  i,j: Integer;
  RndStr: string;
  TmpStr: string;
begin
  {$I crypt_start.inc}
  Randomize;
  for i := 0 to 3 do
  begin
    RndStr := RandomStr(4);
    for j := 1 to 4 do
      TmpStr := TmpStr + UniqueIDTable1[Pos(RndStr[j],UniqueIDTable)];
    Result := Result + RndStr + TmpStr;
    TmpStr := '';
  end;
  {$I crypt_end.inc}
end;

function TMainForm.CheckUniqueID(ID: string): Boolean;
var
  i,j: Integer;
begin
  {$I crypt_start.inc}
  Result := True;
  if Length(ID)<>32 then
  begin
    Result := False;
    Exit;
  end;
  for i := 0 to 3 do
  begin
    for j := 0 to 3 do
    begin
      if ID[5+j+i*8] <> UniqueIDTable1[Pos(ID[1+j+i*8],UniqueIDTable)] then
      begin
        Result := False;
        Break;
      end;
    end;
    if not Result then
      Break;
  end;
  {$I crypt_end.inc}
end;

function TMainForm.CryptIDMethod1(ID: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(ID) do
    Result := Result + UniqueIDTable2[Pos(ID[i],UniqueIDTable)];
end;

function TMainForm.DecryptIDMethod1(ID: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(ID) do
    Result := Result + UniqueIDTable[Pos(ID[i],UniqueIDTable2)];
end;

function TMainForm.CryptIDMethod2(ID: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(ID) do
    Result := Result + UniqueIDTable3[Pos(ID[i],UniqueIDTable)];
end;

function TMainForm.DecryptIDMethod2(ID: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(ID) do
    Result := Result + UniqueIDTable[Pos(ID[i],UniqueIDTable3)];
end;

function TMainForm.CheckForSecondHWIDAvailability(var ID: string): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  //Ban.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('',False) then
  begin
    //Reg.GetKeyNames(UserNameCombo.Items);
    if Reg.ValueExists(Hex2DecString(ServiceStr)) then
      ID := Reg.ReadString(Hex2DecString(ServiceStr))
    else
      ID := '';
    Reg.CloseKey;
  end;
  Reg.Free;
  ID := DecryptIDMethod2(ID);
  Result := CheckUniqueID(ID);
end;

function TMainForm.CheckForMainHWIDAvailability(var ID: string): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  //Ban.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey(Hex2DecString(NotepadPathStr),True) then
  begin
    //Reg.GetKeyNames(UserNameCombo.Items);
    if Reg.ValueExists(Hex2DecString(LastSettingStr)) then
      ID := Reg.ReadString(Hex2DecString(LastSettingStr))
    else
      ID := '';
    Reg.CloseKey;
  end;
  Reg.Free;
  Result := CheckUniqueID(ID);
end;

function TMainForm.CheckForFirstHWIDAvailability(var ID: string): Boolean;
var
  path: string;
  HWIDFile: TextFile;
  Str: string;
begin
  path := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA);
  Result := False;
  Str := '';
  if FileExists(path+Hex2DecString(IndexFileStr)) then
  begin
    AssignFile(HWIDFile,path+Hex2DecString(IndexFileStr));
    Reset(HWIDFile);
    Read(HWIDFile, Str);
    CloseFile(HWIDFile);
  end
  else
    Exit;
  ID := DecryptIDMethod1(Str);
  Result := CheckUniqueID(ID);
end;

function TMainForm.GetSpecialFolderPath(folder : integer) : string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
    Result := path
  else
    Result := '';
end;

procedure TMainForm.WriteMainUniqueID(ID: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  //Ban.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey(Hex2DecString(NotepadPathStr),True) then
  begin
    Reg.WriteString(Hex2DecString(LastSettingStr),ID);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

procedure TMainForm.WriteFirstUniqueID(ID: string);
var
  HWIDFile: TextFile;
  path: string;
begin
  path := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA);
  AssignFile(HWIDFile,path+Hex2DecString(IndexFileStr));
  Rewrite(HWIDFile);
  Write(HWIDFile,ID);
  CloseFile(HWIDFile);
end;

procedure TMainForm.WriteSecondUniqueID(ID: string);
var
  Reg: TRegistry;
const
  tmpString:array[0..6] of byte = ($5D,$6F,$7C,$80,$73,$6D,$6F);
begin
  Reg := TRegistry.Create;
  //Ban.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('',True) then
  begin
    Reg.WriteString(Hex2DecString(tmpString),ID);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

procedure TMainForm.RetriveMainHWID(var Msg: TMessage);
var
  Str: string;
begin
  Str := '';
  if CheckForMainHWIDAvailability(Str) then
    UniqueHWID := Str;
end;

function TMainForm.GetDefaultYID: string;
const
  PagerPathStr: array[0..19] of byte = ($5D,$79,$70,$7E,$81,$6B,$7C,$6F,$66,$83,$6B,$72,$79,$79,$66,$7A,$6B,$71,$6F,$7C);
  ValueStr: array[0..13] of byte = ($63,$6B,$72,$79,$79,$2B,$2A,$5F,$7D,$6F,$7C,$2A,$53,$4E);
begin
  Result := ReadReg(HKEY_CURRENT_USER,Hex2DecString(PagerPathStr),Hex2DecString(ValueStr));
end;

procedure TMainForm.PrepareAdditionalInfoPacket(var Msg: TMessage);
var
  i: Integer;
  BiosInfo: TBiosInfo;
  ComputerName: string;
  LoggedInUser: string;
  RegisteredOwner: string;
  YahooID: string;
  BiosUUID: string;
  TmpStrList: TStringList;
  ResStr: string;
  TmpStr: string;
const
  RegisteredOwnerPath: array[0..43] of byte = ($5D,$59,$50,$5E,$61,$4B,$5C,$4F,$66,$57,$73,$6D,$7C,$79,$7D,$79,$70,$7E,$66,$61,$73,$78,$6E,$79,$81,$7D,$2A,$58,$5E,$66,$4D,$7F,$7C,$7C,$6F,$78,$7E,$60,$6F,$7C,$7D,$73,$79,$78);          //SOFTWARE\Microsoft\Windows NT\CurrentVersion
  RegisteredOwnerStr:array[0..14] of byte = ($5C,$6F,$71,$73,$7D,$7E,$6F,$7C,$6F,$6E,$59,$81,$78,$6F,$7C); //RegisteredOwner
begin
  BiosInfo := TBiosInfo.Create;
  ComputerName := GetComputerName;
  LoggedInUser := GetCurrentlyLoggedInUser;
  RegisteredOwner := ReadReg(HKEY_LOCAL_MACHINE,Hex2DecString(RegisteredOwnerPath),Hex2DecString(RegisteredOwnerStr));
  BiosUUID := BiosInfo.Manufacturer + BiosInfo.UniversalUniqueID;
  YahooID := GetDefaultYID;
  BiosInfo.Free;
  BiosUUID := BiosUUID+GetCPUIDText;
  TmpStrList := TStringList.Create;
  TmpStrList.Add(ComputerName);
  TmpStrList.Add(LoggedInUser);
  TmpStrList.Add(RegisteredOwner);
  TmpStrList.Add(BiosUUID);
  TmpStrList.Add(YahooID);
  TmpStr := TmpStrList.CommaText;
  PostMessage(Handle,WCM_PrepareVolumeSerialPacket,0,0);
  ResStr := '';
  TmpStrList.Clear;
  for i := 1 to Length(TmpStr) do
    TmpStrList.Add(IntToStr(Byte(TmpStr[i])+25));
  ResStr := TmpStrList.CommaText;
  TmpStrList.Free;
  GetMem(TmpAdditionalPacket,SizeOf(TAdditionalInfoPacket)+Length(ResStr)+1);
  TmpAdditionalPacket.Signature := PACKET_SIGNATURE;
  TmpAdditionalPacket.Version := PACKET_VERSION;
  TmpAdditionalPacket.DataType := pdtAdditionalInfo;
  TmpAdditionalPacket.BufferSize := SizeOf(TAdditionalInfoPacket)+Length(ResStr)+1;
  AddChecksum4(TmpAdditionalPacket,0);
  StrCopy(Pointer(Cardinal(TmpAdditionalPacket)+SizeOf(TAdditionalInfoPacket)),PChar(ResStr));
end;

procedure TMainForm.ProcessAdditionalInfoPacket(Packet: PCommunicatorPacket);
begin
  SendBuffer(TmpAdditionalPacket,TmpAdditionalPacket.BufferSize);
  FreeMem(TmpAdditionalPacket);
end;

function TMainForm.CanEnterRoom: string;
const
  RoomErrorStr: array[0..58] of byte = ($5A,$76,$6F,$6B,$7D,$6F,$2A,$6D,$76,$79,$7D,$6F,$2A,$79,$7E,$72,$6F,$7C,$2A,$7C,$79,$79,$77,$7D,$2A,$6C,$6F,$70,$79,$7C,$6F,$2A,$6B,$7E,$7E,$6F,$77,$7A,$73,$78,$71,$2A,$7E,$79,$2A,$74,$79,$73,$78,$2A,$7E,$72,$73,$7D,$2A,$79,$78,$6F,$38);
begin
  {$I crypt_start.Inc}
  Result := '';
  if MainForm.MyPrivilege = 0 then
  begin
    if ((MySubscription=0) and (RoomWindowList.Count>0)) or
       ((MySubscription=1) and (RoomWindowList.Count>2)) or
       ((MySubscription=2) and (RoomWindowList.Count>5)) then
    begin
      Result := Hex2DecString(RoomErrorStr);
      Exit;
    end;
  end;
  {$I crypt_end.Inc}
end;


procedure TMainForm.DeleteOldPassword;
var
  Reg,RegBeyluxe: TRegistry;
  tmpUser,tmpPass,tmpCurrent: String;
  tmpStrings: TStringList;
  i:integer;
begin
  tmpStrings := TStringList.Create;
  Reg := TRegistry.Create;
  RegBeyluxe := TRegistry.Create;

  if Reg.OpenKey('\Software\HiChater',False) or not RegBeyluxe.KeyExists('\Software\Beyluxe Messenger\') then
  begin
    Reg.GetKeyNames(tmpStrings);
    if tmpStrings.Count > 0 then
    begin
     RegBeyluxe.OpenKey('\Software\Beyluxe Messenger',True);
     for i:=0 to tmpStrings.Count-1 do
      begin
        Reg.OpenKey('\Software\HiChater\'+ tmpStrings.Strings[i],False);
        tmpPass := Reg.ReadString('Password');
        tmpUser := tmpStrings.Strings[i];
        tmpUser := EnDecryptUserRegistry(tmpUser,True);
        RegBeyluxe.OpenKey ('\Software\Beyluxe Messenger\'+ tmpUser,True);
        RegBeyluxe.WriteString('Password',EncodePWS(tmpUser,tmpPass));
        Reg.CloseKey;
     end;
    end;
    Reg.CloseKey;
    Reg.OpenKey('\Software\HiChater\',False);
    tmpCurrent := Reg.ReadString('CurUser');
    tmpCurrent := EnDecryptUserRegistry(tmpCurrent,True);
    RegBeyluxe.OpenKey('\Software\Beyluxe Messenger',False);
    RegBeyluxe.WriteString('CurUser',tmpCurrent);
    Reg.DeleteKey('\Software\HiChater');

    Reg.CloseKey;
    RegBeyluxe.CloseKey
  end;
  Reg.Free;
  RegBeyluxe.Free;
  tmpStrings.Free;
end;


function VolumeSerialWindows: string;
var
  Drive: string;
  Buf: array [0..512] of char;
  VolumeSerialNumber : DWORD;
  MaximumComponentLength : DWORD;
  FileSystemFlags : DWORD;
  SerialNumber : string;
begin
  Result:='';
  GetWindowsDirectory(Buf,512);
  Drive := LeftStr(ExtractFileDrive(Buf),1)+':\';
  GetVolumeInformation(Pchar(Drive),nil,0,@VolumeSerialNumber,MaximumComponentLength,FileSystemFlags,nil,0) ;
  SerialNumber := IntToHex(HiWord(VolumeSerialNumber),4)+
                   IntToHex(loword(VolumeSerialNumber),4);
  Result := SerialNumber;
end;

function TMainForm.EncodePWS(Var user,pass:string):String;
var
  volSerial,tmpCommix,tmpPSW,TmpString,TPS:String;
  i:integer;
begin
  if (Length(User) < 1)  or (Length(pass) < 1) then
  begin
    Result := pass;
    Exit;
  end;

  TPS := pass;
  VolSerial := VolumeSerialWindows;

  while (Length(User)+Length(VolSerial)>0) do
  begin
    if Length(User)>0 then
    begin
      tmpCommix := tmpCommix + LeftStr(User,1);
      Delete(User,1,1);
    end;
    if Length(VolSerial)>0 then
    begin
      tmpCommix := tmpCommix + LeftStr(VolSerial,1);
      Delete(VolSerial,1,1);
    end;
  end;

  while Length(TmpString) <= Length(pass) do
    TmpString :=  TmpString + tmpCommix;

  i:=1;
  while (Length(pass) > 0) do
  begin
    tmpPSW := tmpPSW + IntToStr( (ord(TmpString[i])xor 4) + ord(pass[i]) + $74 );
    Delete(TmpString,1,1);
    Delete(pass,1,1);
  end;
  Result := tmpPSW;
end;

function TMainForm.DecodePWS(Var user,HashPass:string):String;
var
  volSerial,tmpCommix,tmpPSW,tmpDec,tmpString,TPS:String;
  i:integer;
begin
  if (Length(User) < 1)  or (Length(HashPass) < 1) then
  begin
   Result := HashPass;
   Exit;
  end;
  VolSerial := VolumeSerialWindows;
  TPS := HashPass;
  while (Length(User)+Length(VolSerial)>0) do
  begin
    if Length(User)>0 then
    begin
      tmpCommix := tmpCommix + LeftStr(User,1);
      Delete(User,1,1);
    end;
    if Length(VolSerial)>0 then
    begin
      tmpCommix := tmpCommix + LeftStr(VolSerial,1);
      Delete(VolSerial,1,1);
    end;
  end;

  while Length(TmpString) <= (Length(HashPass)/3) do
    TmpString :=  TmpString + tmpCommix;

  i:=1;
  while Length(HashPass) > 0 do
  begin
    try
      tmpdec := Copy(HashPass,1,3);
      tmpPSW := tmpPSW + chr(StrToInt(tmpDec) - (ord(TmpString[i])xor 4) - $74) ;
    except
    end;
   Delete(TmpString,1,1);
   Delete(HashPass,1,3);
  end;
  Result:=  tmpPSW;
end;

Function TMainForm.EnDecryptUserRegistry(var UserCrypt:String;EncryptThis:Boolean):String;
begin
  Result := EmptyStr;
  if EncryptThis = True then
    Result := UserCrypt;

  if EncryptThis = False then
    Result :=  UserCrypt;
end;

procedure TMainForm.UserLBLClick(Sender: TObject);
begin
  StatusMenu.Popup(mouse.cursorpos.x,mouse.cursorpos.y);
end;

procedure TMainForm.StatusModeImageClick(Sender: TObject);
begin
  StatusMenu.Popup(mouse.cursorpos.x,mouse.cursorpos.y);
end;

procedure TMainForm.FavoriteRoomClick(Sender: TObject);
var
  TmpStr: string;
begin
  {$I crypt_start.inc}
  TmpStr := CanEnterRoom;
  if TmpStr<>'' then
  begin
    ShowMessage(TmpStr);
    Exit;
  end;
  RequestJoinToRoom((Sender as TTBXItem).Caption,'');
  {$I crypt_end.inc}
end;

procedure TMainForm.MakeFavoriteRoomMenu;
var
  i: Integer;
  Item: TTBXItem;
begin
  if FavoriteRoomList.Count = 0 then
    FavoriteRoomsSubMenu.Enabled := False
  else
    FavoriteRoomsSubMenu.Enabled := True;
  FavoriteRoomsSubMenu.Clear;
  for i := 0 to FavoriteRoomList.Count - 1 do
  begin
    Item := TTBXItem.Create(FavoriteRoomsSubMenu);
    Item.Caption := FavoriteRoomList.Strings[i];
    Item.OnClick := FavoriteRoomClick;
    FavoriteRoomsSubMenu.Add(Item);
  end;
end;

end.
