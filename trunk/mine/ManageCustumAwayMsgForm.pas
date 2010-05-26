unit ManageCustumAwayMsgForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX, Registry;

type
  TManageCustomAwayMsgForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    ListBox1: TListBox;
    CloseButton: TButton;
    DeleteButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ManageCustomAwayMsgForm: TManageCustomAwayMsgForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TManageCustomAwayMsgForm.FormShow(Sender: TObject);
begin
  ListBox1.Items.Text := MainForm.CustomAwayMessages.Text;
end;

procedure TManageCustomAwayMsgForm.DeleteButtonClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  if ListBox1.ItemIndex>-1 then
  begin
    Reg := TRegistry.Create;
    if Reg.DeleteKey('\Software\Beyluxe Messenger\'+  MainForm.MyNickName +'\AwayMessages\'+ListBox1.Items.Strings[ListBox1.ItemIndex]) then
    begin
      MainForm.CustomAwayMessages.Delete(MainForm.CustomAwayMessages.IndexOf(ListBox1.Items.Strings[ListBox1.ItemIndex]));
      ListBox1.Items.Delete(ListBox1.ItemIndex);
    end;
    Reg.Free;
  end;
end;

procedure TManageCustomAwayMsgForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

end.
