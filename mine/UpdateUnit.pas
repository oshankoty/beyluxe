unit UpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, TB2Dock, TB2ToolWindow, TBX;

type
  TUpdateForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    CancelButton: TButton;
    Gauge1: TGauge;
    Label1: TLabel;
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateForm: TUpdateForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TUpdateForm.CancelButtonClick(Sender: TObject);
begin
//
  MainForm.CancelButtonClick(Sender);
end;

end.
