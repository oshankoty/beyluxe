object UpdateForm: TUpdateForm
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Update'
  ClientHeight = 86
  ClientWidth = 379
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
    Width = 379
    Height = 86
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 86
    ClientAreaWidth = 379
    TabOrder = 0
    object Gauge1: TGauge
      Left = 8
      Top = 20
      Width = 361
      Height = 20
      Progress = 0
    end
    object Label1: TLabel
      Left = 8
      Top = 4
      Width = 62
      Height = 13
      Caption = 'Downloading'
      Transparent = True
    end
    object CancelButton: TButton
      Left = 152
      Top = 52
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = CancelButtonClick
    end
  end
end
