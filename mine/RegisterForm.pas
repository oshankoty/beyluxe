unit RegisterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX, Clipbrd, CMClasses;

type
  TRegisterFrm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    NameLabel: TLabel;
    LastNameLabel: TLabel;
    Label3: TLabel;
    EmailLabel: TLabel;
    AgeLabel: TLabel;
    LocationLabel: TLabel;
    NickNameLabel: TLabel;
    Password1Label: TLabel;
    password2Label: TLabel;
    Label10: TLabel;
    SecretAnswerLabel: TLabel;
    CancelBtn: TButton;
    RegisterButton: TButton;
    NameEdit: TEdit;
    LastNameEdit: TEdit;
    GenderCombo: TComboBox;
    EmailEdit: TEdit;
    AgeEdit: TEdit;
    CountryCombo: TComboBox;
    NickNameEdit: TEdit;
    Password1Edit: TEdit;
    Password2Edit: TEdit;
    SecretQuestionCombo: TComboBox;
    SecretAnswerEdit: TEdit;
    ConfirmEmailLabel: TLabel;
    ConfirmEmailEdit: TEdit;
    TopLabel: TLabel;
    procedure RegisterButtonClick(Sender: TObject);
    procedure AgeEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure NickNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure NameEditContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure EditBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RegisterFrm: TRegisterFrm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TRegisterFrm.RegisterButtonClick(Sender: TObject);
begin
  //if MainForm.CheckRegisterForm then
    ModalResult := mrOk;
end;

procedure TRegisterFrm.AgeEditKeyPress(Sender: TObject; var Key: Char);
begin
  if ((Byte(Key)<$30) or (Byte(Key)>$39)) and (Byte(Key)<>8) then
    Key := #0;
end;

procedure TRegisterFrm.FormShow(Sender: TObject);
begin
  RegisterFrm.NameLabel.Font.Color := clNone;
  RegisterFrm.LastNameLabel.Font.Color := clNone;
  RegisterFrm.NickNameLabel.Font.Color := clNone;
  RegisterFrm.Password1Label.Font.Color := clNone;
  RegisterFrm.password2Label.Font.Color := clNone;
  RegisterFrm.SecretAnswerLabel.Font.Color := clNone;
  RegisterFrm.EmailLabel.Font.Color := clNone;
  RegisterFrm.ConfirmEmailLabel.Font.Color := clNone;
  RegisterFrm.AgeLabel.Font.Color := clNone;
  RegisterFrm.LocationLabel.Font.Color := clNone;
end;

procedure TRegisterFrm.NickNameEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  //if (not IsDigit(Key)) and (Byte(Key)<>8) and (not IsAlph(Key)) and (not IsSeperator(Key))then
    //Key := #0;
end;

procedure TRegisterFrm.NameEditContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
end;

procedure TRegisterFrm.EditBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((ssCtrl in Shift) AND (Key = ord('V'))) or
     ((ssShift in Shift) AND (Key = VK_INSERT))then
  begin
    //if Clipboard.HasFormat(CF_TEXT) then ClipBoard.Clear;

    //(Sender as TEdit).SelText := '"Paste" DISABLED!';

    Key := 0;
  end;
end;

end.
