object GetLockCode: TGetLockCode
  Left = 250
  Top = 320
  BorderStyle = bsDialog
  Caption = 'Beyluxe'
  ClientHeight = 73
  ClientWidth = 223
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 223
    Height = 73
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 73
    ClientAreaWidth = 223
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 52
      Height = 13
      Caption = 'Lock Code'
      Transparent = True
    end
    object Edit1: TEdit
      Left = 64
      Top = 13
      Width = 148
      Height = 21
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
    object TBXButton1: TButton
      Left = 128
      Top = 44
      Width = 57
      Height = 21
      Caption = 'Join'
      TabOrder = 1
      OnClick = TBXButton1Click
    end
    object TBXButton2: TButton
      Left = 40
      Top = 44
      Width = 57
      Height = 21
      Caption = 'Close'
      TabOrder = 2
      OnClick = TBXButton2Click
    end
  end
end
