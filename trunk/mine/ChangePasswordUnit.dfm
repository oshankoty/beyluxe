object ChangePasswordForm: TChangePasswordForm
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Change Password'
  ClientHeight = 220
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 301
    Height = 220
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 220
    ClientAreaWidth = 301
    TabOrder = 0
    object SecretQuestionLabel: TLabel
      Left = 16
      Top = 8
      Width = 30
      Height = 13
      Caption = '     .    '
      Transparent = True
    end
    object Label1: TLabel
      Left = 16
      Top = 32
      Width = 66
      Height = 13
      Caption = 'SecretAnswer'
      Transparent = True
    end
    object Label2: TLabel
      Left = 40
      Top = 81
      Width = 83
      Height = 13
      Caption = 'Current Password'
      Transparent = True
    end
    object Label3: TLabel
      Left = 40
      Top = 105
      Width = 71
      Height = 13
      Caption = 'New Password'
      Transparent = True
    end
    object Label4: TLabel
      Left = 40
      Top = 129
      Width = 109
      Height = 13
      Caption = 'Confirm New Password'
      Transparent = True
    end
    object SecretAnswerEdit: TEdit
      Left = 104
      Top = 29
      Width = 169
      Height = 21
      MaxLength = 31
      TabOrder = 0
    end
    object CurrentPasswordEdit: TEdit
      Left = 152
      Top = 76
      Width = 121
      Height = 21
      MaxLength = 31
      TabOrder = 1
    end
    object NewPasswordEdit: TEdit
      Left = 152
      Top = 100
      Width = 121
      Height = 21
      MaxLength = 31
      TabOrder = 2
    end
    object ConfirmNewPasswordEdit: TEdit
      Left = 152
      Top = 125
      Width = 121
      Height = 21
      MaxLength = 31
      TabOrder = 3
    end
    object OkButton: TButton
      Left = 168
      Top = 176
      Width = 75
      Height = 25
      Caption = '&Ok'
      TabOrder = 4
      OnClick = OkButtonClick
    end
    object CloseButton: TButton
      Left = 56
      Top = 176
      Width = 75
      Height = 25
      Caption = '&Close'
      TabOrder = 5
      OnClick = CloseButtonClick
    end
  end
end
