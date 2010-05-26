object JoinRoomAsAdminForm: TJoinRoomAsAdminForm
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Join Room As Admin'
  ClientHeight = 108
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 300
    Height = 108
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 108
    ClientAreaWidth = 300
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 19
      Width = 87
      Height = 13
      Caption = 'Owner Nick Name'
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 52
      Width = 78
      Height = 13
      Caption = 'Admin Password'
      Transparent = True
    end
    object FriendListCombo: TComboBox
      Left = 112
      Top = 16
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object AdminPassEdit: TEdit
      Left = 112
      Top = 48
      Width = 177
      Height = 21
      MaxLength = 9
      PasswordChar = '*'
      TabOrder = 1
      OnKeyPress = AdminPassEditKeyPress
    end
    object JoinButton: TButton
      Left = 152
      Top = 80
      Width = 100
      Height = 21
      Caption = 'Join Room'
      TabOrder = 2
      OnClick = JoinButtonClick
    end
    object CloseButton: TButton
      Left = 40
      Top = 80
      Width = 100
      Height = 21
      Caption = 'Close'
      TabOrder = 3
      OnClick = CloseButtonClick
    end
  end
end
