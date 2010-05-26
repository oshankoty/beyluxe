object AddBuddyForm: TAddBuddyForm
  Left = 232
  Top = 199
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add Buddy'
  ClientHeight = 82
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 289
    Height = 82
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 82
    ClientAreaWidth = 289
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 61
      Height = 13
      Caption = 'Buddy Name'
      Transparent = True
    end
    object Edit1: TEdit
      Left = 72
      Top = 16
      Width = 209
      Height = 21
      MaxLength = 32
      TabOrder = 0
    end
    object Button1: TButton
      Left = 48
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object Button2: TButton
      Left = 168
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
