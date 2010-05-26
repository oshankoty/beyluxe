unit JoinRoomAsAdmin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TBXDkPanels, StdCtrls, TB2Dock, TB2ToolWindow, TBX;

type
  TJoinRoomAsAdminForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    FriendListCombo: TComboBox;
    Label1: TLabel;
    AdminPassEdit: TEdit;
    Label2: TLabel;
    JoinButton: TButton;
    CloseButton: TButton;
    procedure JoinButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure AdminPassEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  JoinRoomAsAdminForm: TJoinRoomAsAdminForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TJoinRoomAsAdminForm.JoinButtonClick(Sender: TObject);
begin
  MainForm.JoinRoomAsAdminByOwner(FriendListCombo.Text,AdminPassEdit.Text);
  Close;  
end;

procedure TJoinRoomAsAdminForm.FormShow(Sender: TObject);
begin
  FriendListCombo.Clear;
  FriendListCombo.Sorted := True;
  FriendListCombo.Items.AddStrings(MainForm.OnLineFriendList.FirendList);
  FriendListCombo.Items.AddStrings(MainForm.OffLineFriendList.FirendList);
  AdminPassEdit.Text := '';
end;

procedure TJoinRoomAsAdminForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TJoinRoomAsAdminForm.AdminPassEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    Key := #0;
    JoinButtonClick(Self);
  end;
end;

end.
