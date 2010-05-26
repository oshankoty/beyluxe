object PMWindow: TPMWindow
  Left = 226
  Top = 148
  Caption = 'PMWindow'
  ClientHeight = 319
  ClientWidth = 440
  Color = clBtnFace
  Constraints.MinHeight = 346
  Constraints.MinWidth = 448
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 440
    Height = 303
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Menubar: TTBToolbar
      Left = 0
      Top = 0
      Width = 440
      Height = 19
      Align = alTop
      Caption = 'TBXToolbar1'
      CloseButton = False
      FullSize = True
      MenuBar = True
      ProcessShortCuts = True
      ShrinkMode = tbsmWrap
      TabOrder = 0
      object mClose: TTBXSubmenuItem
        Caption = '&File'
        object New1: TTBXItem
          Caption = 'New'
        end
        object Print1: TTBXItem
          Caption = 'Print'
        end
        object Exit1: TTBXItem
          Caption = 'Close'
        end
      end
      object Edit1: TTBXSubmenuItem
        Caption = '&Edit'
        object Cut1: TTBXItem
          Caption = 'Cut'
        end
        object Copy1: TTBXItem
          Caption = 'Copy'
        end
        object Paste1: TTBXItem
          Caption = 'Paste'
        end
        object SelectAll1: TTBXItem
          Caption = 'Select All'
        end
        object Delete1: TTBXItem
          Caption = 'Delete'
        end
      end
      object Option1: TTBXSubmenuItem
        Caption = '&Option'
        object SaveSettingAsDefault: TTBXItem
          Caption = 'Save As Default PM Setting'
          OnClick = SaveSettingAsDefaultClick
        end
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 19
      Width = 440
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object TBXToolWindow1: TTBXToolWindow
        Left = 0
        Top = 0
        Width = 440
        Height = 41
        Align = alClient
        Caption = 'TBXToolWindow1'
        ClientAreaHeight = 41
        ClientAreaWidth = 440
        TabOrder = 0
        object AddButton: TSpeedButton
          Left = 46
          Top = 3
          Width = 36
          Height = 36
          Hint = 'Add Contact'
          Flat = True
          Glyph.Data = {
            FE0A0000424DFE0A00000000000036000000280000001E0000001E0000000100
            180000000000C80A0000120B0000120B00000000000000000000EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8E8
            D8BBCA9143BE7410BD710BBD710CBD710CBD710CBD710CBD710CBD710CBD710C
            BD710CBD710CBD710BBE730FC78A36E6D3B2EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8D2A667BA6E
            08BA6E08BA6E08BA6E08BA6E08BA6E08BA6E08BA6E08BA6E08BA6E08BA6E08BA
            6E08BA6E08BA6E08BA6E08CB974DEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8C9944AB76C07B76C07
            B76C07B76C07B76C07B76C07B76C07B76C07B76C07B76C07B76C07B76C07B76C
            07B76C07B76C07C1832EEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8C48B3EB56A07B56A07B87112BB
            771DBB781EBB771DBB771DBB771DBB771DBB771DBB771DBB771DB97215B56A07
            B56A07BC7A21EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D80000EFE9D8EFE9D8EFE9D8BF8432B26907B26907DDC39AEFE9D8EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8E4D1B1B26A09B26907B7
            7317EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            0000EFE9D8EFE9D8EFE9D8BB8131AE6707AF6809DFC9A4EFE9D8EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8E6D8BCB06A0CAE6707B37117EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9
            D8EFE9D8EFE9D8B97F30AB6406AC6609E0CBA8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D8EFE9D8EFE9D8E7D9BEAD690DAB6406B06D15EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8
            EFE9D8B98339A76206A86408DDC8A4EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D8EFE9D8EFE9D8E5D6BBA9650BA76206AF711EEFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8BD
            8E4DA36006A36006D6BB92EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            EFE9D8EFE9D8DFCDACA46108A36006B37D32EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8C49D66A05E
            06A05E06C5A06AEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8CFB184A05E06A05E06BA8C4CEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8CEB1849B5B059B5B05
            AC7830EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8B485
            439B5B059B5B05C5A26EEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8DCCAAA985A07975905985B07DC
            CBABEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8E3D5BB9A5E0C975905
            975905D6C09CEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D80000EFE9D8EFE9D8EFE9D8EBE3CF975C0E9356059356059F6A21EAE0
            CCEFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EDE6D4A5732F935605935605945808E7
            DCC5C7B494A88B60AF956CA88B60C7B494EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            0000EFE9D8EFE9D8EFE9D8EFE9D8AC80438F54048F54048F54049A641BCDB48C
            E7DCC6EDE5D3E8DEC8D2BD999E6B258F54048F54048F5404A57635EFE9D8B295
            6A8B5F228F64298B5F22B2956AEFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9
            D8EFE9D8EFE9D8EFE9D8E1D4BA8F560B8B51048B51048B51048B5205915A1096
            621B925B128B52058B51048B51048B51048D5408D8C6A8EFE9D8A9834D844C02
            844C02844C02A9834DEFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8C3A77D884F06874E04874E04874E04874E04874E04874E
            04874E04874E04874E04874E04B89768EFE9D8EFE9D8B58D5491530291530291
            5302B58D54EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D8BDA075865008834C03834C03834C03834C03834C03834C03
            834C03854E06AC8042C5A06ABC8F51BC8F51A96E1F9E5B029E5B029E5B02A96E
            1FBC8F51BC8F51C5A06AD5BC94EFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D8EFE9D8D5C5A8976E3382500B7F4B057E4B047F4B05814E09926729CF
            BC9CCA9E61B27017AC6303AC6303AC6303AC6303AC6303AC6303AC6303AC6303
            AC6303B27017CA9E61EFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8BBA07887581A7E4B08855415B29367EFE9D8EFE9D8D5AA
            6DC5822ABB6B03BB6B03BB6B03BB6B03BB6B03BB6B03BB6B03BB6B03BB6B03C5
            822AD5AA6DEFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8ED
            E6D49D7845774603774502774502774502774502936C34E8E0CCDAA762CD7E18
            C97304C97304C97304C97304C97304C97304C97304C97304C97304CD7E18DAA7
            62EFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8A585587343
            02734302734302734302734302734302734302987543E7C695E2B06BDFA352DF
            A352D98921D67A04D67A04D67A04D98921DFA352DFA352E2B06BE7C695EFE9D8
            0000EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8DCCFB7724406704102704102
            704102704102704102704102704102714204CEBDA0EFE9D8EFE9D8EFE9D8E7A9
            55E28104E28104E28104E7A955EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8B198726C3F016C3F016C3F016C3F016C
            3F016C3F016C3F016C3F016C3F01A3865BEFE9D8EFE9D8EFE9D8EEA94FED8705
            ED8705ED8705EEA94FEFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D8A48960693D01693D01693D01693D01693D01693D
            01693D01693D01693D0197784AEFE9D8EFE9D8EFE9D8F3B96CF59A25F59D2CF5
            9A25F3B96CEFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D8C3B193673B01673B01673B01673B01673B01673B01673B01
            673B01673B01B39D7AEFE9D8EFE9D8EFE9D8F3CC95F6B763F5BC6EF6B763F3CC
            95EFE9D8EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D8EAE3D0754F1B643A01643A01643A01643A01643A01643A01643A016E
            4711E2D9C4EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            EFE9D8CCBDA369400B623801623801623801623801623801663D07C1AF91EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8D2C5AD7D5B2B633A04613801623A03785424CABBA0EFE9D8EFE9D8EFE9D8
            EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D80000EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9
            D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EF
            E9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8EFE9D8
            0000}
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
          OnClick = AddButtonClick
        end
        object SpeedButton1: TSpeedButton
          Left = 6
          Top = 3
          Width = 36
          Height = 36
          Flat = True
          Glyph.Data = {
            F6060000424DF606000000000000360000002800000018000000180000000100
            180000000000C0060000C40E0000C40E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAF1F1F1ECECECECECECECEC
            ECECECECECECECECECECECECECF1F1F1FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1F1D4D4D4
            C8C8C8CACACAC8C8C8C5C5C5C8C8C8CDCDCDCFCFCFDBDBDBF3F3F3FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF754719754719754719794C1F754719794C1F754719754719754719E2E2E2
            F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFCFBFAFCFBFAFC2B19F7C4D21B2997F7C4D21B0A090BD
            AD9DC2B19FEAEAEAF9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAECECECDFDFDFDFDFDF7C4D21B299
            7F7C4D21D0D0D0DBDBDBDBDBDBDDDDDDECECECFAFAFAFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAEAEAEA7B4E217E522D
            7E522D784F29916D4B784F297E522D7C4D217C4D21E4E4E4E2E2E2ECECECFAFA
            FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEDECEB7B
            4E21FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7C4D21
            E4E4E4DDDDDDF1F1F1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7B4E21FFFFFFFFFFFFACC7B0176803165D04164B040F3A020C2901A1
            A99BC0C0C0FFFFFF754414D9D9D9ECECECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF7B4E21FFFFFF889E8A176803A3A5A3A3A5A3A3A5
            A3A3A5A3A3A5A30C2901A1A99BCACACA754414D9D9D9ECECECFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7C4D21FFFFFF176803B2B3B3
            C5C6C6E8E8E7FFFFFFE8E8E7C5C6C6ABA9670C2901C5C5C57C4D21D9D9D9ECEC
            ECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7C4D21FF
            FFFF176803B2B3B3527C46E8E8E7164B04E8E8E7527C46ABA9670C2901C5C5C5
            7C4D21D9D9D9ECECECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7C4D21FFFFFF176803527C46C5C6C6164B04FFFFFF164B04C5C6C652
            7C460C2901C5C5C57C4D21D9D9D9ECECECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFAFAFA7D4F23FFFFFF176803B2B3B3527C46E8E8E7164B
            04E8E8E7527C46ABA9670C2901C0C0C07D4F23CFCFCFE2E2E2FAFAFAFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6754414FFFFFF176803527C46
            C5C6C6164B04FFFFFF164B04C5C6C6527C460F3A02BCBCBC754414CFCFCFDDDD
            DDF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF66330066330066
            3300176803B2B3B3527C46E8E8E7164B04E8E8E7527C46ABA967114402663300
            663300663300F1F1F1FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF176803B2B3B3C5C6C6E8E8E7FFFFFFE8E8E7C5C6C6AB
            A967135203C5C5C5ECECECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFCCCA96FFFFFFFFFFFFFFFFFF176803B2B3B3C5C6C6E8E8E7FFFF
            FFE8E8E7C5C6C6ABA967165D04C5C5C5ECECECFFFFFFCCCA96FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFABA967FFFFFFFFFFFFFFFFFFFFFFFF176803B2B3B3
            527C46E8E8E7164B04E8E8E7527C46ABA967165D04C5C5C5ECECECFFFFFFFFFF
            FFABA967FFFFFFFFFFFFFFFFFFFFFFFFABA967FFFFFFFFFFFFCCCA96FFFFFFFF
            FFFF176803527C46C5C6C6164B04FFFFFF164B04C5C6C6527C46165D04C5C5C5
            ECECECCCCA96FFFFFFFFFFFFABA967FFFFFFFFFFFFFFFFFFABA967FFFFFFABA9
            67FFFFFFFFFFFFFFFFFF176803B2B3B3527C46E8E8E7164B04E8E8E7527C46AB
            A967176803CFCFCFF1F1F1FFFFFFABA967FFFFFFABA967FFFFFFFFFFFFFFFFFF
            ABA967FFFFFFABA967FFFFFFFFFFFFFFFFFF176803E8E8E8C5C6C6E8E8E7FFFF
            FFE8E8E7C5C6C6ABA967197104E7E7E7FAFAFAFFFFFFABA967FFFFFFABA967FF
            FFFFFFFFFFFFFFFFABA967FFFFFFFFFFFFCCCA96FFFFFFFBFCFBFFFFFF176803
            FFFFFFFFFFFFFFFFFFFFFFFFE8E8E7176803EAEAEAFAFAFAFFFFFFCCCA96FFFF
            FFFFFFFFABA967FFFFFFFFFFFFFFFFFFFFFFFFABA967FFFFFFFFFFFFFFFFFFFF
            FFFFFDFEFDFFFFFF769C734E774B4E774B4E774B769C73F3F3F3F9F9F9FFFFFF
            FFFFFFFFFFFFFFFFFFABA967FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCA
            96FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCA96FFFFFFFFFFFFFFFFFF}
        end
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 244
      Width = 440
      Height = 59
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object TBXToolWindow3: TTBXToolWindow
        Left = 0
        Top = 0
        Width = 440
        Height = 59
        Align = alClient
        Caption = 'TBXToolWindow3'
        ClientAreaHeight = 59
        ClientAreaWidth = 440
        TabOrder = 0
        DesignSize = (
          440
          59)
        object Button1: TButton
          Left = 369
          Top = 5
          Width = 65
          Height = 49
          Anchors = [akRight, akBottom]
          Caption = 'Send'
          TabOrder = 0
          OnClick = Button1Click
        end
        object InputMemo: TRichEdit
          Left = 5
          Top = 6
          Width = 357
          Height = 48
          Anchors = [akLeft, akTop, akRight]
          BevelInner = bvNone
          BevelOuter = bvNone
          BevelKind = bkFlat
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          PopupMenu = RichEditPOPUP
          TabOrder = 1
          OnChange = InputMemoChange
          OnKeyPress = InputMemoKeyPress
          OnMouseDown = InputMemoMouseDown
        end
      end
    end
    object TextToolbarPanel: TPanel
      Left = 0
      Top = 215
      Width = 440
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object TBXToolWindow2: TTBXToolWindow
        Left = 0
        Top = 0
        Width = 440
        Height = 29
        Align = alClient
        Caption = 'TBXToolWindow2'
        ClientAreaHeight = 29
        ClientAreaWidth = 440
        TabOrder = 0
        DesignSize = (
          440
          29)
        object Label1: TLabel
          Left = 142
          Top = 7
          Width = 20
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Size'
          Transparent = True
        end
        object UnderLineButton: TSpeedButton
          Left = 106
          Top = 3
          Width = 23
          Height = 22
          AllowAllUp = True
          Anchors = [akLeft, akBottom]
          GroupIndex = 3
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Sylfaen'
          Font.Style = [fsBold, fsUnderline]
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000013000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF0000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF846F5B0000000000
            000000000000009D846CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000B2987FFFFFFF
            C7AA8E000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
            FFFFFFFFFFFFFFFFFFFF87705B000000000000AE9175FFFFFFFFFFFFFFFFFFA6
            8A6F0000009D8269FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
            FFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF493D
            32756250FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
            FFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF0000
            00000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000
            000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
            FFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
            FFFFFF000000000000000000000000000000FFFFFFFFFFFFFFFFFF0000000000
            00000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF000000}
          ParentFont = False
          OnClick = UnderLineButtonClick
        end
        object ItalicButton: TSpeedButton
          Left = 82
          Top = 3
          Width = 21
          Height = 22
          AllowAllUp = True
          Anchors = [akLeft, akBottom]
          GroupIndex = 2
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Sylfaen'
          Font.Style = [fsBold, fsItalic]
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000013000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF62524400000000000000
            0000000000DBB897FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBDA187000000000000B298
            7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3AF8D0000000000005B4C3DFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF756250000000000000DBB897FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFBB9D81000000000000A88D74FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFE2BE9C000000000000625244FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF7C6A58000000000000E9C7A6FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFAE91750000000000009D8269FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE2
            BE9C000000000000625244FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7562
            50000000000000E9C7A6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBB9D81000000
            000000E9C7A6E9C7A6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9C7A675625000000000
            0000E9C7A6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7B66520000000000000000000000000000
            00625244FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFF000000}
          ParentFont = False
          OnClick = ItalicButtonClick
        end
        object BoldButton: TSpeedButton
          Left = 58
          Top = 3
          Width = 23
          Height = 22
          AllowAllUp = True
          Anchors = [akLeft, akBottom]
          GroupIndex = 1
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1710618
          Font.Height = -19
          Font.Name = 'Sylfaen'
          Font.Style = [fsBold]
          Glyph.Data = {
            AA030000424DAA03000000000000360000002800000011000000110000000100
            1800000000007403000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF00FFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A
            5B4F44FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
            FFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFF
            FFFFFFFFFFFFFFFF1A1A1A1A1A1A927B65FFFFFFFFFFFFFFFFFFFFFFFF00FFFF
            FFFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFFFFFFFFFF1A1A1A1A
            1A1A1A1A1AFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF1A1A
            1A1A1A1A1A1A1AFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFFFFFF
            FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFF
            FFFFFFFF1A1A1A1A1A1AA68D75FFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
            FFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFFFF1A1A1A1A1A1A776859FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A
            1A1A1A1A1A1A1A1A1A1A1A1ABB9C7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF00FFFFFFFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFF907B671A1A1A
            5B4F44FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
            FFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFFFF1A1A1A1A1A1A716253FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFF
            FFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFF
            FFFFFFFFFFFFFFFFFFFF1A1A1A1A1A1A1A1A1AFFFFFFB098801A1A1A1A1A1A98
            8370FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFF1A1A1A1A1A
            1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A927B65FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF00}
          ParentFont = False
          OnClick = BoldButtonClick
        end
        object SpeedButton4: TSpeedButton
          Left = 32
          Top = 3
          Width = 23
          Height = 22
          Anchors = [akLeft, akBottom]
          Flat = True
          Glyph.Data = {
            D6020000424DD60200000000000036000000280000000F0000000E0000000100
            180000000000A002000000000000000000000000000000000000EBF5F4EBF5F4
            EBF5F4EBF5F4EBF5F46384A5184A7B00396B00396B0031634A6B8CADB5C6EBF5
            F4EBF5F4EBF5F4000000EBF5F4EBF5F4EBF5F4EBF5F4396B94105A8C397B9C52
            63524A5A5242738C18528400315A94A5B5EBF5F4EBF5F4000000EBF5F4EBF5F4
            EBF5F4EBF5F408528C399CCEB5B56BDEBD52946B08738C7B73BDE74284AD0031
            5A8494ADEBF5F4000000EBF5F4EBF5F4EBF5F4EBF5F4296B9C3994C6CECE8CFF
            DE6BC6A5297373525A9CEF63ADE74284AD00315ACECED6000000EBF5F4EBF5F4
            EBF5F4EBF5F44A84AD429CC663BDDE84C6CE7BB5C65263FF4A42FF2939DE4284
            C61042735A7394000000EBF5F4EBF5F4D6DEE784ADC6186BA54294C673CEF75A
            BDE75ABDF78C94FF8484FF3131E71031943173A5214A73000000EBF5F484ADCE
            2984AD217BAD1873AD1873A563B5D67BCEEF5ABDE75A94F7637BFF396BDE52B5
            EF429CCE0031630000006BA5C62184B552A5CE2184B52184B5217BAD6BB5DE8C
            D6F784CEF763BDEF42B5B5219C6342ADC63994C60039630000002184B57BBDDE
            9CD6EF3194BD2184BD429CC69CDEF79CDEF78CD6F76BDEBD52EF5A18A5181094
            39318CBD00396B000000218CBDFFFFFFDEF7FFBDE7FFA5D6EFB5E7FFADE7F7A5
            DEF794DEF75AEF6363F76329AD2939AD9C2173A5315A840000003194BDBDDEEF
            FFFFFFD6EFFFCEEFFFBDEFFF9CCEDE31424A4A636B63B5A55ACE9C63C6DE52B5
            DE08427394A5BD0000009CC6D6399CC6DEEFF7FFFFFFE7F7FFCEEFFFA5C6D66B
            737394949494B5BDCEEFFF84ADCE105284527B9CEBF5F4000000EBF5F49CC6D6
            2994C67BBDDEB5D6E7D6E7F7EFFFFFBDCED6A5BDC69CBDD63173A508528C6B8C
            ADEBF5F4EBF5F4000000EBF5F4EBF5F4CED6DE73ADCE318CBD2184B5217BAD18
            73A5186B9C3173A57394B5CECEDEEBF5F4EBF5F4EBF5F4000000}
          OnClick = SpeedButton4Click
        end
        object SmileButton: TSpeedButton
          Left = 6
          Top = 3
          Width = 23
          Height = 22
          Anchors = [akLeft, akBottom]
          Flat = True
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF3A82AF3A82AF356E9F356E9F3A82AF3A82AFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3D93BF3988B642ACD441C0E941
            D4FC41D4FC41C0E942ACD43988B63D93BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            3D93BF42ACD441D4FC36CEFE2BC4FF2BC4FF2BC4FF2BC4FF36CEFE36CEFE3BA2
            DC3988B6FFFFFFFFFFFFFFFFFF3D93BF42ACD441D4FC36CEFE3BA2DC3A7ACD33
            58BB3358BB3A7ACD3BA2DC2BC4FF36CEFE3BA2DC3D93BFFFFFFFFFFFFF3988B6
            4ADCFE41D4FC3BA2DC3A7ACD42ACD457D3F757D3F742ACD43A7ACD3BA2DC2BC4
            FF41D4FC3988B6FFFFFF3A82AF42ACD441C9FC41ADEE365CCA66CBF26CE8FE6C
            E8FE6CE8FE5EE3FE55C8F8365CCA3C95E437C4FE42ACD43A82AF3A82AF4CCFE9
            57C8FE589AE4589AE478D1FF88EFFF7BEEFF7BEEFF6CE8FE62CCFE3D91E7589A
            E430B0FF41C0E93A82AF356E9F5EE3FE6ED0FF7DC6FF89CAFF90D4FFA8F3FF98
            F3FF88EFFF7BEEFF62CCFE55BFFE47BAFE30B0FF41D4FC356E9F356E9F6CE8FE
            8EE0FF90D4FF7CCCFB86DBFB8EE8FAA8F3FF98F3FF5EE3FE5BD7FE57C8FE57C8
            FE2DBBFF41D4FC356E9F3A82AF6AD6F197EDFFA8F3FF8EE8FAC67B63AAB1AEB8
            F7FF98F3FF92AFB0C67B635EE3FE5EE3FE36CEFE41C0E93A82AF3A82AF62AED8
            97EDFFB8F7FF8EE8FAB59B90AAB1AEB8F7FF98F3FF92AFB0A79A915EE3FE4ADC
            FE41D4FC42ACD43A82AFFFFFFF3A82AF8EE8FAA8F3FFB8F7FF8EE8FA8EE8FAB8
            F7FF98F3FF6CE8FE41D4FC6CE8FE41D4FC41D4FC3988B6FFFFFFFFFFFF3D93BF
            62AED897EDFFA8F3FFB8F7FFB8F7FFA8F3FF88EFFF7BEEFF6CE8FE4ADCFE4ADC
            FE42ACD43D93BFFFFFFFFFFFFFFFFFFF3A82AF62AED88EE8FA97EDFF97EDFF88
            EFFF6CE8FE5EE3FE4ADCFE4ADCFE42ACD43D93BFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF3D93BF3988B642ACD451D3E95EE3FE5EE3FE4CCFE942ACD43988B63D93
            BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3A82AF3A82AF35
            6E9F356E9F3A82AF3A82AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          OnClick = SmileButtonClick
        end
        object BuzzButton: TSpeedButton
          Left = 219
          Top = 4
          Width = 23
          Height = 22
          Anchors = [akLeft, akBottom]
          Flat = True
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF48CB9348CB93FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF48CB93FFFFFFFFFFFFFFFFFF48
            CB9348CB93FFFFFFFFFFFFFFFFFF48CB93FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF04B76B48CB93FFFFFFFFFFFF04B76B0FBA72FFFFFFFFFFFF61D2A248CB
            93FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF04B76B04B76B04B76B04B76B04
            B76B04B76B04B76B04B76B04B76B48CB93FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF04B76B10B8A504B77810B8A316B9B902B77118BAAA04B76BFFFF
            FFFFFFFFFFFFFFFFFFFF48CB9348CB9348CB9348CB9304B76B0FB89F25BAF318
            6DFF186DFF23BAEB14B9B404B76B48CB9348CB9348CB9348CB93FFFFFF48CB93
            09B96E04B76B14B8B417B9BD28BAFF186DFF186DFF28BAFF1AB9C814B8B404B7
            6B04B76B48CB93FFFFFFFFFFFFFFFFFF48CB9304B76B0DB89826BAF528BAFF23
            A2FF25ABFF28BAFF27BAFB11B8A804B76B48CB93FFFFFFFFFFFFFFFFFFFFFFFF
            48CB9304B76B0CB79525BAF328BAFF186DFF186DFF28BAFF27BAFA10B8A304B7
            6B48CB93FFFFFFFFFFFFFFFFFF48CB9304B76B04B76B14B8B31AB9C928BAFF18
            6DFF186DFF28BAFF1CB9D214B8B404B76B04B76B48CB93FFFFFF48CB9348CB93
            48CB9304B76B04B76B0EB89D26BAF6186DFF186DFF24BAEF14B8B21FBF7F48CB
            9348CB9348CB9348CB93FFFFFFFFFFFFFFFFFFFFFFFF04B76B12B8A705B77B18
            6DFF186DFF03B77413B8AF1BBE79FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF04B76B0FBA7248CB9304B7750BB88648CB931CBE7900B66948CB
            93FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF04B76B04B76B04B76BFFFFFF04
            B76B0CB970FFFFFFFFFFFF04B76B04B76BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF04B76BFFFFFFFFFFFFFFFFFF48CB9304B76BFFFFFFFFFFFFFFFFFF48CB
            93FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF48
            CB9304B76BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          OnClick = BuzzButtonClick
        end
        object FontSizeCombo: TComboBox
          Left = 166
          Top = 4
          Width = 41
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akBottom]
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = '1'
          OnChange = FontSizeComboChange
          Items.Strings = (
            '1'
            '2'
            '3')
        end
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 60
      Width = 440
      Height = 155
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 4
      object TBXToolWindow4: TTBXToolWindow
        Left = 0
        Top = 0
        Width = 440
        Height = 155
        Align = alClient
        Caption = 'TBXToolWindow4'
        ClientAreaHeight = 155
        ClientAreaWidth = 440
        TabOrder = 0
        DesignSize = (
          440
          155)
        object Panel1: TPanel
          Left = 3
          Top = 0
          Width = 425
          Height = 144
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          BorderStyle = bsSingle
          TabOrder = 0
          object Viewer: TMemo
            Left = -1
            Top = -1
            Width = 425
            Height = 144
            BevelOuter = bvNone
            BorderStyle = bsNone
            Lines.Strings = (
              'Viewer')
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
    end
  end
  object TBXStatusBar1: TTBXStatusBar
    Left = 0
    Top = 303
    Width = 440
    Height = 16
    Panels = <>
    UseSystemFont = False
  end
  object ViewerPopup: TPopupMenu
    Left = 121
    Top = 105
    object Copy2: TMenuItem
      Caption = 'Copy'
      OnClick = Copy2Click
    end
    object ClearScreen1: TMenuItem
      Caption = 'Clear Screen'
      OnClick = ClearScreen1Click
    end
    object AutoScrollHtml: TMenuItem
      AutoCheck = True
      Caption = 'Auto Scroll'
      Checked = True
    end
  end
  object RichEditPOPUP: TTBXPopupMenu
    Left = 206
    Top = 170
    object mrCopy: TTBXItem
      Caption = 'Copy'
      OnClick = mrCopyClick
    end
    object mrCut: TTBXItem
      Caption = 'Cut'
      OnClick = mrCutClick
    end
    object mrPaste: TTBXItem
      Caption = 'Paste'
      OnClick = mrPasteClick
    end
    object mrDelete: TTBXItem
      Caption = 'Delete'
      OnClick = mrDeleteClick
    end
  end
  object ShakeTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = ShakeTimerTimer
    Left = 152
    Top = 35
  end
  object ColorPOPUP: TPopupMenu
    OwnerDraw = True
    Left = 29
    Top = 148
    object mcBlack: TMenuItem
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcGreen: TMenuItem
      Tag = 1
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcBlue: TMenuItem
      Tag = 2
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcOrange: TMenuItem
      Tag = 3
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcBrown: TMenuItem
      Tag = 4
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcPurple: TMenuItem
      Tag = 5
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcSoorati: TMenuItem
      Tag = 6
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcSkyBlue: TMenuItem
      Tag = 7
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcGray: TMenuItem
      Tag = 8
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object mcOtherColors: TMenuItem
      Tag = 9
      OnClick = mcBlackClick
      OnDrawItem = mcBlackDrawItem
      OnMeasureItem = mcBlackMeasureItem
    end
    object OtherColors1: TMenuItem
      Caption = 'Other Colors ...'
      OnClick = OtherColors1Click
    end
  end
  object ColorDialog1: TColorDialog
    Color = clSilver
    CustomColors.Strings = (
      'ColorA=FFFFFFFF'
      'ColorB=FFFFFFFF'
      'ColorC=FFFFFFFF'
      'ColorD=FFFFFFFF'
      'ColorE=FFFFFFFF'
      'ColorF=FFFFFFFF'
      'ColorG=FFFFFFFF'
      'ColorH=FFFFFFFF'
      'ColorI=FFFFFFFF'
      'ColorJ=FFFFFFFF'
      'ColorK=FFFFFFFF'
      'ColorL=FFFFFFFF'
      'ColorM=FFFFFFFF'
      'ColorN=FFFFFFFF'
      'ColorO=FFFFFFFF'
      'ColorP=FFFFFFFF')
    Left = 28
    Top = 180
  end
end