object LoginForm: TLoginForm
  Left = 383
  Top = 251
  ActiveControl = LoginButton
  BorderStyle = bsDialog
  Caption = 'Beyluxe Messenger'
  ClientHeight = 214
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 232
    Height = 214
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 214
    ClientAreaWidth = 232
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 12
      Width = 50
      Height = 13
      Caption = 'UserName'
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 46
      Height = 13
      Caption = 'Password'
      Transparent = True
    end
    object RegisterLabel: TLabel
      Left = 64
      Top = 72
      Width = 127
      Height = 13
      Cursor = crHandPoint
      Caption = 'Click here for new account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      Transparent = True
      OnClick = RegisterLabelClick
    end
    object ForgotPasswordLabel: TLabel
      Left = 64
      Top = 92
      Width = 78
      Height = 13
      Cursor = crHandPoint
      Caption = 'Forgot password'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      Transparent = True
    end
    object CloseButton: TButton
      Left = 120
      Top = 178
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 5
      OnClick = CloseButtonClick
    end
    object LoginButton: TButton
      Left = 40
      Top = 178
      Width = 75
      Height = 25
      Caption = 'Login'
      TabOrder = 4
      OnClick = LoginButtonClick
    end
    object PasswordEdit: TEdit
      Left = 64
      Top = 40
      Width = 161
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
      Text = 'Password'
      OnChange = PasswordEditChange
    end
    object UserNameCombo: TComboBox
      Left = 64
      Top = 8
      Width = 161
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = UserNameComboChange
      OnKeyPress = UserNameComboKeyPress
    end
    object InvisibleLogin: TCheckBox
      Left = 24
      Top = 144
      Width = 97
      Height = 17
      Caption = 'Login invisible'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
    end
    object SavePassword: TCheckBox
      Left = 24
      Top = 117
      Width = 97
      Height = 17
      Caption = 'Save password'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
    end
  end
end
