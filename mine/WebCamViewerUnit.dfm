object WebcamViewerForm: TWebcamViewerForm
  Left = 247
  Top = 131
  Width = 328
  Height = 286
  BorderStyle = bsSizeToolWin
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage32
    Left = 0
    Top = 0
    Width = 320
    Height = 232
    Align = alClient
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smResize
    TabOrder = 0
  end
  object RepaintTimer: TTimer
    Enabled = False
    Interval = 70
    OnTimer = RepaintTimerTimer
    Left = 40
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object View1: TMenuItem
      Caption = 'View'
      object Size1: TMenuItem
        Caption = 'Size'
        object Small1: TMenuItem
          AutoCheck = True
          Caption = 'Small'
          RadioItem = True
          OnClick = Small1Click
        end
        object Medium1: TMenuItem
          AutoCheck = True
          Caption = 'Medium'
          Default = True
          RadioItem = True
          OnClick = Medium1Click
        end
        object Larg1: TMenuItem
          AutoCheck = True
          Caption = 'Larg'
          RadioItem = True
          OnClick = Larg1Click
        end
      end
      object Alwaysontop1: TMenuItem
        AutoCheck = True
        Caption = 'Always on top'
        Checked = True
        OnClick = Alwaysontop1Click
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
  end
end
