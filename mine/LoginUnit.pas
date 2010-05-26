unit LoginUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, TB2Dock, TB2ToolWindow, TBX, TBXDkPanels,
  JvGradient, IdCoder, IdCoder3to4, IdCoderMIME, IdBaseComponent;

type
  TLoginForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Label1: TLabel;
    Label2: TLabel;
    RegisterLabel: TLabel;
    ForgotPasswordLabel: TLabel;
    CloseButton: TButton;
    LoginButton: TButton;
    PasswordEdit: TEdit;
    UserNameCombo: TComboBox;
    InvisibleLogin: TCheckBox;
    SavePassword: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoginButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure RegisterLabelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UserNameComboChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UserNameComboKeyPress(Sender: TObject; var Key: Char);
    procedure PasswordEditChange(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    
  public
    { Public declarations }
    CloseFromMainWindow: Boolean;
    PasswordUser:String;
  end;

var
  LoginForm: TLoginForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not MainForm.LoggedIn then
  begin
    MainForm.ReallyClose := True;
    MainForm.Close;
  end;
end;

procedure TLoginForm.LoginButtonClick(Sender: TObject);
begin
  Application.ProcessMessages;
  MainForm.LoginButtonClick(Self);
end;

procedure TLoginForm.CloseButtonClick(Sender: TObject);
begin
  if MessageBox(Handle,'Are you sure you want to close Beyluxe Messenger?','Confirm Exit',MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    MainForm.CloseFromLogin := True;
    MainForm.ReallyClose := True;
    MainForm.Close;
  end;
end;

procedure TLoginForm.RegisterLabelClick(Sender: TObject);
begin
  MainForm.RegisterLabelClick(Self);
end;

procedure TLoginForm.FormShow(Sender: TObject);
var
  Reg: TRegistry;
  tmpUser,tmpCur:string;
  tmpStringList: TStringList;
  i:integer;
begin
  MainForm.LoadSystemPreferences;
  MainForm.DeleteOldPassword;
  tmpStringList := TStringList.Create;
  Reg := TRegistry.Create;
  if Reg.OpenKey('\Software\Beyluxe Messenger',False) then
  begin
    Reg.GetKeyNames(tmpStringList);
    if tmpStringList.Count > 0 then
    begin
      for i:=0 to tmpStringList.Count-1 do
      begin
       tmpUser := tmpStringList.Strings[i];
       tmpStringList.Strings[i] := MainForm.EnDecryptUserRegistry(tmpUser,False);
      end;
      tmpStringList.Sort;
      UserNameCombo.Items := tmpStringList;
      if UserNameCombo.Items.Count>0 then
      begin
        tmpCur := Reg.ReadString('CurUser');
        if tmpUser <> EmptyStr then
          begin
            tmpCur :=MainForm.EnDecryptUserRegistry(tmpCur,False);
            UserNameCombo.ItemIndex := UserNameCombo.Items.IndexOf(tmpCur);
          end
           else PasswordEdit.Text := EmptyStr;
      end;
    end;
    Reg.CloseKey;
  end;
  Reg.Free;
  tmpStringList.Free;
  UserNameComboChange(Self);
end;

procedure TLoginForm.UserNameComboChange(Sender: TObject);
var
  Reg: TRegistry;
  UserTmp,PassTmp:String;
begin

  Reg := TRegistry.Create;
  UserTmp := UserNameCombo.Text;
  UserTmp := MainForm.EnDecryptUserRegistry(UserTmp,True);
  Reg.OpenKey('\Software\Beyluxe Messenger\'+UserTmp,False);
  UserTmp := UserNameCombo.Text;
  PassTmp := Reg.ReadString('Password');
  if PassTmp = EmptyStr then
   PasswordEdit.Text := EmptyStr
  else
   PasswordEdit.Text := 'Password';
  
  UserTmp := UserNameCombo.Text;
  UserTmp := MainForm.EnDecryptUserRegistry(UserTmp,True);
  PasswordUser := MainForm.DecodePWS(UserTmp, PassTmp);
  if PasswordEdit.Text<>'' then
    SavePassword.Checked := True
  else
    SavePassword.Checked := False;
  Reg.CloseKey;
  Reg.Free;
end;

procedure TLoginForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not CloseFromMainWindow then
  begin
    MainForm.CloseFromLogin := True;
    MainForm.Close;
  end;
end;

procedure TLoginForm.UserNameComboKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    LoginButtonClick(Self);
end;

procedure TLoginForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  //Params.WndParent := GetDesktopWindow;
end;



procedure TLoginForm.PasswordEditChange(Sender: TObject);
begin
 PasswordUser := PasswordEdit.Text;
end;

end.
