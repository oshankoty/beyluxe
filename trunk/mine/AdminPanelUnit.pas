unit AdminPanelUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX, TBXDkPanels, ExtCtrls;

type
  TAdminControlPanel = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    UserComboBox: TComboBox;
    BanListBox: TListBox;
    BounceListBox: TListBox;
    BanUserButton: TButton;
    UnBounceUserButton: TButton;
    UnBanUserButton: TButton;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    DefaultRedDotVideo: TCheckBox;
    DefaultRedDotMic: TCheckBox;
    DefaultRedDotText: TCheckBox;
    GroupBox2: TGroupBox;
    RoomMessageEditBox: TEdit;
    Button3: TButton;
    procedure UnBounceUserButtonClick(Sender: TObject);
    procedure TBXButton1Click(Sender: TObject);
    procedure NewUserReddotCheckBoxesClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BanUserButtonClick(Sender: TObject);
    procedure UnBanUserButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }

  end;

implementation

uses RoomWindowUnit;

{$R *.dfm}

{ TAdminControlPanel }

procedure TAdminControlPanel.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := 0;
end;

procedure TAdminControlPanel.UnBounceUserButtonClick(Sender: TObject);
begin
  if BounceListBox.ItemIndex<>-1 then
    TRoomWindow(Owner).UnBounceThisUser(BounceListBox.Items.Strings[BounceListBox.ItemIndex]);
end;

procedure TAdminControlPanel.TBXButton1Click(Sender: TObject);
begin
  if MessageBox(Handle,'This will Close the Room. Are you sure?','Warning',MB_YESNO)=IDYES then
    TRoomWindow(Owner).AdminCloseRoom;
end;

procedure TAdminControlPanel.NewUserReddotCheckBoxesClick(Sender: TObject);
begin
  TRoomWindow(Owner).SetNewUserReddotsOrder(DefaultRedDotText.Checked,DefaultRedDotMic.Checked,DefaultRedDotVideo.Checked);
end;

procedure TAdminControlPanel.Button3Click(Sender: TObject);
begin
  TRoomWindow(Owner).SetRoomTitle(RoomMessageEditBox.Text);
end;

procedure TAdminControlPanel.BanUserButtonClick(Sender: TObject);
begin
  if UserComboBox.Text<>'' then
  begin
    TRoomWindow(Owner).BanUser(UserComboBox.Text,True);
    UserComboBox.Text := '';
  end;
end;

procedure TAdminControlPanel.UnBanUserButtonClick(Sender: TObject);
begin
  if BanListBox.ItemIndex<>-1 then
    TRoomWindow(Owner).BanUser(BanListBox.Items.Strings[BanListBox.ItemIndex],False);
end;

end.
