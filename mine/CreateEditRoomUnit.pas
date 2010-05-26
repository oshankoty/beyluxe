unit CreateEditRoomUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX;

type
  TCreateEditMyRoom = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    RoomNameEdit: TEdit;
    AdminCodeEdit: TEdit;
    LockCodeEdit: TEdit;
    WelComeMemo: TMemo;
    RatingComboBox: TComboBox;
    CategoriesCombo: TComboBox;
    SubCategoriesCombo: TComboBox;
    CreateJoinButton: TButton;
    CloseButton: TButton;
    GroupBox1: TGroupBox;
    SuperAdminFriendListCombo: TComboBox;
    SuperAdminListBox: TListBox;
    AddToSuperAdminListButton: TButton;
    RemoveFromSuperAdminListButton: TButton;
    GroupBox2: TGroupBox;
    AdminFriendListCombo: TComboBox;
    AdminListBox: TListBox;
    AddToAdminListButton: TButton;
    RemoveFromAdminListButton: TButton;
    Label8: TLabel;
    AdminListControl: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure CategoriesComboChange(Sender: TObject);
    procedure CreateJoinButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure RoomNameEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddToAdminListButtonClick(Sender: TObject);
    procedure AddToSuperAdminListButtonClick(Sender: TObject);
    procedure RemoveFromAdminListButtonClick(Sender: TObject);
    procedure RemoveFromSuperAdminListButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateEditMyRoom: TCreateEditMyRoom;

implementation

uses MainUnit;

{$R *.dfm}

procedure TCreateEditMyRoom.FormShow(Sender: TObject);
begin
{
  CategoriesCombo.Items := MainForm.Categories;
  CategoriesCombo.ItemIndex := 0;
  CategoriesComboChange(Self);
  FriendListCombo.Clear;
  FriendListCombo.Items.AddStrings(MainForm.OnLineFriendList.FirendList);
  FriendListCombo.Items.AddStrings(MainForm.OffLineFriendList.FirendList);
  FriendListCombo.ItemIndex := 0;
}
end;

procedure TCreateEditMyRoom.CategoriesComboChange(Sender: TObject);
begin
  SubCategoriesCombo.Items := MainForm.SubCategories[CategoriesCombo.ItemIndex];
  SubCategoriesCombo.ItemIndex := 0;
end;

procedure TCreateEditMyRoom.CreateJoinButtonClick(Sender: TObject);
var
  TmpStrList: TStringList;
begin
  if Length(AdminCodeEdit.Text)<3 then
  begin
    MessageBox(Handle,'Admin code must be minimum 3 characters.','Beyluxe Messenger',MB_OK);
    Exit;
  end;
  TmpStrList := TStringList.Create;
  TmpStrList.Add(AdminListBox.Items.CommaText);
  TmpStrList.Add(SuperAdminListBox.Items.CommaText);
  MainForm.CreateRoom(MainForm.MyNickName,RoomNameEdit.Text,
                      AdminCodeEdit.Text,LockCodeEdit.Text,
                      {AdminListBox.Items.Text} TmpStrList.CommaText,WelComeMemo.Text,Byte(AdminListControl.Checked),
                      CategoriesCombo.ItemIndex,SubCategoriesCombo.ItemIndex,
                      RatingComboBox.ItemIndex);
  TmpStrList.Free;
  Close;
end;

procedure TCreateEditMyRoom.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TCreateEditMyRoom.RoomNameEditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((ssCtrl in Shift) AND (Key = ord('V'))) or
     ((ssShift in Shift) AND (Key = VK_INSERT))then
  begin
    //if Clipboard.HasFormat(CF_TEXT) then ClipBoard.Clear;

    //(Sender as TEdit).SelText := '"Paste" DISABLED!';

    Key := 0;
  end;
end;

procedure TCreateEditMyRoom.AddToAdminListButtonClick(Sender: TObject);
begin
  if AdminListBox.Items.IndexOf(AdminFriendListCombo.Text)=-1 then
    AdminListBox.Items.Add(AdminFriendListCombo.Text);
end;

procedure TCreateEditMyRoom.AddToSuperAdminListButtonClick(
  Sender: TObject);
begin
  if SuperAdminListBox.Items.IndexOf(SuperAdminFriendListCombo.Text)=-1 then
    SuperAdminListBox.Items.Add(SuperAdminFriendListCombo.Text);
end;

procedure TCreateEditMyRoom.RemoveFromAdminListButtonClick(
  Sender: TObject);
begin
  if AdminListBox.ItemIndex>-1 then
    AdminListBox.Items.Delete(AdminListBox.ItemIndex);
end;

procedure TCreateEditMyRoom.RemoveFromSuperAdminListButtonClick(
  Sender: TObject);
begin
  if SuperAdminListBox.ItemIndex>-1 then
    SuperAdminListBox.Items.Delete(SuperAdminListBox.ItemIndex);
end;

end.
