unit VolumeCtrlUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TB2Dock, TB2ToolWindow, TBX, ComCtrls;

type
  TVolControlForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    VolumeControl: TTrackBar;
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TBXToolWindow1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Private declarations }
    function PointInRect(Point: TPoint): Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }

  end;

//var
//  VolControlForm: TVolControlForm;

implementation

uses MainUnit;

{$R *.dfm}

{ TVolControlForm }

procedure TVolControlForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := MainForm.VolumeControlOwnerHandle;
  //FAllocatedWnd := AllocateHWnd(nil);
  //Params.WndParent := FAllocatedWnd;
end;

procedure TVolControlForm.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TVolControlForm.FormShow(Sender: TObject);
begin
  //MouseCapture := True;
  Width := 30;
end;

procedure TVolControlForm.FormDestroy(Sender: TObject);
begin
  //DeallocateHWnd(FAllocatedWnd);
end;

function TVolControlForm.PointInRect(Point: TPoint): Boolean;
begin
  Result := (Point.X>0) and (Point.Y>0) and (Point.X<Width) and (Point.Y<Height);
end;

procedure TVolControlForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LocalPoint: TPoint;
begin
  LocalPoint.X := X;
  LocalPoint.Y := Y;
  if not PointInRect(LocalPoint) then
    Close;
end;

procedure TVolControlForm.TBXToolWindow1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  LocalPoint: TPoint;
begin
  LocalPoint.X := X;
  LocalPoint.Y := Y;
  if PointInRect(LocalPoint) then
  begin
    mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;
end;

end.
