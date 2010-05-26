object CreateEditMyRoom: TCreateEditMyRoom
  Left = 249
  Top = 207
  BorderStyle = bsDialog
  Caption = 'My Room'
  ClientHeight = 461
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 434
    Height = 461
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 461
    ClientAreaWidth = 434
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 73
      Width = 59
      Height = 13
      Caption = 'Room Name'
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 193
      Width = 57
      Height = 13
      Caption = 'Admin Code'
      Transparent = True
    end
    object Label3: TLabel
      Left = 8
      Top = 225
      Width = 52
      Height = 13
      Caption = 'Lock Code'
      Transparent = True
    end
    object Label4: TLabel
      Left = 8
      Top = 137
      Width = 45
      Height = 13
      Caption = 'Welcome'
      Transparent = True
    end
    object Label5: TLabel
      Left = 8
      Top = 105
      Width = 31
      Height = 13
      Caption = 'Rating'
      Transparent = True
    end
    object Label6: TLabel
      Left = 8
      Top = 8
      Width = 42
      Height = 13
      Caption = 'Category'
      Transparent = True
    end
    object Label7: TLabel
      Left = 8
      Top = 40
      Width = 64
      Height = 13
      Caption = 'Sub Category'
      Transparent = True
    end
    object Label8: TLabel
      Left = 8
      Top = 152
      Width = 43
      Height = 13
      Caption = 'Message'
      Transparent = True
    end
    object RoomNameEdit: TEdit
      Left = 80
      Top = 70
      Width = 345
      Height = 21
      MaxLength = 79
      TabOrder = 0
      OnKeyDown = RoomNameEditKeyDown
    end
    object AdminCodeEdit: TEdit
      Left = 80
      Top = 190
      Width = 121
      Height = 21
      MaxLength = 9
      TabOrder = 3
    end
    object LockCodeEdit: TEdit
      Left = 80
      Top = 222
      Width = 121
      Height = 21
      MaxLength = 9
      TabOrder = 4
    end
    object WelComeMemo: TMemo
      Left = 80
      Top = 137
      Width = 345
      Height = 42
      Lines.Strings = (
        'Welcome to my group')
      MaxLength = 1000
      TabOrder = 2
    end
    object RatingComboBox: TComboBox
      Left = 79
      Top = 102
      Width = 122
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'General'
      Items.Strings = (
        'General'
        'Restricted'
        'Adult')
    end
    object CategoriesCombo: TComboBox
      Left = 80
      Top = 4
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
      OnChange = CategoriesComboChange
    end
    object SubCategoriesCombo: TComboBox
      Left = 80
      Top = 36
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
    object CreateJoinButton: TButton
      Left = 232
      Top = 424
      Width = 121
      Height = 25
      Caption = 'Create/Edit Room'
      Default = True
      TabOrder = 10
      OnClick = CreateJoinButtonClick
    end
    object CloseButton: TButton
      Left = 80
      Top = 424
      Width = 121
      Height = 25
      Cancel = True
      Caption = 'Close'
      TabOrder = 11
      OnClick = CloseButtonClick
    end
    object GroupBox1: TGroupBox
      Left = 224
      Top = 272
      Width = 201
      Height = 145
      Caption = 'Super Admin List'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 9
      object SuperAdminFriendListCombo: TComboBox
        Left = 8
        Top = 16
        Width = 177
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object SuperAdminListBox: TListBox
        Left = 8
        Top = 72
        Width = 177
        Height = 66
        ItemHeight = 13
        TabOrder = 1
      end
      object AddToSuperAdminListButton: TButton
        Left = 8
        Top = 40
        Width = 81
        Height = 25
        Caption = 'Add'
        TabOrder = 2
        OnClick = AddToSuperAdminListButtonClick
      end
      object RemoveFromSuperAdminListButton: TButton
        Left = 104
        Top = 40
        Width = 81
        Height = 25
        Caption = 'Remove'
        TabOrder = 3
        OnClick = RemoveFromSuperAdminListButtonClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 272
      Width = 201
      Height = 145
      Caption = 'Admin List'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 8
      object AdminFriendListCombo: TComboBox
        Left = 8
        Top = 16
        Width = 177
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object AdminListBox: TListBox
        Left = 8
        Top = 72
        Width = 177
        Height = 66
        ItemHeight = 13
        TabOrder = 1
      end
      object AddToAdminListButton: TButton
        Left = 8
        Top = 40
        Width = 81
        Height = 25
        Caption = 'Add'
        TabOrder = 2
        OnClick = AddToAdminListButtonClick
      end
      object RemoveFromAdminListButton: TButton
        Left = 104
        Top = 40
        Width = 81
        Height = 25
        Caption = 'Remove'
        TabOrder = 3
        OnClick = RemoveFromAdminListButtonClick
      end
    end
    object AdminListControl: TCheckBox
      Left = 8
      Top = 248
      Width = 97
      Height = 17
      Caption = 'AdminListControl'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 7
    end
  end
end
