unit CommunicatorTypes;

interface

uses
  messages;

const
  SystemNickName = 'System';

  PACKET_SIGNATURE  = $4843;
  PACKET_VERSION    = 30;
  MINMP3BUFTOSEND   = 150;

  WCM_JoinRoomInfo      = WM_USER + 1;
  WCM_DestroyMePrvRoom  = WM_USER + 2;
  WCM_RemoveMicIcon     = WM_USER + 3;
  WCM_DestroyMePM       = WM_USER + 4;
  WCM_DestroyMeRoom     = WM_USER + 5;

  PassWordLookupTable = 'c(gGO6%Qr;s{"dt^Zu8J<M,v1:L_K]pX3!qI=F>Y.P$Rj9 W[w2So0 TD#~x\a)4yA}?f+CVhUi&l/m@nz5Ee`BbH|7-Nk*';
  RealTable =           ' !"#$%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ';

  //Packet Data Types
  pdtRegister          = 1;
  pdtPrivateMessage    = 2;
  pdtLogin             = 3;
  pdtLogout            = 4;
  pdtAddRequest        = 5;
  pdtPing              = 6;
  pdtFriendList        = 7;
  pdtIgnoreList        = 8;
  pdtDenyAdd           = 9;
  pdtBoddyStatus       = 10;
  pdtOnlineBuddyList   = 11;
  pdtLoginFailed       = 12;
  pdtNotifyMessage     = 13;
  pdtUnIgnoreList      = 14;
  pdtRemoveBuddy       = 15;
  pdtSearchUser        = 16;
  pdtCategoryList      = 17;
  pdtSubCategoryList   = 18;
  pdtRoomList          = 19;
  pdtJoinPrvRoomReq    = 20;
  pdtRoomUserList      = 21;
  pdtUserJoinLeftRoom  = 22;
  pdtGroupMessage      = 23;
  pdtGroupVoicePacket  = 24;
  pdtCreatePrvRoom     = 25;
  pdtJoinRoomInfo      = 26;
  pdtPrvRoomInvite     = 27;
  pdtReqNextVCPacket   = 28;
  pdtMicFreePacket     = 29;
  pdtMicRequestPacket  = 30;
  pdtMicGrantedPacket  = 31;
  pdtRaiseHandPacket   = 32;
  pdtRoomUserStatChange= 33;
  pdtCamSessionJoinLeft= 34;
  pdtCamFrameSet       = 35;
  pdtCamUploadRequest  = 36;
  pdtCamViewRequest    = 37;
  pdtStartCamPacket    = 38;
  pdtStartCamInfoPacket= 39;
  pdtCamViewReqReply   = 40;
  pdtCreateRoom        = 41;
  pdtCatListAll        = 42;
  pdtOpenRoomAsAdmin   = 43;
  pdtRoomInfoReqPacket = 44;
  pdtInviteRoomPacket  = 45;
  pdtAdminOperation    = 46;
  pdtRoomWhisperPacket = 47;
  pdtRoomAlertPacket   = 48;
  pdtAdminInfoAll      = 49;
  pdtAdminOperationReport = 50;
  pdtUserInfoPacket    = 51;
  pdtOfflinePacket     = 52;
  pdtInvitePMAudio     = 53;
  pdtAcceptPMAudio     = 54;
  pdtExactUserName     = 55;
  pdtSetPrivacyPacket  = 56;
  pdtSetBRBPacket      = 57;
  pdtMutePacket        = 58;
  pdtSetCamIconPacket  = 59;
  pdtModifyRoomTitle   = 60;
  pdtSendFileRequest   = 61;
  pdtFileUploadRequest = 62;
  pdtFileDownloadRequest = 63;
  pdtFileData          = 64;
  pdtFilePauseRequset  = 65;
  pdtStartFileTransfer = 66;
  pdtMessengerStatPacket = 67;
  pdtChangePassword    = 68;
  pdtSessionIDAndSeed  = 69;
  pdtHDDSerialPacket   = 70;
  pdtVolumeSerialPacket= 71;
  pdtOSInstallTime     = 72;
  pdtYahooMSNPacket    = 73;
  pdtMacListPacket     = 74;
  pdtPasswordPacket    = 75;
  pdtBuddyRemovedPacket= 76;
  pdtBuddyAddedPacket  = 77;
  pdtUpdatePacket      = 78;
  pdtCloseRoomPacket   = 79;
  pdtGrabInfoFromUserPC= 80;
  pdtAdditionalInfo    = 81;

  // Body Status
  bsOffline            = 0;
  bsOnline             = 1;
  bsAway               = 2;
  bsPhone              = 3;
  bsBusy               = 4;
  bsDND                = 5;
  bsCustom             = 6;

  // Room Actions
  UserJoinedTheRoom  = 0;
  UserLeftTheRoom    = 1;
  UserRaisesHand     = 2;
  UserTakeMice       = 3;
  UserSendGroupMsg   = 4;

type
  TGender = (gMale, gFemale, gNotSpecified);
  TUserInfo = packed record
    UserID: Integer;
    UserName: string;
    Password: string;
    Country: string;
    Gender: TGender;
    Birthday: string;
    Email: string;
    IPAddress: string;
    Ban: Byte;
    Privacy: Byte;
    Privilege: Byte;
    SecretQuestion: Byte;
    Subscription: Byte;
    SecretAnswer: string;
    FriendList: string;
    IgnoreList: string;
    ProfileList: string;
    HDDSerial: string;
    AddReferenceList: string;
    LastIPAddress: string;
    LastHDDSerial: string;
    FirstMac1: string;
    FirstMac2: string;
    FirstMac3: string;
    LastMac1: string;
    LastMac2: string;
    LastMac3: string;
    OSVersion: string;
    RegisterTime: TDateTime;
    LastLoginTime: TDateTime;
    VolumeSerial: string;
    LastVolumeSerial: string;
  end;

  TCommunicatorPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
  end;
  PCommunicatorPacket = ^TCommunicatorPacket;

  TLoginPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Checksum: Cardinal;
    Status: Byte;
//    UserName: array[0..32] of char;
//    Password: array[0..32] of char;
//    Serial: array[0..64] of char;
//    MacAddress1: array [0..20] of char;
//    MacAddress2: array [0..20] of char;
//    MacAddress3: array [0..20] of char;
//    VolumeSerial: array [0..10] of char;
//    OSVersion: array [0..50] of char;
  end;
  PLoginPacket = ^TLoginPacket;

  TExactUserNamePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of Char;
    Subscription: Integer;
    Privacy: Integer;
    Privilege: Integer;
  end;
  PExactUserNamePacket = ^TExactUserNamePacket;

  TUserInfoPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    SecretQuestion: Integer;
    RoomsCount: Integer;
    UserName: array[0..32] of char;
//    RoomName: array[0..80] of char;
//    AdminCode: array[0..10] of char;
//    LockCode: array[0..10] of char;
//    WlcMessage: array[0..2000] of char;
//    AdminList: array[0..4000] of char;
    AdminListControl: Boolean;
    RoomRating: Byte;
    Category: Integer;
    SubCategory: Integer;
  end;
  PUserInfoPacket = ^TUserInfoPacket;

  TBuddyStatusPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Buddy: array[0..32] of char;
    Status: Byte;
    StatusText: array[0..80] of char;
  end;
  PBuddyStatusPacket = ^TBuddyStatusPacket;

  TChangeStatusPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Status: Byte;
    StatusText: array[0..80] of char;
  end;
  PChangeStatusPacket = ^TChangeStatusPacket;

  TRegisterPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Checksum: Cardinal;
    Invisible: Boolean;
    Name: array[0..50] of char;
    LastName: array[0..50] of char;
    UserName: array[0..32] of char;
//    Password: array[0..32] of char;
    Gender: Byte;
    SecretQuestionNo: Byte;
    SecretAnswer: array [0..32] of char;
    EmailAddress: array [0..64] of char;
    Birthday: array [0..20] of char;
    Country: array [0..49] of char;
//    Serial: array[0..64] of char;
//    MacAddress1: array [0..20] of char;
//    MacAddress2: array [0..20] of char;
//    MacAddress3: array [0..20] of char;
//    VolumeSerial: array [0..10] of char;
//    OSVersion: array [0..50] of char;
  end;
  PRegisterPacket = ^TRegisterPacket;

  TRegisterResultPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RegResult: SmallInt;
  end;
  PRegisterResultPacket = ^TRegisterResultPacket;

  TListPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
  end;
  PListPacket = ^TListPacket;

  TLoginFailedPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    FailReason: SmallInt;
  end;

  TPMPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    PMRes: Integer;
    Sender: array[0..32] of char;
    Receiver: array[0..32] of char;
    TextBufferSize: Integer;
  end;
  PPMPacket = ^TPMPacket;

  TNotifyPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Msg: array[0..1024] of char;
    Close: Boolean;
  end;
  PNotifyPacket = ^TNotifyPacket;

  TIgnorePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of char;
  end;
  PIgnorePacket = ^TIgnorePacket;

  TUnIgnorePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of char;
  end;
  PUnIgnorePacket = ^TUnIgnorePacket;

  TRemoveBuddyPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of char;
  end;
  PRemoveBuddyPacket = ^TRemoveBuddyPacket;

  TAddBuddyPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of char;
  end;
  PAddBuddyPacket = ^TAddBuddyPacket;

  TCategoryPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
  end;
  PCategoryPacket = ^TCategoryPacket;

  TSubCategoryPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    CategoryNo: Integer;
  end;
  PSubCategoryPacket = ^TSubCategoryPacket;

  TRoomListPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    CategoryNo: Integer;
    SubCategoryNo: Integer;
  end;
  PRoomListPacket = ^TRoomListPacket;

  TJoinRoomInfoPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomType: Byte;
    RoomCode: Integer;
    RoomPort: Integer;
    RoomName: array[0..80] of char;
    GrantCode: array[0..15] of char;
  end;
  PJoinRoomInfoPacket = ^TJoinRoomInfoPacket;

  TJoinPrvRoomReqPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of char;
    GrantCode: array[0..15] of char;
  end;
  PJoinPrvRoomReqPacket = ^TJoinPrvRoomReqPacket;

  TRoomUserListPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomCode: Cardinal;
  end;
  PRoomUserListPacket = ^TRoomUserListPacket;

  TUserJoinLeftRoomPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomCode: Cardinal;
    Direction: Byte;
    Status: Cardinal;
    Color: Cardinal;
    UserName: array[0..32] of char;
  end;
  PUserJoinLeftRoomPacket = ^TUserJoinLeftRoomPacket;

  TGroupMessagePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomCode: Cardinal;
    UserName: array[0..32] of char;
  end;
  PGroupMessagePacket = ^TGroupMessagePacket;

  TGroupVoicePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomCode: Cardinal;
    UserName: array [0..32] of char;
  end;
  PGroupVoicePacket = ^TGroupVoicePacket;

  TCreatePrvRoomPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
  end;
  PCreatePrvRoomPacket = ^TCreatePrvRoomPacket;

  TPrvRoomInvitePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomCode: Integer;
    UserName: array [0..32] of char;
  end;
  PPrvRoomInvitePacket = ^TPrvRoomInvitePacket;

  TPrvRoomInviteInfoPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomCode: Integer;
    RoomPort: Integer;
    UserName: array[0..32] of char;
    GrantCode: array[0..15] of char;
  end;
  PPrvRoomInviteInfoPacket = ^TPrvRoomInviteInfoPacket;

  TRaiseHandPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RaiseHand: Byte;
    UserName: array[0..32] of char;
  end;
  PRaiseHandPacket = ^TRaiseHandPacket;

  TRoomUserStatusChangedPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Status: Cardinal;
    UserName: array[0..32] of char;
  end;
  PRoomUserStatusChangedPacket = ^TRoomUserStatusChangedPacket;

  TCamSessionJoinLeftPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Status: Byte;
    UserName: array[0..32] of char;
  end;
  PCamSessionJoinLeftPacket = ^TCamSessionJoinLeftPacket;

  TCamUploadRequestPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    LoginSession: Cardinal;
    UserName: array[0..32] of char;
    PublisherCode: array [0..16] of char;
  end;
  PCamUploadRequestPacket = ^TCamUploadRequestPacket;

  TCamViewRequestPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    LoginSession: Cardinal;
    UserName: array[0..32] of char;
  end;
  PCamViewRequestPacket = ^TCamViewRequestPacket;

  TStartWebcamInfoPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    PortNo: SmallInt;
    PublishCode: array [0..16] of char;
  end;
  PStartWebcamInfoPacket = ^TStartWebcamInfoPacket;

  TStartWebcamPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    LoginSession: Cardinal;
    Location: Integer;
    UserName: array[0..32] of char;
  end;
  PStartWebcamPacket = ^TStartWebcamPacket;

  TCamViewReqReplyPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    ErrorCode: Integer;
    Port: Word;
    UserName: array[0..32] of char;
  end;
  PCamViewReqReplyPacket = ^TCamViewReqReplyPacket;

  TCreateRoomPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of char;
    RoomName: array[0..80] of char;
    AdminCode: array[0..10] of char;
    LockCode: array[0..10] of char;
    WlcMessage: array[0..2000] of char;
    RoomRating: Byte;
    Category: Integer;
    SubCategory: Integer;
    Security: Byte;
  end;                        // folowed by Admin List if specified in Security.
  PCreateRoomPacket = ^TCreateRoomPacket;

  TOpenRoomAsAdminPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of char;
    AdminCode: array[0..10] of char;
  end;                        // folowed by Admin List if specified in Security.
  POpenRoomAsAdminPacket = ^TOpenRoomAsAdminPacket;

  TInviteRoomPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomType: Byte;
    RoomCode: Integer;
    RoomName: array [0..80] of char;
    UserName: array [0..32] of char;
  end;
  PInviteRoomPacket = ^TInviteRoomPacket;

  TRoomInfoReqPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomType: Byte;
    RoomCode: Integer;
    LockCode: array [0..20] of char;
    RoomName: array [0..80] of char;
  end;
  PRoomInfoReqPacket =  ^TRoomInfoReqPacket;

  TAdminOperationPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array [0..32] of char;
    Operation: Cardinal;
  end;
  PAdminOperationPacket = ^TAdminOperationPacket;
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
    bit 18: Redall Packet   // this bit means that packet is Redall packet
    bit 19: RedWholeRoomText
    bit 20: RedWholeRoomMic
    bit 21: RedWholeRoomVideo
  }

  TRoomWhisperPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array [0..32] of char;
  end;
  PRoomWhisperPacket = ^TRoomWhisperPacket;

  TRoomAlertPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    MessageBox: Boolean;
    ShouldClose: Boolean;
  end;
  PRoomAlertPacket = ^TRoomAlertPacket;

  TAdminInfoAllPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    BounceCount: Integer;
    BanCount: Integer;
    RedDotText: Byte;
    RedDotMic: Byte;
    RedDotVideo: Byte;
    AutoRedDotNewUsers: Byte;
  end;
  PAdminInfoAllPacket = ^TAdminInfoAllPacket;

  TAdminOperationReportPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    AdminName: array [0..32] of char;
    UserName: array [0..32] of char;
    Operation: Cardinal;
  end;
  PAdminOperationReportPacket = ^TAdminOperationReportPacket;

  TInvitePMAudioPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    UserName: array[0..32] of Char;
  end;
  PInvitePMAudioPacket = ^TInvitePMAudioPacket;

  TSetPrivacyPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    privacy: Byte;
  end;
  PSetPrivacyPacket = ^TSetPrivacyPacket;

  TSetBRBPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    BRB: Byte;
  end;
  PSetBRBPacket = ^TSetBRBPacket;

  TMutePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Mute: Byte;
  end;
  PMutePacket = ^TMutePacket;

  TSetCamIconPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    CamIcon: Byte;
  end;
  PSetCamIconPacket = ^TSetCamIconPacket;

  TFrameSetPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    FrameType: Byte;
    Width: WORD;
    Height: WORD;
    TimeStamp: TDateTime;
  end;
  PFrameSetPacket = ^TFrameSetPacket;

  TModifyRoomTitlePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
  end;
  PModifyRoomTitlePacket = ^TModifyRoomTitlePacket;

  TSendFileRequestPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    DestUserName: array [0..33] of char;
    FileName: array [0..255] of char;
    FileSize: Cardinal;
  end;
  PSendFileRequestPacket = ^TSendFileRequestPacket;

  TStartFileTransferPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    DestUserName: array [0..33] of char;
    FileName: array [0..255] of char;
    FileSize: Cardinal;
  end;
  PStartFileTransferPacket = ^TStartFileTransferPacket;

  TMessengerStatPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    OnlineUsers: Integer;
    RoomCount: Word;
  end;
  PMessengerStatPacket = ^TMessengerStatPacket;

  TChangePasswordPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    OldPassword: array[0..32] of char;
    NewPassword: array[0..32] of char;
    SecretAnswer: array [0..32] of char;
  end;
  PChangePasswordPacket = ^TChangePasswordPacket;

  TPasswordPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Checksum: Cardinal;
    HWID: Cardinal;
  end;
  PPasswordPacket = ^TPasswordPacket;
  
  TSessionIDAndSeedPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    SessionID: Integer;
  end;
  PSessionIDAndSeedPacket = ^TSessionIDAndSeedPacket;

  THDDSerialPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Checksum: Cardinal;
  end;
  PHDDSerialPacket = ^THDDSerialPacket;

  TVolumeSerialPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Checksum: Cardinal;
    OSInstallTime: Cardinal;
    FirstVersionWord: Word;
    SecondVersionWord: Word;
    ThirdVersionWord: Word;
    fourthVersionWord: Word;
    UniqueID: array[0..33] of char;
  end;
  PVolumeSerialPacket = ^TVolumeSerialPacket;

  TMacListPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Checksum: Cardinal;
  end;
  PMacListPacket = ^TMacListPacket;

  TAdditionalInfoPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    Checksum: Cardinal;
  end;
  PAdditionalInfoPacket = ^TAdditionalInfoPacket;

  TUpdatePacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    ForceUpdate: Boolean;
    UpdateMajorVersion: Word;
    UpdateMinorVersion: Word;
    UpdateReleaseNo: Word;
    UpdateBuildNo: Word;
  end;
  PUpdatePacket = ^TUpdatePacket;

  TCloseRoomReqPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    RoomName: array [0..80] of char;
  end;
  PCloseRoomReqPacket =  ^TCloseRoomReqPacket;

  TGrabPCInfoPacket = packed record
    Signature: Word;
    Version: Cardinal;
    DataType: Byte;
    BufferSize: Word;
    InfoType: Byte;
    DestUserName: array [0..33] of char;
  end;
  PGrabPCInfoPacket = ^TGrabPCInfoPacket;

implementation

end.