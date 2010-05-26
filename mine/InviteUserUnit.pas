unit InviteUserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX, CheckLst, ComCtrls;

type
  TInviteUserForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Button1: TButton;
    UsersListView: TListView;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

//var
// InviteUserForm: TInviteUserForm;

implementation

uses MainUnit, CMClasses;

{$R *.dfm}

procedure TInviteUserForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  MainForm.OnLineFriendList.FirendList.Sort;
  with MainForm.OnLineFriendList do
    for i := 0 to Count -1 do
      if FirendList.Strings[i]<>MainForm.MyNickName then
      begin
        UsersListView.Items.Add;
        UsersListView.Items.Item[UsersListView.Items.Count - 1].Caption := FirendList.Strings[i];
        UsersListView.Items.Item[UsersListView.Items.Count - 1].ImageIndex := Icons[i];
      end;
end;

procedure TInviteUserForm.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TInviteUserForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TInviteUserForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := MainForm.InviteToRoomFormOwner.Handle;
end;

end.
