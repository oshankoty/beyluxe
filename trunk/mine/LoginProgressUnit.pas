unit LoginProgressUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvWaitingGradient, TB2Dock, TB2ToolWindow, TBX;

type
  TLoginProgressForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    JvWaitingGradient1: TJvWaitingGradient;
    Label1: TLabel;
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  LoginProgressForm: TLoginProgressForm;

implementation

{$R *.dfm}

{ TLoginProgressForm }

procedure TLoginProgressForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    Style := Style or WS_DLGFRAME;
end;

end.
