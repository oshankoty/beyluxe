unit BrowseRoomsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, TB2Dock, TB2ToolWindow, TBX, ImgList, {GetLockPassword,}
  Menus, TB2Item, CMClasses, Registry;

type
  TBrowseRoomsForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    RoomListLBL: TLabel;
    RoomList: TListView;
    Button1: TButton;
    Button2: TButton;
    ImageList1: TImageList;
    ShowAR: TCheckBox;
    BrowseRoomPOPUPMenu: TTBXPopupMenu;
    TBXItem1: TTBXItem;
    TBXItem2: TTBXItem;
    pmCloseRoom: TTBXItem;
    CategoryTree: TTreeView;
    Label2: TLabel;
    RefreshBtn: TButton;
    TBXItem3: TTBXItem;
    procedure CategoryListClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CategoryListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure SubCategoryListClick(Sender: TObject);
    procedure RoomListDblClick(Sender: TObject);
    procedure RoomListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Button1Click(Sender: TObject);
    procedure CategoryListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ShowARClick(Sender: TObject);
    procedure RoomListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure pmCloseRoomClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CategoryTreeClick(Sender: TObject);
    procedure RefreshBtnClick(Sender: TObject);
    procedure TBXItem3Click(Sender: TObject);
  private
    { Private declarations }
    FCategoryChanged: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    
  public
    { Public declarations }
  end;

var
  BrowseRoomsForm: TBrowseRoomsForm;

const
  RoomListLBLCaption:string = 'Room List';

implementation

uses
  MainUnit;

{$R *.dfm}

procedure TBrowseRoomsForm.CategoryListClick(Sender: TObject);
var
  i: Integer;
begin
{
  if FCategoryChanged then
  begin
    SubCategoryList.Clear;
    RoomList.Clear;
    if CategoryList.ItemIndex<>-1 then
    begin
      with MainForm.SubCategories[CategoryList.ItemIndex] do
        for i := 0 to Count - 1 do
          SubCategoryList.AddItem(Strings[i],nil);
      FCategoryChanged := False;
    end;
  end;
}
end;

procedure TBrowseRoomsForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TBrowseRoomsForm.CategoryListChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if ctState in [change] then
    FCategoryChanged := True;
end;

procedure TBrowseRoomsForm.SubCategoryListClick(Sender: TObject);
begin
  //MainForm.GetRoomList(CategoryList.ItemIndex,SubCategoryList.ItemIndex);
end;

procedure TBrowseRoomsForm.RoomListDblClick(Sender: TObject);
const
  AlreadyInRoomError: array[0..30] of byte = ($63,$79,$7F,$2A,$72,$6B,$80,$6F,$2A,$7E,$72,$73,$7D,$2A,$7C,$79,$79,$77,$2A,$6B,$76,$7C,$6F,$6B,$6E,$83,$2A,$79,$7A,$6F,$78);
  ErrorStr: array[0..4] of byte = ($4F,$7C,$7C,$79,$7C);
begin
  if RoomList.ItemIndex = -1 then
    Exit;
  if not MainForm.IamCurrentlyInRoom(RoomList.Items[RoomList.ItemIndex].Caption) then
  begin
    //if RoomList.Items[RoomList.ItemIndex].SubItemImages[0]>0 then
    {if RoomList.Items[RoomList.ItemIndex].ImageIndex > 2 then
    begin
      GetLockCodeForm := TGetLockCode.Create(Self);
      if GetLockCodeForm.ShowModal = mrOK then
      begin
        MainForm.RequestJoinToRoom(RoomList.Items[RoomList.ItemIndex].SubItems[1],'');
        GetLockCodeForm.Free;
      end
      else
      begin
        GetLockCodeForm.Free;
      end;
    end
    else}
      MainForm.RequestJoinToRoom(RoomList.Items[RoomList.ItemIndex].SubItems[1],'');
  end
  else
    MessageBox(Handle,PChar(Hex2DecString(AlreadyInRoomError)),PChar(Hex2DecString(ErrorStr)),MB_OK);
end;

procedure TBrowseRoomsForm.RoomListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if StrToInt(Item1.SubItems[2])<StrToInt(Item2.SubItems[2]) then
    Compare := 1
  else
    Compare := 0;
end;

procedure TBrowseRoomsForm.Button1Click(Sender: TObject);
begin
  RoomListDblClick(Self);
end;

procedure TBrowseRoomsForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TBrowseRoomsForm.CategoryListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  i: Integer;
begin
{
  if FCategoryChanged then
  begin
    SubCategoryList.Clear;
    RoomList.Clear;
    if CategoryList.ItemIndex<>-1 then
    begin
      with MainForm.SubCategories[CategoryList.ItemIndex] do
        for i := 0 to Count - 1 do
          SubCategoryList.AddItem(Strings[i],nil);
      FCategoryChanged := False;
    end;
  end;
}
end;

procedure TBrowseRoomsForm.ShowARClick(Sender: TObject);
begin
  if ShowAR.Checked then
  begin
    if MessageBox(Handle,'These rooms may contain material of sexual or controversial nature which is inappropriate for users under the age of 18'+#13+#10+' and which maybe offensive to some adults.'+#13+#10+'Do not enter this type of room if you are under 18, or the laws in your state.','Warning!',MB_OKCANCEL)=ID_OK then
    begin
      //SubCategoryListClick(Self);
      CategoryTreeClick(Self);
      Exit;
    end
    else
      ShowAR.Checked := False;
  end
  else
  begin
    ShowAR.Checked := False;
    //SubCategoryListClick(Self);
    CategoryTreeClick(Self);
  end;
end;

procedure TBrowseRoomsForm.RoomListCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Subscription: Integer;
begin
  Subscription := Integer(Item.Data);
  case Subscription of
  0: RoomList.Canvas.Font.Color := clBlack;
  1: RoomList.Canvas.Font.Color := clBlue;
  2: RoomList.Canvas.Font.Color := clGreen;
  6: RoomList.Canvas.Font.Color := clRed;
  end;
end;

procedure TBrowseRoomsForm.pmCloseRoomClick(Sender: TObject);
begin
  if RoomList.ItemIndex = -1 then
    Exit;
  if MessageBox(Handle,PChar('Are you sure to close "'+RoomList.Items[RoomList.ItemIndex].SubItems[1]+'" Room?'), 'Confirmation',MB_YESNO) = ID_YES then
    MainForm.CloseRoomRequest(RoomList.Items[RoomList.ItemIndex].SubItems[1],'')
end;

procedure TBrowseRoomsForm.FormShow(Sender: TObject);
begin
  RoomList.OnDblClick := RoomListDblClick;
end;

procedure TBrowseRoomsForm.CategoryTreeClick(Sender: TObject);
var
  tmpStr:string;
begin
  // TADD
  if CategoryTree.Selected.Index = -1 then Exit;
  tmpStr := Copy(Caption,6,7);
  if not CategoryTree.Selected.HasChildren then
    begin
      MainForm.GetRoomList(CategoryTree.Selected.Parent.Index,CategoryTree.Selected.Index);
      //RefreshBtn.Visible := True;
      RoomListLBL.Caption := CategoryTree.Selected.Text + tmpStr;
    end;
end;

procedure TBrowseRoomsForm.RefreshBtnClick(Sender: TObject);
begin
if CategoryTree.Selected.Index = -1 then Exit;
  CategoryTreeClick(Self);
end;

procedure TBrowseRoomsForm.TBXItem3Click(Sender: TObject);
var
  RoomName: string;
  Registry: TRegistry;
begin
  RoomName := RoomList.Items[RoomList.ItemIndex].SubItems[1];
  if MainForm.FavoriteRoomList.IndexOf(RoomName)=-1 then
  begin
    Registry := TRegistry.Create;
    Registry.CreateKey('\Software\Beyluxe Messenger\'+ MainForm.MyNickName + '\FavoriteRooms\'+RoomName);
    Registry.CloseKey;
    Registry.Free;
    ShowMessage('Room '+RoomName+' has been Added to your Favorite Room List.');
  end
  else
  begin
    ShowMessage('Room '+RoomName+' is already in your Favorite Room List.');
    Exit;
  end;
  MainForm.FavoriteRoomList.Add(RoomName);
  MainForm.MakeFavoriteRoomMenu;
end;

end.
