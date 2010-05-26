object CustomAwayMessageForm: TCustomAwayMessageForm
  Left = 221
  Top = 192
  BorderStyle = bsDialog
  Caption = 'Custom Away Message'
  ClientHeight = 74
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 498
    Height = 74
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 74
    ClientAreaWidth = 498
    TabOrder = 0
    object CustomMsgCombo: TComboBox
      Left = 8
      Top = 12
      Width = 481
      Height = 21
      ItemHeight = 13
      MaxLength = 79
      TabOrder = 0
    end
    object OkButton: TButton
      Left = 56
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object CancelButton: TButton
      Left = 328
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
