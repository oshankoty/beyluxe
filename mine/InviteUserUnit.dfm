object InviteUserForm: TInviteUserForm
  Left = 256
  Top = 191
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Invite User'
  ClientHeight = 307
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 261
    Height = 307
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 307
    ClientAreaWidth = 261
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 101
      Height = 13
      Caption = 'Select Users to Invite'
      Transparent = True
    end
    object Button1: TButton
      Left = 92
      Top = 264
      Width = 75
      Height = 25
      Caption = 'Invite'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object UsersListView: TListView
      Left = 14
      Top = 40
      Width = 233
      Height = 209
      Checkboxes = True
      Columns = <
        item
          Width = 200
        end>
      ReadOnly = True
      ShowColumnHeaders = False
      SmallImages = MainForm.FriendListImages
      TabOrder = 1
      ViewStyle = vsReport
    end
  end
end
