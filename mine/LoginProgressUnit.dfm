object LoginProgressForm: TLoginProgressForm
  Left = 378
  Top = 268
  BorderStyle = bsNone
  Caption = 'Loging on to server'
  ClientHeight = 65
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 217
    Height = 65
    Align = alClient
    Caption = 'Loging in. Please wait...'
    ClientAreaHeight = 65
    ClientAreaWidth = 217
    TabOrder = 0
    object JvWaitingGradient1: TJvWaitingGradient
      Left = 8
      Top = 40
      Width = 201
      Color = clBtnFace
      Enabled = True
      GradientWidth = 50
      Interval = 18
      ParentColor = False
    end
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 112
      Height = 13
      Caption = 'Loging in. Please wait...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
end
