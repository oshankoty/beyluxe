program BeyluxeMessenger;

uses
  FastMM4,
  FastCode,
  FastMove,
  windows,
  Forms,
  SysUtils,
  MainUnit in 'MainUnit.pas' {MainForm},
  RegisterForm in 'RegisterForm.pas' {RegisterFrm},
  LoginUnit in 'LoginUnit.pas' {LoginForm},
  PMWindowUnit in 'PMWindowUnit.pas' {PMWindow},
  CustomAwayMsgForm in 'CustomAwayMsgForm.pas' {CustomAwayMessageForm},
  AddBuddyUnit in 'AddBuddyUnit.pas' {AddBuddyForm},
  BrowseRoomsUnit in 'BrowseRoomsUnit.pas' {BrowseRoomsForm},
  RoomWindowUnit in 'RoomWindowUnit.pas' {RoomWindow},
  InviteMessageBox in 'InviteMessageBox.pas' {InviteMsgBoxForm},
  InviteUserUnit in 'InviteUserUnit.pas' {InviteUserForm},
  ClientThread in 'ClientThread.pas',
  PlayThreadUnit in 'PlayThreadUnit.pas',
  SmilesUnit in 'SmilesUnit.pas' {SmilesForm},
  LogThread in 'LogThread.pas',
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  MyWebcamUnit in 'MyWebcamUnit.pas' {MyCamForm},
  WebCamViewerUnit in 'WebCamViewerUnit.pas' {WebcamViewerForm},
  VolumeCtrlUnit in 'VolumeCtrlUnit.pas' {VolControlForm},
  CreateEditRoomUnit in 'CreateEditRoomUnit.pas' {CreateEditMyRoom},
  IdeSN in 'IdeSN.pas',
  WhisperUnit in 'WhisperUnit.pas' {WhisperForm},
  JoinRoomAsAdmin in 'JoinRoomAsAdmin.pas' {JoinRoomAsAdminForm},
  OfflinesUnit in 'OfflinesUnit.pas' {OfflinesForm},
  GetLockPassword in 'bitmap\GetLockPassword.pas' {GetLockCode},
  ManageCustumAwayMsgForm in 'ManageCustumAwayMsgForm.pas' {ManageCustomAwayMsgForm},
  PreferencesUnit in 'PreferencesUnit.pas' {PreferencesForm},
  AdminPanelUnit in 'AdminPanelUnit.pas' {AdminControlPanel},
  ChangePasswordUnit in 'ChangePasswordUnit.pas' {ChangePasswordForm},
  CommunicatorTypes in 'CommunicatorTypes.pas',
  LoginProgressUnit in 'LoginProgressUnit.pas' {LoginProgressForm},
  Recorder in 'Recorder.pas',
  MiniNotifyUnit in 'MiniNotifyUnit.pas' {MiniNotifyForm},
  UpdateUnit in 'UpdateUnit.pas' {UpdateForm},
  VideoHeader in 'VideoHeader.pas';

{$R *.res}
var
  i: Integer;
  Mutex: THandle;
  CanRun: Boolean;
  TmpStr: string;
  SumStr: Integer;
  SumDifferent: Integer;
  SumStr1: Integer;
  LastError: Integer;
begin
  if not FileExists(ExtractFilePath(Application.ExeName)+'speexw.acm') then
  begin
    MessageBox(Application.Handle,'speexw.acm not found please reinstall the application for fix this problem and try again.','Beyluxe Messenger',MB_OK);
    Halt;
  end;
  {$I Crypt_start.inc}
  TmpStr := ParamStr(1);
  SumStr := 0;
  SumDifferent := 0;
  for i := 1 to Length(TmpStr) do
  begin
    Inc(SumStr,Byte(TmpStr[i]));
    if i>1 then
      Inc(SumDifferent,Byte(TmpStr[i])-Byte(TmpStr[i-1]));
  end;
  TmpStr := Copy(ExtractFileName(ParamStr(0)), 1, 17);
  SumStr1 := 0;
  for i := 1 to Length(TmpStr) do
  begin
    Inc(SumStr1,Byte(TmpStr[i]));
  end;

  if (SumStr1=1717) or (SumStr1=1703) or (SumStr1=1781) or (SumStr1=1767) then
  begin
    Mutex := CreateMutex(nil, True, PChar(TmpStr));
    TmpStr := '';
    LastError := GetLastError;
    CanRun := False;
    if (((Mutex <> 0) and (LastError = 0)) or (SumStr-SumDifferent=724)) then
    begin
      CanRun := True;
    end;
    if CanRun then
    begin
      ShowWindow(Application.Handle, SW_HIDE);
      Application.Initialize;
      Application.ShowMainForm := False;
      Application.CreateForm(TMainForm, MainForm);
      Application.CreateForm(TRegisterFrm, RegisterFrm);
      Application.CreateForm(TLoginForm, LoginForm);
      Application.CreateForm(TCustomAwayMessageForm, CustomAwayMessageForm);
      Application.CreateForm(TAddBuddyForm, AddBuddyForm);
      Application.CreateForm(TBrowseRoomsForm, BrowseRoomsForm);
      Application.CreateForm(TSmilesForm, SmilesForm);
      Application.CreateForm(TAboutForm, AboutForm);
      Application.CreateForm(TCreateEditMyRoom, CreateEditMyRoom);
      Application.CreateForm(TJoinRoomAsAdminForm, JoinRoomAsAdminForm);
      Application.CreateForm(TManageCustomAwayMsgForm, ManageCustomAwayMsgForm);
      Application.CreateForm(TPreferencesForm, PreferencesForm);
      Application.CreateForm(TChangePasswordForm, ChangePasswordForm);
      Application.CreateForm(TLoginProgressForm, LoginProgressForm);
      Application.CreateForm(TMiniNotifyForm, MiniNotifyForm);
      Application.CreateForm(TUpdateForm, UpdateForm);
      Application.CreateForm(TMyCamForm, MyCamForm);
      LoginForm.Show;
      Application.Run;
    end;
    if Mutex <> 0 then
      CloseHandle(Mutex);
  end;
  {$I Crypt_end.inc}
end.

