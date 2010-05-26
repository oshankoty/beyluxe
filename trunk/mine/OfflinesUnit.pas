unit OfflinesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Htmlview, ExtCtrls, StdCtrls, TB2Dock, TB2ToolWindow, TBX,
  ComCtrls, CMClasses, RoomWindowUnit, TB2Item, Menus;

type
  TOfflinesForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Panel1: TPanel;
    Viewer: THTMLViewer;
    OfflineListView: TListView;
    ViewerPOPUP: TTBXPopupMenu;
    Copy2: TTBXItem;
    ClearScreen1: TTBXItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure OfflineListViewClick(Sender: TObject);
    procedure OfflineListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ViewerHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    procedure ViewerImageRequest(Sender: TObject; const SRC: String;
      var Stream: TMemoryStream);
    procedure Copy2Click(Sender: TObject);
    procedure OfflineListViewDblClick(Sender: TObject);
  private
    { Private declarations }
    FOfflinesStr: string;
    SmileStringList: TStringList;
    procedure SetOfflinesStr(const Value: string);
    procedure SendTextToViewer(User, Text: string; UserColor: TColor);
    procedure FillSmileStringList;
    function ReplaceSmilesText(Str: string): string;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    OfflineSenders: TStringList;
    OfflineList: TStringList;
    //FOfflineTexts: TStringList;
    property OfflinesStr: string read FOfflinesStr write SetOfflinesStr;
  end;

var
  OfflinesForm: TOfflinesForm;

implementation

uses MainUnit, SmilesUnit;

{$R *.dfm}

{ TOfflinesForm }

procedure TOfflinesForm.SetOfflinesStr(const Value: string);
begin
  FOfflinesStr := Value;
end;

procedure TOfflinesForm.FormCreate(Sender: TObject);
begin
  OfflineSenders := TStringList.Create;
  OfflineList := TStringList.Create;
  Viewer.LoadStrings(OfflineList);
  SmileStringList := TStringList.Create;
  FillSmileStringList;
end;

procedure TOfflinesForm.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to OfflineList.Count - 1 do
    FreeMem(Pointer(OfflineList.Objects[i]));
  OfflineList.Free;
  OfflineSenders.Free;
  SmileStringList.Free;
end;

procedure TOfflinesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TOfflinesForm.FormShow(Sender: TObject);
var
  i: Integer;
  PMText: string;
begin
  for i := 0 to OfflineList.Count - 1 do
  begin
    OfflineListView.Items.Add;
    OfflineListView.Items[i].Caption := OfflineSenders.Strings[i];
    OfflineListView.Items[i].SubItems.Add(OfflineList.Strings[i]);

    Viewer.LoadString(PChar(OfflineList.Objects[i]),'',HTMLType);
    Viewer.SelectAll;
    PMText := Viewer.SelText;
    Viewer.SelLength := 0;
    Viewer.Clear;
    OfflineListView.Items[i].SubItems.Add(PMText);
  end;
end;

procedure TOfflinesForm.OfflineListViewClick(Sender: TObject);
//var
//  Str: string;
begin
  Viewer.Clear;
  if OfflineListView.ItemIndex<>-1 then
  begin
    SendTextToViewer(OfflineSenders.Strings[OfflineListView.ItemIndex],PChar(OfflineList.Objects[OfflineListView.ItemIndex]),BUDDYNICKCOLOR);
{    Viewer.Clear;
    Str := '<B><font size=0 color=#'+IntToHex($0000EE,8)+'>'+OfflineSenders.Strings[OfflineListView.ItemIndex]+':</font></B> ';
    Str := Str + PChar(OfflineList.Objects[OfflineListView.ItemIndex]);
    Viewer.AddString(Str,'',HTMLType);
}
  end;
end;

procedure TOfflinesForm.OfflineListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  OfflineListViewClick(Self);
end;

procedure TOfflinesForm.SendTextToViewer(User, Text: string;
  UserColor: TColor);
var
  Str: string;
begin
  Str := '<B><font size=0 color=#'+IntToHex(WebColor(BUDDYNICKCOLOR),8)+'>'+User+':</font></B> ';
  Str := Str + ReplaceSmilesText(' '+Text);
//  Str := CorrectHTMLLinks(Str);
  Viewer.LoadString(Str,'',HTMLType);
  Viewer.VScrollBarPosition := Viewer.VScrollBar.Max;
  Viewer.Invalidate;
end;

procedure TOfflinesForm.ViewerHotSpotClick(Sender: TObject;
  const SRC: String; var Handled: Boolean);
begin
  Handled := BrowseURL(SRC);
end;

procedure TOfflinesForm.ViewerImageRequest(Sender: TObject;
  const SRC: String; var Stream: TMemoryStream);
var
  ImageIndex: Integer;
begin
  ImageIndex := StrToIntDef(SRC,0);
  if (ImageIndex>-1) and (ImageIndex<MainForm.SmilesStreamList.Count) then
    Stream := TMemoryStream(MainForm.SmilesStreamList.Items[ImageIndex]);
end;

function TOfflinesForm.ReplaceSmilesText(Str: string): string;
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

procedure TOfflinesForm.FillSmileStringList;
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

procedure TOfflinesForm.Copy2Click(Sender: TObject);
begin
  Viewer.CopyToClipboard;
end;

procedure TOfflinesForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TOfflinesForm.OfflineListViewDblClick(Sender: TObject);
var
  Index: Integer;
  Buddy: string;
begin
 if OfflineListView.ItemIndex = -1 then Exit;

 Index := OfflineListView.ItemIndex;
 Buddy := OfflineListView.Items.Item[index].Caption;
 if Buddy <> '' then
   MainForm.OpenChatWindow(Buddy);

end;

end.
