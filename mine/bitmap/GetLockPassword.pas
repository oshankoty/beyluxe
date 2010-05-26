unit GetLockPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TBXDkPanels, StdCtrls, TB2Dock, TB2ToolWindow, TBX;

type
  TGetLockCode = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Label1: TLabel;
    Edit1: TEdit;
    TBXButton1: TButton;
    TBXButton2: TButton;
    procedure TBXButton1Click(Sender: TObject);
    procedure TBXButton2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }

  end;

var
  GetLockCode: TGetLockCode;

implementation

{$R *.dfm}

procedure TGetLockCode.TBXButton1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TGetLockCode.TBXButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TGetLockCode.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    Key := #0;
    TBXButton1Click(Self);
  end;
end;

procedure TGetLockCode.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := TForm(Owner).Handle;
end;

end.
