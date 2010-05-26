object AdminControlPanel: TAdminControlPanel
  Left = 277
  Top = 206
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Admin Control Panel'
  ClientHeight = 428
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 305
    Height = 428
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 428
    ClientAreaWidth = 305
    TabOrder = 0
    object Label1: TLabel
      Left = 6
      Top = 12
      Width = 53
      Height = 13
      Caption = 'User Name'
      Transparent = True
    end
    object Label2: TLabel
      Left = 160
      Top = 72
      Width = 38
      Height = 13
      Caption = 'Ban List'
      Transparent = True
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 56
      Height = 13
      Caption = 'Bounce List'
      Transparent = True
    end
    object UserComboBox: TComboBox
      Left = 64
      Top = 8
      Width = 233
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
    object BanListBox: TListBox
      Left = 160
      Top = 88
      Width = 137
      Height = 97
      ItemHeight = 13
      TabOrder = 5
    end
    object BounceListBox: TListBox
      Left = 8
      Top = 88
      Width = 137
      Height = 97
      ItemHeight = 13
      TabOrder = 3
    end
    object BanUserButton: TButton
      Left = 160
      Top = 40
      Width = 137
      Height = 25
      Caption = 'Add to BanList'
      TabOrder = 2
      OnClick = BanUserButtonClick
    end
    object UnBounceUserButton: TButton
      Left = 8
      Top = 192
      Width = 137
      Height = 25
      Caption = 'UnBounce Selected User'
      TabOrder = 4
      OnClick = UnBounceUserButtonClick
    end
    object UnBanUserButton: TButton
      Left = 160
      Top = 192
      Width = 137
      Height = 25
      Caption = 'UnBan Selected User'
      TabOrder = 6
      OnClick = UnBanUserButtonClick
    end
    object Button1: TButton
      Left = 104
      Top = 392
      Width = 75
      Height = 25
      Caption = 'Close Room'
      TabOrder = 9
      OnClick = TBXButton1Click
    end
    object Button2: TButton
      Left = 8
      Top = 40
      Width = 137
      Height = 25
      Caption = 'Add to BounceList'
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 224
      Width = 137
      Height = 97
      Caption = 'New Users Status'
      Color = clSkyBlue
      ParentColor = False
      TabOrder = 7
      object DefaultRedDotVideo: TCheckBox
        Left = 16
        Top = 69
        Width = 97
        Height = 17
        Caption = 'Reddot Video'
        Checked = True
        Color = clBtnFace
        ParentColor = False
        State = cbChecked
        TabOrder = 2
        OnClick = NewUserReddotCheckBoxesClick
      end
      object DefaultRedDotMic: TCheckBox
        Left = 16
        Top = 45
        Width = 97
        Height = 17
        Caption = 'Reddot Mic'
        Checked = True
        Color = clBtnFace
        ParentColor = False
        State = cbChecked
        TabOrder = 1
        OnClick = NewUserReddotCheckBoxesClick
      end
      object DefaultRedDotText: TCheckBox
        Left = 16
        Top = 21
        Width = 97
        Height = 17
        Caption = 'Reddot Text'
        Checked = True
        Color = clBtnFace
        ParentColor = False
        State = cbChecked
        TabOrder = 0
        OnClick = NewUserReddotCheckBoxesClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 328
      Width = 289
      Height = 57
      Caption = 'Modify Room Message'
      Color = clSkyBlue
      ParentColor = False
      TabOrder = 8
      object RoomMessageEditBox: TEdit
        Left = 8
        Top = 24
        Width = 201
        Height = 21
        MaxLength = 2000
        TabOrder = 0
      end
      object Button3: TButton
        Left = 216
        Top = 21
        Width = 65
        Height = 25
        Caption = 'Modify'
        TabOrder = 1
        OnClick = Button3Click
      end
    end
  end
end
