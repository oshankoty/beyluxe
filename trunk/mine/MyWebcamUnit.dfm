object MyCamForm: TMyCamForm
  Left = 202
  Top = 122
  BorderStyle = bsToolWindow
  Caption = 'My Webcam'
  ClientHeight = 120
  ClientWidth = 160
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object VideoWindow: TVideoWindow
    Left = 0
    Top = 0
    Width = 160
    Height = 120
    FilterGraph = FilterGraph
    VMROptions.Mode = vmrWindowed
    VMROptions.Streams = 1
    VMROptions.KeepAspectRatio = False
    Color = clBlack
    Align = alClient
  end
  object FilterGraph: TFilterGraph
    Mode = gmCapture
    GraphEdit = True
    Left = 120
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object Devices: TMenuItem
      Caption = 'Devices'
    end
    object View1: TMenuItem
      Caption = 'View'
      object Alwaysontop1: TMenuItem
        AutoCheck = True
        Caption = 'Always on top'
        Checked = True
        OnClick = Alwaysontop1Click
      end
      object Size1: TMenuItem
        Caption = 'Size'
        object Small1: TMenuItem
          AutoCheck = True
          Caption = 'Small'
          Checked = True
          Default = True
          RadioItem = True
          OnClick = Small1Click
        end
        object Medium1: TMenuItem
          AutoCheck = True
          Caption = 'Medium'
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
      object Setting1: TMenuItem
        Caption = 'Setting'
        OnClick = Setting1Click
      end
    end
  end
  object Filter: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph
    Left = 88
    Top = 8
  end
  object SampleGrabber: TSampleGrabber
    OnBuffer = SampleGrabberBuffer
    FilterGraph = FilterGraph
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 56
    Top = 8
  end
end
