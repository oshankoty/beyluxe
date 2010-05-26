unit AddBuddyUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX;

type
  TAddBuddyForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddBuddyForm: TAddBuddyForm;

implementation

{$R *.dfm}

procedure TAddBuddyForm.FormShow(Sender: TObject);
begin
  Edit1.Text := '';
end;

end.
