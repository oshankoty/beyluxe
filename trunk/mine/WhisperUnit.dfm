object WhisperForm: TWhisperForm
  Left = 126
  Top = 161
  ActiveControl = Edit1
  BorderStyle = bsDialog
  Caption = 'WhisperForm'
  ClientHeight = 104
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 420
    Height = 104
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 104
    ClientAreaWidth = 420
    TabOrder = 0
    object SendButton: TButton
      Left = 335
      Top = 68
      Width = 75
      Height = 25
      Caption = 'Send'
      TabOrder = 0
      OnClick = SendButtonClick
    end
    object Edit1: TEdit
      Left = 16
      Top = 32
      Width = 393
      Height = 21
      MaxLength = 256
      TabOrder = 1
      OnKeyPress = Edit1KeyPress
    end
    object KeepOpenCheckBox: TCheckBox
      Left = 16
      Top = 64
      Width = 121
      Height = 17
      Caption = 'Keep Window Open'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
    end
  end
end
