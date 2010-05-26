object OfflinesForm: TOfflinesForm
  Left = 286
  Top = 184
  Caption = 'Offline Messages'
  ClientHeight = 246
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 463
    Height = 246
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 246
    ClientAreaWidth = 463
    TabOrder = 0
    ExplicitHeight = 239
    DesignSize = (
      463
      246)
    object Panel1: TPanel
      Left = 5
      Top = 152
      Width = 452
      Height = 79
      Anchors = [akLeft, akRight, akBottom]
      BorderStyle = bsSingle
      TabOrder = 0
      object Viewer: THTMLViewer
        Left = 1
        Top = 1
        Width = 446
        Height = 73
        OnHotSpotClick = ViewerHotSpotClick
        OnImageRequest = ViewerImageRequest
        TabOrder = 0
        Align = alClient
        PopupMenu = ViewerPOPUP
        DefBackground = clWindow
        BorderStyle = htNone
        HistoryMaxCount = 0
        DefFontName = 'Arial'
        DefPreFontName = 'Arial'
        NoSelect = False
        ScrollBars = ssVertical
        CharSet = DEFAULT_CHARSET
        MarginHeight = 1
        MarginWidth = 3
        PrintMarginLeft = 2.000000000000000000
        PrintMarginRight = 2.000000000000000000
        PrintMarginTop = 2.000000000000000000
        PrintMarginBottom = 2.000000000000000000
        PrintScale = 1.000000000000000000
      end
    end
    object OfflineListView: TListView
      Left = 6
      Top = 8
      Width = 449
      Height = 129
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Sender'
          Width = 80
        end
        item
          Caption = 'Time'
          Width = 145
        end
        item
          AutoSize = True
          Caption = 'Message'
          MinWidth = 175
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
      OnClick = OfflineListViewClick
      OnDblClick = OfflineListViewDblClick
      OnSelectItem = OfflineListViewSelectItem
    end
  end
  object ViewerPOPUP: TTBXPopupMenu
    Left = 166
    Top = 98
    object Copy2: TTBXItem
      Caption = 'Copy'
      ImageIndex = 2
      OnClick = Copy2Click
    end
    object ClearScreen1: TTBXItem
      Caption = 'Clear Screen'
      ImageIndex = 0
    end
  end
end
