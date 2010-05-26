object BrowseRoomsForm: TBrowseRoomsForm
  Left = 221
  Top = 169
  ActiveControl = Button1
  BorderStyle = bsDialog
  Caption = 'Browse Rooms'
  ClientHeight = 418
  ClientWidth = 707
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 707
    Height = 418
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 418
    ClientAreaWidth = 707
    TabOrder = 0
    object RoomListLBL: TLabel
      Left = 216
      Top = 8
      Width = 47
      Height = 13
      Caption = 'Room List'
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 133
      Height = 13
      Caption = 'Categories / Sub Categories'
      Transparent = True
    end
    object RoomList: TListView
      Left = 216
      Top = 24
      Width = 481
      Height = 329
      Columns = <
        item
          Caption = 'R'
          Width = 23
        end
        item
          Caption = 'L'
          Width = 0
        end
        item
          Caption = 'RoomName'
          Width = 375
        end
        item
          Caption = 'Members'
          Width = 60
        end>
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      PopupMenu = BrowseRoomPOPUPMenu
      SmallImages = ImageList1
      SortType = stData
      TabOrder = 0
      ViewStyle = vsReport
      OnCompare = RoomListCompare
      OnCustomDrawItem = RoomListCustomDrawItem
    end
    object Button1: TButton
      Left = 216
      Top = 384
      Width = 75
      Height = 25
      Caption = 'Join'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 624
      Top = 384
      Width = 75
      Height = 25
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 2
      OnClick = Button2Click
    end
    object ShowAR: TCheckBox
      Left = 216
      Top = 360
      Width = 177
      Height = 17
      Caption = 'Show adult and restricted rooms'
      Color = 15913653
      ParentColor = False
      TabOrder = 3
      OnClick = ShowARClick
    end
    object CategoryTree: TTreeView
      Left = 8
      Top = 24
      Width = 201
      Height = 385
      HideSelection = False
      HotTrack = True
      Indent = 19
      ReadOnly = True
      TabOrder = 4
      OnClick = CategoryTreeClick
    end
    object RefreshBtn: TButton
      Left = 296
      Top = 384
      Width = 75
      Height = 25
      Caption = 'Refresh'
      TabOrder = 5
      OnClick = RefreshBtnClick
    end
  end
  object ImageList1: TImageList
    Left = 512
    Top = 376
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008248BE008D36B800EC05F1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008248BE008A37B700E906EF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF003D82D80058BBF5001222BB000102FB000000FF000000FF000000
      FF000000FF00000000000000000000000000000000000000000000000000BF00
      0000BF0000005B81AF005EBDF10075273800B9030400BF000000BF000000BF00
      0000BF0000000000000000000000000000000000000000000000000000001672
      B1001A74B1001A74B0001876B3001777B300137AB6000D7CBA000A7CBA00077A
      B8000279BA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF004646
      FF004646FF003843C20053AEEB004EA7EF003551C5004243F1004646FF004646
      FF004646FF000000FF0000000000000000000000000000000000BF000000FF00
      0000FF000000B41318005EA0D10056AAE90083365800EC010200FF000000FF00
      0000FF000000BF00000000000000000000000000000000000000D4E8F6000000
      00000000000085BFE50048A2DA00389FD800249DD7001CA1DA0015A2DA000DA1
      D900059BD900018ED00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF004646
      FF005B5BFF005959F8004550C3003F9AE4003AAAF4003259B200565BF2005B5B
      FF004646FF004646FF000000FF000000000000000000BF000000FF000000FF00
      0000FF595900F8585800BC4E53004F91CB003CAEF6006C5C7900E65A5D00FF59
      5900FF000000FF000000BF0000000000000000000000198AD500000000006BB3
      E40091C8EB000000000000000000DFF1FA004CB5E40024ADE2001CB0E30013B0
      E3000AACE200049BD9000276B800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF000000000000000000FE00FE00434EC400358BDC002B9EF6007665E200A248
      D5004F6DBA003F5DC1000A14D7000000000000000000BF000000FF000000FF59
      5900FF595900FF595900FF595900BC4D53004982C0002C9FFB006D84B0009B78
      89008A7484008B465B0093161E000000000000000000228ED70000000000A3D0
      EE0048A2DE008EC6EB00B8DDF30000000000C5E7F7002BB1E40021B3E40018B4
      E5000EB0E30008A0DA00057BBA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF00424CC500347BD4004BB6F40062CB
      EC0070E5FF0068D1FB002854BA00C20BCC0000000000BF000000FF0000000000
      00000000000000000000FF595900FF595900BB4B54005562CD004DB8F60064CD
      EE006EE4FF0068D3FC005C597A00BC0DC900000000002C94D90074B8E6000000
      0000B4D9F1004CA5DF0046A5DF0000000000CEEAF80064C5EA0052C2EA001BB1
      E40014ADE2000FA1DA000B7DBB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF008B3DB80068D1FF0071F0
      FF006CD7F3004468BC001228B8007F4CC10000000000BF000000FF000000FF59
      590000000000FF595900FF595900FF595900FF5959009060700068D0FF0071EF
      FF0075D6EC00953F4700791E2B007E50C300000000003598DA004BA3DE0083BF
      E90000000000B0D7F10049A5DF008BC9EB00F8FCFE000000000000000000CAEC
      F80043BAE70018A0D900127FBB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000000000000000000000000000004F6ABD006CD7FF0065C0
      E6005A75C7004545FB000000EC00797BD30000000000BF000000FF000000FF59
      5900FF595900000000000000000000000000000000009440BC006ED8FF0072B9
      D300AC6E7200FD000000B20000007A7DD400000000003F9DDC0053A7E00056A9
      E00086C1E90000000000AAD4F00041A3DE005BB4E50041AEE20055B9E6000000
      0000E3F3FB0039A8DD00187EB900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF009432BD005FBDF200486B
      BB005B5BFF004546FA000D1BBB00886BCA0000000000BF000000FF000000FF59
      5900FF59590000000000FF595900FF595900FF595900992ABD0063B6E7008567
      7A00FF595900F60202007B242B008A68C8000000000045A0DE005AAAE1005CAA
      E10057A8E10094C8EB00000000005EAFE200369FDD002C9EDD00249DDD002EA3
      DE00000000008CC9E9001D7DB800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF00C909D1004266BB004158
      B8004D50D8003745BA003B6FC300B120C30000000000BF000000FF000000FF59
      5900FF595900FF59590000000000FF59590000000000D24E5100815D7500885A
      6D00BE4E50009C252B006E6A7A00BA18C700000000004FA5DF0063AFE30061AD
      E20059A9E1007AB9E700000000004EA4DF00369ADB0046A5E00062B3E4002496
      DA00A1D2EF00BFDFF200217CB700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF0000000000494ECE004971
      C20059A4DA00558FCF001829C100FC00FC0000000000BF000000FF000000FF59
      5900FF595900FF59590000000000FF59590000000000FF595900C74C50008170
      880079A3BA00867D8B00862A2F00FC00FC000000000053A7E0006CB4E50068B2
      E4005EABE10080BDE800000000005AAAE1003A9ADB009ECEEE00F8FCFE003B9E
      DC00B2D9F200B7DAF000237CB700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF005B5B
      FF0000000000000000000000000000000000000000005B5BFF005B5BFF005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      5900FF595900FF595900FF59590000000000FF595900FF595900FF595900FF59
      5900FF595900FF000000BF00000000000000000000005EACE2007ABCE70070B6
      E50063AEE30066AFE300E4F1FA00C1DFF300459EDD003E9BDC0051A6DF0067B2
      E400FDFEFF0075B7E300237BB600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF004646FF004646
      FF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5B
      FF004646FF004646FF000000FF000000000000000000BF000000FF000000FF00
      0000FF595900FF5959000000000000000000FF595900FF595900FF595900FF59
      5900FF000000FF000000BF00000000000000000000006BB4E5008DC5EA0080BF
      E8006FB6E50067B1E30091C6EB00F9FCFE00DDEDF90096C9EC00AED5F0000000
      0000B1D7F1003596D5001E78B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF004646
      FF004646FF004646FF004646FF004646FF004646FF004646FF004646FF004646
      FF004646FF000000FF0000000000000000000000000000000000BF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BF000000000000000000000000000000000000009DCDEE008CC5
      EA0079BBE70070B6E5006AB2E40087C1E900C3E0F400EBF5FB00D4E9F70093C8
      EC0045A0DE002F92D30000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00000000000000000000000000000000000000000000000000BF00
      0000BF000000BF000000BF000000BF000000BF000000BF000000BF000000BF00
      0000BF00000000000000000000000000000000000000000000000000000067B1
      E4005BAAE10054A7E0004FA5DF004AA2DE004BA3DE0046A1DE003F9DDC003B9B
      DC003196D9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008248BE007D41B200D60DE2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000062
      0000006200000062000000620000006200000062000000620000006200000062
      0000006200000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00000000000000000000000000000000000000000000000000BF00
      0000BF000000BF000000BF000000BF000000BF000000BF000000BF000000BF00
      0000BF0000000000000000000000000000000000000000000000000000000062
      0000006200003D91B00059BEF2001F655500025F060000620000006200000062
      0000006200000000000000000000000000000000000000000000006200000080
      0000008000000080000000800000008000000080000000800000008000000080
      00000080000000620000000000000000000000000000000000000000FF004646
      FF004646FF004646FF004646FF004646FF004646FF004646FF004646FF004646
      FF004646FF000000FF0000000000000000000000000000000000BF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BF00000000000000000000000000000000000000006200000080
      0000008000000B691E003D96A60054B8F5001C716B0001750400008000000080
      0000008000000062000000000000000000000000000000620000008000000080
      000000B3000000B3000000B3000000B3000000B3000000B3000000B3000000B3
      000000800000008000000062000000000000000000000000FF004646FF004646
      FF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5B
      FF004646FF004646FF000000FF000000000000000000BF000000FF000000FF00
      0000FF595900FF595900FF595900FF595900FF595900FF595900FF595900FF59
      5900FF000000FF000000BF000000000000000000000000620000008000000080
      000000B3000001AE010006940F002E94A2003DB3FF00137F620004A40E0000B3
      00000080000000800000006200000000000000000000006200000080000000B3
      000000B3000000B300000000000000000000000000000000000000B3000000B3
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF000000000000000000000000005B5BFF005B5BFF005B5BFF00000000000000
      00005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      5900FF595900FF595900FF595900FF595900FF595900FF595900FF595900FF59
      5900FF595900FF000000BF0000000000000000000000006200000080000000B3
      000000B3000000B3000000000000C10BCE00526CCE002FA4FF001F9D910020A3
      5300258C49001C7346000A5E1C000000000000000000006200000080000000B3
      000000B300000000000000B3000000B3000000B3000000B300000000000000B3
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF005B5BFF00000000005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF0000000000
      00000000000000000000FF595900FF595900FF59590000000000000000000000
      0000FF595900FF000000BF0000000000000000000000006200000080000000B3
      000000B300000000000000B3000000B30000048D13001F84980045B4F8005DC5
      E10071E3FF0069D3FE00296F7300C808D00000000000006200000080000000B3
      00000000000000B3000000B3000000B3000000B3000000B300000000000000B3
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF00000000005B5BFF005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      590000000000FF595900FF595900FF595900FF595900FF59590000000000FF59
      5900FF595900FF000000BF0000000000000000000000006200000080000000B3
      00000000000000B3000000B3000000B3000000B3000012842D0068CCFF006EEB
      FF006CE2FA00328B6C00165D41008049C00000000000006200000080000000B3
      00000000000000B3000000B30000000000000000000000000000000000000000
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000000000000000000000000000005B5BFF005B5BFF005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      5900FF5959000000000000000000000000000000000000000000FF595900FF59
      5900FF595900FF000000BF0000000000000000000000006200000080000000B3
      00000000000000B3000000B300000000000000000000A725BD0070D5FF006CC5
      F1003EA66D00027A0300005E00007979D30000000000006200000080000000B3
      00000000000000B3000000B3000000B3000000B3000000B3000000B3000000B3
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF00000000005B5BFF005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      5900FF59590000000000FF595900FF595900FF59590000000000FF595900FF59
      5900FF595900FF000000BF0000000000000000000000006200000080000000B3
      00000000000000B3000000B3000000B3000000B30000108827005CC0EA003697
      820001AC01000080000008541400866ECB0000000000006200000080000000B3
      00000000000000B3000000B3000000B3000000B3000000B3000000B3000000B3
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF00000000005B5BFF005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      5900FF595900FF59590000000000FF59590000000000FF595900FF595900FF59
      5900FF595900FF000000BF0000000000000000000000006200000080000000B3
      00000000000000B3000000B3000000B3000000B3000004980A00248568001C83
      4F0001A50200076910003C8A8400AA29C00000000000006200000080000000B3
      000000B300000000000000B3000000B3000000B30000000000000000000000B3
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF005B5BFF00000000005B5BFF005B5BFF005B5BFF00000000005B5BFF005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      5900FF595900FF59590000000000FF59590000000000FF595900FF595900FF59
      5900FF595900FF000000BF0000000000000000000000006200000080000000B3
      000000B300000000000000B3000000B3000000B3000000000000D405D800268C
      610046B1A60043A18E001A643300FC00FC0000000000006200000080000000B3
      000000B3000000B3000000000000000000000000000000B300000000000000B3
      000000B30000008000000062000000000000000000000000FF004646FF005B5B
      FF0000000000000000000000000000000000000000005B5BFF005B5BFF005B5B
      FF005B5BFF004646FF000000FF000000000000000000BF000000FF000000FF59
      5900FF595900FF595900FF59590000000000FF595900FF595900FF595900FF59
      5900FF595900FF000000BF0000000000000000000000006200000080000000B3
      000000B3000000B3000000000000000000000000000000B300000000000000B3
      000000B300000080000000620000000000000000000000620000008000000080
      000000B3000000B3000000B3000000B3000000B3000000B3000000B3000000B3
      000000800000008000000062000000000000000000000000FF004646FF004646
      FF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5BFF005B5B
      FF004646FF004646FF000000FF000000000000000000BF000000FF000000FF00
      0000FF595900FF5959000000000000000000FF595900FF595900FF595900FF59
      5900FF000000FF000000BF000000000000000000000000620000008000000080
      000000B3000000B3000000B3000000B3000000B3000000B3000000B3000000B3
      0000008000000080000000620000000000000000000000000000006200000080
      0000008000000080000000800000008000000080000000800000008000000080
      00000080000000620000000000000000000000000000000000000000FF004646
      FF004646FF004646FF004646FF004646FF004646FF004646FF004646FF004646
      FF004646FF000000FF0000000000000000000000000000000000BF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BF00000000000000000000000000000000000000006200000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000062000000000000000000000000000000000000000000000062
      0000006200000062000000620000006200000062000000620000006200000062
      0000006200000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00000000000000000000000000000000000000000000000000BF00
      0000BF000000BF000000BF000000BF000000BF000000BF000000BF000000BF00
      0000BF0000000000000000000000000000000000000000000000000000000062
      0000006200000062000000620000006200000062000000620000006200000062
      0000006200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00F8FFF8FFFFFF0000E007E007E0070000
      C003C003D803000080018001A60100008C018001A101000084009C0091010000
      8400880088610000878087808411000084008400820900008400828082010000
      84408280820100008F818101800100008001830180110000C003C003C0030000
      E007E007E0070000FFFFFFFFFFFF0000FFFFFFFFFFFFF8FFE007E007E007E007
      C003C003C003C003800180018001800183C18E3180018201842184219C718400
      882184418821880089F1878187C1898088018441844188008801844182818800
      846184418281844083A18F81810183A18001800183018001C003C003C003C003
      E007E007E007E007FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object BrowseRoomPOPUPMenu: TTBXPopupMenu
    Left = 472
    Top = 376
    object TBXItem1: TTBXItem
      Caption = 'Join Room'
      OnClick = RoomListDblClick
    end
    object TBXItem2: TTBXItem
      Caption = 'Join As Admin'
      Visible = False
    end
    object TBXItem3: TTBXItem
      Caption = 'Add To Favorites'
      OnClick = TBXItem3Click
    end
    object pmCloseRoom: TTBXItem
      Caption = 'Close The Room'
      Visible = False
      OnClick = pmCloseRoomClick
    end
  end
end
