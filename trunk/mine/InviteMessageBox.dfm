object InviteMsgBoxForm: TInviteMsgBoxForm
  Left = 2
  Top = 15
  BorderStyle = bsDialog
  Caption = 'Invitation'
  ClientHeight = 100
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 327
    Height = 100
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 100
    ClientAreaWidth = 327
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 11
      Width = 32
      Height = 13
      Caption = 'Label1'
      Transparent = True
    end
    object Label2: TLabel
      Left = 16
      Top = 32
      Width = 107
      Height = 13
      Caption = 'Would you like to join?'
      Transparent = True
    end
    object Button1: TButton
      Left = 192
      Top = 56
      Width = 75
      Height = 25
      Caption = 'No'
      ModalResult = 7
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 40
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Yes'
      Default = True
      ModalResult = 6
      TabOrder = 1
    end
  end
  object Timer1: TTimer
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 168
    Top = 8
  end
end
