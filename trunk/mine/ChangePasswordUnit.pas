unit ChangePasswordUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TB2Dock, TB2ToolWindow, TBX, StdCtrls;

type
  TChangePasswordForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    SecretQuestionLabel: TLabel;
    SecretAnswerEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CurrentPasswordEdit: TEdit;
    NewPasswordEdit: TEdit;
    ConfirmNewPasswordEdit: TEdit;
    OkButton: TButton;
    CloseButton: TButton;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  ChangePasswordForm: TChangePasswordForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TChangePasswordForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TChangePasswordForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TChangePasswordForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then
    Close;
end;

procedure TChangePasswordForm.OkButtonClick(Sender: TObject);
begin
  if NewPasswordEdit.Text<>ConfirmNewPasswordEdit.Text then
  begin
    ShowMessage('Passwords does not match');
    Exit;
  end;
  MainForm.ChangePassword(SecretAnswerEdit.Text,CurrentPasswordEdit.Text,NewPasswordEdit.Text);
  Close;
end;

end.
