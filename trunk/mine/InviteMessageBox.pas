unit InviteMessageBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RoomWindowUnit, ExtCtrls, TB2Dock, TB2ToolWindow, TBX,
  {GetLockPassword,} CMClasses;

type
  TInviteMsgBoxForm = class(TForm)
    TBXToolWindow1: TTBXToolWindow;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    ShowingModal: Boolean;
    function CanEnterRoom: string;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    GrantCode: string;
    RoomName: string;
    RoomCode: Integer;
    RoomPort: Integer;
    RoomType: Integer;
  end;

implementation

uses MainUnit, Contnrs;

{$R *.dfm}

procedure TInviteMsgBoxForm.Button2Click(Sender: TObject);
var
  i: Integer;
//  Found: Boolean;
  RoomWindow: TRoomWindow;
  //GetLockCodeForm: TGetLockCode;
  ResStr: string;
begin
  {$I crypt_start.inc}
  ResStr := CanEnterRoom;
  if ResStr<>'' then
  begin
    ShowMessage(ResStr);
    Exit;
  end;
  if RoomType = 1 then
  begin
    for i := 0 to MainForm.RoomWindowList.Count - 1 do
      if TRoomWindow(MainForm.RoomWindowList.Items[i]).RoomCode = RoomCode then
      begin
        //Found := True;
        ShowingModal := False;
        Close;
        Exit;
      end;
    RoomWindow := TRoomWindow.Create(nil);
    RoomWindow.GrantCode := GrantCode;
    RoomWindow.RoomCode := RoomCode;
    RoomWindow.RoomPort := RoomPort;
    RoomWindow.RoomType := 1;
    RoomWindow.AddToFavoriteButton.Enabled := False;
    RoomWindow.Show;
    MainForm.RoomWindowList.Add(RoomWindow);
  end
  else
  {if RoomType>1 then
  begin
    GetLockCodeForm := TGetLockCode.Create(Self);
    ShowingModal := True;
    if GetLockCodeForm.ShowModal = mrOK then
    begin
      MainForm.RequestJoinToRoom(RoomName,GetLockCodeForm.Edit1.Text);
      GetLockCodeForm.Free;
    end
    else
    begin
      GetLockCodeForm.Free;
      Close;
    end;
  end
  else
  begin}
    MainForm.RequestJoinToRoom(RoomName,'');
  //end;
  ShowingModal := False;
  Close;
  {$I crypt_end.inc}
end;

procedure TInviteMsgBoxForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TInviteMsgBoxForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TInviteMsgBoxForm.Timer1Timer(Sender: TObject);
begin
  if ShowingModal then
    Exit;
  Close;
end;

procedure TInviteMsgBoxForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

function TInviteMsgBoxForm.CanEnterRoom: string;
const
  RoomErrorStr: array[0..58] of byte = ($5A,$76,$6F,$6B,$7D,$6F,$2A,$6D,$76,$79,$7D,$6F,$2A,$79,$7E,$72,$6F,$7C,$2A,$7C,$79,$79,$77,$7D,$2A,$6C,$6F,$70,$79,$7C,$6F,$2A,$6B,$7E,$7E,$6F,$77,$7A,$73,$78,$71,$2A,$7E,$79,$2A,$74,$79,$73,$78,$2A,$7E,$72,$73,$7D,$2A,$79,$78,$6F,$38);
begin
  {$I crypt_start.inc}
  Result := '';
  if MainForm.MyPrivilege = 0 then
  begin
    if ((MainForm.MySubscription=0) and (MainForm.RoomWindowList.Count>0)) or
       ((MainForm.MySubscription=1) and (MainForm.RoomWindowList.Count>2)) or
       ((MainForm.MySubscription=2) and (MainForm.RoomWindowList.Count>5)) then
    begin
      Result := Hex2DecString(RoomErrorStr);
      Exit;
    end;
  end;
  {$I crypt_end.inc}
end;

procedure TInviteMsgBoxForm.FormShow(Sender: TObject);
begin
  Button2.OnClick := Button2Click;
end;

end.
