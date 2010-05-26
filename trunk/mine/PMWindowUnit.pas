unit PMWindowUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, OleCtrls, SHDocVw, StdCtrls, mshtml, ActiveX, Menus, Htmlview,
  ExtCtrls, Buttons, MyDialogs, ComCtrls, rtf2HTML, CommunicatorTypes,
  CMClasses, TBXExtItems, TBX, TB2Item, TB2Toolbar, TB2Dock, TB2ToolWindow,
  TBXStatusBars, MMSystem, Dialogs, StrUtils;

const
  MYNICKCOLOR = $003333BB;
  BUDDYNICKCOLOR = $00BB3333;

type
  TPMWindow = class(TForm)
    ViewerPopup: TPopupMenu;
    Copy2: TMenuItem;
    ClearScreen1: TMenuItem;
    RichEditPOPUP: TTBXPopupMenu;
    mrCopy: TTBXItem;
    mrCut: TTBXItem;
    mrPaste: TTBXItem;
    mrDelete: TTBXItem;
    Panel2: TPanel;
    Menubar: TTBToolbar;
    mClose: TTBXSubmenuItem;
    New1: TTBXItem;
    Print1: TTBXItem;
    Exit1: TTBXItem;
    Edit1: TTBXSubmenuItem;
    Cut1: TTBXItem;
    Copy1: TTBXItem;
    Paste1: TTBXItem;
    SelectAll1: TTBXItem;
    Delete1: TTBXItem;
    Option1: TTBXSubmenuItem;
    SaveSettingAsDefault: TTBXItem;
    Panel3: TPanel;
    Panel4: TPanel;
    TBXStatusBar1: TTBXStatusBar;
    TextToolbarPanel: TPanel;
    Panel6: TPanel;
    TBXToolWindow1: TTBXToolWindow;
    AddButton: TSpeedButton;
    SpeedButton1: TSpeedButton;
    TBXToolWindow2: TTBXToolWindow;
    Label1: TLabel;
    UnderLineButton: TSpeedButton;
    ItalicButton: TSpeedButton;
    BoldButton: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SmileButton: TSpeedButton;
    FontSizeCombo: TComboBox;
    TBXToolWindow3: TTBXToolWindow;
    Button1: TButton;
    TBXToolWindow4: TTBXToolWindow;
    Panel1: TPanel;
    BuzzButton: TSpeedButton;
    ShakeTimer: TTimer;
    InputMemo: TRichEdit;
    ColorPOPUP: TPopupMenu;
    mcBlack: TMenuItem;
    mcGreen: TMenuItem;
    mcBlue: TMenuItem;
    mcOrange: TMenuItem;
    mcBrown: TMenuItem;
    mcPurple: TMenuItem;
    mcSoorati: TMenuItem;
    mcSkyBlue: TMenuItem;
    mcGray: TMenuItem;
    mcOtherColors: TMenuItem;
    OtherColors1: TMenuItem;
    ColorDialog1: TColorDialog;
    AutoScrollHtml: TMenuItem;
    Viewer: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure InputMemoKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ViewerLink(Sender: TObject; const Rel, Rev, Href: String);
    procedure ViewerHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure UnderLineButtonClick(Sender: TObject);
    procedure FontSizeComboChange(Sender: TObject);
    procedure InputMemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SmileButtonClick(Sender: TObject);
    procedure ViewerImageRequest(Sender: TObject; const SRC: String;
      var Stream: TMemoryStream);
    procedure mrCopyClick(Sender: TObject);
    procedure mrCutClick(Sender: TObject);
    procedure mrPasteClick(Sender: TObject);
    procedure mrDeleteClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure ClearScreen1Click(Sender: TObject);
    procedure OtherColors1Click(Sender: TObject);
    procedure SaveSettingAsDefaultClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure ShakeTimerTimer(Sender: TObject);
    procedure BuzzButtonClick(Sender: TObject);
    procedure mcBlackDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure mcBlackMeasureItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);
    procedure mcBlackClick(Sender: TObject);
    procedure InputMemoChange(Sender: TObject);
  private
    { Private declarations }
//    function GetRTF(RE: TRichedit): string;
    SmileStringList: TStringList;
    ShakeCounter: Integer;
    procedure SynchronizeInputFontStyles;
    procedure FillSmileStringList;
    procedure Buzz;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    BuddyName: string;
    MyNickName: string;
    CurrentColor: TColor;
    function ReplaceSmilesText(Str: string): string;
    procedure AppendToWB(WB: TMemo; const html: widestring);
    procedure SendText;
    procedure PMReceived(PMText: string);
  end;

implementation

uses
  MainUnit,LoginUnit, SmilesUnit, PreferencesUnit;

{$R *.dfm}

procedure TPMWindow.FormCreate(Sender: TObject);
var
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  { Viewer.LoadStrings(StrList);  }
  StrList.Free;
end;

procedure TPMWindow.AppendToWB(WB: TMemo; const html: widestring);
var
   Range: IHTMLTxtRange;
begin
   WB.Lines.Add(html);
   //Range := ((WB.Document AS IHTMLDocument2).body AS IHTMLBodyElement).createTextRange;
   //Range.Collapse(False) ;
   //Range.PasteHTML(html) ;
end;

procedure TPMWindow.InputMemoKeyPress(Sender: TObject; var Key: Char);
begin
  SynchronizeInputFontStyles;
  if Key = #13 then
  begin
    SendText;
    Key := #0;
  end;
  ActiveControl := InputMemo;
end;

procedure TPMWindow.SendText;
var
  Str: string;
  HTMLText: string;
begin
  if InputMemo.Text = '' then
    Exit;
  Str := '<B><font size=0 color=#'+IntToHex(MYNICKCOLOR,8)+'>'+MyNickName+':</font></B> ';
  HTMLText := RtfToHtml('',InputMemo);
  HTMLText := CorrectHTMLCode(HTMLText);
  HTMLText := ReplaceSmilesText(HTMLText);
  HTMLText := CorrectHTMLLinks(HTMLText);
  Str := Str + HTMLText;
  //Viewer.AddString(Str,'',HTMLType);
  AppendToWB(Viewer, Str);
  MainForm.SendPM(BuddyName,HTMLText);
  InputMemo.Clear;
  //SendMessage(InputMemo.Handle, EM_LINEINDEX,-1,0);
  //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
  Viewer.Invalidate;
  //keybd_event(VK_UP,0,0,0);
end;

procedure TPMWindow.Button1Click(Sender: TObject);
begin
  SendText;
  //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
  Viewer.Invalidate;
  ActiveControl := InputMemo;
end;

procedure TPMWindow.PMReceived(PMText: string);
var
  Str: string;
  ScrollPosition: Integer;
begin
  if PMText = '<Action=Buzz>' then
  begin
    Str := '<B><font size=0 color=#'+IntToHex(clRed,8)+'> BUZZZ!!!</font></B> ';
    Buzz;
  end
  else
  begin
    Str := '<B><font size=0 color=#'+IntToHex(BUDDYNICKCOLOR,8)+'>'+BuddyName+':</font></B> ';
    Str := Str + PMText;
  end;

  {if Viewer.Height <  Viewer.VScrollBar.Max then
   if Viewer.VScrollBar.Max = Viewer.Height + Viewer.VScrollBar.Position then
      begin
        ScrollPosition := Viewer.VScrollBar.Max;
        AutoScrollHtml.Checked := True;
      end
    else
      begin
        ScrollPosition := Viewer.VScrollBar.Position;
        AutoScrollHtml.Checked := False;
      end;  }

  AppendToWB(Viewer, Str);
  //Viewer.LoadString(Str,'',HTMLType);
  //Viewer.LoadTextFromString(Str);


  {if AutoScrollHtml.Checked then
    Viewer.VScrollBarPosition := Viewer.VScrollBar.Max
  else
    Viewer.VScrollBarPosition := ScrollPosition;         }

  Viewer.Invalidate;
end;

procedure TPMWindow.FormShow(Sender: TObject);
begin
  //MouseCapture := True;
  CurrentColor := clBlack;
  SmileStringList := TStringList.Create;
  FillSmileStringList;
  SynchronizeInputFontStyles;
  BoldButton.Down := MainForm.UserSetting.PMBold;
  ItalicButton.Down := MainForm.UserSetting.PMItalic;
  UnderLineButton.Down := MainForm.UserSetting.PMUnderLine;

  BoldButtonClick(Self);
  ItalicButtonClick(Self);
  UnderLineButtonClick(Self);

  InputMemo.SelAttributes.Color := MainForm.UserSetting.PMColor;
  CurrentColor := MainForm.UserSetting.PMColor;
  FontSizeCombo.ItemIndex := MainForm.UserSetting.PMFontSize;
  FontSizeComboChange(Self);
  //Menubar.Color := MainForm.MenuBarColor;
end;

procedure TPMWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    ExStyle := ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TPMWindow.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TPMWindow.Button2Click(Sender: TObject);
{
var
  i: Integer;
  dd: PChar;
  }
begin
{
  //Memo1.Lines.Text :=
//  i := Viewer.GetTextLen;
  Viewer.SelectAll;
  Memo1.Lines.Text := Viewer.SelText;
  Viewer.SelLength := 0;
  }
end;

procedure TPMWindow.ViewerLink(Sender: TObject; const Rel, Rev,
  Href: String);
begin
  InputMemo.Lines.Add(Rel);
  InputMemo.Lines.Add(Rev);
  InputMemo.Lines.Add(Href);
end;

procedure TPMWindow.ViewerHotSpotClick(Sender: TObject; const SRC: String;
  var Handled: Boolean);
begin
  if RightStr(SRC,1)<>'/' then
    Handled := BrowseURL('http://beyluxe.com/protection/check.php?link='+SRC+'/')
  else
    Handled := BrowseURL('http://beyluxe.com/protection/check.php?link='+SRC);
end;

procedure TPMWindow.SpeedButton4Click(Sender: TObject);
var
  MyPoint: TPoint;
begin
  GetCursorPos(MyPoint);
  ColorPOPUP.Popup(MyPoint.X,MyPoint.Y);
end;

{
function TPMWindow.GetRTF(RE: TRichedit): string;
var
   strStream: TStringStream;
begin
   strStream := TStringStream.Create('') ;
   try
     RE.PlainText := False;
     RE.Lines.SaveToStream(strStream) ;
     Result := strStream.DataString;
   finally
     strStream.Free
   end;
end;
}
procedure TPMWindow.BoldButtonClick(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    if BoldButton.Down then
      Style := Style + [fsBold]
    else
      Style := Style - [fsBold];
  ActiveControl := InputMemo;
end;

procedure TPMWindow.ItalicButtonClick(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    if ItalicButton.Down then
      Style := Style + [fsItalic]
    else
      Style := Style - [fsItalic];
  ActiveControl := InputMemo;
end;

procedure TPMWindow.UnderLineButtonClick(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    if UnderLineButton.Down then
      Style := Style + [fsUnderline]
    else
      Style := Style - [fsUnderline];
  ActiveControl := InputMemo;
end;

procedure TPMWindow.FontSizeComboChange(Sender: TObject);
begin
  with InputMemo.SelAttributes do
    case FontSizeCombo.ItemIndex of
    0: Size := 10;
    1: Size := 12;
    2: Size := 18;
    end;
  ActiveControl := InputMemo;
end;

procedure TPMWindow.InputMemoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SynchronizeInputFontStyles;
end;

procedure TPMWindow.SynchronizeInputFontStyles;
var
  FontStyle: TFontStyles;
  FontSize: Integer;
begin
  FontSize := 10;
  case FontSizeCombo.ItemIndex of
  0: FontSize := 10;
  1: FontSize := 12;
  2: FontSize := 18;
  end;
  FontStyle := [];
  if ItalicButton.Down then
    FontStyle := FontStyle + [fsItalic];
  if UnderLineButton.Down then
    FontStyle := FontStyle + [fsUnderline];

  if BoldButton.Down then
    FontStyle := FontStyle + [fsBold];

  if InputMemo.SelAttributes.Color <> CurrentColor then
    InputMemo.SelAttributes.Color := CurrentColor;

  if InputMemo.SelAttributes.Style <> FontStyle then
    InputMemo.SelAttributes.Style := FontStyle;

  if InputMemo.SelAttributes.Size <> FontSize then
    InputMemo.SelAttributes.Size := FontSize;
end;

procedure TPMWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SmileStringList.Free;
  PostMessage(MainForm.Handle,WCM_DestroyMePM,Integer(Self),0);
end;

procedure TPMWindow.FillSmileStringList;
var
  i: Integer;
  MaxLength: Integer;
  SmileStr: string;
begin
  MaxLength := 0;
  for i := 0 To SmilesForm.SmileStrList.Count - 1 do
  begin
    SmileStr := SmilesForm.SmileStrList.Strings[i];
    SmileStr := StringReplace(SmileStr,'<','&lt;',[rfReplaceAll]);
    SmileStr := StringReplace(SmileStr,'>','&gt;',[rfReplaceAll]);
    SmileStr := StringReplace(SmileStr,'"','&quot;',[rfReplaceAll]);
    if Length(SmileStr)>MaxLength then
      MaxLength := Length(SmileStr);
  end;
  while MaxLength>1 do
  begin
    for i := 0 To SmilesForm.SmileStrList.Count - 1 do
    begin
      SmileStr := SmilesForm.SmileStrList.Strings[i];
      SmileStr := StringReplace(SmileStr,'<','&lt;',[rfReplaceAll]);
      SmileStr := StringReplace(SmileStr,'>','&gt;',[rfReplaceAll]);
      SmileStr := StringReplace(SmileStr,'"','&quot;',[rfReplaceAll]);
      if Length(SmileStr)=MaxLength then
      begin
        SmileStringList.AddObject(SmileStr,TObject(i));
      end;
    end;
    Dec(MaxLength);
  end;
end;

procedure TPMWindow.SmileButtonClick(Sender: TObject);
var
  WhereToShow: TPoint;
  MyPoint: TPoint;
begin
  MyPoint.X := SmileButton.Left + SmileButton.Width div 2;
  MyPoint.Y := SmileButton.Top + SmileButton.Height div 2 - SmilesForm.ClientHeight;
  WhereToShow := ClientToScreen(MyPoint);
  {SmilesForm.Left := WhereToShow.X;
  SmilesForm.Top := WhereToShow.Y;
  SmilesForm.ActiveRichEdit := InputMemo;
  SmilesForm.ShowModal;}
  MainForm.ActiveRichEdit := InputMemo;
  MainForm.SmilePOPUP.Popup(WhereToShow.X,WhereToShow.Y+TextToolbarPanel.Top+5);
end;

function TPMWindow.ReplaceSmilesText(Str: string): string;
var
  i: Integer;
  MyStr: string;
begin
  MyStr := Str;
  for i := 0 to SmileStringList.Count -1 do
  begin
    MyStr := StringReplace(MyStr,SmileStringList.Strings[i],'<IMG src="'+IntToStr(Integer(SmileStringList.Objects[i]))+'"></IMG>',[rfReplaceAll]);
  end;
  Result := MyStr;
end;

procedure TPMWindow.ViewerImageRequest(Sender: TObject; const SRC: String;
  var Stream: TMemoryStream);
var
  ImageIndex: Integer;
begin
  ImageIndex := StrToIntDef(SRC,0);
  if (ImageIndex>-1) and (ImageIndex<MainForm.SmilesStreamList.Count) then
    Stream := TMemoryStream(MainForm.SmilesStreamList.Items[ImageIndex]);
end;

procedure TPMWindow.mrCopyClick(Sender: TObject);
begin
  InputMemo.CopyToClipboard;
end;

procedure TPMWindow.mrCutClick(Sender: TObject);
begin
  InputMemo.CutToClipboard;
end;

procedure TPMWindow.mrPasteClick(Sender: TObject);
begin
  InputMemo.PasteFromClipboard;
end;

procedure TPMWindow.mrDeleteClick(Sender: TObject);
begin
  InputMemo.SelText := '';
end;

procedure TPMWindow.Copy2Click(Sender: TObject);
begin
  {Viewer.CopyToClipboard;}
end;

procedure TPMWindow.ClearScreen1Click(Sender: TObject);
begin
  {Viewer.Clear;
  Viewer.Reformat;  }
end;

procedure TPMWindow.SaveSettingAsDefaultClick(Sender: TObject);
var
  Setting: TUserSetting;
begin
  Setting := MainForm.UserSetting;
  Setting.PMBold := fsBold in InputMemo.SelAttributes.Style;
  Setting.PMItalic := fsItalic in InputMemo.SelAttributes.Style;
  Setting.PMUnderLine := fsUnderline in InputMemo.SelAttributes.Style;
  Setting.PMColor := InputMemo.SelAttributes.Color;
  Setting.PMFontSize := FontSizeCombo.ItemIndex;
  MainForm.UserSetting := Setting;
  MainForm.SaveUserSetting;
end;

procedure TPMWindow.AddButtonClick(Sender: TObject);
begin
  MainForm.AddAsFriend(BuddyName);
end;

procedure TPMWindow.ShakeTimerTimer(Sender: TObject);
begin
  if ShakeCounter mod 4 = 0 then
    Left := Left - 5
  else
  if ShakeCounter mod 4 = 1 then
    Top := Top - 5
  else
  if ShakeCounter mod 4 = 2 then
    Left := Left + 5
  else
  if ShakeCounter mod 4 = 3 then
    Top := Top + 5;
//  else
  if ShakeCounter = 7 then
  begin
    //Left := Left - 5;
    //Top := Top - 5;
    ShakeTimer.Enabled := False;
    ShakeCounter := 0;
    Exit;
  end;
  Inc(ShakeCounter);
end;

procedure TPMWindow.Buzz;
begin
  if MainForm.CanPlayAlertSound then
    PlaySound(PChar(MainForm.SystemPreferences.BuzzSnd),0,SND_FILENAME or SND_ASYNC or SND_NOWAIT or SND_NODEFAULT);
  ShakeTimer.Enabled := True;
end;

procedure TPMWindow.BuzzButtonClick(Sender: TObject);
var
  Str: string;
begin
  Str := '<B><font size=0 color=#'+IntToHex(clRed,8)+'> BUZZZ!!!</font></B> ';
  //Viewer.LoadString(Str,'',HTMLType);
  //Viewer.LoadTextFromString(Str);
  AppendToWB(Viewer, Str);
  //Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
  Viewer.Invalidate;
  MainForm.SendPM(BuddyName,'<Action=Buzz>');
  Buzz;
end;

procedure TPMWindow.mcBlackDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  TmpRect: TRect;
begin
  if Selected then
    ACanvas.Brush.Color := clHighlight
  else
    ACanvas.Brush.Color := clMenu;

  //ARect.Left := 20;
  ACanvas.FillRect(ARect);
  TmpRect.Left := ARect.Left + 5;
  TmpRect.Top := ARect.Top + 3;
  TmpRect.Bottom := ARect.Bottom - 3;
  TmpRect.Right := ARect.Right - 5;
  case (Sender as TMenuItem).Tag of
  0: ACanvas.Brush.Color := clBlack;
  1: ACanvas.Brush.Color := clGreen;
  2: ACanvas.Brush.Color := clBlue;
  3: ACanvas.Brush.Color := $004F7CE8;
  4: ACanvas.Brush.Color := $00005782;
  5: ACanvas.Brush.Color := $00BE3F75;
  6: ACanvas.Brush.Color := $008000FF;
  7: ACanvas.Brush.Color := clSkyBlue;
  8: ACanvas.Brush.Color := $00BE3F75;
  9: ACanvas.Brush.Color := clGray;
  end;
  ACanvas.FillRect(TmpRect);
end;

procedure TPMWindow.mcBlackMeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin
  Height := Height - 5;
end;

procedure TPMWindow.OtherColors1Click(Sender: TObject);
var
  ColorDialog: THCColorDialog;
begin
  ColorDialog := THCColorDialog.Create(Self);
  if ColorDialog.Execute then
    CurrentColor := ColorDialog.Color;
  InputMemo.SelAttributes.Color := CurrentColor;
  ColorDialog.Free;
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TPMWindow.mcBlackClick(Sender: TObject);
begin
  case (Sender as TMenuItem).Tag of
  0: CurrentColor := clBlack;
  1: CurrentColor := clGreen;
  2: CurrentColor := clBlue;
  3: CurrentColor := $004F7CE8;
  4: CurrentColor := $00005782;
  5: CurrentColor := $00BE3F75;
  6: CurrentColor := $008000FF;
  7: CurrentColor := clSkyBlue;
  8: CurrentColor := $00BE3F75;
  9: CurrentColor := clGray;
  end;
  InputMemo.SelAttributes.Color := CurrentColor;
  if InputMemo.Enabled then
    ActiveControl := InputMemo;
end;

procedure TPMWindow.InputMemoChange(Sender: TObject);
begin
  MainForm.LastHWND     := Handle;
  MainForm.LastTypeTime := Now;
end;

end.
