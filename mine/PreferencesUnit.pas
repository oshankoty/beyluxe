unit PreferencesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TB2Dock, TB2ToolWindow, TBX, StdCtrls, ComCtrls, ExtCtrls,
  TBXDkPanels, Buttons, Spin, Registry, PlayThreadUnit, DSPack, DSUtil,
  DirectShow9;

type
  TSystemPreferences = record
    StartWithWindows: Boolean;
    OpenInNewBrowser: Boolean;
    CloseWithCloseButton: Boolean;
    AutoFontSaveForPM: Boolean;
    AutoFontSaveForRoom: Boolean;
    ClearArchiveOnClose: Boolean;
    SaveMainWindowPos: Boolean;

    AlertSoundsEnable: Boolean;
    AlertWhenInRoom: Boolean;

    ArchiveEnable: Boolean;

    BuddyComesOnLineSnd: string;
    BuddyGoesOfflineSnd: string;
    BounceSnd: string;
    InviteSnd: string;
    PMSnd: string;
    DNDSnd: string;
    BuzzSnd: string;

    AutoUnfreezScreen: Integer;

    PosX: Integer;
    PosY: Integer;
    Width: Integer;
    Height: Integer;

    AudioSoundDeviceIndex: Integer;
    AudioSoundCaptureDeviceIndex: Integer;
    myWebcamDeviceIndex: Integer;
    myWebcamMyCamSize: Integer;
    myWebcamAlwayonTop: Boolean;
    myWebcamAuto: Boolean;
    ViewWebcamOnTop: Boolean;
    ViewWebcamSize: Integer;
  end;

  TAccountPreferences = record
    WhisperAlowEveryOne: Boolean;
    PMAlowEveryOne: Boolean;
    FileTransferAlowEveryOne: Boolean;
    InviteAlowEveryOne: Boolean;
  end;

  TPreferencesForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    ItemsListBox: TListBox;
    GeneralPanel: TPanel;
    TBXToolWindow2: TTBXToolWindow;
    ApplyButton: TButton;
    CancelButton: TButton;
    OkButoon: TButton;
    MessageArchivePanel: TPanel;
    TBXToolWindow3: TTBXToolWindow;
    ArchiveEnableRadioBox: TRadioButton;
    ViewMessageArchiveButton: TButton;
    ArchiveDisableRadioBox: TRadioButton;
    ClearMessageArchiveButton: TButton;
    ArchiveQuestion1Label: TLabel;
    ArchiveQuestion2Label: TLabel;
    PCStartupGroup: TGroupBox;
    AutoStartHiChatterCkeckBox: TCheckBox;
    UsingMessengerGroup: TGroupBox;
    OpenLinksInNewBrowserCkeckBox: TCheckBox;
    CloseProgramOnCloseCkeckBox: TCheckBox;
    ClosingPMGroup: TGroupBox;
    AutoSavePMFontSettingCheckBox: TCheckBox;
    ClosingRoomGroup: TGroupBox;
    AutoSaveRoomFontSettingCheckBox: TCheckBox;
    CloseMessengerGroup: TGroupBox;
    ClearArchiveOnExitCheckBox: TCheckBox;
    SaveWindowPosCheckBox: TCheckBox;
    EventAndSoundsPanel: TPanel;
    TBXToolWindow4: TTBXToolWindow;
    ListBox1: TListBox;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    DisableAlertSoundsCheckBox: TCheckBox;
    DisableAlertSoundsInRoomCkeckBox: TCheckBox;
    PrivacyOptionPanel: TPanel;
    TBXToolWindow5: TTBXToolWindow;
    GroupBox1: TGroupBox;
    PMAlowEveryOneRadioBox: TRadioButton;
    PMAlowContactListRadioBox: TRadioButton;
    GroupBox2: TGroupBox;
    InviteAlowEveryOneRadioBox: TRadioButton;
    InviteAlowContactListRadioBox: TRadioButton;
    GroupBox3: TGroupBox;
    WhisperAlowEveryOneRadioBox: TRadioButton;
    WhisperAlowContactListRadioBox: TRadioButton;
    GroupBox4: TGroupBox;
    FileTransferAlowEveryOneRadioBox: TRadioButton;
    FileTransferAlowContactListRadioBox: TRadioButton;
    GroupBox5: TGroupBox;
    ListBox2: TListBox;
    Button1: TButton;
    Button2: TButton;
    WebcamSetupPanel: TPanel;
    TBXToolWindow6: TTBXToolWindow;
    AudioSetupPanel: TPanel;
    TBXToolWindow7: TTBXToolWindow;
    TBToolWindow2: TTBToolWindow;
    Panel7: TPanel;
    TBToolWindow1: TTBToolWindow;
    Panel8: TPanel;
    TBToolWindow3: TTBToolWindow;
    Panel9: TPanel;
    TBToolWindow4: TTBToolWindow;
    Panel10: TPanel;
    TBToolWindow5: TTBToolWindow;
    Panel11: TPanel;
    TBToolWindow6: TTBToolWindow;
    Panel12: TPanel;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    UnfreezeTimeEdit: TSpinEdit;
    Label2: TLabel;
    AccountManager: TPanel;
    TBXToolWindow8: TTBXToolWindow;
    TBToolWindow7: TTBToolWindow;
    Panel2: TPanel;
    AccountPanel: TGroupBox;
    AccountLabel: TLabel;
    AccountList: TListBox;
    AccountDelete: TButton;
    AccountClear: TButton;
    LblSetting: TLabel;
    SpeakersComboBox: TComboBox;
    LblSpeakers: TLabel;
    LblMicrophone: TLabel;
    MicrophoneComboBox: TComboBox;
    FilterGraph: TFilterGraph;
    VideoWindow: TVideoWindow;
    SampleGrabber: TSampleGrabber;
    WebcamComboBox: TComboBox;
    Filter: TFilter;
    WebcamAutoCheckbox: TCheckBox;
    WebcamAlwayonTop: TCheckBox;
    GroupBox7: TGroupBox;
    myWebcamSize: TRadioGroup;
    Setting: TButton;
    WebcamStart: TButton;
    ViewWebcam: TGroupBox;
    ViewWebcamSize: TRadioGroup;
    ViewWebcamontop: TCheckBox;
    FavoriteManagerPanel: TPanel;
    TBXToolWindow9: TTBXToolWindow;
    TBToolWindow8: TTBToolWindow;
    Panel3: TPanel;
    GroupBox8: TGroupBox;
    FavoriteListBox: TListBox;
    FavoriteDeleteBTN: TButton;
    procedure ItemsListBoxClick(Sender: TObject);
    procedure OkButoonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure AutoStartHiChatterCkeckBoxClick(Sender: TObject);
    procedure OpenLinksInNewBrowserCkeckBoxClick(Sender: TObject);
    procedure CloseProgramOnCloseCkeckBoxClick(Sender: TObject);
    procedure AutoSavePMFontSettingCheckBoxClick(Sender: TObject);
    procedure AutoSaveRoomFontSettingCheckBoxClick(Sender: TObject);
    procedure ClearArchiveOnExitCheckBoxClick(Sender: TObject);
    procedure SaveWindowPosCheckBoxClick(Sender: TObject);
    procedure PMAlowContactListRadioBoxClick(Sender: TObject);
    procedure InviteAlowEveryOneRadioBoxClick(Sender: TObject);
    procedure WhisperAlowEveryOneRadioBoxClick(Sender: TObject);
    procedure FileTransferAlowEveryOneRadioBoxClick(Sender: TObject);
    procedure ArchiveEnableRadioBoxClick(Sender: TObject);
    procedure DisableAlertSoundsCheckBoxClick(Sender: TObject);
    procedure DisableAlertSoundsInRoomCkeckBoxClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure UnfreezeTimeEditChange(Sender: TObject);
    procedure AccountDeleteClick(Sender: TObject);
    procedure AccountClearClick(Sender: TObject);
    procedure WebcamComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WebcamStartClick(Sender: TObject);
    procedure WebcamAutoCheckboxClick(Sender: TObject);
    procedure WebcamAlwayonTopClick(Sender: TObject);
    procedure myWebcamSizeClick(Sender: TObject);
    procedure ViewWebcamSizeClick(Sender: TObject);
    procedure ViewWebcamontopClick(Sender: TObject);
    procedure SpeakersComboBoxChange(Sender: TObject);
    procedure MicrophoneComboBoxChange(Sender: TObject);
    procedure FavoriteDeleteBTNClick(Sender: TObject);
  private
    { Private declarations }
    WebcamStarted: Boolean;
    procedure LoadFormDefaults;
    procedure AccountPC;
    procedure GetAudioSetting;
    procedure SetAudioSetting;
    procedure GetWebcamSetting;
    procedure SetWebcamSetting;
    procedure OnSelectDevice(sender: TObject);
  public
    { Public declarations }
    FSystemPreferences: TSystemPreferences;
    FAccountPreferences: TAccountPreferences;
    procedure WebcamToolBringup;
  end;

var
  PreferencesForm: TPreferencesForm;
  SysDev: TSysDevEnum;

implementation

uses MainUnit;

{$R *.dfm}

procedure TPreferencesForm.ItemsListBoxClick(Sender: TObject);
var
  ItemIndex: Integer;
begin
  ItemIndex := ItemsListBox.ItemIndex;
  if ItemIndex = -1 then
    Exit;
  case ItemIndex of
  0: GeneralPanel.BringToFront;
  1: MessageArchivePanel.BringToFront;
  2: EventAndSoundsPanel.BringToFront;
  3: PrivacyOptionPanel.BringToFront;
  4: AccountManager.BringToFront;
  5: FavoriteManagerPanel.BringToFront;
  6: WebcamToolBringup;
  7: AudioSetupPanel.BringToFront;
  end;
end;

procedure TPreferencesForm.OkButoonClick(Sender: TObject);
begin
  if ApplyButton.Enabled then
  begin
    SetAudioSetting;
    SetWebcamSetting;
    MainForm.SystemPreferences := FSystemPreferences;
    MainForm.AccountPreferences := FAccountPreferences;
    MainForm.SaveSystemPreferences;
    MainForm.SetPrivacy;
  end;
  Close;
end;

procedure TPreferencesForm.AccountPC;
var
  REG:TRegistry;
  tmpStringList : TStringList;
  i:integer;
  tmpUser : string;
begin
  AccountList.Clear;
  tmpStringList := TStringList.Create;
  Reg := TRegistry.Create;
  if Reg.OpenKey('\Software\Beyluxe Messenger',False) then
   Reg.GetKeyNames(tmpStringList);
  for i:=0 to tmpStringList.Count-1 do
  begin
    tmpUser := tmpStringList.Strings[i];
    tmpStringList.Strings[i] := MainForm.EnDecryptUserRegistry(tmpUser,False);
  end;
  AccountList.Items := tmpStringList;
  tmpStringList.Free;
  Reg.Free;
end;

procedure TPreferencesForm.LoadFormDefaults;
begin
  FAccountPreferences := MainForm.AccountPreferences;
  FSystemPreferences := MainForm.SystemPreferences;
  AutoStartHiChatterCkeckBox.Checked := FSystemPreferences.StartWithWindows;
  if FSystemPreferences.ArchiveEnable then
    ArChiveEnableRadioBox.Checked := True
  else
    ArchiveDisableRadioBox.Checked := True;
  OpenLinksInNewBrowserCkeckBox.Checked := FSystemPreferences.OpenInNewBrowser;
  CloseProgramOnCloseCkeckBox.Checked := FSystemPreferences.CloseWithCloseButton;
  AutoSavePMFontSettingCheckBox.Checked := FSystemPreferences.AutoFontSaveForPM;
  AutoSaveRoomFontSettingCheckBox.Checked := FSystemPreferences.AutoFontSaveForRoom;
  ClearArchiveOnExitCheckBox.Checked := FSystemPreferences.ClearArchiveOnClose;
  SaveWindowPosCheckBox.Checked := FSystemPreferences.SaveMainWindowPos;
  DisableAlertSoundsCheckBox.Checked := not FSystemPreferences.AlertSoundsEnable;
  DisableAlertSoundsInRoomCkeckBox.Checked := not FSystemPreferences.AlertWhenInRoom;
  UnfreezeTimeEdit.Text := IntToStr(FSystemPreferences.AutoUnfreezScreen);

  PMAlowEveryOneRadioBox.Checked := FAccountPreferences.PMAlowEveryOne;
  PMAlowContactListRadioBox.Checked := not FAccountPreferences.PMAlowEveryOne;
  WhisperAlowEveryOneRadioBox.Checked := FAccountPreferences.WhisperAlowEveryOne;
  WhisperAlowContactListRadioBox.Checked := not FAccountPreferences.WhisperAlowEveryOne;
  InviteAlowEveryOneRadioBox.Checked := FAccountPreferences.InviteAlowEveryOne;
  InviteAlowContactListRadioBox.Checked := not FAccountPreferences.InviteAlowEveryOne;
  FileTransferAlowEveryOneRadioBox.Checked := FAccountPreferences.FileTransferAlowEveryOne;
  FileTransferAlowContactListRadioBox.Checked := not FAccountPreferences.FileTransferAlowEveryOne;
end;

procedure TPreferencesForm.FormShow(Sender: TObject);
begin
  WebcamStarted := False;
  LoadFormDefaults;
  AccountPC;
  GetAudioSetting;
  ListBox1.ItemIndex := 0;
  FavoriteListBox.Items := MainForm.FavoriteRoomList;
  ItemsListBoxClick(Self);
end;

procedure TPreferencesForm.ApplyButtonClick(Sender: TObject);
begin
  SetAudioSetting;
  SetWebcamSetting;
  MainForm.SystemPreferences := FSystemPreferences;
  MainForm.AccountPreferences := FAccountPreferences;
  MainForm.SaveSystemPreferences;
  MainForm.SetPrivacy;
  ApplyButton.Enabled := False;
end;

procedure TPreferencesForm.AutoStartHiChatterCkeckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.StartWithWindows := AutoStartHiChatterCkeckBox.Checked;
end;

procedure TPreferencesForm.OpenLinksInNewBrowserCkeckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.OpenInNewBrowser := OpenLinksInNewBrowserCkeckBox.Checked;
end;  

procedure TPreferencesForm.CloseProgramOnCloseCkeckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.CloseWithCloseButton := CloseProgramOnCloseCkeckBox.Checked;
end;

procedure TPreferencesForm.AutoSavePMFontSettingCheckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.AutoFontSaveForPM := AutoSavePMFontSettingCheckBox.Checked;
end;

procedure TPreferencesForm.AutoSaveRoomFontSettingCheckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.AutoFontSaveForRoom := AutoSaveRoomFontSettingCheckBox.Checked;
end;

procedure TPreferencesForm.ClearArchiveOnExitCheckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.ClearArchiveOnClose := CloseProgramOnCloseCkeckBox.Checked;
end;

procedure TPreferencesForm.SaveWindowPosCheckBoxClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.SaveMainWindowPos := SaveWindowPosCheckBox.Checked;
end;

procedure TPreferencesForm.PMAlowContactListRadioBoxClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FAccountPreferences.PMAlowEveryOne := PMAlowEveryOneRadioBox.Checked;
end;

procedure TPreferencesForm.InviteAlowEveryOneRadioBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FAccountPreferences.InviteAlowEveryOne := InviteAlowEveryOneRadioBox.Checked;
end;

procedure TPreferencesForm.WhisperAlowEveryOneRadioBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FAccountPreferences.WhisperAlowEveryOne := WhisperAlowEveryOneRadioBox.Checked;
end;

procedure TPreferencesForm.FileTransferAlowEveryOneRadioBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FAccountPreferences.FileTransferAlowEveryOne := FileTransferAlowEveryOneRadioBox.Checked;
end;

procedure TPreferencesForm.ArchiveEnableRadioBoxClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.ArchiveEnable := ArchiveEnableRadioBox.Checked;
end;

procedure TPreferencesForm.DisableAlertSoundsCheckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.AlertSoundsEnable := not DisableAlertSoundsCheckBox.Checked;
end;

procedure TPreferencesForm.DisableAlertSoundsInRoomCkeckBoxClick(
  Sender: TObject);
begin
  ApplyButton.Enabled := True;
  FSystemPreferences.AlertWhenInRoom := not DisableAlertSoundsInRoomCkeckBox.Checked;
end;

procedure TPreferencesForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TPreferencesForm.WebcamAutoCheckboxClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.WebcamAlwayonTopClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.myWebcamSizeClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.ViewWebcamSizeClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.ViewWebcamontopClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.SpeakersComboBoxChange(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.MicrophoneComboBoxChange(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.UnfreezeTimeEditChange(Sender: TObject);
begin
  if (UnfreezeTimeEdit.Text='') or
     (UnfreezeTimeEdit.Text='-') or
     (UnfreezeTimeEdit.Text='+') then
    FSystemPreferences.AutoUnfreezScreen := 0
  else
    FSystemPreferences.AutoUnfreezScreen := StrToInt(UnfreezeTimeEdit.Text);
  ApplyButton.Enabled := True;
end;

procedure TPreferencesForm.AccountDeleteClick(Sender: TObject);
var
  Reg:TRegistry;
  tmpString:String;
begin
if AccountList.ItemIndex = -1 then Exit;
tmpString := AccountList.Items.Strings[AccountList.ItemIndex];
if MessageDlg('Are you sure you want to Delete cache '+ tmpString + ' ?', mtConfirmation, mbOKCancel, 0) = MB_OKCANCEL then
 begin
  Reg := TRegistry.Create;
  Reg.DeleteKey('\Software\Beyluxe Messenger\'+ MainForm.EnDecryptUserRegistry(tmpString,True)) ;
  Reg.Free;
 end;
AccountPC;
end;

procedure TPreferencesForm.AccountClearClick(Sender: TObject);
var
  Reg:TRegistry;
  tmpString:String;
begin
if AccountList.ItemIndex = -1 then Exit;
tmpString := AccountList.Items.Strings[AccountList.ItemIndex];
if MessageDlg('Are you sure you want to Clear cache '+ tmpString + ' ?', mtConfirmation, mbOKCancel, 0) = MB_OKCANCEL then
 begin
  Reg := TRegistry.Create;
  Reg.DeleteKey('\Software\Beyluxe Messenger\'+ MainForm.EnDecryptUserRegistry(tmpString,True));
  Reg.CreateKey('\Software\Beyluxe Messenger\'+ MainForm.EnDecryptUserRegistry(tmpString,True));
  Reg.Free;
 end;
AccountPC;
end;

procedure TPreferencesForm.GetAudioSetting;
begin
  SpeakersComboBox.Items := MainForm.FPlayThread.Devices;
  if FSystemPreferences.AudioSoundDeviceIndex > SpeakersComboBox.Items.Count then
    SpeakersComboBox.ItemIndex := 0
  else
   SpeakersComboBox.ItemIndex := FSystemPreferences.AudioSoundDeviceIndex;

  MicrophoneComboBox.Items := MainForm.FPlayThread.DevicesCaputer;
  if FSystemPreferences.AudioSoundCaptureDeviceIndex > MicrophoneComboBox.Items.Count then
    MicrophoneComboBox.ItemIndex := 0
  else
    MicrophoneComboBox.ItemIndex := FSystemPreferences.AudioSoundCaptureDeviceIndex;
end;

procedure TPreferencesForm.SetAudioSetting;
begin
  if (SpeakersComboBox.ItemIndex <> FSystemPreferences.AudioSoundDeviceIndex) or
     (MicrophoneComboBox.ItemIndex <> FSystemPreferences.AudioSoundCaptureDeviceIndex) then
  begin
        if (SpeakersComboBox.ItemIndex <> FSystemPreferences.AudioSoundDeviceIndex) then
            MessageBox(0,'Restart The Beyluxe Messenger for The new settings to take effect.','Setting',0);

    FSystemPreferences.AudioSoundDeviceIndex := SpeakersComboBox.ItemIndex;
    FSystemPreferences.AudioSoundCaptureDeviceIndex := MicrophoneComboBox.ItemIndex;
  end;
end;

procedure TPreferencesForm.GetWebcamSetting;
var
  i: integer;
begin
  WebcamComboBox.Clear;
  SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  if SysDev.CountFilters > 0 then
    for i := 0 to SysDev.CountFilters - 1 do
      WebcamComboBox.Items.Add(SysDev.Filters[i].FriendlyName)
  else
    begin
      WebcamComboBox.Enabled := False;
      WebcamStart.Enabled := False;
    end;
      
  if FSystemPreferences.myWebcamDeviceIndex > WebcamComboBox.Items.Count then
    WebcamComboBox.ItemIndex := 0
  else
    WebcamComboBox.ItemIndex := FSystemPreferences.myWebcamDeviceIndex;

  myWebcamSize.ItemIndex := FSystemPreferences.myWebcamMyCamSize;
  ViewWebcamSize.ItemIndex := FSystemPreferences.ViewWebcamSize;

  if FSystemPreferences.ViewWebcamOnTop then
    ViewWebcamontop.Checked := True
  else
    ViewWebcamontop.Checked := False;

  if FSystemPreferences.myWebcamAlwayonTop then
    WebcamAlwayonTop.Checked := True
  else
    WebcamAlwayonTop.Checked := False;

  WebcamAutoCheckbox.Checked := FSystemPreferences.myWebcamAuto;
  WebcamAlwayonTop.Checked   := FSystemPreferences.myWebcamAlwayonTop;
end;

procedure TPreferencesForm.SetWebcamSetting;
begin
 if WebcamStarted = False then Exit;

  FSystemPreferences.myWebcamDeviceIndex := WebcamComboBox.ItemIndex;
  FSystemPreferences.myWebcamAlwayonTop  := WebcamAlwayonTop.Checked;
  FSystemPreferences.myWebcamAuto        := WebcamAutoCheckbox.Checked;
  FSystemPreferences.myWebcamMyCamSize   := myWebcamSize.ItemIndex;
  FSystemPreferences.ViewWebcamSize      := ViewWebcamSize.ItemIndex;
  FSystemPreferences.ViewWebcamOnTop     := ViewWebcamontop.Checked;
end;

procedure TPreferencesForm.OnSelectDevice(sender: TObject);
begin
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
  Filter.BaseFilter.Moniker := SysDev.GetMoniker(WebcamComboBox.ItemIndex);
  FilterGraph.Active := true;
  with FilterGraph as ICaptureGraphBuilder2 do
    RenderStream(@PIN_CATEGORY_PREVIEW, nil, Filter as IBaseFilter, SampleGrabber as IBaseFilter, VideoWindow as IbaseFilter);
  FilterGraph.Play;
end;

procedure TPreferencesForm.WebcamComboBoxChange(Sender: TObject);
begin
  if (WebcamComboBox.ItemIndex <> -1) and
     (WebcamComboBox.Items.Strings[WebcamComboBox.ItemIndex] <> EmptyStr) then
        OnSelectDevice(self);
end;


procedure TPreferencesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if WebcamStarted then
  begin
    SysDev.Free;
    FilterGraph.Stop;
    FilterGraph.Active := false;
    FilterGraph.ClearGraph;
  end;
  
end;

procedure TPreferencesForm.WebcamToolBringup;
begin
 WebcamSetupPanel.BringToFront;
 GetWebcamSetting;
 WebcamStarted := True;
end;

procedure TPreferencesForm.WebcamStartClick(Sender: TObject);
begin
  if WebcamStart.Caption = 'Start' then
    begin
      WebcamStart.Caption := 'Stop';
      OnSelectDevice(self);
    end
  else
    begin
      WebcamStart.Caption := 'Start';
      FilterGraph.ClearGraph;
      FilterGraph.Active := false;
      FilterGraph.Active := true;
    end;
end;



procedure TPreferencesForm.FavoriteDeleteBTNClick(Sender: TObject);
var
  Reg: TRegistry;
  Key: string;
begin
  if FavoriteListBox.ItemIndex = -1 then Exit;
  Reg := TRegistry.Create;
  Key := '\Software\Beyluxe Messenger\'+ MainForm.MyNickName + '\FavoriteRooms\'+ FavoriteListBox.Items[FavoriteListBox.ItemIndex];
  if Reg.KeyExists(Key) then
  begin
    Reg.DeleteKey(Key);
    MainForm.FavoriteRoomList.Delete(MainForm.FavoriteRoomList.IndexOf(FavoriteListBox.Items[FavoriteListBox.ItemIndex]));
    MainForm.MakeFavoriteRoomMenu;
    FavoriteListBox.Items.Delete(FavoriteListBox.ItemIndex);
  end;
  Reg.Free;
end;

end.
