unit SmilesUnit;

{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, HtmlGif2, ImgList, GR32, GR32_Image, COMCtrls;

const
  WM_MouseCapture = WM_USER+1;

type
  TSmilesForm = class(TForm)
    Image321: TImage32;
    Bitmap32List: TBitmap32List;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    LastSelectedRect: TRect;
    LastSelectedBitmap: TBitmap32;
    FSmileStrList: TStringList;
    FAllocatedWnd: THandle;
    FActiveRichEdit: TRichEdit;
    function PointInRect(Point: TPoint): Boolean;
    function RectsEqual(Rect1,Rect2: TRect): Boolean;
    procedure CorrectBitmap(Bitmap: TBitmap32; SrcColor,DstColor: TColor32);
    procedure SetMouseCapture(var Msg: TMessage); message WM_MouseCapture;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    property ActiveRichEdit: TRichEdit read FActiveRichEdit write FActiveRichEdit;
    property SmileStrList: TStringList read FSmileStrList;
  end;

var
  SmilesForm: TSmilesForm;

implementation

{$R *.dfm}

uses
  MainUnit, Types;

procedure TSmilesForm.CorrectBitmap(Bitmap: TBitmap32; SrcColor,DstColor: TColor32);
var
  x,y: Integer;
begin
  for x := 0 to Bitmap.Width-1 do
    for y := 1 to Bitmap.Height do
    begin
      if (Bitmap.Pixel[x,Bitmap.Height-y] = SrcColor) then
        Bitmap.Pixel[x,Bitmap.Height-y] := DstColor
      else
        break;
    end;
  for x := 0 to Bitmap.Width-1 do
    for y := 0 to Bitmap.Height-1 do
    begin
      if (Bitmap.Pixel[x,y] = SrcColor) then
        Bitmap.Pixel[x,y] := DstColor
      else
        break;
    end;
end;

procedure TSmilesForm.FormCreate(Sender: TObject);
var
  i: Integer;
  TmpGifImage: TGifImage;
  Stream: TStream;
  Animated: Boolean;
  Bitmap32: TBitmap32;
  SmileStr: string;
begin
  Image321.Bitmap.SetSizeFrom(Image321);
  for i := 0 to 93 do
  begin
    Bitmap32 := Bitmap32List.Bitmaps.Add.Bitmap;
    Stream := TStream(MainForm.SmilesStreamList.Items[i]);
    TmpGifImage := CreateAGifFromStream(Animated,Stream);
    Bitmap32.Assign(TmpGifImage.Bitmap);
    CorrectBitmap(Bitmap32,clBlack32,$00CCCCFF);
    TmpGifImage.Free;
  end;
  Image321.Bitmap.Clear($00CCCCFF);
  Paint;
  LastSelectedBitmap := TBitmap32.Create;
  LastSelectedBitmap.SetSize(40,20);
  FSmileStrList := TStringList.Create;
  SmileStr :=
    ':),:(,;),:D,;;),:-\,:-x,:">,:p,:*,:)],'+
    ':-c,~X(,:-h,:-t,8->,:-??,%-(,:o3,x_x,:'+
    'o,:!!,\m/,:-q,:-bd,^#(^,:bz,=((,x( ,:>'+
    ',B-),:-s,>:),:((,#:-S,:)),:-|,/:),0:-)'+
    ',:-B,=;,=)),|-),8-|,:-&,:-$,[-(,:o),L-),8-'+
    '},(:|,=P~,:-?,:-<,<:-P,:@),3:-O,:(|),~'+
    ':>,@};-,%%-,:-SS,**==,(~~),~o),:-w,*-:'+
    '),:-<,8-X,>:P,=:),>-),:-L,<):),[-o<,=D>'+
    ',^:)^,:-",:^o,B-(,:)>-,[-X,\:D/,>:D<,o->'+
    ',o=>,o-+,(%),>:P,>:/,:-@';
  FSmileStrList.CommaText := SmileStr;
end;

procedure TSmilesForm.FormDestroy(Sender: TObject);
begin
  DeallocateHWnd(FAllocatedWnd);
  FSmileStrList.Free;
  LastSelectedBitmap.Free;
end;

procedure TSmilesForm.FormShow(Sender: TObject);
begin
  LastSelectedRect := Rect(0,0,0,0);
  //PostMessage(Handle,WM_MouseCapture,0,0);
  Image321.Bitmap.FrameRectTS(Image321.GetBitmapRect,clGray32);
  MouseCapture := True;
end;

function TSmilesForm.PointInRect(Point: TPoint): Boolean;
begin
  Result := (Point.X>0) and (Point.Y>0) and (Point.X<Width) and (Point.Y<Height);
end;

procedure TSmilesForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  LocalPoint: TPoint;
  MyRect: TRect;
begin
  LocalPoint.X := X;
  LocalPoint.Y := Y;
  if PointInRect(LocalPoint) then
  begin
    MyRect.Left := (LocalPoint.X div 40)*40;
    MyRect.Right := MyRect.Left + 40;
    MyRect.Top := (LocalPoint.Y div 20)*20;
    MyRect.Bottom := MyRect.Top + 20;
    if not RectsEqual(MyRect,LastSelectedRect) then
    begin
      Image321.Bitmap.Draw(LastSelectedRect,LastSelectedBitmap.BoundsRect,LastSelectedBitmap);
      Image321.Bitmap.DrawTo(LastSelectedBitmap,0,0,MyRect);
      Image321.Bitmap.FillRectTS(MyRect,$66000096);
      LastSelectedRect := MyRect;
    end;
  end
  else
    Image321.Bitmap.Draw(LastSelectedRect,LastSelectedBitmap.BoundsRect,LastSelectedBitmap);
end;

procedure TSmilesForm.FormPaint(Sender: TObject);
var
  x,y: Integer;
  Bitmap: TBitmap32;
  Y4Draw,X4Draw: Integer;
begin
  for y := 0 to 8 do
    for x := 0 to 9 do
    begin
      Bitmap := Bitmap32List.Bitmap[y*10+x];
      if Bitmap.Width<40 then
        X4Draw := x*40+(40-Bitmap.Width) div 2
      else
        X4Draw := x*40;
      if Bitmap.Height<20 then
        Y4Draw := y*20+(20-Bitmap.Height) div 2
      else
        Y4Draw := y*20;

      Image321.Bitmap.Draw(X4Draw,Y4Draw,Bitmap);
    end;
end;

function TSmilesForm.RectsEqual(Rect1, Rect2: TRect): Boolean;
begin
  Result := (Rect1.Left = Rect2.Left) and
            (Rect1.Top = Rect2.Top) and
            (Rect1.Right = Rect2.Right) and
            (Rect1.Bottom = Rect2.Bottom);
end;

procedure TSmilesForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  FAllocatedWnd := AllocateHWnd(nil);
  Params.WndParent := FAllocatedWnd;
end;

procedure TSmilesForm.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TSmilesForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  LocalPoint: TPoint;
begin
  LocalPoint.X := X;
  LocalPoint.Y := Y;
  if PointInRect(LocalPoint) then
    FActiveRichEdit.SelText := FSmileStrList.Strings[LocalPoint.x div 40 + (LocalPoint.Y div 20)*10];
  Image321.Bitmap.Draw(LastSelectedRect,LastSelectedBitmap.BoundsRect,LastSelectedBitmap);
  Close;
end;

procedure TSmilesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  MouseCapture := False;
end;

procedure TSmilesForm.SetMouseCapture(var Msg: TMessage);
begin
  MouseCapture := True;
end;

procedure TSmilesForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Image321.Bitmap.Draw(LastSelectedRect,LastSelectedBitmap.BoundsRect,LastSelectedBitmap);
  Close;
end;

end.
