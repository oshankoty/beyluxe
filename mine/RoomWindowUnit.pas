unit RoomWindowUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, Htmlview, CommunicatorTypes, mmSystem,
  ExtCtrls, PlayThreadUnit, {ClientThread, }ImgList, rtf2HTML, Buttons,
  MyDialogs, StrUtils, Registry, ShellAPI, SyncObjs, CMClasses, MyWebcamUnit,
  TB2Item, TB2Dock, TB2Toolbar, TBX, TBXToolPals, TBXExtItems,
  TB2ToolWindow, GR32_Image, {VUmeter,} GraphUtil, AdminPanelUnit,
  WhisperUnit, TBXDkPanels, VolumeCtrlUnit, DateUtils, JclSysinfo,
  TBXStatusBars, JvGradient, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdGlobal, OleCtrls, SHDocVw, mshtml;

const
  MYNICKCOLOR = $00337733;
  BUDDYNICKCOLOR = $00BB3333;
  JOINROOMCOLOR = $0037AAFF;
  LEFTROOMCOLOR = $00006BBB;
  WCM_USERONMIC = WM_USER + $100;
  WCM_GROUPMSG = WM_USER + $101;
  WCM_JOINLEFT = WM_USER + $102;
  WCM_MICGRANTED = WM_USER + $103;
  WCM_RAISEHAND = WM_USER + $104;
  WCM_USERLIST = WM_USER + $105;
  WCM_MICFREE = WM_USER + $106;
  WCM_WHISPER = WM_USER + $107;
  WCM_WHISPERCLOSED = WM_USER + $108;
  WCM_ROOMALERT = WM_USER + $109;
  WCM_ADMININFOALL = WM_USER + $10A;
  WCM_ADMINOPNOTIFY = WM_USER + $10B;
  WCM_SENDWISPER = WM_USER + $10C;
  WCM_GROUPTITLE = WM_USER + $10D;
  WCM_ADMINOPERATION = WM_USER + $10E;

  WCM_Disconnected = WM_USER + $200;

type
  TRoomUserInfo  = record
    UserName: array [0..34] of char;
    Color: TColor;
    Status: Cardinal;
    Direction: Byte;
  end;

  TAdminInfo = record
    RedDotText: Byte;
    RedDotMic: Byte;
    RedDotVideo: Byte;
    AutoRedDotNewUsers: Byte;
    BounceListStr: string;
    BanListStr: string;
  end;

  PRoomUserInfo = ^TRoomUserInfo;
  TCardinalArray = array [0..32767] of Cardinal;
  PCardinalArray = ^TCardinalArray;
  TProcessPacket = procedure (Packet: PCommunicatorPacket) of object;

  TInputThread = class(TThread)
  private
//    FClientThread: TClientThread;
    FOWner: TObject;
    FThreadTerminated: Boolean;
    FGroupMessageSenderList: TStringList;
    FGroupMessageList: TStringList;
    FJoinLeftList: TStringList;
    FUserOnMic: string;
    FGroupMsgCriticalSection: TCriticalSection;
    FJoinLeftCriticalSection: TCriticalSection;
    FUserStatusList: TStringList;
    FUserStatusCriticalSection: TCriticalSection;
    FUserList: TStringList;
    FWhisperUserNameList: TStringList;
    FWhisperList: TstringList;
    FWhisperCriticalSection: TCriticalSection;
    FRoomAlertList: TStringList;
    FRoomAlertListCriticalSection: TCriticalSection;
    FAdminInfo: TAdminInfo;
    FAdminOpertationNotifyList: TStringList;
    FAdminOpertationNotifyAdminList: TStringList;
    FAdminOpertationNotifyListCriticalSection: TCriticalSection;
    FOWnerHandle: THandle;
    FTCPClient: TIdTCPClient;
    FOutputBufferList: TList;
    FOutputCriticalSection: TCriticalSection;
    FPacketBuffer: Pointer;
    FPacketBufferPtr: Integer;
    FGroupTitle: string;
    FAdminOperationListCriticalSection: TCriticalSection;
    FAdminOperationList: TStringList;
    procedure ProccesPacket(Buffer: Pointer; BufSize: Integer);
    procedure ExecuteGroupAlertPacket(Packet: PRoomAlertPacket);
    procedure ExecuteMicGrantedPacket(Packet: PCommunicatorPacket);
    procedure ExecuteWhisperPacket(Packet: PRoomWhisperPacket);
    procedure ExecuteGroupVoicePacket(Packet: PGroupVoicePacket);
    procedure ExecuteRoomTitlePacket(Packet: PModifyRoomTitlePacket);
    procedure ExecuteRoomUserListPacket(Packet: PRoomUserListPacket);
    procedure ExecuteGroupMessagePacket(Packet: PGroupMessagePacket);
    procedure ExecuteUserJoinLeftRoomPacket(Packet: PUserJoinLeftRoomPacket);
    procedure ExecuteUserStatChangedPacket(Packet: PRoomUserStatusChangedPacket);
    procedure ExecuteMicFreePacket(Packet: PCommunicatorPacket);
    procedure ExecuteAdminOperationReportPacket(Packet: PAdminOperationReportPacket);
    procedure ExecuteAdminOperationPacket(Packet: PAdminOperationPacket);
    procedure ExecuteAdminInfoAllPacket(Packet: PAdminInfoAllPacket);
    procedure AddToPacketBuffer(Buffer: Pointer; Size: Integer);
    procedure CheckAndProccessPacket;
    procedure ProcessInOutOperations;
    procedure DropInvalidPacket;
    procedure ExecutePacket(Packet: PCommunicatorPacket);
  protected
    procedure Execute; override;
    procedure DoAction;
  public
//    property ClientThread: TClientThread read FClientThread write FClientThread;
    LastDataSentTime: TDateTime;
    procedure SendBuffer(Packet: Pointer; Size: Integer);
    property Owner: TObject read FOWner write FOWner;
    property OwnerHandle: THandle read FOWnerHandle write FOWnerHandle;
    property ThreadTerminated: Boolean read FThreadTerminated;
    property GroupMessageSenderList: TStringList read FGroupMessageSenderList;
    property GroupMessageList: TStringList read FGroupMessageList;
    property GroupMsgCriticalSection: TCriticalSection read FGroupMsgCriticalSection;
    property JoinLeftCriticalSection: TCriticalSection read FJoinLeftCriticalSection;
    property JoinLeftList: TStringList read FJoinLeftList;
    property UserOnMic: string read FUserOnMic;
    property UserStatusList: TStringList read FUserStatusList;
    property WhisperCriticalSection: TCriticalSection read FWhisperCriticalSection;
    property WhisperList: TStringList read FWhisperList;
    property WhisperUserNameList: TStringList read FWhisperUserNameList;
    property UserStatusCriticalSection: TCriticalSection read FUserStatusCriticalSection;
    property UserList: TStringList read FUserList;
    property RoomAlertList: TStringList read FRoomAlertList;
    property RoomAlertListCriticalSection: TCriticalSection read FRoomAlertListCriticalSection;
    property AdminInfo: TAdminInfo read FAdminInfo;
    property AdminOpertationNotifyList: TStringList read FAdminOpertationNotifyList;
    property AdminOpertationNotifyListCriticalSection: TCriticalSection read FAdminOpertationNotifyListCriticalSection;
    property AdminOpertationNotifyAdminList: TStringList read FAdminOpertationNotifyAdminList;
    property AdminOperationListCriticalSection: TCriticalSection read FAdminOperationListCriticalSection;
    property AdminOperationList: TStringList read FAdminOperationList; 
    property TCPClient: TIdTCPClient read FTCPClient;
    property GroupTitle: string read FGroupTitle write FGroupTitle;
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;


  TRoomWindow = class(TForm)
    MeterTimer: TTimer;
    Menubar: TTBToolbar;
    mClose: TTBXSubmenuItem;
    mSave: TTBXItem;
    Print1: TTBXItem;
    Exit1: TTBXItem;
    Edit1: TTBXSubmenuItem;
    Cut1: TTBXItem;
    Copy1: TTBXItem;
    Paste1: TTBXItem;
    SelectAll1: TTBXItem;
    Delete1: TTBXItem;
    Option1: TTBXSubmenuItem;
    Notifymewhenauserlefttheroom1: TTBXItem;
    Notifymewhenauserjoinedtheroom1: TTBXItem;
    SaveDefaultSetting: TTBXItem;
    AdminMenu: TTBXSubmenuItem;
    TBXItem3: TTBXItem;
    OffImage: TImage;
    HotImage: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ListViewPOPUPMenu: TTBXPopupMenu;
    mSendPM: TTBXItem;
    mSendWhisper: TTBXItem;
    mBlockUser: TTBXItem;
    TBXItem8: TTBXItem;
    TBXItem7: TTBXItem;
    mAddBuddy: TTBXItem;
    TBXItem6: TTBXItem;
    TBXItem5: TTBXItem;
    mBRBSeperator: TTBXSeparatorItem;
    mBRB: TTBXItem;
    AdminListViewPOPUPMenu: TTBXPopupMenu;
    ReddotSubMenu: TTBXSubmenuItem;
    mDefaultReddot: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    mReddotVideo: TTBXItem;
    mReddotMic: TTBXItem;
    mReddotText: TTBXItem;
    mBounceUser: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    MakeUserSuperAdmin: TTBXItem;
    MakeUserAdmin: TTBXItem;
    RemoveAdminPower: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    maSendPM: TTBXItem;
    maSendWhisper: TTBXItem;
    maBlockUser: TTBXItem;
    TBXItem15: TTBXItem;
    TBXItem16: TTBXItem;
    maAddBuddy: TTBXItem;
    TBXItem18: TTBXItem;
    TBXItem19: TTBXItem;
    maBRBSeparator: TTBXSeparatorItem;
    maBRB: TTBXItem;
    RichEditPOPUP: TTBXPopupMenu;
    mrCopy: TTBXItem;
    mrCut: TTBXItem;
    mrPaste: TTBXItem;
    mrDelete: TTBXItem;
    ViewerPOPUP: TTBXPopupMenu;
    Copy2: TTBXItem;
    ClearScreen1: TTBXItem;
    MenuImages: TImageList;
    PingTimer: TTimer;
    ColorPOPUP: TPopupMenu;
    mcBlack: TMenuItem;
    mcGreen: TMenuItem;
    mcBlue: TMenuItem;
    mcOrange: TMenuItem;
    mcBrown: TMenuItem;
    mcPurple: TMenuItem;
    mcSoorati: TMenuItem;
    mcSkyBlue: TMenuItem;
    mcGray: TMenuItem;
    mcOtherColors: TMenuItem;
    OtherColors1: TMenuItem;
    ColorDialog1: TColorDialog;
    Panel5: TPanel;
    UsersListView: TListView;
    TBXToolWindow3: TTBXToolWindow;
    StartCamButton: TSpeedButton;
    InviteButton: TSpeedButton;
    AddToFavoriteButton: TSpeedButton;
    BrowseRoomsButton: TSpeedButton;
    TBXStatusBar1: TTBXStatusBar;
    Panel4: TPanel;
    Panel7: TPanel;
    TBXToolWindow1: TTBXToolWindow;
    SendButton: TSpeedButton;
    InputMemo: TRichEdit;
    TBXToolWindow4: TTBXToolWindow;
    Panel6: TPanel;
    Panel8: TPanel;
    TBXToolWindow5: TTBXToolWindow;
    Label3: TLabel;
    UnderLineButton: TSpeedButton;
    ItalicButton: TSpeedButton;
    BoldButton: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SmileButton: TSpeedButton;
    MuteButton: TSpeedButton;
    FontSizeCombo: TComboBox;
    Panel9: TPanel;
    TBXToolWindow2: TTBXToolWindow;
    Image1: TImage;
    Image2: TImage;
    WindowsRecordingControlButton: TSpeedButton;
    WindowsVolumeControlButton: TSpeedButton;
    //RecordMeter: TVUmeter;
    //PlayMeter: TVUmeter;
    Panel10: TPanel;
    TBXToolWindow6: TTBXToolWindow;
    RaiseHandButton: TSpeedButton;
    MicButton: TSpeedButton;
    ActionMenu: TTBXSubmenuItem;
    mInviteFriends: TTBXItem;
    mPMSelectedUser: TTBXItem;
    mRaiseHand: TTBXItem;
    mViewWebcam: TTBXItem;
    TBXItem12: TTBXItem;
    TBXItem13: TTBXItem;
    mVoiceActivate: TTBXItem;
    mLockOnMic: TTBXItem;
    RoomTitleRichEdit: TRichEdit;
    RoomTitlePOPUP: TTBXPopupMenu;
    RoomTitleCopy: TTBXItem;
    WebBrowser1: TWebBrowser;
    TBXSeparatorItem4: TTBXSeparatorItem;
    FreezDisplay: TTBXItem;
    TBXSubmenuItem1: TTBXSubmenuItem;
    TBXItem1: TTBXItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXItem2: TTBXItem;
    TBXItem4: TTBXItem;
    TBXItem9: TTBXItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    TBXItem10: TTBXItem;
    TBXSubmenuItem2: TTBXSubmenuItem;
    TBXItem11: TTBXItem;
    TBXItem14: TTBXItem;
    TBXItem17: TTBXItem;
    TBXItem20: TTBXItem;
    TBXItem21: TTBXItem;
    TBXItem22: TTBXItem;
    TBXItem23: TTBXItem;
    TBXItem24: TTBXItem;
    TBXItem25: TTBXItem;
    TBXItem26: TTBXItem;
    TBXItem27: TTBXItem;
    TBXItem28: TTBXItem;
    TBXItem29: TTBXItem;
    TBXItem30: TTBXItem;
    TBXItem31: TTBXItem;
    TBXItem32: TTBXItem;
    TBXItem33: TTBXItem;
    TBXItem34: TTBXItem;
    Viewer: TWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SendButtonClick(Sender: TObject);
    procedure InputMemoKeyPress(Sender: TObject; var Key: Char);
    procedure MicButtonClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure UnderLineButtonClick(Sender: TObject);
    procedure FontSizeComboChange(Sender: TObject);
    procedure SmileButtonClick(Sender: TObject);
    procedure ViewerImageRequest(Sender: TObject; const SRC: String;
      var Stream: TMemoryStream);
    procedure ViewerHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    procedure Copy2Click(Sender: TObject);
    procedure UsersListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure RaiseHandButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Notifymewhenauserjoinedtheroom1Click(Sender: TObject);
    procedure Notifymewhenauserlefttheroom1Click(Sender: TObject);
    procedure ClearScreen1Click(Sender: TObject);
    procedure Viewwebcam1Click(Sender: TObject);
    procedure StartCamButtonClick(Sender: TObject);
    procedure InviteButtonClick(Sender: TObject);
    procedure MeterTimerTimer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ListViewPOPUPMenuPopup(Sender: TObject);
    procedure mBounceUserClick(Sender: TObject);
    procedure mDefaultReddotClick(Sender: TObject);
    procedure mReddotVideoClick(Sender: TObject);
    procedure AdminListViewPOPUPMenuPopup(Sender: TObject);
    procedure TBXItem3Click(Sender: TObject);
    procedure mReddotMicClick(Sender: TObject);
    procedure mReddotTextClick(Sender: TObject);
    procedure WindowsRecordingControlButtonClick(Sender: TObject);
    procedure WindowsVolumeControlButtonClick(Sender: TObject);
    procedure mSendWhisperClick(Sender: TObject);
    procedure mSendPMClick(Sender: TObject);
    procedure MakeUserAdminClick(Sender: TObject);
    procedure MakeUserSuperAdminClick(Sender: TObject);
    procedure RemoveAdminPowerClick(Sender: TObject);
    procedure UsersListViewClick(Sender: TObject);
    procedure mrCopyClick(Sender: TObject);
    procedure mrCutClick(Sender: TObject);
    procedure mrPasteClick(Sender: TObject);
    procedure mrDeleteClick(Sender: TObject);
    procedure mSaveClick(Sender: TObject);
    procedure mAddBuddyClick(Sender: TObject);
    procedure mBlockUserClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PingTimerTimer(Sender: TObject);
    procedure SaveDefaultSettingClick(Sender: TObject);
    procedure mcOtherColorsDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure mcOtherColorsMeasureItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);
    procedure OtherColors1Click(Sender: TObject);
    procedure mcOtherColorsClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure BrowseRoomsButtonClick(Sender: TObject);
    procedure maBRBClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MuteButtonClick(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure mVoiceActivateClick(Sender: TObject);
    procedure mInviteFriendsClick(Sender: TObject);
    procedure mPMSelectedUserClick(Sender: TObject);
    procedure mLockOnMicClick(Sender: TObject);
    procedure UsersListViewResize(Sender: TObject);
    procedure ActionMenuPopup(Sender: TTBCustomItem;
      FromLink: Boolean);
    procedure mRaiseHandClick(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure RoomTitleRichEditMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RoomTitleCopyClick(Sender: TObject);
    procedure RoomTitleRichEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddToFavoriteButtonClick(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FreezDisplayClick(Sender: TObject);
    procedure TBXItem1Click(Sender: TObject);
    procedure TBXItem11Click(Sender: TObject);
    procedure TBXItem14Click(Sender: TObject);
    procedure TBXItem17Click(Sender: TObject);
    procedure TBXItem20Click(Sender: TObject);
    procedure TBXItem21Click(Sender: TObject);
    procedure TBXItem22Click(Sender: TObject);
    procedure TBXItem23Click(Sender: TObject);
    procedure TBXItem24Click(Sender: TObject);
    procedure TBXItem25Click(Sender: TObject);
    procedure TBXItem26Click(Sender: TObject);
    procedure TBXItem27Click(Sender: TObject);
    procedure TBXItem28Click(Sender: TObject);
    procedure TBXItem29Click(Sender: TObject);
    procedure TBXItem30Click(Sender: TObject);
    procedure TBXItem31Click(Sender: TObject);
    procedure TBXItem32Click(Sender: TObject);
    procedure TBXItem33Click(Sender: TObject);
    procedure TBXItem34Click(Sender: TObject);
    procedure UsersListViewDblClick(Sender: TObject);
  private
    { Private declarations }
    //ClientThread: TClientThread;
    InBuffer: Pointer;
    TmpBuffer: Pointer;
    VoiceMemoryStream: TMemoryStream;
    SendVoiceIsBusy: Boolean;
    CurrentColor: TColor;
    SmileStringList: TStringList;
    IsActive: Boolean;
    {$IFDEF AUDIOLOG}
    TestAudioFile: TFileStream;
    {$ENDIF}
    FVoiceEnable: Boolean;
    InputThread: TInputThread;
    POPUPActiveUserName: string;
    FAdminControlPanel: TAdminControlPanel;
    FWhisperWindow: TWhisperForm;
    FRoomClosing: Boolean;
    FBRB: Boolean;
    FRoomStrQueue: TStringList;
    FIsAdmin: Boolean;
    WMExist: Boolean;
    WMWindowsHWND : THandle;
    procedure OutputVolumeCahnged(Sender: TObject);
    procedure EnableAdminControls;
    procedure ExecuteMicFreePacket(Packet: PCommunicatorPacket);
    procedure ExecuteMicGrantedPacket(Packet: PCommunicatorPacket);
    procedure JoinRoomInfo(var msg: TMessage); message WCM_JoinRoomInfo;
    procedure RemoveMicIcon(var msg: TMessage); message WCM_RemoveMicIcon;
    procedure HandleUserOnMic(var msg: TMessage); message WCM_USERONMIC;
    procedure HandleGroupMsgPacket(var msg: TMessage); message WCM_GROUPMSG;
    procedure HandleJoinLeftPacket(var msg: TMessage); message WCM_JOINLEFT;
    procedure HandleMicGrantedPacket(var msg: TMessage); message WCM_MICGRANTED;
    procedure HandleUserStatChagedPacket(var msg: TMessage); message WCM_RAISEHAND;
    procedure HandleUserListPacket(var msg: TMessage); message WCM_USERLIST;
    procedure HandleMicFreePacket(var msg: TMessage); message WCM_MICFREE;
    procedure HandleDisconnet(var msg: TMessage); message WCM_Disconnected;
    procedure HandleWhisperPacket(var msg: TMessage); message WCM_WHISPER;
    procedure HandleWhisperWindowClosedMsg(var msg: TMessage); message WCM_WHISPERCLOSED;
    procedure HandleRoomAlertPacket(var msg: TMessage); message WCM_ROOMALERT;
    procedure HandleAdminInfoAllPacket(var msg: TMessage); message WCM_ADMININFOALL;
    procedure HandleAdminOperationNotifyPacket(var msg: TMessage); message WCM_ADMINOPNOTIFY;
    procedure HandleGroupTitlePacket(var msg: TMessage); message WCM_GROUPTITLE;
    procedure HandleAdminOperationPacket(var msg: TMessage); message WCM_ADMINOPERATION;
    procedure SendWhisper(var msg: TMessage); message WCM_SENDWISPER;
    procedure SendTextToRoom(User,Text: string; UserColor: TColor);
//    procedure ExchangeUserListItem(Index1,Index2: Integer);
    procedure UpdateThisUserIcon(Item: TListItem);
    procedure SendGroupMessageToServer(Msg: string);
    procedure SendBuffer(const Buffer; Size: Integer);
    procedure RaiseThisUserHande(UserIndex: Integer);
    procedure UnRaiseThisUserHande(UserIndex: Integer);
    procedure RedDotTextThisUser(UserIndex: Integer);
    procedure UnRedDotTextThisUser(UserIndex: Integer);
    procedure RedDotMicThisUser(UserIndex: Integer);
    procedure UnRedDotMicThisUser(UserIndex: Integer);
    procedure RedDotVideoThisUser(UserIndex: Integer);
    procedure UnRedDotVideoThisUser(UserIndex: Integer);
    procedure ShowCamIconForThisUser(UserIndex: Integer);
    procedure RemoveCamIconForThisUser(UserIndex: Integer);
    procedure ShowBRBIconForThisUser(UserIndex: Integer);
    procedure RemoveBRBIconForThisUser(UserIndex: Integer);
    procedure UpdateAdminStatForThisUser(UserIndex: Integer);
    procedure SynchronizeInputFontStyles;
    procedure FillSmileStringList;
    procedure DisableAdminControls;
    procedure AdminReport(AdminName,UserName: string; AdminOperation: Cardinal);
    function ShiftDown: Boolean;
    procedure MoveUserListItem(Index1, Index2: Integer);
    function GetLastRaiseIndex: Integer;
    procedure AddToHTMLViewer(Str: string);
    procedure WMGetWindows(var Msg : TWMCopyData) ; message WM_COPYDATA;
    procedure WMSendString(var user,Text:string);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    Streaming: Boolean;
    GrantCode: string;
    RoomCode: Integer;
    RoomPort: Integer;
    RoomType: Byte;
    FVolumeControlForm: TVolControlForm;
    DisplayFreezed: Boolean;
    DisPlayFreezTime: TDateTime;
    procedure SetPrivacy(Privacy: Byte);
    function ReplaceSmilesText(Str: string): string;
    procedure UserOnMic(UserName: string);
    procedure SendVoicePacket(Buf: Pointer; Size: Integer);
    procedure AdminCloseRoom;
    procedure SetNewUserReddotsOrder(RedText,RedMic,RedVideo: Boolean);
    procedure SetRoomTitle(RoomTitle: string);
    procedure UnBounceThisUser(UserName: string);
    procedure BanUser(UserName: string; Ban: Boolean);
    procedure BounceUser(UserName: string; Bounce: Boolean);
    procedure ApplyDefaultRedDots;
    procedure ConnectToRoom;
    procedure ShowCamIcon(Show: Boolean);
    property IsWindowActive: Boolean read IsActive;
    property VoiceEnable: Boolean read FVoiceEnable write FVoiceEnable;
    property RoomClosing: Boolean read FRoomClosing;
    procedure AppendToWB(WB: TWebBrowser; const html: widestring);
//    property PlayThread: TPlayThread read FPlayThread write FPlayThread;
  end;

implementation

uses MainUnit, InviteUserUnit, SmilesUnit, Math, Types, BrowseRoomsUnit;

{$R *.dfm}

{ TInputThread }

constructor TInputThread.Create(CreateSuspended: Boolean);
begin
  inherited Create (CreateSuspended);
  FGroupMessageSenderList := TStringList.Create;
  FGroupMessageList := TStringList.Create;
  FJoinLeftList := TStringList.Create;
  FGroupMsgCriticalSection := TCriticalSection.Create;
  FJoinLeftCriticalSection := TCriticalSection.Create;
  FUserStatusCriticalSection := TCriticalSection.Create;
  FUserStatusList := TStringList.Create;
  FUserList := TStringList.Create;
  FWhisperUserNameList := TStringList.Create;
  FWhisperCriticalSection := TCriticalSection.Create;
  FWhisperList := TStringList.Create;
  FRoomAlertList := TStringList.Create;
  FRoomAlertListCriticalSection := TCriticalSection.Create;
  FAdminOpertationNotifyList := TStringList.Create;
  FAdminOpertationNotifyListCriticalSection := TCriticalSection.Create;
  FAdminOpertationNotifyAdminList := TStringList.Create;
  FAdminOperationListCriticalSection := TCriticalSection.Create;
  FAdminOperationList := TStringList.Create;
  FOutputBufferList := TList.Create;
  FOutputCriticalSection := TCriticalSection.Create;
  FTCPClient := TIdTCPClient.Create;
  GetMem(FPacketBuffer,65536);
end;

destructor TInputThread.Destroy;
begin
  FreeMem(FPacketBuffer);
  FTCPClient.Free;
  FOutputCriticalSection.Free;
  FOutputBufferList.Free;
  FAdminOperationList.Free;
  FAdminOperationListCriticalSection.Free;
  FAdminOpertationNotifyAdminList.Free;
  FAdminOpertationNotifyListCriticalSection.Free;
  FAdminOpertationNotifyList.Free;
  FRoomAlertListCriticalSection.Free;
  FRoomAlertList.Free;
  FWhisperList.Free;
  FWhisperCriticalSection.Free;
  FWhisperUserNameList.Free;
  FUserList.Free;
  FUserStatusList.Free;
  FUserStatusCriticalSection.Free;
  FJoinLeftCriticalSection.Free;
  FGroupMsgCriticalSection.Free;
  FJoinLeftList.Free;
  FGroupMessageList.Free;
  FGroupMessageSenderList.Free;
  inherited;
end;

procedure TInputThread.DoAction;
begin
end;

procedure TInputThread.Execute;
begin
  inherited;
  try
    while not Terminated do
    begin
      Sleep(5);
      ProcessInOutOperations;
    end;
  finally
    FThreadTerminated := True;
  end;
end;

procedure TInputThread.ExecuteGroupMessagePacket(
  Packet: PGroupMessagePacket);
var
  UserName: string;
  Text: PChar;
//  TextW: WideString;
  RoomText: string;
begin
  UserName := Packet.UserName;
  //PByte(Cardinal(Packet)+Packet.BufferSize)^ := 0;
  Text := Pointer(Cardinal(Packet)+SizeOf(TGroupMessagePacket));
  //TextW := UTF8Decode(String(Text));
  //RoomText := TextW;
  RoomText := Text;
  FGroupMsgCriticalSection.Enter;
  FGroupMessageSenderList.Add(UserName);
  FGroupMessageList.Add(RoomText);
  FGroupMsgCriticalSection.Leave;
  PostMessage(FOWnerHandle,WCM_GROUPMSG,0,0);
  //SendTextToRoom(UserName,RoomText,clBlue);
end;

procedure TInputThread.ExecuteAdminOperationReportPacket(
  Packet: PAdminOperationReportPacket);
begin
  FAdminOpertationNotifyListCriticalSection.Enter;
  FAdminOpertationNotifyList.AddObject(Packet.UserName,TObject(Packet.Operation));
  FAdminOpertationNotifyAdminList.Add(Packet.AdminName);
  FAdminOpertationNotifyListCriticalSection.Leave;
  PostMessage(OwnerHandle,WCM_ADMINOPNOTIFY,0,0);
end;

procedure TInputThread.ExecuteGroupVoicePacket(Packet: PGroupVoicePacket);
var
  RoomWindow: TRoomWindow;
  VoiceDataSize: Integer;
begin
  if MainForm.AudioEnable then
  begin
    RoomWindow := TRoomWindow(Owner);
    //RoomWindow.Streaming := False;
    if not RoomWindow.VoiceEnable then
      Exit;
    VoiceDataSize := Packet.BufferSize - SizeOf(TGroupVoicePacket);
    FUserOnMic := Packet.UserName;
    PostMessage(FOwnerHandle,WCM_USERONMIC,0,0);
    {$IFDEF AUDIOLOG}
    RoomWindow.TestAudioFile.Write(Pointer(Cardinal(Packet)+SizeOf(TGroupVoicePacket))^,VoiceDataSize);
    {$ENDIF}
    if MainForm.ActiveRoomWindow = RoomWindow then
      MainForm.PlayThread.AddPlayBuffer(Pointer(Cardinal(Packet)+SizeOf(TGroupVoicePacket)),VoiceDataSize);
  end;
end;

procedure TInputThread.ExecuteMicFreePacket(Packet: PCommunicatorPacket);
begin
  PostMessage(FOwnerHandle,WCM_MICFREE,0,0);
end;

procedure TInputThread.ExecuteMicGrantedPacket(
  Packet: PCommunicatorPacket);
begin
  PostMessage(FOwnerHandle,WCM_MICGRANTED,0,0);
end;

procedure TInputThread.ExecuteUserStatChangedPacket(Packet: PRoomUserStatusChangedPacket);
var
  UserName: string;
begin
  UserName := Packet.UserName;
  UserStatusCriticalSection.Enter;
  UserStatusList.AddObject(UserName,TObject(Packet.Status));
  UserStatusCriticalSection.Leave;
  PostMessage(FOWnerHandle,WCM_RAISEHAND,0,0);
end;

procedure TInputThread.ExecuteGroupAlertPacket(Packet: PRoomAlertPacket);
var
  Status: Cardinal;
begin
  FRoomAlertListCriticalSection.Enter;
  Status := 0;
  if Packet.MessageBox then
    Status := Status or 1;
  if Packet.ShouldClose then
    Status := Status or 2;
  FRoomAlertList.AddObject(PChar(Cardinal(Packet)+SizeOf(TRoomAlertPacket)),TObject(Status));
  FRoomAlertListCriticalSection.Leave;
  PostMessage(FOWnerHandle,WCM_ROOMALERT,0,0);
end;

procedure TInputThread.ExecuteWhisperPacket(Packet: PRoomWhisperPacket);
var
  UserName: string;
  WhisperText: string;
begin
//DEFAULT_CHARSET
  UserName := Packet.UserName;
  WhisperText := PChar(Pointer(Cardinal(Packet)+SizeOf(TRoomWhisperPacket)));
  WhisperCriticalSection.Enter;
  FWhisperUserNameList.Add(UserName);
  FWhisperList.Add(WhisperText);
  WhisperCriticalSection.Leave;
  PostMessage(FOWnerHandle,WCM_WHISPER,0,0);
end;

procedure TInputThread.ExecuteRoomUserListPacket(
  Packet: PRoomUserListPacket);
var
  Index: Integer;
  UserList: PChar;
  TmpPointer: Pointer;
  TmpList: TStringList;
begin
/////////////////////////////////////
//  User Status Format             //
//       Bit 0,1,2,3: Privilege    //
//       Bit 4: Video              //
//       Bit 5: Raise Hand         //
//       Bit 6: Red Dot Text       //
//       Bit 7: Red Dot Mic        //
//       Bit 8: Red Dot Video      //
//       Bit 9: BRB                //
/////////////////////////////////////

  //PByte(Cardinal(Packet)+Packet.BufferSize)^ := 0;
  UserList := Pointer(Cardinal(Packet)+SizeOf(TRoomUserListPacket));
  TmpList := TStringList.Create;
  TmpList.CommaText := UserList;
  FUserList.Clear;
//  FUserList.CommaText := UserList;
  Index := 0;
  try
    //for i := 0 to FUserList.Count - 1 do
    while Index<TmpList.Count-2 do
    begin
      GetMem(TmpPointer,SizeOf(TRoomUserInfo));
      StrCopy(PRoomUserInfo(TmpPointer).UserName,PChar(TmpList.Strings[Index]));
      Inc(Index);
      PRoomUserInfo(TmpPointer).Status := StrToIntDef(TmpList.Strings[Index],0);
      Inc(Index);
      PRoomUserInfo(TmpPointer).Color := StrToIntDef(TmpList.Strings[Index],0);
      Inc(Index);
      FUserList.AddObject(PRoomUserInfo(TmpPointer).UserName,TObject(TmpPointer));
    end;
  finally
    TmpList.Free;
  end;
  PostMessage(FOWnerHandle,WCM_USERLIST,0,0);
end;

procedure TInputThread.ExecuteAdminInfoAllPacket(
  Packet: PAdminInfoAllPacket);
var
//  i: Integer;
  AllStr: string;
  AllStrList: TStringList;
  BanStringList: TStringList;
  BounceStringList: TStringList;
begin
  AllStrList := TStringList.Create;
  BanStringList := TStringList.Create;
  BounceStringList := TStringList.Create;

  FAdminInfo.RedDotText := Packet.RedDotText;
  FAdminInfo.RedDotMic := Packet.RedDotMic;
  FAdminInfo.RedDotVideo := Packet.RedDotVideo;
  FAdminInfo.AutoRedDotNewUsers := Packet.AutoRedDotNewUsers;

  AllStr := PChar(Cardinal(Packet)+SizeOf(TAdminInfoAllPacket));
  AllStrList.CommaText := AllStr;
  {
  for i := 0 to Packet.BounceCount - 1 do
  begin
    BounceStringList.Add(AllStrList.Strings[0]);
    AllStrList.Delete(0);
  end;

  AllStr := PChar(Cardinal(Packet)+SizeOf(TAdminInfoAllPacket)+Length(AllStr)+1);
  AllStrList.CommaText := AllStr;

  for i := 0 to Packet.BanCount - 1 do
  begin
    BanStringList.Add(AllStrList.Strings[0]);
    AllStrList.Delete(0);
  end;
  }
  FAdminInfo.BounceListStr := AllStrList.Strings[0]; //BounceStringList.CommaText;
  FAdminInfo.BanListStr :=  AllStrList.Strings[1];//BanStringList.CommaText;
  BounceStringList.Free;
  BanStringList.Free;
  AllStrList.Free;
  PostMessage(FOWnerHandle,WCM_ADMININFOALL,0,0);
end;

procedure TInputThread.ExecuteUserJoinLeftRoomPacket(Packet: PUserJoinLeftRoomPacket);
var
  UserName: string;
  TmpPointer: Pointer;
begin
  UserName := Packet.UserName;
  GetMem(TmpPointer,SizeOf(TRoomUserInfo));
  StrCopy(PRoomUserInfo(TmpPointer).UserName,PChar(UserName));
  PRoomUserInfo(TmpPointer).Color := Packet.Color;
  PRoomUserInfo(TmpPointer).Status := Packet.Status;
  PRoomUserInfo(TmpPointer).Direction := Packet.Direction;
  FJoinLeftCriticalSection.Enter;
  FJoinLeftList.AddObject(UserName,TObject(TmpPointer));
  FJoinLeftCriticalSection.Leave;
  PostMessage(FOWnerHandle,WCM_JOINLEFT,0,0);
end;

procedure TInputThread.ExecutePacket(Packet: PCommunicatorPacket);
begin
  case Packet.DataType of
  pdtRoomUserList: ExecuteRoomUserListPacket(PRoomUserListPacket(Packet));
  pdtUserJoinLeftRoom: ExecuteUserJoinLeftRoomPacket(PUserJoinLeftRoomPacket(Packet));
  pdtGroupMessage: ExecuteGroupMessagePacket(PGroupMessagePacket(Packet));
  pdtGroupVoicePacket: ExecuteGroupVoicePacket(PGroupVoicePacket(Packet));
  pdtReqNextVCPacket: ;//ExecuteReqNextVCPacket(PCommunicatorPacket(Packet));
  pdtMicGrantedPacket: ExecuteMicGrantedPacket(Packet);
//  pdtRaiseHandPacket: ExecuteUserStatChangedPacket(PRoomUserStatusChangedPacket(Packet));
  pdtRoomUserStatChange: ExecuteUserStatChangedPacket(PRoomUserStatusChangedPacket(Packet));
  pdtMicFreePacket: ExecuteMicFreePacket(Packet);
  pdtRoomWhisperPacket: ExecuteWhisperPacket(PRoomWhisperPacket(Packet));
  pdtRoomAlertPacket: ExecuteGroupAlertPacket(PRoomAlertPacket(Packet));
  pdtAdminInfoAll: ExecuteAdminInfoAllPacket(PAdminInfoAllPacket(Packet));
  pdtAdminOperationReport: ExecuteAdminOperationReportPacket(PAdminOperationReportPacket(Packet));
  pdtAdminOperation: ExecuteAdminOperationPacket(PAdminOperationPacket(Packet));
  pdtModifyRoomTitle: ExecuteRoomTitlePacket(PModifyRoomTitlePacket(Packet));
  end;
end;

procedure TInputThread.SendBuffer(Packet: Pointer; Size: Integer);
var
  LocalBuffer: Pointer;
begin
  if Size = 0 then Exit;
  GetMem(LocalBuffer,Size);
  CopyMemory(LocalBuffer,Packet,Size);
  FOutputCriticalSection.Enter;
  FOutputBufferList.Add(LocalBuffer);
  FOutputCriticalSection.Leave;
end;

procedure TInputThread.AddToPacketBuffer(Buffer: Pointer; Size: Integer);
var
  DestPtr: Pointer;
begin
  if FPacketBufferPtr + Size<65536 then
  begin
    DestPtr := Pointer(Cardinal(FPacketBuffer)+Cardinal(FPacketBufferPtr));
    Move(Buffer^,DestPtr^,Size);
    FPacketBufferPtr := FPacketBufferPtr + Size;
  end
  else
  begin
  end;
end;

procedure TInputThread.CheckAndProccessPacket;
var
  DestPtr: Pointer;
  NewPacketBufferLen: Integer;
begin
  while PCommunicatorPacket(FPacketBuffer).BufferSize <= FPacketBufferPtr do
  begin
    if PCommunicatorPacket(FPacketBuffer).Signature = PACKET_SIGNATURE then
      ExecutePacket(FPacketBuffer{,PCommunicatorPacket(FPacketBuffer).BufferSize})
    else
    begin
      DropInvalidPacket;
      Exit;  //we can not continue here because if there is no valid header signature found user thread will hang.
    end;
    NewPacketBufferLen := FPacketBufferPtr - PCommunicatorPacket(FPacketBuffer).BufferSize;
    DestPtr := Pointer(Cardinal(FPacketBuffer)+PCommunicatorPacket(FPacketBuffer).BufferSize);
    Move(DestPtr^, FPacketBuffer^, NewPacketBufferLen);
    FPacketBufferPtr := NewPacketBufferLen;
  end;
end;

procedure TInputThread.DropInvalidPacket;
var
  i: Integer;
  DestPtr: Pointer;
  NewPacketBufferLen: Integer;
  Location: Integer;
begin
  Location := -1;
  for i := 0 to FPacketBufferPtr - 2 do
    if PCommunicatorPacket(Cardinal(FPacketBuffer)+Cardinal(i)).Signature = PACKET_SIGNATURE then
    begin
      Location := i;
      break;
    end;
  if Location>0 then
  begin
    NewPacketBufferLen := FPacketBufferPtr - Location;
    DestPtr := Pointer(Cardinal(FPacketBuffer)+Cardinal(Location));
    Move(DestPtr^, FPacketBuffer^, NewPacketBufferLen);
    FPacketBufferPtr := NewPacketBufferLen;
  end;
end;

procedure TInputThread.ProccesPacket(Buffer: Pointer; BufSize: Integer);
begin
  AddToPacketBuffer(Buffer,BufSize);
  CheckAndProccessPacket;
end;

procedure TInputThread.ProcessInOutOperations;
var
  Buf: TIdBytes;
  Len: Integer;
  Buffer: Pointer;
  Connected: Boolean;
begin
  try
    Connected := TCPClient.Connected;
  except
    Connected := False;
  end;
  if not Connected then
  begin
    //ClientTimer.Enabled := False;
    PostMessage(OwnerHandle,WCM_Disconnected,0,0);
    Terminate;
    Exit;
  end;
  Len := TCPClient.IOHandler.InputBuffer.Size;
  if Len>0 then
  begin
    TCPClient.IOHandler.ReadBytes(Buf,Len);
    if Len<65536 then
    begin
      GetMem(Buffer,Len);
      CopyMemory(Buffer,@Buf[0],Len);
      try
        ProccesPacket(Buffer,Len);
      finally
        FreeMem(Buffer);
      end;
    end
    else
    begin     // Packet is to long: disconnect user and log event
    end;
  end;

  while FOutputBufferList.Count>0 do
  begin
    Buffer := FOutputBufferList.items[0];
    Len := PCommunicatorPacket(Buffer).BufferSize;
    SetLength(Buf,Len);
    CopyMemory(@Buf[0],Buffer,Len);
    try
      TCPClient.IOHandler.Write(Buf);
    except
      //ClientTimer.Enabled := False;
      PostMessage(OwnerHandle,WCM_Disconnected,0,0);
      Terminate;
      Exit;
    end;
    LastDataSentTime := Now;
    //SetLength(Buf,0);

    FOutputCriticalSection.Enter;
    FOutputBufferList.Delete(0);
    FOutputCriticalSection.Leave;
    FreeMem(Buffer);
  end;
end;

procedure TInputThread.ExecuteRoomTitlePacket(
  Packet: PModifyRoomTitlePacket);
begin
  PByte(Pointer(Cardinal(Packet)+Packet.BufferSize-1))^ := 0;
  FGroupTitle := PChar(Pointer(Cardinal(Packet)+SizeOf(TModifyRoomTitlePacket)));
  PostMessage(FOWnerHandle,WCM_GROUPTITLE,0,0);
end;

procedure TInputThread.ExecuteAdminOperationPacket(
  Packet: PAdminOperationPacket);
begin
  AdminOperationListCriticalSection.Enter;
  AdminOperationList.AddObject(Packet.UserName,TObject(Packet.Operation));
  AdminOperationListCriticalSection.Leave;
  PostMessage(OwnerHandle,WCM_ADMINOPERATION,0,0);
end;

{ TRoomWindow }
procedure TRoomWindow.ConnectToRoom;
begin

end;

procedure TRoomWindow.FormShow(Sender: TObject);
var
  StrList: TStringList;
begin
  WMExist := False;
  FRoomStrQueue := TStringList.Create;
  MicButton.Glyph := OffImage.Picture.Bitmap;
  VoiceMemoryStream := TMemoryStream.Create;
  StrList := TStringList.Create;
  {Viewer.LoadStrings(StrList);   }
  StrList.Free;

  GetMem(InBuffer,65536);
  GetMem(TmpBuffer,65536);
{
  ClientThread := TClientThread.Create(True);
  ClientThread.RemoteHost := MainForm.ServerIp;
  ClientThread.RemotePort := IntToStr(RoomPort);
  ClientThread.OwnerHandle := Handle;
  ClientThread.Connect;
  ClientThread.Resume;
  ClientThread.FreeOnTerminate := False;
}
  SmileStringList := TStringList.Create;
  FillSmileStringList;
  VoiceEnable := True;
  InputThread := TInputThread.Create(True);
  InputThread.Owner := Self;
  InputThread.OwnerHandle := Handle;
//  InputThread.ClientThread := ClientThread;
  InputThread.FreeOnTerminate := False;
  InputThread.TCPClient.Host := MainForm.ServerIP;
  InputThread.TCPClient.Port := RoomPort;
  InputThread.TCPClient.Connect;
  InputThread.Resume;
  {$IFDEF AUDIOLOG}
  TestAudioFile := TFileStream.Create('C:\Room Capture'+FloatToStr(Now)+'.mp3',fmCreate);
  {$ENDIF}
  Caption := 'Private #'+IntToStr(RoomCode);
  MeterTimer.Enabled := True;
  FAdminControlPanel := TAdminControlPanel.Create(Self);
  MainForm.VolumeControlOwnerHandle := Handle;
  FVolumeControlForm := TVolControlForm.Create(Self);
  BoldButton.Down := MainForm.UserSetting.GroupBold;
  ItalicButton.Down := MainForm.UserSetting.GroupItalic;
  UnderLineButton.Down := MainForm.UserSetting.GroupUnderLine;

  BoldButtonClick(Self);
  ItalicButtonClick(Self);
  UnderLineButtonClick(Self);

  InputMemo.SelAttributes.Color := MainForm.UserSetting.GroupColor;
  CurrentColor := MainForm.UserSetting.GroupColor;
  FontSizeCombo.ItemIndex := MainForm.UserSetting.GroupFontSize;
  FontSizeComboChange(Self);

  Notifymewhenauserlefttheroom1.Checked := MainForm.UserSetting.GroupLeftNotify;
  Notifymewhenauserjoinedtheroom1.Checked := MainForm.UserSetting.GroupJoinNotify;
  Color := MainForm.SplitterColor;
  PostMessage(Handle,WCM_JoinRoomInfo,0,0);
  RoomTitleRichEdit.Text := '';
  WebBrowser1.Navigate('http://www.beyluxe.com/tssed/');
  WebBrowser1.Visible := False;
  //Menubar.Color := MainForm.MenuBarColor;
end;

procedure TRoomWindow.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TimeOut: Integer;
begin
  FVolumeControlForm.Free;
  Streaming := False;
  VoiceEnable := False;
  if MainForm.ActiveRoomWindow = Self then // This is because calling sendvoicepacket
    MainForm.ActiveRoomWindow := nil;      // may cause exceptions
  FRoomClosing := True;
  FRoomStrQueue.Free;
  FAdminControlPanel.Free;
  MeterTimer.Enabled := True;
  InputThread.Terminate;
  TimeOut := 0;
  while not InputThread.ThreadTerminated do
  begin
    Inc(TimeOut);
    Sleep(1);
    if TimeOut>2000 then
      Break;
    //Application.HandleMessage;
  end;
  try
    InputThread.TCPClient.Disconnect;
  except
  end;
  InputThread.Free;
  SmileStringList.Free;
  Streaming := False;
  //MainForm.PlayThread.SendVoiceBufferProc := nil;
  while SendVoiceIsBusy do
    Sleep(1);
  //ClientThread.Terminate;
  //while not ClientThread.ThreadTerminated do
  //  Sleep(1);
  //ClientThread.Free;
  while UsersListView.Items.Count>0 do
  begin
    FreeMem(UsersListView.Items.Item[0].Data);
    UsersListView.Items.Delete(0);
  end;

  {$IFDEF AUDIOLOG}
  TestAudioFile.Free;
  {$ENDIF}

  FreeMem(TmpBuffer);
  FreeMem(InBuffer);
  VoiceMemoryStream.Free;
  PostMessage(MainForm.Handle,WCM_DestroyMePrvRoom,Integer(Self),0);
end;

procedure TRoomWindow.JoinRoomInfo(var msg: TMessage);
var
  Packet: TJoinPrvRoomReqPacket;
begin
  if FRoomClosing then Exit;
  ZeroMemory(@Packet,SizeOf(TJoinPrvRoomReqPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtJoinPrvRoomReq;
  Packet.BufferSize := SizeOf(TJoinPrvRoomReqPacket);
  StrCopy(Packet.UserName,PChar(MainForm.MyNickName));
  StrCopy(Packet.GrantCode,PChar(GrantCode));
  SendBuffer(Packet,SizeOf(TJoinPrvRoomReqPacket));
  if MainForm.PlayThread.InitializeError then
    MainForm.AudioEnable := False;
  if not MainForm.AudioEnable then
  begin
    MuteButtonClick(Self);
    MuteButton.Enabled := False;
    Image1.Enabled := False;
  end;
end;

procedure TRoomWindow.SendTextToRoom(User, Text: string;
  UserColor: TColor);
var
  Str: string;
begin
  if FRoomClosing then Exit;
  if User = MainForm.MyNickName then
    Str := '<B><font size=0 color=#'+IntToHex(WebColor(MYNICKCOLOR),8)+'>'+User+':</font></B> '
  else
    Str := '<B><font size=0 color=#'+IntToHex(WebColor(BUDDYNICKCOLOR),8)+'>'+User+':</font></B> ';

  Str := Str + ReplaceSmilesText(' '+Text);
  Str := CorrectHTMLLinks(Str);
  AddToHTMLViewer(Str);
end;

procedure TRoomWindow.SendButtonClick(Sender: TObject);
var
  Str: string;
  HTMLText: string;
begin
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
  if InputMemo.Text ='' then
    Exit;
  HTMLText := RtfToHtml('',InputMemo);
  HTMLText := CorrectHTMLCode(HTMLText);
  Str := Str + HTMLText;
  SendTextToRoom(MainForm.MyNickName,Str,0); // baraye zood raftane text dar roomezafe shod   //
                                             // va hamchenin bargasht az server disable shod  //
  SendGroupMessageToServer(HTMLText);
  InputMemo.Clear;
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TRoomWindow.InputMemoKeyPress(Sender: TObject; var Key: Char);
begin
  SynchronizeInputFontStyles;
  if Key = #13 then
  begin
    SendButtonClick(Self);
    Key := #0;
  end;
  ActiveControl := InputMemo;
end;

procedure TRoomWindow.SendVoicePacket(Buf: Pointer; Size: Integer);
var
  Packet: PGroupVoicePacket;
begin
  if Streaming and VoiceEnable then
  begin
    SendVoiceIsBusy := True;
    if VoiceMemoryStream.Size>8096 then
      VoiceMemoryStream.Clear;
    VoiceMemoryStream.Write(Buf^,Size);
    if VoiceMemoryStream.Size<MINMP3BUFTOSEND then
    begin
      SendVoiceIsBusy := False;
      Exit;
    end;
    GetMem(Packet,SizeOf(TGroupVoicePacket)+VoiceMemoryStream.Size);
    ZeroMemory(Packet,SizeOf(TGroupVoicePacket)+VoiceMemoryStream.Size);
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtGroupVoicePacket + 100;
    Packet.BufferSize := VoiceMemoryStream.Size + SizeOf(TGroupVoicePacket);
    Packet.RoomCode := RoomCode;
    StrCopy(Packet.UserName,PChar(MainForm.MyNickName));
    CopyMemory(Pointer(Cardinal(Packet)+SizeOf(TGroupVoicePacket)),VoiceMemoryStream.Memory,VoiceMemoryStream.Size);
    SendBuffer(Packet^,SizeOf(TGroupVoicePacket)+VoiceMemoryStream.Size);
    VoiceMemoryStream.Clear;
    FreeMem(Packet);
    SendVoiceIsBusy := False;
  end;
end;

procedure TRoomWindow.MicButtonClick(Sender: TObject);
var
  Packet: TCommunicatorPacket;
  msg: TMessage;
begin
  if Streaming then
  begin
    Streaming := False;
    RemoveMicIcon(Msg);
    //UserOnMic('');
    //MicButton.Caption := 'Free';
    MicButton.Glyph := OffImage.Picture.Bitmap;
    mVoiceActivate.Checked := False;
  end
  else
  begin
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtMicRequestPacket;
    Packet.BufferSize := SizeOf(TCommunicatorPacket);
    SendBuffer(Packet,SizeOf(TCommunicatorPacket));
  end;
end;

procedure TRoomWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TRoomWindow.SendBuffer(const Buffer; Size: Integer);
begin
  InputThread.SendBuffer(@Buffer,Size);
end;

procedure TRoomWindow.RemoveMicIcon(var msg: TMessage);
var
  i: Integer;
  LastRaiseHand: Integer;
begin
  if FRoomClosing then Exit;
  if not Streaming then
  begin
    for i := 0 to UsersListView.Items.Count-1 do
      if UsersListView.Items.Item[i].ImageIndex = 1 then
      begin
        UsersListView.Items.Item[i].ImageIndex := 0;
        UpdateThisUserIcon(UsersListView.Items.Item[i]);
        break;
      end;
    LastRaiseHand := GetLastRaiseIndex;
    if LastRaiseHand>1 then
      MoveUserListItem(0,LastRaiseHand);
  end;
{
  if FRoomClosing then Exit;
  if not Streaming then
    for i := 0 to UsersListView.Items.Count-1 do
      if UsersListView.Items.Item[i].ImageIndex = 1 then
      begin
        UsersListView.Items.Item[i].ImageIndex := 0;
        UpdateThisUserIcon(UsersListView.Items.Item[i]);
        break;
      end;
  LastRaiseHand := GetLastRaiseIndex;
  if LastRaiseHand>1 then
    MoveUserListItem(0,LastRaiseHand);
}
end;

procedure TRoomWindow.SpeedButton4Click(Sender: TObject);
var
//  ColorDialog: THCColorDialog;
  MyPoint: TPoint;
begin
{
  ColorDialog := THCColorDialog.Create(Self);
  if ColorDialog.Execute then
    CurrentColor := ColorDialog.Color;
  InputMemo.SelAttributes.Color := CurrentColor;
  ColorDialog.Free;
  ActiveControl := InputMemo;
}
  GetCursorPos(MyPoint);
  ColorPOPUP.Popup(MyPoint.X,MyPoint.Y);
  //ClientToScreen()
end;

procedure TRoomWindow.BoldButtonClick(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    if BoldButton.Down then
      Style := Style + [fsBold]
    else
      Style := Style - [fsBold];
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TRoomWindow.ItalicButtonClick(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    if ItalicButton.Down then
      Style := Style + [fsItalic]
    else
      Style := Style - [fsItalic];
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TRoomWindow.UnderLineButtonClick(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    if UnderLineButton.Down then
      Style := Style + [fsUnderline]
    else
      Style := Style - [fsUnderline];
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TRoomWindow.FontSizeComboChange(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    case FontSizeCombo.ItemIndex of
    0: Size := 10;
    1: Size := 12;
    2: Size := 16;
    end;
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TRoomWindow.SynchronizeInputFontStyles;
var
  FontStyle: TFontStyles;
  FontSize: Integer;
begin
  FontSize := 10;
  case FontSizeCombo.ItemIndex of
  0: FontSize := 10;
  1: FontSize := 12;
  2: FontSize := 16;
  end;
  FontStyle := [];
  if ItalicButton.Down then
    FontStyle := FontStyle + [fsItalic];
  if UnderLineButton.Down then
    FontStyle := FontStyle + [fsUnderline];

  if BoldButton.Down then
    FontStyle := FontStyle + [fsBold];

  if InputMemo.SelAttributes.Color <> CurrentColor then
    InputMemo.SelAttributes.Color := CurrentColor;

  if InputMemo.SelAttributes.Style <> FontStyle then
    InputMemo.SelAttributes.Style := FontStyle;

  if InputMemo.SelAttributes.Size <> FontSize then
    InputMemo.SelAttributes.Size := FontSize;
end;

procedure TRoomWindow.SendGroupMessageToServer(Msg: string);
var
  Packet: PGroupMessagePacket;
  PacketSize: Cardinal;
begin
  if FRoomClosing then Exit;
  //Msg := UTF8Encode(Msg);
  PacketSize := SizeOf(TGroupMessagePacket)+Length(Msg)+1;
  GetMem(Packet,PacketSize);
  ZeroMemory(Packet,PacketSize);
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtGroupMessage;
  Packet.BufferSize := PacketSize;
  Packet.RoomCode := RoomCode;
  StrCopy(Packet.UserName,PChar(MainForm.MyNickName));
  StrCopy(PChar(Cardinal(Packet)+SizeOf(TGroupMessagePacket)),PChar(Msg));
  PByte(Cardinal(Packet)+PacketSize-1)^ := 0;
  SendBuffer(Packet^,PacketSize);
  FreeMem(Packet);
end;

procedure TRoomWindow.SmileButtonClick(Sender: TObject);
var
  WhereToShow: TPoint;
begin
  GetCursorPos(WhereToShow);
  MainForm.ActiveRichEdit := InputMemo;
  MainForm.SmilePOPUP.Popup(WhereToShow.X,WhereToShow.Y-(7*24+5));
  if InputMemo.Enabled then
    InputMemo.SetFocus;
end;

function TRoomWindow.ReplaceSmilesText(Str: string): string;
var
  i,j: Integer;
  Tmp: Integer;
  MyStr: string;
  MinPos,MinIndex: Integer;
begin
  MyStr := Str;
  for j := 0 to 5 do
  begin
    MinIndex := -1;
    MinPos := Length(MyStr);
    for i := 0 to SmileStringList.Count -1 do
    begin
      Tmp := Pos(SmileStringList.Strings[i],MyStr);
      if (Tmp>0) and (Tmp<MinPos) then
      begin
        MinPos := Tmp;
        MinIndex := i;
      end;
    end;
    if MinIndex>-1 then
      MyStr := StringReplace(MyStr,SmileStringList.Strings[MinIndex],'<IMG src="'+IntToStr(Integer(SmileStringList.Objects[MinIndex]))+'"></IMG>',[rfIgnoreCase]);
  end;
  Result := MyStr;
end;

procedure TRoomWindow.FillSmileStringList;
var
  i: Integer;
  MaxLength: Integer;
  SmileStr: string;
begin
  
  MaxLength := 0;
  for i := 0 To SmilesForm.SmileStrList.Count - 1 do
  begin
    SmileStr := SmilesForm.SmileStrList.Strings[i];
    SmileStr := StringReplace(SmileStr,'<','&lt;',[rfReplaceAll]);
    SmileStr := StringReplace(SmileStr,'>','&gt;',[rfReplaceAll]);
    SmileStr := StringReplace(SmileStr,'"','&quot;',[rfReplaceAll]);
    if Length(SmileStr)>MaxLength then
      MaxLength := Length(SmileStr);
  end;
  while MaxLength>1 do
  begin
    for i := 0 To SmilesForm.SmileStrList.Count - 1 do
    begin
      SmileStr := SmilesForm.SmileStrList.Strings[i];
      SmileStr := StringReplace(SmileStr,'<','&lt;',[rfReplaceAll]);
      SmileStr := StringReplace(SmileStr,'>','&gt;',[rfReplaceAll]);
      SmileStr := StringReplace(SmileStr,'"','&quot;',[rfReplaceAll]);
      if Length(SmileStr)=MaxLength then
      begin
        SmileStringList.AddObject(SmileStr,TObject(i));
      end;
    end;
    Dec(MaxLength);
  end;
end;

procedure TRoomWindow.ViewerImageRequest(Sender: TObject;
  const SRC: string; var Stream: TMemoryStream);
var
  ImageIndex: Integer;
begin
  ImageIndex := StrToIntDef(SRC,0);
  if (ImageIndex>-1) and (ImageIndex<MainForm.SmilesStreamList.Count) then
    Stream := TMemoryStream(MainForm.SmilesStreamList.Items[ImageIndex]);
end;

procedure TRoomWindow.ViewerHotSpotClick(Sender: TObject;
  const SRC: String; var Handled: Boolean);
begin
  if RightStr(SRC,1)<>'/' then
    Handled := BrowseURL('http://beyluxe.com/protection/check.php?link='+SRC+'/')
  else
    Handled := BrowseURL('http://beyluxe.com/protection/check.php?link='+SRC);
end;

procedure TRoomWindow.Copy2Click(Sender: TObject);
begin
  //Viewer.CopyToClipboard;
end;

procedure TRoomWindow.ExecuteMicGrantedPacket(Packet: PCommunicatorPacket);
begin
  if FRoomClosing then Exit;
  Streaming := True;
  UserOnMic(MainForm.MyNickName);
  RaiseHandButton.Down := False;
  MicButton.Glyph := HotImage.Picture.Bitmap;
  //MicButton.Caption := 'Transfering'
end;

procedure TRoomWindow.UserOnMic(UserName: string);
var
  i: Integer;
begin
  if UsersListView.Items.Count = 0 then
    Exit;
  if (UserName<>MainForm.MyNickName) and (MicButton.Glyph = HotImage.Picture.Bitmap) then
    MicButton.Glyph := OffImage.Picture.Bitmap;
    //MicButton.Caption := 'Free';
  if (UserName = PRoomUserInfo(UsersListView.Items.Item[0].Data).UserName) and
     (UsersListView.Items.Item[0].ImageIndex = 1) then
     Exit;

  if UsersListView.Items.Item[0].ImageIndex = 1 then   // In order to fix the last bug with mic
  begin
     UsersListView.Items.Item[0].ImageIndex := 0;
     MoveUserListItem(0,GetLastRaiseIndex);            //
  end;
  // clear all mic icons
  for i := 0 to UsersListView.Items.Count-1 do
    if UsersListView.Items.Item[i].ImageIndex = 1 then
    begin
      UsersListView.Items.Item[i].ImageIndex := 0;
      break;
    end;

  for i := 0 to UsersListView.Items.Count-1 do
    if (PRoomUserInfo(UsersListView.Items.Item[i].Data).UserName = UserName) then
    begin
      if i<>0 then
      begin
        MoveUserListItem(i,0);
        UsersListView.Items[0].ImageIndex := 1;
      end
      else
      begin
        if UsersListView.Items[0].ImageIndex<>1 then
          UsersListView.Items[0].ImageIndex := 1;
      end;
      Exit;
    end;
end;

procedure TRoomWindow.UsersListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  UsersListView.Canvas.Font.Color := PRoomUserInfo(Item.Data).Color;
end;

procedure TRoomWindow.RaiseHandButtonClick(Sender: TObject);
var
  Packet: TRaiseHandPacket;
begin
  if Streaming then
    Exit;
  if Sender = RaiseHandButton then
    RaiseHandButton.Down := not RaiseHandButton.Down;
  ZeroMemory(@Packet,SizeOf(TRaiseHandPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtRaiseHandPacket;
  Packet.BufferSize := SizeOf(TRaiseHandPacket);
  if RaiseHandButton.Down then
  begin
    Packet.RaiseHand := 0;
    //RaiseHandButton.Down := False;
  end
  else
  begin
    Packet.RaiseHand := 1;
    //RaiseHandButton.Down := True;
  end;
  StrCopy(Packet.UserName,PChar(MainForm.MyNickName));
  SendBuffer(Packet,SizeOf(TRaiseHandPacket));
end;

procedure TRoomWindow.ExecuteMicFreePacket(Packet: PCommunicatorPacket);
begin
  if FRoomClosing then Exit;
  if Streaming then
  begin
    Streaming := False;
    //MicButton.Caption := 'Free';
    MicButton.Glyph := OffImage.Picture.Bitmap;
    RemoveMicIcon(TMessage(nil^));
  end;
end;

procedure TRoomWindow.FormActivate(Sender: TObject);
begin
  if MainForm.AudioEnable then
  begin
    if FRoomClosing then Exit; // fix Exception while closing the room as admin
    IsActive := True;
    MainForm.ActiveRoomWindow := Self;

    // I put the following "if" because sometimes formactivate event
    // triggered before formshow on some systems and on this time
    // FVolumeControlForm not created so we will get exception on
    // call to OutputVolumeCahnged
    if FVolumeControlForm<>nil then
      OutputVolumeCahnged(Self);
    MainForm.PlayThread.RoomWindowHandle := Handle;
  end;
end;

procedure TRoomWindow.FormDeactivate(Sender: TObject);
begin
  IsActive := False;
end;

procedure TRoomWindow.HandleUserOnMic(var msg: TMessage);
begin
  if FRoomClosing then Exit;
  UserOnMic(InputThread.UserOnMic);
end;

procedure TRoomWindow.HandleGroupMsgPacket(var msg: TMessage);
var
  MsgSender: string;
  MsgText: string;
  FlashInfo: TFlashWInfo;
begin
  if FRoomClosing {or DisplayFreezed} then Exit;
  while InputThread.GroupMessageSenderList.Count > 0 do
  begin
    MsgSender := InputThread.FGroupMessageSenderList.Strings[0];
    MsgText := InputThread.FGroupMessageList.Strings[0];
    InputThread.GroupMsgCriticalSection.Enter;
    InputThread.FGroupMessageSenderList.Delete(0);
    InputThread.FGroupMessageList.Delete(0);
    InputThread.GroupMsgCriticalSection.Leave;
    SendTextToRoom(MsgSender,MsgText,clBlue);
    WMSendString(MsgSender,MsgText);
    if GetForegroundWindow<>Handle then
    begin
      FlashInfo.cbSize := SizeOf(TFlashWInfo);
      FlashInfo.dwFlags := FLASHW_CAPTION or FLASHW_TRAY;
      FlashInfo.uCount := 1;
      FlashInfo.dwTimeout := 1000;
      FlashInfo.hwnd := Handle;
      FlashWindowEx(FlashInfo);
    end;
  end;
end;

procedure TRoomWindow.HandleJoinLeftPacket(var msg: TMessage);
var
  i: Integer;
  Data: PRoomUserInfo;
  UserName: string;
  Direction: Byte;
  Status: Cardinal;
  Str: string;
begin
  if FRoomClosing then Exit;
  while InputThread.JoinLeftList.Count>0 do
  begin
    UserName := InputThread.JoinLeftList.Strings[0];
    Data := PRoomUserInfo(InputThread.JoinLeftList.Objects[0]);
    InputThread.JoinLeftCriticalSection.Enter;
    InputThread.JoinLeftList.Delete(0);
    InputThread.JoinLeftCriticalSection.Leave;
    Direction := Data.Direction;
    Status := Data.Status;
    if Direction = 1 then
    begin
      for i := 0 to UsersListView.Items.Count-1 do
        if PRoomUserInfo(UsersListView.Items.Item[i].Data).UserName = UserName then
        begin
          FreeMem(UsersListView.Items.Item[i].Data);
          UsersListView.Items.Delete(i);
          break;
        end;
      if Notifymewhenauserlefttheroom1.Checked then
      begin
        Str := '<font size=1 color=#'+IntToHex(WebColor(LEFTROOMCOLOR),8)+'>'+UserName+' has left the room.</font>';
        AddToHTMLViewer(Str);
      end;
      FreeMem(Data);
    end
    else
    begin
      UsersListView.Items.Add;
      if Status and 7>0 then
        UsersListView.Items.Item[UsersListView.Items.Count - 1].Caption := '@'+UserName
      else
        UsersListView.Items.Item[UsersListView.Items.Count - 1].Caption := UserName;
      UsersListView.Items.Item[UsersListView.Items.Count - 1].Data := Data;
      UpdateAdminStatForThisUser(UsersListView.Items.Count - 1);
{
      UsersListView.Items.Item[UsersListView.Items.Count - 1].ImageIndex := -1;
      if (Status and $10)>0 then
        UsersListView.Items.Item[UsersListView.Items.Count - 1].ImageIndex := 2
      else
      if (Status and $E0)>0 then
        UsersListView.Items.Item[UsersListView.Items.Count - 1].ImageIndex := 3;
      UsersListView.Items.Item[UsersListView.Items.Count - 1].Data := Data;     }
      UpdateThisUserIcon(UsersListView.Items.Item[UsersListView.Items.Count - 1]);
      if Notifymewhenauserjoinedtheroom1.Checked then
      begin
        Str := '<font size=1 color=#'+IntToHex(WebColor(JOINROOMCOLOR),8)+'>'+UserName+' has joined the room.</font>';
        AddToHTMLViewer(Str);
      end;
    end;
  end;
end;

procedure TRoomWindow.Notifymewhenauserjoinedtheroom1Click(
  Sender: TObject);
begin
  Notifymewhenauserjoinedtheroom1.Checked := not Notifymewhenauserjoinedtheroom1.Checked;
end;

procedure TRoomWindow.Notifymewhenauserlefttheroom1Click(Sender: TObject);
begin
  Notifymewhenauserlefttheroom1.Checked := not Notifymewhenauserlefttheroom1.Checked;
end;

procedure TRoomWindow.HandleMicGrantedPacket(var msg: TMessage);
begin
  if FRoomClosing then Exit;
  ExecuteMicGrantedPacket(nil);
end;

procedure TRoomWindow.HandleUserListPacket(var msg: TMessage);
var
  i: Integer;
  Status: Cardinal;
begin
  if FRoomClosing then Exit;

/////////////////////////////////////
//  User Status Byte Format        //
//       Bit 0,1,2,3: Privilege    //
//       Bit 4: Video              //
//       Bit 5: Raise Hand         //
//       Bit 6: Red Dot Text       //
//       Bit 7: Red Dot Mic        //
//       Bit 8: Red Dot Video      //
//       Bit 9: BRB                //
//       Bit 9:
/////////////////////////////////////

  //PByte(Cardinal(Packet)+Packet.BufferSize)^ := 0;
  //UserList := Pointer(Cardinal(Packet)+SizeOf(TRoomUserListPacket));
  //RoomUserList.CommaText := UserList;


  //UsersListView.Items.Clear;
  while UsersListView.Items.Count>0 do
  begin
    FreeMem(UsersListView.Items.Item[0].Data);
    UsersListView.Items.Delete(0);
  end;


  //StatusArray := PWordArray(Cardinal(Packet)+SizeOf(TRoomUserListPacket)+StrLen(UserList)+1);
  for i := 0 to InputThread.UserList.Count - 1 do
  begin
    UsersListView.Items.Add;
{
    Status := PRoomUserInfo(InputThread.UserList.Objects[i]).Status;
    if Status and $F >0 then
    begin
      UsersListView.Items.Item[i].Caption := '@'+InputThread.UserList.Strings[i];
      if PRoomUserInfo(InputThread.UserList.Objects[i]).UserName=MainForm.MyNickName then
        EnableAdminControls;
    end
    else
      UsersListView.Items.Item[i].Caption := InputThread.UserList.Strings[i];


    if (Status and $10)>0 then
      UsersListView.Items.Item[i].ImageIndex := 2
    else
    if (Status and $E0)>0 then
      UsersListView.Items.Item[i].ImageIndex := 3;
}
    Status := PRoomUserInfo(InputThread.UserList.Objects[i]).Status;
    UsersListView.Items.Item[i].Data := PRoomUserInfo(InputThread.UserList.Objects[i]);
    if Status and $40>0 then
      RedDotTextThisUser(i);
    if Status and $80>0 then
      RedDotMicThisUser(i);
    if Status and $100>0 then
      RedDotVideoThisUser(i);
    UpdateAdminStatForThisUser(i);
    UpdateThisUserIcon(UsersListView.Items.Item[i]);
  end;
  InputThread.UserList.Clear;
end;

procedure TRoomWindow.HandleMicFreePacket(var msg: TMessage);
begin
  if FRoomClosing then Exit;
  ExecuteMicFreePacket(nil);
end;

procedure TRoomWindow.ClearScreen1Click(Sender: TObject);
begin
  //Viewer.Clear;
  //Viewer.Reformat;
end;

procedure TRoomWindow.Viewwebcam1Click(Sender: TObject);
begin
  //TADD WEBCAM
  if UsersListView.ItemIndex<>-1 then
    MainForm.StartViewCamRequest(POPUPActiveUserName);
end;

procedure TRoomWindow.StartCamButtonClick(Sender: TObject);
begin
  MainForm.StartCamRequest(0);
end;

procedure TRoomWindow.InviteButtonClick(Sender: TObject);
var
  InviteUserForm: TInviteUserForm;
  i: Integer;
begin
  MainForm.InviteToRoomFormOwner := Self;
  InviteUserForm := TInviteUserForm.Create(Self);
  InviteUserForm.ShowModal;

  if InviteUserForm.ModalResult = mrOk then
    if RoomType = 1 then
      for i := 0 to InviteUserForm.UsersListView.Items.Count - 1 do
      begin
        if InviteUserForm.UsersListView.Items.Item[i].Checked then
          MainForm.InviteUserToPrivate(InviteUserForm.UsersListView.Items.Item[i].Caption,RoomCode);
      end
    else
      for i := 0 to InviteUserForm.UsersListView.Items.Count - 1 do
      begin
        if InviteUserForm.UsersListView.Items.Item[i].Checked then
          MainForm.InviteUserToRoom(InviteUserForm.UsersListView.Items.Item[i].Caption,Caption,RoomType);
      end;
  InviteUserForm.Close;
end;

procedure TRoomWindow.MeterTimerTimer(Sender: TObject);
begin
  if DisplayFreezed then
  begin
    if MilliSecondsBetween(Now,DisPlayFreezTime)>MainForm.SystemPreferences.AutoUnfreezScreen * 1000 then
    begin
      DisplayFreezed := False;
      FreezDisplay.Checked := False;
      //PostMessage(Handle,WCM_GROUPMSG,0,0);
    end;
  end;
  if not MainForm.AudioEnable then
  begin
    //PlayMeter.Position := 0;
    //RecordMeter.Position := 0;
    Exit;
  end;
  if MainForm.ActiveRoomWindow = Self then
  begin
    //PlayMeter.Position := MainForm.PlayThread.PlayMeterValue + 100;
    //RecordMeter.Position := MainForm.PlayThread.RecMeterValue + 100;
  end;
end;

procedure TRoomWindow.Image1Click(Sender: TObject);
var
  PointToShow: TPoint;
begin
  PointToShow := ClientToScreen(Point(Image1.Left+Image1.Width div 2,Image1.Top + Image1.Height div 2 - FVolumeControlForm.Height));
  FVolumeControlForm.Left := PointToShow.X+Panel9.Left+Panel2.Left;
  FVolumeControlForm.Top := PointToShow.Y+Panel9.Top+Panel2.Top;
  FVolumeControlForm.VolumeControl.OnChange := OutputVolumeCahnged;
  FVolumeControlForm.Show;
end;

procedure TRoomWindow.ListViewPOPUPMenuPopup(Sender: TObject);
var
  Item: TListItem;
begin
  if UsersListView.ItemIndex<>-1 then
  begin
    Item := UsersListView.Items[UsersListView.ItemIndex];
    POPUPActiveUserName := PRoomUserInfo(Item.Data).UserName;
    {
    if POPUPActiveUserName = MainForm.MyNickName then
    begin
      mBRB.Visible := True;
      mBRBSeperator.Visible := True;
      if FBRB then
        mBRB.Caption := 'Remove BRB Icon'
      else
        mBRB.Caption := 'Show BRB Icon';
    end;
    }
  end
  else
    POPUPActiveUserName := '';
end;

procedure TRoomWindow.EnableAdminControls;
begin
  if FRoomClosing then Exit;
  AdminMenu.Visible := True;
  UsersListView.PopupMenu := AdminListViewPOPUPMenu;
end;

procedure TRoomWindow.DisableAdminControls;
begin
  AdminMenu.Visible := False;
  UsersListView.PopupMenu := ListViewPOPUPMenu;
end;

procedure TRoomWindow.mBounceUserClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex<>-1 then
  begin
    ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtAdminOperation;
    Packet.BufferSize := SizeOf(TAdminOperationPacket);
    StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items.Item[UsersListView.ItemIndex].Data).UserName);
    //Packet.UserName := ActiveUserNameForPopup;
    Packet.Operation := 8;  // Bit 4 = 1  //
    InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
  end;
end;

{
procedure TRoomWindow.HandleUserStatChagedPacket(var msg: TMessage);
var
  i: Integer;
  UserIndex: Integer;
  LastRaiseIndex: Integer;
  UserName: string;
  RaiseHand: Boolean;
begin
  LastRaiseIndex := -1;
  UserIndex := -1;
  while InputThread.RaiseHandList.Count>0 do
  begin
    UserName := InputThread.RaiseHandList.Strings[0];
    RaiseHand := Boolean(Cardinal(InputThread.RaiseHandList.Objects[0]) and $10);
    InputThread.RaiseHandCriticalSection.Enter;
    InputThread.RaiseHandList.Delete(0);
    InputThread.RaiseHandCriticalSection.Leave;
    for i := 0 to UsersListView.Items.Count - 1 do
      if PRoomUserInfo(UsersListView.Items.Item[i].Data).UserName = UserName then
      begin
        UserIndex := i;
        break;
      end;
    for i := 0 to UsersListView.Items.Count - 1 do
      if (UsersListView.Items.Item[i].ImageIndex<>1) and
         (UsersListView.Items.Item[i].ImageIndex<>2) then
      begin
        LastRaiseIndex := i;
        break;
      end;
    if LastRaiseIndex = -1 then
      LastRaiseIndex := UsersListView.Items.Count - 1;
    if UserIndex = LastRaiseIndex then
    begin
      if RaiseHand then
        UsersListView.Items[LastRaiseIndex].ImageIndex := 2
      else
        UsersListView.Items[LastRaiseIndex].ImageIndex := 0;

      if UserName=MainForm.MyNickName then
        RaiseHandButton.Down := RaiseHand;
      UsersListView.Repaint;
      Continue;
    end;
    if (LastRaiseIndex<>-1) and (UserIndex<>-1) then
    begin
      ExchangeUserListItem(LastRaiseIndex,UserIndex);
      if RaiseHand then
      begin
        UsersListView.Items[LastRaiseIndex].ImageIndex := 2;
        if UserName=MainForm.MyNickName then
          RaiseHandButton.Down := RaiseHand;
      end
      else
      begin
        UsersListView.Items[LastRaiseIndex].ImageIndex := 0;
        if UserName=MainForm.MyNickName then
          RaiseHandButton.Down := RaiseHand;
      end;
    end;
    UsersListView.Repaint;
  end;
end;
}

procedure TRoomWindow.HandleUserStatChagedPacket(var msg: TMessage);
var
  i,j: Integer;
  UserIndex: Integer;
  UserName: string;
  Status: Cardinal;
  StatusDifference: Cardinal;
begin
  if FRoomClosing then Exit;
  UserIndex := -1;
  while InputThread.UserStatusList.Count>0 do
  begin
    UserName := InputThread.UserStatusList.Strings[0];
    Status := Cardinal(InputThread.UserStatusList.Objects[0]);
    InputThread.UserStatusCriticalSection.Enter;
    InputThread.UserStatusList.Delete(0);
    InputThread.UserStatusCriticalSection.Leave;
    for i := 0 to UsersListView.Items.Count - 1 do
      if PRoomUserInfo(UsersListView.Items.Item[i].Data).UserName = UserName then
      begin
        UserIndex := i;
        break;
      end;

    // remember we had read access violation exception on the line below
    // for now we prevent it by checking UserIndex but in the future we
    // have to look for its reason
    //(why some times user not exist in the room)
    // Or maybe we would like to add user to userlist right now.
    if UserIndex=-1 then
      Continue;


    StatusDifference := PRoomUserInfo(UsersListView.Items.Item[UserIndex].Data).Status xor Status;

    /////////////////////////////////////
    //  User Status Format             //
    //       Bit 0,1,2,3: Privilege    //
    //       Bit 4: Video              //
    //       Bit 5: Raise Hand         //
    //       Bit 6: Red Dot Text       //
    //       Bit 7: Red Dot Mic        //
    //       Bit 8: Red Dot Video      //
    //       Bit 9: BRB                //
    /////////////////////////////////////
    PRoomUserInfo(UsersListView.Items.Item[UserIndex].Data).Status := Status;
    for i := 0 to 32 do
    begin
      if StatusDifference and (1 shl i)<>0 then
      begin
        case i of
        0: UpdateAdminStatForThisUser(UserIndex);
        1: UpdateAdminStatForThisUser(UserIndex);
        2: UpdateAdminStatForThisUser(UserIndex);
        3: UpdateAdminStatForThisUser(UserIndex);
        4:
        if (Status and (1 shl i))>0 then
          ShowCamIconForThisUser(UserIndex)
        else
          RemoveCamIconForThisUser(UserIndex);
        5:
        begin
          if (Status and (1 shl i))>0 then
            RaiseThisUserHande(UserIndex)
          else
            UnRaiseThisUserHande(UserIndex);           // RaiseHand and UnraiseHand changes the UserIndex
          for j := 0 to UsersListView.Items.Count - 1 do
            if PRoomUserInfo(UsersListView.Items.Item[j].Data).UserName = UserName then
            begin
              UserIndex := j;
              break;
            end;
        end;
        6:
        if (Status and (1 shl i))>0 then
          RedDotTextThisUser(UserIndex)
        else
          UnRedDotTextThisUser(UserIndex);
        7:
        if (Status and (1 shl i))>0 then
          RedDotMicThisUser(UserIndex)
        else
          UnRedDotMicThisUser(UserIndex);
        8:
        if (Status and (1 shl i))>0 then
          RedDotVideoThisUser(UserIndex)
        else
          UnRedDotVideoThisUser(UserIndex);
        9:
        if (Status and (1 shl i))>0 then
          ShowBRBIconForThisUser(UserIndex)
        else
          RemoveBRBIconForThisUser(UserIndex);
        end;
      end;
    end;
  end;
end;

{
procedure TRoomWindow.ExchangeUserListItem(Index1, Index2: Integer);
var
  Index1Caption: string;
  Index1Data: Pointer;
  Index1ImgIndex: Integer;
begin
  Index1Caption := UsersListView.Items.Item[Index1].Caption;
  Index1Data := UsersListView.Items.Item[Index1].Data;
  Index1ImgIndex := UsersListView.Items.Item[Index1].ImageIndex;

  UsersListView.Items.Item[Index1].Caption := UsersListView.Items.Item[Index2].Caption;
  UsersListView.Items.Item[Index1].Data := UsersListView.Items.Item[Index2].Data;
  UsersListView.Items.Item[Index1].ImageIndex := UsersListView.Items.Item[Index2].ImageIndex;

  UsersListView.Items.Item[Index2].Caption := Index1Caption;
  UsersListView.Items.Item[Index2].Data := Index1Data;
  UsersListView.Items.Item[Index2].ImageIndex := Index1ImgIndex;
end;
}

procedure TRoomWindow.MoveUserListItem(Index1, Index2: Integer);
begin
  if Index1<Index2 then
  begin
    UsersListView.Items.Insert(Index2);
    UsersListView.Items.Item[Index2].Caption := UsersListView.Items.Item[Index1].Caption;
    UsersListView.Items.Item[Index2].Data := UsersListView.Items.Item[Index1].Data;
    UsersListView.Items.Item[Index2].ImageIndex := UsersListView.Items.Item[Index1].ImageIndex;
    UsersListView.Items.Item[Index2].StateIndex := UsersListView.Items.Item[Index1].StateIndex;
    UsersListView.Items.Delete(Index1);
  end
  else
  if Index1>Index2 then
  begin
    UsersListView.Items.Insert(Index2);
    UsersListView.Items.Item[Index2].Caption := UsersListView.Items.Item[Index1+1].Caption;
    UsersListView.Items.Item[Index2].Data := UsersListView.Items.Item[Index1+1].Data;
    UsersListView.Items.Item[Index2].ImageIndex := UsersListView.Items.Item[Index1+1].ImageIndex;
    UsersListView.Items.Item[Index2].StateIndex := UsersListView.Items.Item[Index1+1].StateIndex;
    UsersListView.Items.Delete(Index1+1);
  end;
end;

function TRoomWindow.GetLastRaiseIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to UsersListView.Items.Count - 1 do
    if (UsersListView.Items.Item[i].ImageIndex<>1) and
       (UsersListView.Items.Item[i].ImageIndex<>2) then
    begin
      if (i=0) and (UsersListView.Items.Count>1) and (UsersListView.Items.Item[i+1].ImageIndex=2) then
        Continue;
      Result := i;
      break;
    end;

  if Result = -1 then
  begin
    if UsersListView.Items.Count=1 then
      Result := 0
    else
      Result := UsersListView.Items.Count;
  end;
end;

procedure TRoomWindow.RaiseThisUserHande(UserIndex: Integer);
var
  LastRaiseIndex: Integer;
  UserName: string;
begin
  if FRoomClosing then Exit;
  UserName := PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName;

  LastRaiseIndex := GetLastRaiseIndex;

  if UserIndex = LastRaiseIndex then
  begin
    //UsersListView.Items[LastRaiseIndex].ImageIndex := 2;
    UpdateThisUserIcon(UsersListView.Items[LastRaiseIndex]);
    if UserName=MainForm.MyNickName then
      RaiseHandButton.Down := True;
    Exit;
  end;
  if (LastRaiseIndex<>-1) and (UserIndex<>-1) then
  begin
    MoveUserListItem(UserIndex,LastRaiseIndex);
    UserIndex := LastRaiseIndex;
    UpdateThisUserIcon(UsersListView.Items[UserIndex]);
    //UsersListView.Items[LastRaiseIndex].ImageIndex := 2;
    if UserName=MainForm.MyNickName then
      RaiseHandButton.Down := True;
  end;
end;

procedure TRoomWindow.UnRaiseThisUserHande(UserIndex: Integer);
var
  LastRaiseIndex: Integer;
  UserName: string;
begin
  UserName := PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName;
  LastRaiseIndex := GetLastRaiseIndex;
  if UserIndex = LastRaiseIndex then
  begin
    UpdateThisUserIcon(UsersListView.Items[LastRaiseIndex]);
    if UserName=MainForm.MyNickName then
      RaiseHandButton.Down := False;
  end;
  if (LastRaiseIndex<>-1) and (UserIndex<>-1) then
  begin
    UpdateThisUserIcon(UsersListView.Items[UserIndex]);
    MoveUserListItem(UserIndex,LastRaiseIndex);
    if UserName=MainForm.MyNickName then
      RaiseHandButton.Down := False;
  end;
end;

procedure TRoomWindow.RedDotMicThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
  begin
    MicButton.Enabled := False;
    RaiseHandButton.Enabled := False;
  end;
end;

procedure TRoomWindow.RedDotTextThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
  begin
    SendButton.Enabled := False;
    InputMemo.Enabled := False;
  end;
end;

procedure TRoomWindow.RedDotVideoThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
    StartCamButton.Enabled := False;
end;

procedure TRoomWindow.RemoveBRBIconForThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
    FBRB := False;
end;

procedure TRoomWindow.RemoveCamIconForThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
end;

procedure TRoomWindow.ShowBRBIconForThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
    FBRB := True;
end;

procedure TRoomWindow.ShowCamIconForThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
end;

procedure TRoomWindow.UnRedDotMicThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
  begin
    MicButton.Enabled := True;
    RaiseHandButton.Enabled := True;
  end;
end;

procedure TRoomWindow.UnRedDotTextThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
  begin
    InputMemo.Enabled := True;
    SendButton.Enabled := True;
  end;
end;

procedure TRoomWindow.UnRedDotVideoThisUser(UserIndex: Integer);
begin
  UpdateThisUserIcon(UsersListView.Items[UserIndex]);
  if PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName = MainForm.MyNickName then
    StartCamButton.Enabled := True;
end;

procedure TRoomWindow.UpdateThisUserIcon(Item: TListItem);
var
  Status: Cardinal;
begin
  if FRoomClosing then Exit;
  Status := PRoomUserInfo(Item.Data).Status;
  //TADD WEBCAM
  if ((Status and $10)>0) and not ((Status and $100)>0)then
    Item.StateIndex := 0   // video icon
  else
    Item.StateIndex := -1; // blank icon

  if (Item = UsersListView.Items[0]) and (Item.ImageIndex = 1) and (not (Status and $80)>0) then
    Exit;
  Item.ImageIndex := 0;        // blank Icon
  //Item.StateIndex := -1;
  if (Status and $200)>0 then
    Item.ImageIndex := 7;      // BRB Icon

  if (Status and $C0)>0 then                           // 0001 1100 0000
    Item.ImageIndex := 3;      // Reddot Icon

  if (Status and $100)>0 then
    Item.ImageIndex := 3;      // Reddot Icon

  if (Status and $20)>0 then
    Item.ImageIndex := 2;      //  Hand Icon

end;

/////////////////////////////////////
//  User Status Format             //
//       Bit 0,1,2,3: Privilege    //
//       Bit 4: Video              //
//       Bit 5: Raise Hand         //
//       Bit 6: Red Dot Text       //
//       Bit 7: Red Dot Mic        //
//       Bit 8: Red Dot Video      //
//       Bit 9: BRB                //
/////////////////////////////////////
procedure TRoomWindow.UpdateAdminStatForThisUser(UserIndex: Integer);
var
  Privilege: Byte;
  UserName: string;
begin
  Privilege := PRoomUserInfo(UsersListView.Items[UserIndex].Data).Status and $0F;
  UserName := PRoomUserInfo(UsersListView.Items[UserIndex].Data).UserName;
  if Privilege>0 then
  begin
    UsersListView.Items[UserIndex].Caption := '@'+ UserName;
    FAdminControlPanel.RoomMessageEditBox.Text := RoomTitleRichEdit.Text;
    if UserName = MainForm.MyNickName then
    begin
      FIsAdmin := True;
      EnableAdminControls;
      if Privilege>2 then
      begin
        MakeUserAdmin.Visible := True;
        MakeUserSuperAdmin.Visible := True;
        RemoveAdminPower.Visible := True;;
      end
      else
      if Privilege=2 then
      begin
        MakeUserAdmin.Visible := True;
        MakeUserSuperAdmin.Visible := False;
        RemoveAdminPower.Visible := True;
      end
      else
      begin
        MakeUserAdmin.Visible := False;
        MakeUserSuperAdmin.Visible := False;
        RemoveAdminPower.Visible := False;
      end;
    end;
  end
  else
  begin
    if UserName = MainForm.MyNickName then
    begin
      FIsAdmin := False;
      DisableAdminControls;
    end;
    UsersListView.Items[UserIndex].Caption := UserName;
  end;
end;

procedure TRoomWindow.AdminListViewPOPUPMenuPopup(Sender: TObject);
var
  Item: TListItem;
  Status: Cardinal;
begin
  if UsersListView.ItemIndex<>-1 then
  begin
    Item := UsersListView.Items[UsersListView.ItemIndex];
    POPUPActiveUserName := PRoomUserInfo(Item.Data).UserName;
    Status := PRoomUserInfo(Item.Data).Status;
    if Status and $40>0 then
      mReddotText.Caption := 'Remove Red dot Text'
    else
      mReddotText.Caption := 'Red dot Text';

    if Status and $80>0 then
      mReddotMic.Caption := 'Remove Red dot Mic'
    else
      mReddotMic.Caption := 'Red dot Mic';

    if Status and $100>0 then
      mReddotVideo.Caption := 'Remove Red dot Video'
    else
      mReddotVideo.Caption := 'Red dot Video';

    if (Status and $40>0) or (Status and $80>0) or (Status and $100>0) then
      mDefaultReddot.Caption := 'Remove Red Dot   (Shift+Click)'
    else
      mDefaultReddot.Caption := 'Red Dot   (Shift+Click)';

    {
    if PRoomUserInfo(Item.Data).UserName = MainForm.MyNickName then
    begin
      maBRB.Visible := True;
      maBRBSeparator.Visible := True;
      if FBRB then
        maBRB.Caption := 'Remove BRB Icon'
      else
        maBRB.Caption := 'Show BRB Icon';
    end;
    }
  end;
end;

procedure TRoomWindow.TBXItem3Click(Sender: TObject);
begin
  FAdminControlPanel.Show;
end;

procedure TRoomWindow.mDefaultReddotClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex = -1 then
    Exit;
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName);
  Packet.Operation := 0;
  if TTBXItem(Sender).Caption = 'Red Dot   (Shift+Click)' then
  begin
    Packet.Operation := Packet.Operation or 7; //Byte(FAdminControlPanel.DefaultRedDotText.Checked);
//    Packet.Operation := Packet.Operation or Byte(FAdminControlPanel.DefaultRedDotVideo.Checked) shl 1;
//    Packet.Operation := Packet.Operation or Byte(FAdminControlPanel.DefaultRedDotMic.Checked) shl 2;
  end;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;
/////////////////////////////////////
//  User Status Format             //
//       Bit 0,1,2,3: Privilege    //
//       Bit 4: Video              //
//       Bit 5: Raise Hand         //
//       Bit 6: Red Dot Text       //
//       Bit 7: Red Dot Mic        //
//       Bit 8: Red Dot Video      //
//       Bit 9: BRB                //
/////////////////////////////////////
  {
  Operation:
    bit 0: Red dot Text
    bit 1: Red dot Video
    bit 2: Red dot Mic
    bit 3: Bounce
    bit 4: Ban
    bit 5: Red dot whole Room
    bit 6: Give Temporary Admin
    bit 7: Give Temporary Super Admin
    bir 8: Take Back Admin Power
    bit 9: UnBounceUser
    bit 10: UnBanUser
    bit 11: Unraise Hand
    bit 12: Special Operation
    bit 13: Default RedDot Text
    bit 14: Default RedDot Video
    bit 15: Default RedDot Mic
    bit 16: AutoRedDot NewUsers
    bit 17: Close Room
  }

procedure TRoomWindow.mReddotMicClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex = -1 then
    Exit;
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName);
  Packet.Operation := 0;
  if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $40)>0 then
    Packet.Operation := Packet.Operation or 1;
  if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $100)>0 then
    Packet.Operation := Packet.Operation or 2;

  if TTBXItem(Sender).Caption = 'Red dot Mic' then
    Packet.Operation := Packet.Operation or 4;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

procedure TRoomWindow.mReddotVideoClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex = -1 then
    Exit;
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName);
  Packet.Operation := 0;
  if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $40)>0 then
    Packet.Operation := Packet.Operation or 1;
  if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $80)>0 then
    Packet.Operation := Packet.Operation or 4;
  if TTBXItem(Sender).Caption = 'Red dot Video' then
    Packet.Operation := Packet.Operation or 2;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

procedure TRoomWindow.mReddotTextClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex = -1 then
    Exit;
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName);
  Packet.Operation := 0;
  if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $80)>0 then
    Packet.Operation := Packet.Operation or 4;
  if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $100)>0 then
    Packet.Operation := Packet.Operation or 2;
  if TTBXItem(Sender).Caption = 'Red dot Text' then
    Packet.Operation := Packet.Operation or 1;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

procedure TRoomWindow.OutputVolumeCahnged(Sender: TObject);
var
  Vol,ScaledVolume: Extended;
begin
  if MainForm.AudioEnable and not (MainForm.FProgramClosing) then
  begin
    Vol := (FVolumeControlForm.VolumeControl.Position) / -10000;
    ScaledVolume := LogN(1.001,Max(Vol,0.00009));
    MainForm.PlayThread.OutputVolume := Round(ScaledVolume); //-10000 - VolControlForm.VolumeControl.Position;
  end;
end;

procedure TRoomWindow.WindowsRecordingControlButtonClick(Sender: TObject);
begin
//� Playback Devices: control.exe mmsys.cpl,,0
//� Recording Devices: control.exe mmsys.cpl,,1
  if IsWinVista then
    ShellExecute(0,'open','control.exe','mmsys.cpl,,1',nil,SW_SHOW)
  else
    ShellExecute(0,'open','sndvol32','-rec',nil,SW_SHOW);
end;

procedure TRoomWindow.WindowsVolumeControlButtonClick(Sender: TObject);
begin
//� Playback Devices: control.exe mmsys.cpl,,0
//� Recording Devices: control.exe mmsys.cpl,,1
  if IsWinVista then
    ShellExecute(0,'open','control.exe','mmsys.cpl,,0',nil,SW_SHOW)
  else
    ShellExecute(0,'open','sndvol32',nil,nil,SW_SHOW);
end;

procedure TRoomWindow.HandleWhisperPacket(var msg: TMessage);
var
  WhisperSender: string;
  WhisperText: string;
begin
  if FRoomClosing then Exit;
  while InputThread.WhisperList.Count>0 do
  begin
    WhisperSender := InputThread.WhisperUserNameList.Strings[0];
    WhisperText := InputThread.WhisperList.Strings[0];
    InputThread.WhisperCriticalSection.Enter;
    InputThread.WhisperUserNameList.Delete(0);
    InputThread.WhisperList.Delete(0);
    InputThread.WhisperCriticalSection.Leave;
    AppendToWB(Viewer, '<font size=1 color=#0000FF><B><I> Whisper from '+WhisperSender+':');
    AppendToWB(Viewer, '<font size=1 color=#0000FF><B><I>   '+WhisperText);
    AppendToWB(Viewer, '<font size=1 color=#0000FF><B><I> End Whisper');
    //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
    Viewer.Invalidate;
  end;
end;

procedure TRoomWindow.AppendToWB(WB: TWebBrowser; const html: widestring);
var
   Range: IHTMLTxtRange;
begin
   Range := ((WB.Document AS IHTMLDocument2).body AS IHTMLBodyElement).createTextRange;
   Range.Collapse(False) ;
   Range.PasteHTML(html) ;
end;

procedure TRoomWindow.mSendWhisperClick(Sender: TObject);
begin
  if UsersListView.ItemIndex = -1 then
    Exit;
  if FWhisperWindow<>nil then
  begin
    ShowMessage('You already have Whisper Window Open. Plz Close it before Attemp to open another one.');
    Exit;
  end;
  MainForm.TmpHandleforWisWnd := Handle;
  FWhisperWindow := TWhisperForm.Create(Self);
  FWhisperWindow.MyOwner := Self;
  FWhisperWindow.Show;
  FWhisperWindow.UserName := PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName;
end;

procedure TRoomWindow.SendWhisper(var msg: TMessage);
var
  Packet: PRoomWhisperPacket;
  BufSize: Integer;
begin
  BufSize := SizeOf(TRoomWhisperPacket)+Length(FWhisperWindow.Edit1.Text)+1;
  GetMem(Packet,BufSize);
  ZeroMemory(Packet,BufSize);
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtRoomWhisperPacket;
  Packet.BufferSize := BufSize;
  StrCopy(Packet.UserName,PChar(FWhisperWindow.UserName));
  StrCopy(Pointer(Cardinal(Packet)+SizeOf(TRoomWhisperPacket)),PChar(FWhisperWindow.Edit1.Text));
  InputThread.SendBuffer(Packet,BufSize);
  FreeMem(Packet);
  FWhisperWindow.Edit1.Text := '';
  if not FWhisperWindow.KeepOpenCheckBox.Checked then
  begin
    FWhisperWindow.Close;
    FWhisperWindow.Free;
    FWhisperWindow := nil;
  end;
end;

procedure TRoomWindow.HandleWhisperWindowClosedMsg(var msg: TMessage);
begin
  if FRoomClosing then Exit;
  FWhisperWindow := nil;
end;

procedure TRoomWindow.mSendPMClick(Sender: TObject);
var
  Buddy: string;
begin
  if UsersListView.ItemIndex>-1 then
  begin
    Buddy := PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName;
    MainForm.OpenChatWindow(Buddy);
  end;
end;

procedure TRoomWindow.HandleRoomAlertPacket(var msg: TMessage);
var
  Status: Cardinal;
  AlertStr: string;
begin
  if FRoomClosing then Exit;
  while InputThread.RoomAlertList.Count>0 do
  begin
    AlertStr := InputThread.RoomAlertList.Strings[0];
    Status := Cardinal(InputThread.RoomAlertList.Objects[0]);
    InputThread.RoomAlertListCriticalSection.Enter;
    InputThread.RoomAlertList.Delete(0);
    InputThread.RoomAlertListCriticalSection.Leave;
    if (Status and 2>0) and (Status and 1>0) then
    begin
      MainForm.MessageBoxText := AlertStr;
      MainForm.MessageBoxCaption := 'Beyluxe Messenger';
      PostMessage(MainForm.Handle,WCM_ShowMessageBoxAndClose,Handle,0);// Close;
      Exit;
    end;

    if Status and 1>0 then  // is msg box message
    begin
      MessageBox(Handle,PChar(AlertStr),'Alert',MB_OK);
    end
    else
    begin
      //Viewer.LoadTextFromString('<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> '+AlertStr);
      AppendToWB(Viewer,'<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> '+AlertStr);
      //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
      Viewer.Invalidate;
    end;

  end;
end;

/////////////////////////////////////
//  User Status Format             //
//       Bit 0,1,2,3: Privilege    //
//       Bit 4: Video              //
//       Bit 5: Raise Hand         //
//       Bit 6: Red Dot Text       //
//       Bit 7: Red Dot Mic        //
//       Bit 8: Red Dot Video      //
//       Bit 9: BRB                //
/////////////////////////////////////
  {
  Operation:
    bit 0: Red dot Text
    bit 1: Red dot Video
    bit 2: Red dot Mic
    bit 3: Bounce
    bit 4: Ban
    bit 5: Red dot whole Room
    bit 6: Give Temporary Admin
    bit 7: Give Temporary Super Admin
    bir 8: Take Back Admin Power
    bit 9: UnBounceUser
    bit 10: UnBanUser
    bit 11: Unraise Hand
    bit 12: Special Operation
    bit 13: Default RedDot Text
    bit 14: Default RedDot Video
    bit 15: Default RedDot Mic
    bit 16: AutoRedDot NewUsers
    bit 17: Close Room
  }

procedure TRoomWindow.MakeUserAdminClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex>-1 then
  begin
    ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtAdminOperation;
    Packet.BufferSize := SizeOf(TAdminOperationPacket);
    StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName);
    Packet.Operation := 0;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $40)>0 then
      Packet.Operation := Packet.Operation or 1;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $80)>0 then
      Packet.Operation := Packet.Operation or 4;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $100)>0 then
      Packet.Operation := Packet.Operation or 2;
    Packet.Operation := Packet.Operation or $40;
    InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
  end;
end;

procedure TRoomWindow.MakeUserSuperAdminClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex>-1 then
  begin
    ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtAdminOperation;
    Packet.BufferSize := SizeOf(TAdminOperationPacket);
    StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName);
    Packet.Operation := 0;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $40)>0 then
      Packet.Operation := Packet.Operation or 1;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $80)>0 then
      Packet.Operation := Packet.Operation or 4;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $100)>0 then
      Packet.Operation := Packet.Operation or 2;
    Packet.Operation := Packet.Operation or $80;
    InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
  end;
end;

procedure TRoomWindow.RemoveAdminPowerClick(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  if UsersListView.ItemIndex>-1 then
  begin
    ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtAdminOperation;
    Packet.BufferSize := SizeOf(TAdminOperationPacket);
    StrCopy(Packet.UserName,PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName);
    Packet.Operation := 0;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $40)>0 then
      Packet.Operation := Packet.Operation or 1;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $80)>0 then
      Packet.Operation := Packet.Operation or 4;
    if (PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).Status and $100)>0 then
      Packet.Operation := Packet.Operation or 2;
    Packet.Operation := Packet.Operation or $100;
    InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
  end;
end;

procedure TRoomWindow.HandleAdminInfoAllPacket(var msg: TMessage);
var
  DefRedDotTextHandler: TNotifyEvent;
  DefRedDotMicHandler: TNotifyEvent;
  DefRedDotVideoHandler: TNotifyEvent;
begin
  if FRoomClosing then Exit;
  with FAdminControlPanel do
  begin
    BounceListBox.Clear;
    BounceListBox.Items.CommaText := InputThread.AdminInfo.BounceListStr;
    BanListBox.Items.CommaText := InputThread.AdminInfo.BanListStr;

    // We have to remove event handlers to prevent loop

    //First save EventHandler addresses
    DefRedDotTextHandler := DefaultRedDotText.OnClick;
    DefRedDotMicHandler := DefaultRedDotMic.OnClick;
    DefRedDotVideoHandler := DefaultRedDotVideo.OnClick;

    //then nil them...
    DefaultRedDotText.OnClick := nil;
    DefaultRedDotMic.OnClick := nil;
    DefaultRedDotVideo.OnClick := nil;

    //Now modify them
    DefaultRedDotText.Checked := InputThread.AdminInfo.RedDotText>0;
    DefaultRedDotMic.Checked := InputThread.AdminInfo.RedDotMic>0;
    DefaultRedDotVideo.Checked := InputThread.AdminInfo.RedDotVideo>0;

    //Now restore EventHandlers
    DefaultRedDotText.OnClick := DefRedDotTextHandler;
    DefaultRedDotMic.OnClick := DefRedDotMicHandler;
    DefaultRedDotVideo.OnClick := DefRedDotVideoHandler;
  end;
end;

procedure TRoomWindow.ApplyDefaultRedDots;
var
  Packet: TAdminOperationPacket;
begin
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
//  StrCopy(Packet.UserName,PChar(UserName));
  Packet.Operation := $1000;
  if FAdminControlPanel.DefaultRedDotText.Checked then
    Packet.Operation := Packet.Operation or $2000;
  if FAdminControlPanel.DefaultRedDotText.Checked then
    Packet.Operation := Packet.Operation or $4000;
  if FAdminControlPanel.DefaultRedDotText.Checked then
    Packet.Operation := Packet.Operation or $8000;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

procedure TRoomWindow.BanUser(UserName: string; Ban: Boolean);
var
  Packet: TAdminOperationPacket;
begin
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  StrCopy(Packet.UserName,PChar(UserName));
  if Ban then
    Packet.Operation := 16
  else
    Packet.Operation := 1024;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

  {
  Operation:
    bit 0: Red dot Text
    bit 1: Red dot Video
    bit 2: Red dot Mic
    bit 3: Bounce
    bit 4: Ban
    bit 5: Red dot whole Room
    bit 6: Give Temporary Admin
    bit 7: Give Temporary Super Admin
    bir 8: Take Back Admin Power
    bit 9: UnBounceUser
    bit 10: UnBanUser
    bit 11: Unraise Hand
    bit 12: Special Operation
    bit 13: Default RedDot Text
    bit 14: Default RedDot Video
    bit 15: Default RedDot Mic
    bit 16: AutoRedDot NewUsers
    bit 17: Close Room
  }

procedure TRoomWindow.BounceUser(UserName: string; Bounce: Boolean);
var
  Packet: TAdminOperationPacket;
begin
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  StrCopy(Packet.UserName,PChar(UserName));
  if Bounce then
    Packet.Operation := 8
  else
    Packet.Operation := 512;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

procedure TRoomWindow.HandleAdminOperationNotifyPacket(var msg: TMessage);
var
  AdminName: string;
  UserName: string;
  Operation: Cardinal;
begin
  if FRoomClosing then Exit;
  while InputThread.AdminOpertationNotifyList.Count>0 do
  begin
    AdminName := InputThread.AdminOpertationNotifyAdminList.Strings[0];
    UserName := InputThread.AdminOpertationNotifyList.Strings[0];
    Operation := Cardinal(InputThread.AdminOpertationNotifyList.Objects[0]);
    InputThread.AdminOpertationNotifyListCriticalSection.Enter;
    InputThread.AdminOpertationNotifyList.Delete(0);
    InputThread.AdminOpertationNotifyAdminList.Delete(0);
    InputThread.AdminOpertationNotifyListCriticalSection.Leave;
    AdminReport(AdminName,UserName,Operation);
  end;
end;
{
var
  UserName: string;
  ReddotText: Boolean;
  ReddotVideo: Boolean;
  ReddotMic: Boolean;
  Bounce: Boolean;
  UnBounce: Boolean;
  Ban: Boolean;
  UnBan: Boolean;
  UnRaiseHand: Boolean;
  ReddotWholeRoom: Boolean;
  GiveTemporaryAdmin: Boolean;
  GiveTemporarySuperAdmin: Boolean;
  TakeBackAdminPower: Boolean;
  SpecialOperation: Boolean;
  CloseRoom: Boolean;
  AdminOperation: Cardinal;
  i,Index: Integer;
  DestUser: TRoomUser;
begin
  if User.Admin = 0 then
    Exit;
  AdminOperation := Packet.Operation;
  UserName := Packet.UserName;
  for i := 0 to FUserList.Count -1 do
    if TRoomUser(FUserList.Items[i]).UserName = UserName then
      DestUser := TRoomUser(FUserList.Items[i]);
  ReddotText := AdminOperation and 1>0;
  ReddotVideo := AdminOperation and 2>0;
  ReddotMic := AdminOperation and 4>0;
  Bounce := AdminOperation and 8>0;
  SpecialOperation := AdminOperation and $1000>0;
  UnBounce := AdminOperation and $200>0;
  UnBan := AdminOperation and $400>0;
  UnRaiseHand := AdminOperation and $800>0;
  if Bounce then
  begin
    if User.Privilege<DestUser.Privilege then
    begin
      AlertUser(User,'You have not safficient priviledge to bounce this person.',False,True);
      Exit;
    end
    else
    begin
      AlertUser(DestUser,'You have been bounced from the group '+RoomInfo.RoomName,True,True);
      for i := 0 to FUserList.Count -1 do
        if TRoomUser(FUserList.Items[i])<>DestUser then
          AlertUser(TRoomUser(FUserList.Items[i]),User.UserName+' bounced '+DestUser.UserName+' from the group.',False,False);
      FHDDBounceList.Add(DestUser.HDDSerial);
      FUserBounceList.Add(DestUser.UserName);
      NotifyAdminsAboutOperation(User,Packet);
//      DestUser.FServerThread.TerminateConnection;
      DestUser.FServerThread.Terminate;
    end;
  end;
  if UnBounce then
  begin
    Index := FUserBounceList.IndexOf(UserName);
    if Index>-1 then
    begin
      FUserBounceList.Delete(Index);
      FHDDBounceList.Delete(Index);
    end;
    NotifyAdminsAboutOperation(User,Packet);
  end;
  Ban := AdminOperation and 16>0;
  GiveTemporaryAdmin := AdminOperation and 64>0;
  GiveTemporarySuperAdmin := AdminOperation and 128>0;
  TakeBackAdminPower := AdminOperation and 256>0;
  if UserName<>'' then
  begin
    DestUser.RedDotMic := ReddotMic;
    DestUser.RedDotText := ReddotText;
    DestUser.RedDotVideo := ReddotVideo;
    if GiveTemporaryAdmin then
    begin
      DestUser.Admin := 1;
      SendAdminInfoAllForThisUser(DestUser);
    end
    else
    if GiveTemporarySuperAdmin then
    begin
      DestUser.Admin := 2;
      SendAdminInfoAllForThisUser(DestUser);
    end
    else
    if TakeBackAdminPower then
      DestUser.Admin := 0;
    NotifyAdminsAboutOperation(User,Packet);
    NotifyUsersAboutNewUserStatus(DestUser);
  end;
  if UnRaiseHand then
  begin
    Self.UnRaiseHand(DestUser);
    NotifyAdminsAboutOperation(User,Packet);
  end;

}
procedure TRoomWindow.HandleGroupTitlePacket(var msg: TMessage);
begin
  if FRoomClosing then Exit;
  RoomTitleRichEdit.Text := InputThread.GroupTitle;
  FAdminControlPanel.RoomMessageEditBox.Text := InputThread.GroupTitle;
end;

procedure TRoomWindow.AdminReport(AdminName, UserName: string;
  AdminOperation: Cardinal);
var
  i: Integer;
  UnRaiseHand: Boolean;
  Bounce: Boolean;
  UnBounce: Boolean;
  Ban: Boolean;
  UnBan: Boolean;
  Str: string;
  RedDotStr: string;
  ReddotText: Boolean;
  ReddotVideo: Boolean;
  ReddotMic: Boolean;
  CurrUserStat: Cardinal;
  Found: Boolean;


  CurUserRedText: Boolean;
  CurUserRedMic: Boolean;
  CurUserRedVideo: Boolean;
{  ReddotWholeRoom: Boolean;
  GiveTemporaryAdmin: Boolean;
  GiveTemporarySuperAdmin: Boolean;
  TakeBackAdminPower: Boolean;
  SpecialOperation: Boolean;
  CloseRoom: Boolean;}
begin

  ReddotText := AdminOperation and 1>0;
  ReddotVideo := AdminOperation and 2>0;
  ReddotMic := AdminOperation and 4>0;
  //SpecialOperation := AdminOperation and $1000>0;
  //UnBan := AdminOperation and $400>0;

  Bounce := AdminOperation and 8>0;
  UnBounce := AdminOperation and $200>0;
  Ban := AdminOperation and 16>0;
  UnBan := AdminOperation and $400>0;
  UnRaiseHand := AdminOperation and $800>0;

  Found := False;
  CurrUserStat := 0;
  for i := 0 to UsersListView.Items.Count-1 do
    if PRoomUserInfo(UsersListView.Items.Item[i].Data).UserName = UserName then
    begin
      CurrUserStat := PRoomUserInfo(UsersListView.Items.Item[i].Data).Status;
      Found := True;
      break;
    end;
  CurUserRedText := (CurrUserStat and $40)<>0;
  CurUserRedMic := (CurrUserStat and $80)<>0;
  CurUserRedVideo := (CurrUserStat and $100)<>0;

  {
  Ban := AdminOperation and 16>0;
  GiveTemporaryAdmin := AdminOperation and 64>0;
  GiveTemporarySuperAdmin := AdminOperation and 128>0;
  TakeBackAdminPower := AdminOperation and 256>0;
  }
  if Bounce then
  begin
    FAdminControlPanel.BounceListBox.Items.Add(UserName);
    Exit;
  end;

  if UnBounce then
  begin
    FAdminControlPanel.BounceListBox.Items.Delete(FAdminControlPanel.BounceListBox.Items.IndexOf(UserName));
    AppendToWB(Viewer,'<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> @'+AdminName+' Unbounced '+UserName);
    //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
    Viewer.Invalidate;
    Exit;
  end;

  if UnRaiseHand then
  begin
    Str := '<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> @'+AdminName+' UnRaised '+UserName+' hand';
    AddToHTMLViewer(Str);
    Exit;
  end;

  if Ban then
  begin
    FAdminControlPanel.BanListBox.Items.Add(UserName);
    //FAdminControlPanel.BounceListBox.Items.Delete(FAdminControlPanel.BounceListBox.Items.IndexOf(UserName));
    Str := '<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> @'+AdminName+' Baned '+UserName;
    AddToHTMLViewer(Str);
    Exit;
  end;

  if UnBan then
  begin
    FAdminControlPanel.BanListBox.Items.Delete(FAdminControlPanel.BanListBox.Items.IndexOf(UserName));
    Str := '<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> @'+AdminName+' UnBaned '+UserName;
    AddToHTMLViewer(Str);
    Exit;
  end;

  if not Found then
    Exit;


  if (CurUserRedText and (not ReddotText)) or
     (CurUserRedMic and (not ReddotMic)) or
     (CurUserRedVideo and (not ReddotVideo)) then
  begin
    if (CurUserRedText and (not ReddotText)) and
       (CurUserRedMic and (not ReddotMic)) and
       (CurUserRedVideo and (not ReddotVideo)) then
      RedDotStr := 'Text,Mic,Video'
    else
    if (CurUserRedText and (not ReddotText)) and
       (CurUserRedMic and (not ReddotMic)) then
      RedDotStr := 'Text,Mic'
    else
    if (CurUserRedText and (not ReddotText)) and
       (CurUserRedVideo and (not ReddotVideo)) then
      RedDotStr := 'Text,Video'
    else
    if (CurUserRedVideo and (not ReddotVideo)) and
       (CurUserRedMic and (not ReddotMic)) then
      RedDotStr := 'Mic,Video'
    else
    if (CurUserRedVideo and (not ReddotVideo)) then
      RedDotStr := 'Video'
    else
    if (CurUserRedText and (not ReddotText)) then
      RedDotStr := 'Text'
    else
    if (CurUserRedMic and (not ReddotMic)) then
      RedDotStr := 'Mic';

    Str := '<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> @'+AdminName+' UnReddoted '+UserName+' ('+RedDotStr+').';
    AddToHTMLViewer(Str);
    Exit;
  end
  else
  if ReddotText or ReddotMic or ReddotVideo then
  begin
    if ReddotText and ReddotVideo and ReddotMic then
      RedDotStr := 'Text,Mic,Video'
    else
    if ReddotText and ReddotVideo then
      RedDotStr := 'Text,Video'
    else
    if ReddotText and ReddotMic then
      RedDotStr := 'Text,Mic'
    else
    if ReddotVideo and ReddotMic then
      RedDotStr := 'Video,Mic'
    else
    if ReddotText then
      RedDotStr := 'Text'
    else
    if ReddotMic then
      RedDotStr := 'Mic'
    else
    if ReddotVideo then
      RedDotStr := 'Video';

    Str := '<font size=1 color=#DD5522><B> Beyluxe:</B><font size=1 color=#DD5522> @'+AdminName+' Reddoted '+UserName+' ('+RedDotStr+').';
    AddToHTMLViewer(Str);
    Exit;
  end;
end;
{
procedure TRoom.ExecuteAdminOperationPacket(User: TRoomUser;
  Packet: PAdminOperationPacket; Size: Integer);
var
  UserName: string;
  TmpStr1,TmpStr2: string;
  ReddotText: Boolean;
  ReddotVideo: Boolean;
  ReddotMic: Boolean;
  Bounce: Boolean;
  UnBounce: Boolean;
  Ban: Boolean;
  UnBan: Boolean;
  UnRaiseHand: Boolean;
  List: TList;
//  ReddotWholeRoom: Boolean;
  GiveTemporaryAdmin: Boolean;
  GiveTemporarySuperAdmin: Boolean;
  TakeBackAdminPower: Boolean;
  SpecialOperation: Boolean;
  CloseRoom: Boolean;
  AdminOperation: Cardinal;
  AutoReddot: Boolean;
  i,Index: Integer;
  DestUser: TRoomUser;
begin
  if User.Admin = 0 then
    Exit;
  AdminOperation := Packet.Operation;
  UserName := Packet.UserName;
  //  DestUser := nil;
  //for i := 0 to FUserList.Count -1 do
  //  if TRoomUser(FUserList.Items[i]).UserName = UserName then
  //    DestUser := TRoomUser(FUserList.Items[i]);
  DestUser := UserByUserName(UserName);
  ReddotText := AdminOperation and 1>0;
  ReddotVideo := AdminOperation and 2>0;
  ReddotMic := AdminOperation and 4>0;
  Bounce := AdminOperation and 8>0;
  Ban := AdminOperation and 16>0;
  SpecialOperation := AdminOperation and $1000>0;
  UnBounce := AdminOperation and $200>0;
  UnBan := AdminOperation and $400>0;
  UnRaiseHand := AdminOperation and $800>0;
  AutoReddot := AdminOperation and $10000>0;
  CloseRoom := AdminOperation and $20000>0;

  if SpecialOperation then
  begin
    FRedDotText := AdminOperation and $2000>0;
    FRedDotVideo := AdminOperation and $4000>0;
    FRedDotMic := AdminOperation and $8000>0;
    AutoReddotNewUser := AutoReddot;

    if MainForm.EnableAutoRedAdminReport then
      for i := 0 to FUserList.Count - 1 do
        if (TRoomUser(FUserList.Items[i]).Privilege>0) and (TRoomUser(FUserList.Items[i])<>User) then
          SendAdminInfoAllForThisUser(TRoomUser(FUserList.Items[i]));
    //SendAdminInfoAllForAdmins;

    if FRoomInfo.RoomSubscription>0 then
      FDatabase.SetRoomAutoReddot(FRoomInfo.OwnerNickName,FRedDotText,FRedDotMic,FRedDotVideo);
    Exit;
  end;

  if CloseRoom then
  begin
    if RoomInfo.RoomSubscription <> 6  then
    begin
      FCloseRoomCommand := True;
      if User.Privilege>3 then
        FPersonClosingRoom := 'Beyluxe administrator.'
      else
        FPersonClosingRoom := User.UserName;
      FRoomClosed := True;
      Exit;
    end;
    Exit;
  end;

  if Bounce then
  begin
    if DestUser<>nil then
    begin
      if (DestUser<>nil) and (User.Privilege<DestUser.Privilege) then
      begin
        AlertUser(User,'You have not sufficient priviledge to bounce this person.',False,True);
        Exit;
      end
      else
      begin
        AlertUser(DestUser,'You have been bounced from the group '+RoomInfo.RoomName,True,True);
        for i := 0 to FUserList.Count -1 do
          if TRoomUser(FUserList.Items[i])<>DestUser then
            if (User.UserName<>'Invisible Power') and (not User.Invisible) then
              AlertUser(TRoomUser(FUserList.Items[i]),User.UserName+' bounced '+DestUser.UserName+' from the group.',False,False);
        if (HDDBounceList.IndexOf(DestUser.HDDSerial) = -1) or
           (UserBounceList.IndexOf(DestUser.UserName) = -1) then
        begin
          DestUser.Bouncing := True;
          RemoveUser(DestUser.Context,True);
          FHDDBounceList.Add(DestUser.HDDSerial);
          FUserBounceList.Add(DestUser.UserName);
          NotifyAdminsAboutOperation(User,Packet);
          DestUser.NeedDisconnect := True;
          DestUser.FNeedDisconnectReason := 'Bounced';
        end;
        Exit;
      end;
    end;
  end;
  if UnBounce then
  begin
    Index := FUserBounceList.IndexOf(UserName);
    if Index>-1 then
    begin
      FUserBounceList.Delete(Index);
      FHDDBounceList.Delete(Index);
    end;
    NotifyAdminsAboutOperation(User,Packet);
    Exit;
  end;

  if Ban then
  begin
    if DestUser<>nil then
    begin
      if (HDDBanList.IndexOf(DestUser.HDDSerial) = -1) or
         (UserBanList.IndexOf(DestUser.UserName) = -1) then
      begin
        FHDDBanList.Add(DestUser.HDDSerial);
        FUserBanList.Add(DestUser.UserName);
        NotifyAdminsAboutOperation(User,Packet);
      end;
      Exit;
    end
    else
    begin
      TmpStr1 := UserName;
      TmpStr2 := '';
      List := MainForm.FUsers.FUserList.LockList;
      Index := MainForm.FUsers.IndexByUserName(List,UserName);
      if Index>-1 then
      begin
        TmpStr2 := TUser(List.Items[Index]).UserInfo.HDDSerial;
      end;
      MainForm.FUsers.FUserList.UnlockList;
      if TmpStr2 = '' then
        if not FDatabase.GetRoomBanInfo(TmpStr1,TmpStr2) then
          Exit;
      if (HDDBanList.IndexOf(TmpStr1) = -1) or
         (UserBanList.IndexOf(TmpStr2) = -1) then
      begin
        FHDDBanList.Add(TmpStr2);
        FUserBanList.Add(TmpStr1);
        NotifyAdminsAboutOperation(User,Packet);
      end;
      Exit;
    end;
  end;

  if UnBan then
  begin
    Index := UserBanList.IndexOf(UserName);
    if Index<>-1 then
    begin
      HDDBanList.Delete(Index);
      UserBanList.Delete(Index);
    end;
  end;

  GiveTemporaryAdmin := AdminOperation and 64>0;
  GiveTemporarySuperAdmin := AdminOperation and 128>0;
  TakeBackAdminPower := AdminOperation and 256>0;
  if DestUser<>nil then
  begin
    if (ReddotMic or ReddotText or ReddotVideo) and (User.Privilege<DestUser.Privilege) then
    begin
      AlertUser(User,'You have not sufficient priviledge for this action.',False,True);
      Exit;
    end;
    DestUser.RedDotMic := ReddotMic;
    if ReddotMic and DestUser.RaiseHand then
      Self.UnRaiseHand(DestUser);
    DestUser.RedDotText := ReddotText;
    DestUser.RedDotVideo := ReddotVideo;
    if ReddotText or ReddotVideo or ReddotMic then
    begin
      Index := FHDDRedList.IndexOf(DestUser.HDDSerial);
      if Index=-1 then
      begin
        FHDDRedList.Add(DestUser.HDDSerial);
        Index := FHDDRedList.IndexOf(DestUser.HDDSerial);
      end;
      FHDDRedList.Objects[Index] := TObject(DestUser.Status and $1C0);
    end
    else
    begin
      Index := FHDDRedList.IndexOf(DestUser.HDDSerial);
      if Index>-1 then
        FHDDRedList.Delete(Index);
    end;

    if GiveTemporaryAdmin then
    begin
      if User.Privilege<DestUser.Privilege then
      begin
        AlertUser(User,'You have not sufficient priviledge for this action.',False,True);
        Exit;
      end;
      DestUser.Admin := 1;
      DestUser.Privilege := 1;
      SendAdminInfoAllForThisUser(DestUser);
    end
    else
    if GiveTemporarySuperAdmin then
    begin
      if User.Privilege<DestUser.Privilege then
      begin
        AlertUser(User,'You have not sufficient priviledge for this action.',False,True);
        Exit;
      end;
      DestUser.Admin := 2;
      DestUser.Privilege := 2;
      if (User.UserName='Invisible Power') or User.Invisible then
        DestUser.Privilege := 4;

      SendAdminInfoAllForThisUser(DestUser);
    end
    else
    if TakeBackAdminPower then
    begin
      if User.Privilege<=DestUser.Privilege then
      begin
        AlertUser(User,'You have not sufficient privilege to perform this action.',False,True);
        Exit;
      end
      else
        DestUser.Admin := 0;
    end;
    NotifyAdminsAboutOperation(User,Packet);
    NotifyUsersAboutNewUserStatus(DestUser);
    if UnRaiseHand then
    begin
      Self.UnRaiseHand(DestUser);
      NotifyAdminsAboutOperation(User,Packet);
    end;
  end;
end;
}

procedure TRoomWindow.UnBounceThisUser(UserName: string);
begin
  BounceUser(UserName,False);
end;

procedure TRoomWindow.AdminCloseRoom;
var
  Packet: TAdminOperationPacket;
begin
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  Packet.Operation := $1000 or $20000;      // bit 12    1 0000 0000 0000
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

function TRoomWindow.ShiftDown : Boolean;
var
   State : TKeyboardState;
begin
   GetKeyboardState(State) ;
   Result := ((State[vk_Shift] and 128) <> 0) ;
end;

procedure TRoomWindow.UsersListViewClick(Sender: TObject);
begin
  if ShiftDown and (UsersListView.PopupMenu = AdminListViewPOPUPMenu) then
  begin
    AdminListViewPOPUPMenuPopup(Self);
    mDefaultReddot.Click;
  end;
end;

procedure TRoomWindow.mrCopyClick(Sender: TObject);
begin
  InputMemo.CopyToClipboard;
end;

procedure TRoomWindow.mrCutClick(Sender: TObject);
begin
  InputMemo.CutToClipboard;
end;

procedure TRoomWindow.mrPasteClick(Sender: TObject);
begin
  InputMemo.PasteFromClipboard;
end;

procedure TRoomWindow.mrDeleteClick(Sender: TObject);
begin
  InputMemo.SelText := '';
end;

procedure TRoomWindow.mSaveClick(Sender: TObject);
var
  StrList: TStringList;
  SaveDialog: TSaveDialog;
  SelStart,SelLength: Integer;
begin
  StrList := TStringList.Create;
  SaveDialog := TSaveDialog.Create(Self);
  SaveDialog.Filter := 'Text Files (*.txt)|*.txt';
  if SaveDialog.Execute then
  begin
    {SelStart := Viewer.SelStart;
    SelLength := Viewer.SelLength;
    Viewer.SelectAll;
    StrList.Text := Viewer.SelText;
    Viewer.SelStart := SelStart;
    Viewer.SelLength := SelLength;
    if LowerCase(RightStr(SaveDialog.FileName,4))<>'.txt' then
      SaveDialog.FileName := SaveDialog.FileName + '.txt';
    StrList.SaveToFile(SaveDialog.FileName);   }
  end;
  SaveDialog.Free;
  StrList.Free;
end;

procedure TRoomWindow.mAddBuddyClick(Sender: TObject);
var
  Buddy: string;
begin
  if UsersListView.ItemIndex>-1 then
  begin
    Buddy := PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName;
    MainForm.AddAsFriend(Buddy);
  end;
end;

procedure TRoomWindow.mBlockUserClick(Sender: TObject);
var
  Buddy: string;
begin
  if UsersListView.ItemIndex>-1 then
  begin
    Buddy := PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName;
    MainForm.BlockThisUser(Buddy);
  end;
end;

procedure TRoomWindow.FormResize(Sender: TObject);
begin
  //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
  Viewer.Invalidate;
end;

procedure TRoomWindow.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1Click(Self);
end;

procedure TRoomWindow.PingTimerTimer(Sender: TObject);
var
  Packet: TCommunicatorPacket;
begin
  if MilliSecondsBetween(Now,InputThread.LastDataSentTime)>5000 then
  begin
    Packet.Signature := PACKET_SIGNATURE;
    Packet.Version := PACKET_VERSION;
    Packet.DataType := pdtPing;
    Packet.BufferSize := SizeOf(TCommunicatorPacket);
    InputThread.SendBuffer(@Packet,SizeOf(TAddBuddyPacket));
  end;
end;

procedure TRoomWindow.HandleDisconnet(var msg: TMessage);
begin
  if not Showing then Exit;
  MessageBox(Handle,'Disconnected from server.','Error',MB_OK);
  Close;
  //Application.Terminate;
end;

procedure TRoomWindow.SaveDefaultSettingClick(Sender: TObject);
var
  Setting: TUserSetting;
begin
  Setting := MainForm.UserSetting;
  Setting.GroupBold := fsBold in InputMemo.SelAttributes.Style;
  Setting.GroupItalic := fsItalic in InputMemo.SelAttributes.Style;
  Setting.GroupUnderLine := fsUnderline in InputMemo.SelAttributes.Style;
  Setting.GroupColor := InputMemo.SelAttributes.Color;
  Setting.GroupFontSize := FontSizeCombo.ItemIndex;
  Setting.GroupJoinNotify := Notifymewhenauserjoinedtheroom1.Checked;
  Setting.GroupLeftNotify := Notifymewhenauserlefttheroom1.Checked;
  MainForm.UserSetting := Setting;
  MainForm.SaveUserSetting;
end;

procedure TRoomWindow.mcOtherColorsDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var
  TmpRect: TRect;
begin
  if Selected then
    ACanvas.Brush.Color := clHighlight
  else
    ACanvas.Brush.Color := clMenu;

  //ARect.Left := 20;
  ACanvas.FillRect(ARect);
  TmpRect.Left := ARect.Left + 5;
  TmpRect.Top := ARect.Top + 3;
  TmpRect.Bottom := ARect.Bottom - 3;
  TmpRect.Right := ARect.Right - 5;
  case (Sender as TMenuItem).Tag of
  0: ACanvas.Brush.Color := clBlack;
  1: ACanvas.Brush.Color := clGreen;
  2: ACanvas.Brush.Color := clBlue;
  3: ACanvas.Brush.Color := $004F7CE8;
  4: ACanvas.Brush.Color := $00005782;
  5: ACanvas.Brush.Color := $00BE3F75;
  6: ACanvas.Brush.Color := $008000FF;
  7: ACanvas.Brush.Color := clSkyBlue;
  8: ACanvas.Brush.Color := $00BE3F75;
  9: ACanvas.Brush.Color := clGray;
  end;
  ACanvas.FillRect(TmpRect);
end;

procedure TRoomWindow.mcOtherColorsMeasureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
begin
  Height := Height - 5;

end;

procedure TRoomWindow.OtherColors1Click(Sender: TObject);
var
  ColorDialog: THCColorDialog;
begin
  ColorDialog := THCColorDialog.Create(Self);
  if ColorDialog.Execute then
    CurrentColor := ColorDialog.Color;
  InputMemo.SelAttributes.Color := CurrentColor;
  ColorDialog.Free;
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TRoomWindow.mcOtherColorsClick(Sender: TObject);
begin
  case (Sender as TMenuItem).Tag of
  0: CurrentColor := clBlack;
  1: CurrentColor := clGreen;
  2: CurrentColor := clBlue;
  3: CurrentColor := $004F7CE8;
  4: CurrentColor := $00005782;
  5: CurrentColor := $00BE3F75;
  6: CurrentColor := $008000FF;
  7: CurrentColor := clSkyBlue;
  8: CurrentColor := $00BE3F75;
  9: CurrentColor := clGray;
  end;
  InputMemo.SelAttributes.Color := CurrentColor;
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TRoomWindow.SetPrivacy(Privacy: Byte);
var
  Packet: TSetPrivacyPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtSetPrivacyPacket;
  Packet.BufferSize := SizeOf(TSetPrivacyPacket);
  Packet.privacy := Privacy;
  SendBuffer(Packet,SizeOf(TSetPrivacyPacket));
end;

procedure TRoomWindow.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TRoomWindow.BrowseRoomsButtonClick(Sender: TObject);
begin
  BrowseRoomsForm.Show;
  BrowseRoomsForm.RefreshBtnClick(Self);
end;

procedure TRoomWindow.maBRBClick(Sender: TObject);
{
var
  Packet: TSetBRBPacket;
}
begin
{
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtSetBRBPacket;
  Packet.BufferSize := SizeOf(TSetBRBPacket);
  if FBRB then
    Packet.BRB := 0
  else
    Packet.BRB := 1;
  InputThread.SendBuffer(@Packet,SizeOf(TSetBRBPacket));
}
end;

procedure TRoomWindow.FormDestroy(Sender: TObject);
begin
  if Showing then Close;
  //FVolumeControlForm := TVolControlForm.Create(Self);
end;

procedure TRoomWindow.MuteButtonClick(Sender: TObject);
var
  Packet: TMutePacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtMutePacket;
  Packet.BufferSize := SizeOf(TMutePacket);
  if MuteButton.Down then
    Packet.Mute := 1
  else
    Packet.Mute := 0;
  InputThread.SendBuffer(@Packet,SizeOf(TMutePacket));
end;

procedure TRoomWindow.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  if (NewSize>331) or (NewSize<210) then
    Accept := False;
end;

procedure TRoomWindow.mVoiceActivateClick(Sender: TObject);
begin
  mVoiceActivate.Checked := not mVoiceActivate.Checked;
  if not mVoiceActivate.Checked then
    MicButtonClick(Self)
  else
    Streaming := mVoiceActivate.Checked;
end;

procedure TRoomWindow.mInviteFriendsClick(Sender: TObject);
begin
  InviteButtonClick(Self);
end;

procedure TRoomWindow.mPMSelectedUserClick(Sender: TObject);
var
  Buddy: string;
begin
  if UsersListView.ItemIndex = -1 then
  begin
    MessageBox(Handle,'Please select a buddy from list first.','Error',MB_OK);
    Exit;
  end
  else
  begin
    Buddy := PRoomUserInfo(UsersListView.Items[UsersListView.ItemIndex].Data).UserName;
    MainForm.OpenChatWindow(Buddy);
  end;
end;

procedure TRoomWindow.mLockOnMicClick(Sender: TObject);
begin
  MicButtonClick(Self);
end;

procedure TRoomWindow.UsersListViewResize(Sender: TObject);
begin
//  UsersListView.Columns[0].Width := UsersListView.Width - 25;
//  UsersListView.Refresh;
end;

procedure TRoomWindow.ActionMenuPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
begin
  if RaiseHandButton.Down then
    mRaiseHand.Caption := 'Unraise Hand'
  else
    mRaiseHand.Caption := 'Raise Hand';
  if Streaming then
  begin
    mVoiceActivate.Checked := True;
    mLockOnMic.Caption := 'Release Mic'
  end
  else
  begin
    mVoiceActivate.Checked := False;
    mLockOnMic.Caption := 'Lock On Mic'
  end;
end;

procedure TRoomWindow.mRaiseHandClick(Sender: TObject);
begin
  RaiseHandButtonClick(Self);
end;

procedure TRoomWindow.ShowCamIcon(Show: Boolean);
var
  Packet: TSetCamIconPacket;
begin
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtSetCamIconPacket;
  Packet.BufferSize := SizeOf(TSetBRBPacket);
  if Show then
    Packet.CamIcon := 1
  else
    Packet.CamIcon := 0;
  InputThread.SendBuffer(@Packet,SizeOf(TSetBRBPacket));
end;

procedure TRoomWindow.Splitter1Moved(Sender: TObject);
begin
  UsersListView.Columns[0].Width := UsersListView.Width - 21;
end;

procedure TRoomWindow.SetNewUserReddotsOrder(RedText, RedMic,
  RedVideo: Boolean);
var
  Packet: TAdminOperationPacket;
begin
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  Packet.Operation := $1000;      // bit 12    1 0000 0000 0000
  if RedText then
    Packet.Operation := Packet.Operation or $2000;
  if RedVideo then
    Packet.Operation := Packet.Operation or $4000;
  if RedMic then
    Packet.Operation := Packet.Operation or $8000;
  if RedMic or RedVideo or RedText then
    Packet.Operation := Packet.Operation or $10000;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;

procedure TRoomWindow.SetRoomTitle(RoomTitle: string);
var
  Packet: PModifyRoomTitlePacket;
  PacketSize: Integer;
begin
  if Length(RoomTitle)>2000 then Exit;
  PacketSize := SizeOf(TModifyRoomTitlePacket)+Length(RoomTitle)+1;
  GetMem(Packet,PacketSize);
  ZeroMemory(Packet,PacketSize);
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtModifyRoomTitle;
  Packet.BufferSize := PacketSize;
  StrCopy(Pointer(Cardinal(Packet)+SizeOf(TModifyRoomTitlePacket)),PChar(RoomTitle));
  InputThread.SendBuffer(Packet,PacketSize);
  FreeMem(Packet);
end;

procedure TRoomWindow.RoomTitleRichEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if RoomTitleRichEdit.SelText <> '' then
    RoomTitleRichEdit.PopupMenu := RoomTitlePOPUP
  else
    RoomTitleRichEdit.PopupMenu := nil;
end;

procedure TRoomWindow.RoomTitleCopyClick(Sender: TObject);
begin
  RoomTitleRichEdit.CopyToClipboard;
end;

procedure TRoomWindow.RoomTitleRichEditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (not (ssCtrl in Shift)) and InputMemo.Enabled then
    InputMemo.SetFocus;
end;

{
procedure TRoomWindow.BanUser(UserName: string; Ban: Boolean);
var
  Packet: TAdminOperationPacket;
begin
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  StrCopy(Packet.UserName,PChar(UserName));
  if Bounce then
    Packet.Operation := 16
  else
    Packet.Operation := 1024;
  InputThread.SendBuffer(@Packet,SizeOf(TAdminOperationPacket));
end;
}
procedure TRoomWindow.AddToFavoriteButtonClick(Sender: TObject);
var
  Registry: TRegistry;
begin
  if MainForm.FavoriteRoomList.IndexOf(Caption)=-1 then
  begin
    Registry := TRegistry.Create;
    Registry.CreateKey('\Software\Beyluxe Messenger\'+ MainForm.MyNickName + '\FavoriteRooms\'+Caption);
    Registry.CloseKey;
    Registry.Free;
    ShowMessage('Room '+Caption+' has been Added to your Favorite Room List.');
  end
  else
  begin
    ShowMessage('Room '+Caption+' is already in your Favorite Room List.');
    Exit;
  end;
  MainForm.FavoriteRoomList.Add(Caption);
  MainForm.MakeFavoriteRoomMenu;
end;

procedure TRoomWindow.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  ShowWindow(WebBrowser1.Handle,SW_HIDE);
end;

procedure TRoomWindow.FreezDisplayClick(Sender: TObject);
begin
//  FreezDisplay.Checked := not FreezDisplay.Checked;
  DisplayFreezed := FreezDisplay.Checked;
  if DisplayFreezed then
    DisPlayFreezTime := Now;
end;

procedure TRoomWindow.AddToHTMLViewer(Str: string);
begin
  if FRoomClosing then Exit;
  FRoomStrQueue.Add(Str);
  if not DisplayFreezed then
  while FRoomStrQueue.Count>0 do
  begin
    AppendToWB(Viewer, FRoomStrQueue.Strings[0]);
    //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
    Viewer.Invalidate;
    FRoomStrQueue.Delete(0);
  end;
end;

procedure TRoomWindow.HandleAdminOperationPacket(var msg: TMessage);
var
  i: Integer;
  Operation: Cardinal;
  UserName: string;
  RedDotText: Boolean;
  RedDotMic: Boolean;
  RedDotVideo: Boolean;
  DefRedDotTextHandler: TNotifyEvent;
  DefRedDotMicHandler: TNotifyEvent;
  DefRedDotVideoHandler: TNotifyEvent;
begin
  if FRoomClosing then Exit;
  InputThread.AdminOperationListCriticalSection.Enter;
  while InputThread.AdminOperationList.Count>0 do
  begin
    Operation := Cardinal(InputThread.AdminOperationList.Objects[0]);
    UserName := InputThread.AdminOperationList.Strings[0];
    InputThread.AdminOperationList.Delete(0);

    if Operation and $80000>0 then     // if thats RedAll packet
    begin
      RedDotText :=  Operation and $100000>0;
      RedDotMic :=   Operation and $200000>0;
      RedDotVideo := Operation and $400000>0;

      // get from list and execute
      for i := 0 to UsersListView.Items.Count -1 do
      begin
        if PRoomUserInfo(UsersListView.Items.Item[i].Data).UserName = UserName then
          Continue;

        if RedDotVideo then
        begin
          PRoomUserInfo(UsersListView.Items.Item[i].Data).Status := PRoomUserInfo(UsersListView.Items.Item[i].Data).Status or $100;
          RedDotVideoThisUser(i);
        end
        else
        begin
          PRoomUserInfo(UsersListView.Items.Item[i].Data).Status := PRoomUserInfo(UsersListView.Items.Item[i].Data).Status and $FFFFFEFF;
          UnRedDotVideoThisUser(i);
        end;

        if RedDotMic then
        begin
          PRoomUserInfo(UsersListView.Items.Item[i].Data).Status := PRoomUserInfo(UsersListView.Items.Item[i].Data).Status or $80;
          RedDotMicThisUser(i);
        end
        else
        begin
          PRoomUserInfo(UsersListView.Items.Item[i].Data).Status := PRoomUserInfo(UsersListView.Items.Item[i].Data).Status and $FFFFFF7F;
          UnRedDotMicThisUser(i);
        end;

        if RedDotText then
        begin
          PRoomUserInfo(UsersListView.Items.Item[i].Data).Status := PRoomUserInfo(UsersListView.Items.Item[i].Data).Status or $40;
          RedDotTextThisUser(i);
        end
        else
        begin
          PRoomUserInfo(UsersListView.Items.Item[i].Data).Status := PRoomUserInfo(UsersListView.Items.Item[i].Data).Status and $FFFFFFBF;
          UnRedDotTextThisUser(i);
        end;
      end;

      with FAdminControlPanel do
      begin
        DefRedDotTextHandler := DefaultRedDotText.OnClick;
        DefRedDotMicHandler := DefaultRedDotMic.OnClick;
        DefRedDotVideoHandler := DefaultRedDotVideo.OnClick;

        //then nil them...
        DefaultRedDotText.OnClick := nil;
        DefaultRedDotMic.OnClick := nil;
        DefaultRedDotVideo.OnClick := nil;

        //Now modify them
        DefaultRedDotText.Checked := RedDotText;
        DefaultRedDotMic.Checked := RedDotMic;
        DefaultRedDotVideo.Checked := RedDotVideo;

        //Now restore EventHandlers
        DefaultRedDotText.OnClick := DefRedDotTextHandler;
        DefaultRedDotMic.OnClick := DefRedDotMicHandler;
        DefaultRedDotVideo.OnClick := DefRedDotVideoHandler;
      end;
    end;
  end;
  InputThread.AdminOperationListCriticalSection.Leave;
end;

procedure TRoomWindow.TBXItem1Click(Sender: TObject);
var
  Packet: TAdminOperationPacket;
begin
  ZeroMemory(@Packet,SizeOf(TAdminOperationPacket));
  Packet.Signature := PACKET_SIGNATURE;
  Packet.Version := PACKET_VERSION;
  Packet.DataType := pdtAdminOperation;
  Packet.BufferSize := SizeOf(TAdminOperationPacket);
  case TTBXItem(Sender).Tag of
  0: Packet.Operation := $780000;
  1: Packet.Operation := $180000;
  2: Packet.Operation := $280000;
  3: Packet.Operation := $480000;
  4: Packet.Operation := $080000;
  end;
  SendBuffer(Packet,SizeOf(TAdminOperationPacket));
end;

procedure TRoomWindow.TBXItem11Click(Sender: TObject);
begin
  //Viewer.CharSet := ANSI_CHARSET;
end;

procedure TRoomWindow.TBXItem14Click(Sender: TObject);
begin
  //Viewer.CharSet := ARABIC_CHARSET
end;

procedure TRoomWindow.TBXItem17Click(Sender: TObject);
begin
  //Viewer.CharSet := BALTIC_CHARSET
end;

procedure TRoomWindow.TBXItem20Click(Sender: TObject);
begin
  //Viewer.CharSet := CHINESEBIG5_CHARSET
end;

procedure TRoomWindow.TBXItem21Click(Sender: TObject);
begin
  //Viewer.CharSet := DEFAULT_CHARSET
end;

procedure TRoomWindow.TBXItem22Click(Sender: TObject);
begin
  //Viewer.CharSet := EASTEUROPE_CHARSET
end;

procedure TRoomWindow.TBXItem23Click(Sender: TObject);
begin
  //Viewer.CharSet := GB2312_CHARSET
end;

procedure TRoomWindow.TBXItem24Click(Sender: TObject);
begin
  //Viewer.CharSet := GREEK_CHARSET
end;

procedure TRoomWindow.TBXItem25Click(Sender: TObject);
begin
  //Viewer.CharSet := HANGEUL_CHARSET
end;

procedure TRoomWindow.TBXItem26Click(Sender: TObject);
begin
  //Viewer.CharSet := HEBREW_CHARSET
end;

procedure TRoomWindow.TBXItem27Click(Sender: TObject);
begin
  //iewer.CharSet := JOHAB_CHARSET
end;

procedure TRoomWindow.TBXItem28Click(Sender: TObject);
begin
  //Viewer.CharSet := MAC_CHARSET
end;

procedure TRoomWindow.TBXItem29Click(Sender: TObject);
begin
  //Viewer.CharSet := OEM_CHARSET
end;

procedure TRoomWindow.TBXItem30Click(Sender: TObject);
begin
  //Viewer.CharSet := RUSSIAN_CHARSET
end;

procedure TRoomWindow.TBXItem31Click(Sender: TObject);
begin
  //Viewer.CharSet := SHIFTJIS_CHARSET
end;

procedure TRoomWindow.TBXItem32Click(Sender: TObject);
begin
  //Viewer.CharSet := SYMBOL_CHARSET
end;

procedure TRoomWindow.TBXItem33Click(Sender: TObject);
begin
  //Viewer.CharSet := THAI_CHARSET
end;

procedure TRoomWindow.TBXItem34Click(Sender: TObject);
begin
  //Viewer.CharSet := TURKISH_CHARSET
end;

procedure TRoomWindow.UsersListViewDblClick(Sender: TObject);
//var Item: TListItem;
begin
//TADD PM
 {if UsersListView.ItemIndex = -1 then Exit;
 Item := UsersListView.Items[UsersListView.ItemIndex];
 POPUPActiveUserName := PRoomUserInfo(Item.Data).UserName;
 if UsersListView.Items.Item[UsersListView.ItemIndex].StateIndex = 0 then
  Viewwebcam1Click(Self)
 else  }
   mSendPMClick(Self);
end;

procedure TRoomWindow.WMGetWindows(var Msg : TWMCopyData);
var
  HandleW:THandle;
begin
HandleW := Msg.copyDataStruct.dwData;
 if HandleW <> 0 then
 begin
    WMWindowsHWND := HandleW ;
    WMExist := True;
    //forward
    msg.Result := 0010;
 end;
if HandleW = 1101 then
 WMExist := False;
end;


procedure TRoomWindow.WMSendString(var user,Text:string);
var
   stringToSend : string;
   copyDataStruct : TCopyDataStruct;
begin
   if (WMWindowsHWND = 0) and (WMExist = False) then Exit;
   stringToSend := user + chr($58)+ Text;

   copyDataStruct.dwData := 0;
   copyDataStruct.cbData := 1 + Length(stringToSend) ;
   copyDataStruct.lpData := PChar(stringToSend) ;
   SendMessage(WMWindowsHWND, WM_COPYDATA, Integer(Handle), Integer(@copyDataStruct)) ;
end;

end.
