unit CustomAwayMsgForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX;

type
  TCustomAwayMessageForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    CustomMsgCombo: TComboBox;
    OkButton: TButton;
    CancelButton: TButton;
    procedure FormShow(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  CustomAwayMessageForm: TCustomAwayMessageForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TCustomAwayMessageForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TCustomAwayMessageForm.FormShow(Sender: TObject);
begin
  CustomMsgCombo.Items.Text := MainForm.CustomAwayMessages.Text;
end;

end.
