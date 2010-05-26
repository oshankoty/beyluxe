object VolControlForm: TVolControlForm
  Left = 222
  Top = 189
  BorderStyle = bsNone
  ClientHeight = 149
  ClientWidth = 115
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 115
    Height = 149
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 149
    ClientAreaWidth = 115
    TabOrder = 0
    OnMouseMove = TBXToolWindow1MouseMove
    object VolumeControl: TTrackBar
      Left = 5
      Top = 3
      Width = 18
      Height = 144
      Max = 0
      Min = -10000
      Orientation = trVertical
      Position = -10000
      TabOrder = 0
      ThumbLength = 15
      TickStyle = tsNone
    end
  end
end
