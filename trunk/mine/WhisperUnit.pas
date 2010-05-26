unit WhisperUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX;

type
  TWhisperForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    SendButton: TButton;
    Edit1: TEdit;
    KeepOpenCheckBox: TCheckBox;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure SendButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FUserName: string;
    procedure SetUserName(const Value: string);
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    MyOwner: TObject;
    property UserName: string read FUserName write SetUserName;
  end;

var
  WhisperForm: TWhisperForm;

implementation

uses
  RoomWindowUnit, MainUnit;

{$R *.dfm}

procedure TWhisperForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := MainForm.TmpHandleforWisWnd;
end;

procedure TWhisperForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    if Edit1.Text<>'' then
      SendButton.Click;
    Key := #0;
  end;
end;

procedure TWhisperForm.SendButtonClick(Sender: TObject);
begin
  if Edit1.Text<>'' then
    PostMessage(TRoomWindow(MyOwner).Handle,WCM_SENDWISPER,0,0);
end;

procedure TWhisperForm.SetUserName(const Value: string);
begin
  FUserName := Value;
  Caption := 'Whisper to '+ FUserName;
end;

procedure TWhisperForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PostMessage(TRoomWindow(MyOwner).Handle,WCM_WHISPERCLOSED,0,0);
  Action := caFree;
end;

procedure TWhisperForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end;

end.
