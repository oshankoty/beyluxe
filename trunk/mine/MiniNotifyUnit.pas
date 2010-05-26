unit MiniNotifyUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TB2Dock, TB2ToolWindow, TBX, ExtCtrls;

type
  TMiniNotifyForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Label1: TLabel;
    OnlineImage: TImage;
    OfflineImage: TImage;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    { Private declarations }
  public
    { Public declarations }
    TimeOut: Cardinal;
    Counter: Cardinal;
  end;

var
  MiniNotifyForm: TMiniNotifyForm;

implementation

{$R *.dfm}

procedure TMiniNotifyForm.FormShow(Sender: TObject);
begin
  Counter := 0;
  AlphaBlendValue := 255;
  Timer1.Enabled := True;
end;

procedure TMiniNotifyForm.Timer1Timer(Sender: TObject);
begin
  Counter := Counter + 1;
  if Counter<50 then Exit;
  AlphaBlendValue := AlphaBlendValue - 20;
  if AlphaBlendValue<=20 then
  begin
    Timer1.Enabled := False;
    Counter := 0;
    Close;
  end;
end;

procedure TMiniNotifyForm.FormCreate(Sender: TObject);
begin
  TimeOut := 5000;
end;

procedure TMiniNotifyForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    Style := Style or WS_DLGFRAME; 
end;

end.
