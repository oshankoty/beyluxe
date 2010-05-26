object AboutForm: TAboutForm
  Left = 208
  Top = 192
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 134
  ClientWidth = 220
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 220
    Height = 134
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 134
    ClientAreaWidth = 220
    TabOrder = 0
    object Label1: TLabel
      Left = 60
      Top = 12
      Width = 92
      Height = 13
      Caption = 'Beyluxe Messenger'
      Transparent = True
    end
    object Label2: TLabel
      Left = 40
      Top = 33
      Width = 73
      Height = 13
      Caption = 'Module Version'
      Transparent = True
    end
    object Label3: TLabel
      Left = 128
      Top = 33
      Width = 32
      Height = 13
      Caption = 'Label3'
      Transparent = True
    end
    object Label4: TLabel
      Left = 74
      Top = 55
      Width = 71
      Height = 13
      Caption = 'Copyright 2007'
      Transparent = True
    end
    object Label5: TLabel
      Left = 40
      Top = 76
      Width = 154
      Height = 13
      Caption = 'HiChatters Communication S.R.L'
      Transparent = True
    end
    object Button1: TButton
      Left = 72
      Top = 104
      Width = 75
      Height = 25
      Caption = '&Ok'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
