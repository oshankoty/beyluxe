unit CustumAwayMsgForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX;

type
  TForm1 = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    ListBox1: TListBox;
    CloseButton: TButton;
    DeleteButton: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
