object Form1: TForm1
  Left = 192
  Top = 114
  Width = 378
  Height = 340
  Caption = 'Manage Custom Away Messages'
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
    Width = 370
    Height = 306
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 306
    ClientAreaWidth = 370
    TabOrder = 0
    object ListBox1: TListBox
      Left = 8
      Top = 8
      Width = 353
      Height = 249
      ItemHeight = 13
      TabOrder = 0
    end
    object CloseButton: TButton
      Left = 224
      Top = 272
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 1
    end
    object DeleteButton: TButton
      Left = 48
      Top = 272
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
    end
  end
end
