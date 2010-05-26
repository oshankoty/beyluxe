object RegisterFrm: TRegisterFrm
  Left = 291
  Top = 224
  BorderStyle = bsDialog
  Caption = 'Register'
  ClientHeight = 314
  ClientWidth = 679
  Color = clBtnFace
  Constraints.MinHeight = 314
  Constraints.MinWidth = 588
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TBXToolWindow1: TTBXToolWindow
    Left = 0
    Top = 0
    Width = 679
    Height = 314
    Align = alClient
    Caption = 'TBXToolWindow1'
    ClientAreaHeight = 314
    ClientAreaWidth = 679
    TabOrder = 0
    object NameLabel: TLabel
      Left = 11
      Top = 30
      Width = 28
      Height = 13
      Caption = 'Name'
      Transparent = True
    end
    object LastNameLabel: TLabel
      Left = 11
      Top = 62
      Width = 48
      Height = 13
      Caption = 'LastName'
      Transparent = True
    end
    object Label3: TLabel
      Left = 11
      Top = 94
      Width = 35
      Height = 13
      Caption = 'Gender'
      Transparent = True
    end
    object EmailLabel: TLabel
      Left = 386
      Top = 30
      Width = 25
      Height = 13
      Caption = 'Email'
      Transparent = True
    end
    object AgeLabel: TLabel
      Left = 386
      Top = 94
      Width = 19
      Height = 13
      Caption = 'Age'
      Transparent = True
    end
    object LocationLabel: TLabel
      Left = 386
      Top = 126
      Width = 41
      Height = 13
      Caption = 'Location'
      Transparent = True
    end
    object NickNameLabel: TLabel
      Left = 11
      Top = 126
      Width = 51
      Height = 13
      Caption = 'Nick name'
      Transparent = True
    end
    object Password1Label: TLabel
      Left = 11
      Top = 162
      Width = 46
      Height = 13
      Caption = 'Password'
      Transparent = True
    end
    object password2Label: TLabel
      Left = 11
      Top = 190
      Width = 83
      Height = 13
      Caption = 'Confirm password'
      Transparent = True
    end
    object Label10: TLabel
      Left = 11
      Top = 222
      Width = 76
      Height = 13
      Caption = 'Secret Question'
      Transparent = True
    end
    object SecretAnswerLabel: TLabel
      Left = 11
      Top = 254
      Width = 69
      Height = 13
      Caption = 'Secret Answer'
      Transparent = True
    end
    object ConfirmEmailLabel: TLabel
      Left = 386
      Top = 62
      Width = 63
      Height = 13
      Caption = 'Confirm Email'
      Transparent = True
    end
    object TopLabel: TLabel
      Left = 8
      Top = 7
      Width = 213
      Height = 13
      Caption = 'Please fill this form to create account'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object CancelBtn: TButton
      Left = 184
      Top = 280
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 13
    end
    object RegisterButton: TButton
      Left = 432
      Top = 280
      Width = 75
      Height = 25
      Caption = 'Register'
      TabOrder = 12
      OnClick = RegisterButtonClick
    end
    object NameEdit: TEdit
      Left = 99
      Top = 26
      Width = 121
      Height = 21
      MaxLength = 23
      TabOrder = 0
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
    end
    object LastNameEdit: TEdit
      Left = 99
      Top = 58
      Width = 121
      Height = 21
      MaxLength = 23
      TabOrder = 1
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
    end
    object GenderCombo: TComboBox
      Left = 99
      Top = 90
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 2
      Text = 'Not Specified'
      Items.Strings = (
        'Not Specified'
        'Male'
        'Female')
    end
    object EmailEdit: TEdit
      Left = 458
      Top = 26
      Width = 177
      Height = 21
      TabOrder = 8
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
    end
    object AgeEdit: TEdit
      Left = 458
      Top = 90
      Width = 177
      Height = 21
      MaxLength = 3
      TabOrder = 10
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
      OnKeyPress = AgeEditKeyPress
    end
    object CountryCombo: TComboBox
      Left = 458
      Top = 122
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 11
      Items.Strings = (
        'Afghanistan                   '
        'Agalega & St. Brandon Islands '
        'Aland Island                  '
        'Alaska                        '
        'Albania                       '
        'Algeria                       '
        'American Samoa                '
        'Amsterdam & St. Paul Island   '
        'Andaman & Nicobar Islands     '
        'Andorra                       '
        'Angola                        '
        'Anguilla                      '
        'Annobon                       '
        'Antarctica                    '
        'Antigua & Barbuda             '
        'Argentina                     '
        'Armenia                       '
        'Aruba                         '
        'Ascension Island              '
        'Asiatic Russia             '
        'Auckland & Campbell Islands   '
        'Austral Islands               '
        'Australia                     '
        'Austria                       '
        'Aves Island                   '
        'Azerbaijan                    '
        'Azores                        '
        'Bahamas                       '
        'Bahrain                       '
        'Baker, Howland Islands        '
        'Balearic Island              '
        'Banaba (Ocean Island)         '
        'Bangladesh                    '
        'Barbados                      '
        'Belarus                       '
        'Belgium                       '
        'Belize                        '
        'Benin                         '
        'Bermuda                       '
        'Bhutan                        '
        'Bolivia                       '
        'Bosnia-Herzegovina            '
        'Botswana                      '
        'Bouvet Island                 '
        'Brazil                        '
        'British Virgin Islands        '
        'Brunei Darussalam             '
        'Bulgaria                      '
        'Burkina Faso                  '
        'Burundi                       '
        'Kiribati (Br Phoenix)      '
        'Cambodia                        '
        'Cameroon                      '
        'Canada                        '
        'Canary Island                '
        'Cape Verde Island             '
        'Cayman Island                 '
        'Central Africa                '
        'Ceuta & Melilla              '
        'Chad                          '
        'Chagos Island                 '
        'Chatham Island                '
        'Chesterfield Islands          '
        'Chile                         '
        'China                         '
        'Christmas Island              '
        'Clipperton Island             '
        'Cocos Island                  '
        'Cocos-Keeling Island          '
        'Colombia                      '
        'Comoros                       '
        'Congo                         '
        'Conway Reef                   '
        'Corsica                       '
        'Costa Rica                    '
        'Crete                         '
        'Croatia                       '
        'Crozet Island                 '
        'Cuba                          '
        'Cyprus                        '
        'Cyprus, British Bases         '
        'Czech Republic                '
        'Dem. Rep. of Congo              '
        'Denmark                       '
        'Desecheo Island               '
        'Djibouti                      '
        'Dodecanese                    '
        'Dominica                      '
        'Dominican Republic            '
        'Ducie Island                  '
        'E. Kiribati (Line Islands)    '
        'East Malaysia                 '
        'East Timor                    '
        'Easter Island                 '
        'Ecuador                       '
        'Egypt                         '
        'El Salvador                   '
        'England                       '
        'Equatorial Guinea             '
        'Eritrea                       '
        'Estonia                       '
        'Ethiopia                      '
        'European Russia           '
        'Falkland Islands              '
        'Faroe Islands                 '
        'Fernando de Noronha           '
        'Fiji Islands                  '
        'Finland                       '
        'France                        '
        'Franz Josef Land              '
        'French Guiana                 '
        'French Indo-China             '
        'French Polynesia              '
        'Gabon                         '
        'Galapagos Islands             '
        'Georgia                       '
        'Germany                       '
        'Ghana                         '
        'Gibraltar                     '
        'Glorioso Island               '
        'Greece                        '
        'Greenland                     '
        'Grenada                       '
        'Guadeloupe                    '
        'Guam                          '
        'Guantanamo Bay                '
        'Guatemala                     '
        'Guernsey                      '
        'Guinea                        '
        'Guinea-Bissau                 '
        'Guyana                        '
        'Haiti                         '
        'Hawaii                        '
        'Heard Island                  '
        'Honduras                      '
        'Hong Kong                     '
        'Hungary                       '
        'ITU Geneva Switzerland        '
        'Iceland                       '
        'Ifni                          '
        'India                         '
        'Indonesia                     '
        'Iran                          '
        'Iraq                          '
        'Ireland                       '
        'Isle of Man                   '
        'Israel                        '
        'Italy                         '
        'Ivory Coast                   '
        'Jamaica                       '
        'Jan Mayen                     '
        'Japan                         '
        'Jersey                        '
        'Johnston Island               '
        'Jordan                        '
        'Juan Fernandez Island         '
        'Juan de Nova, Europa          '
        'Kaliningrad                   '
        'Kazakhstan                    '
        'Kenya                         '
        'Kerguelen Island              '
        'Kermadec Island               '
        'Kingman Reef                  '
        'Kirghizia                     '
        'Kure Island                   '
        'Kuwait                        '
        'Lakshadweep Islands           '
        'Laos                          '
        'Latvia                        '
        'Lebanon                       '
        'Lesotho                       '
        'Liberia                       '
        'Libya                         '
        'Liechtenstein                 '
        'Lithuania                     '
        'Lord Howe Island              '
        'Luxembourg                    '
        'Macao                         '
        'Macedonia                     '
        'Macquarie Island              '
        'Madagascar                    '
        'Madeira Island                '
        'Malawi                        '
        'Maldive Islands               '
        'Mali                          '
        'Malpelo Island                '
        'Malta                         '
        'Malyj Vysotskij Island        '
        'Mariana Islands               '
        'Market Reef                   '
        'Marquesas Islands             '
        'Marshall Islands              '
        'Martinique                    '
        'Mauritania                    '
        'Mauritius Island              '
        'Mayotte Island                '
        'Mellish Reef                  '
        'Mexico                        '
        'Micronesia                    '
        'Midway Island                 '
        'Minami Torishima              '
        'Moldavia                      '
        'Monaco                        '
        'Mongolia                      '
        'Montenegro                      '
        'Montserrat                    '
        'Morocco                       '
        'Mount Athos                   '
        'Mozambique                    '
        'Myanmar                       '
        'Namibia                       '
        'Nauru                         '
        'Navassa Island                '
        'Nepal                         '
        'Bonaire, Curacao              '
        'Netherlands                   '
        'New Caledonia                 '
        'New Zealand                   '
        'Nicaragua                     '
        'Niger                         '
        'Nigeria                       '
        'Niue                          '
        'Norfolk Island                '
        'North Cook Islands            '
        'DPR of Korea                  '
        'Northern Ireland              '
        'Norway                        '
        'Ogasawara                     '
        'Oman                          '
        'Pakistan                      '
        'Palau                            '
        'Palestine                     '
        'Palmyra, Jarvis Islands       '
        'Panama                        '
        'Papua New Guinea              '
        'Paraguay                      '
        'Peru                          '
        'Peter 1st Island              '
        'Philippines                   '
        'Pitcairn Island               '
        'Poland                        '
        'Portugal                      '
        'Pratas Isl.                   '
        'Prince Edward & Marion Islands '
        'Puerto Rico                   '
        'Qatar                         '
        'Republic of Korea              '
        'Republic of South Africa      '
        'Reunion Island                '
        'RevillaGigedo                '
        'Rodrigues Island              '
        'Romania                       '
        'Rotuma                        '
        'Rwanda                        '
        'Sable Island                  '
        'Saint Martin Island           '
        'San Andreas & Providencia     '
        'San Felix Island              '
        'San Marino                    '
        'Sao Tome & Principe           '
        'Sardinia                      '
        'Saudi Arabia                  '
        'Scarborough Reef              '
        'Scotland                      '
        'Senegal                       '
        'Serbia                         '
        'Seychelles Islands            '
        'Sierra Leone                  '
        'Singapore                     '
        'Slovak Republic               '
        'Slovenia                      '
        'Solomon Islands               '
        'Somalia                       '
        'South Cook Islands            '
        'South Georgia Islands         '
        'South Orkney Islands          '
        'South Sandwich Islands        '
        'South Shetland Islands        '
        'Sov Military Order of Malta   '
        'Spain'
        'Spratly Is.                    '
        'Sri Lanka (Ceylon)            '
        'St. Kitts & Nevis             '
        'St. Helena                    '
        'St. Lucia                     '
        'St. Maarten, St.Eustatius     '
        'St. Paul Island               '
        'St. Pierre & Miquelon         '
        'St. Vincent                   '
        'St.Peter & St.Paul Rocks      '
        'Sudan                         '
        'Suriname                      '
        'Svalbard                      '
        'Swains Island                 '
        'Swaziland                     '
        'Sweden                        '
        'Switzerland                   '
        'Syria                         '
        'Tadzhikistan                  '
        'Taiwan (Formosa)              '
        'Tanzania                      '
        'Temotu Province               '
        'Thailand                      '
        'The Gambia                      '
        'Togo                          '
        'Tokelau Islands               '
        'Tonga                         '
        'Trindad & Tobago              '
        'Trinidade & Martin Vaz        '
        'Tristan da Cunha & Gough      '
        'Tromelin Island               '
        'Tunisia                       '
        'Turkey                        '
        'Turkmenistan                  '
        'Turks & Caicos Islands        '
        'Tuvalu                        '
        'U.S. Virgin Islands           '
        'Uganda                        '
        'Ukraine                   '
        'United Arab Emirates          '
        'United Nations, Headquarters  '
        'AK United States of America   '
        'Uruguay                       '
        'Uzbekistan                    '
        'Vanuatu                       '
        'Vatican City                  '
        'Venezuela                     '
        'Vietnam                       '
        'W. Kiribati (Gilbert Islands) '
        'Wake Island                   '
        'Wales                         '
        'Wallis & Futuna Islands       '
        'West Malaysia                 '
        'Western Sahara                '
        'Samoa                         '
        'Willis Island                 '
        'Yemen                         '
        'Zambia                        '
        'Zimbabwe')
    end
    object NickNameEdit: TEdit
      Left = 99
      Top = 122
      Width = 121
      Height = 21
      MaxLength = 31
      TabOrder = 3
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
      OnKeyPress = NickNameEditKeyPress
    end
    object Password1Edit: TEdit
      Left = 99
      Top = 154
      Width = 177
      Height = 21
      MaxLength = 31
      PasswordChar = '*'
      TabOrder = 4
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
    end
    object Password2Edit: TEdit
      Left = 99
      Top = 186
      Width = 177
      Height = 21
      MaxLength = 31
      PasswordChar = '*'
      TabOrder = 5
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
    end
    object SecretQuestionCombo: TComboBox
      Left = 99
      Top = 218
      Width = 273
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 6
      Text = 'What was the name of your first school?'
      Items.Strings = (
        'What is your father'#39's middle name?'
        'What was the name of your first school?'
        'Who was your childhood hero?'
        'What is your favorite pastime?'
        'What was your high school mascot?'
        'What make was your first car or bike?'
        'Where did you first meet your spouse?'
        'What is your pet'#39's name?'
        'What is the name of street where you grew up?'
        'What is the name of your favorite restaurant?'
        'What is the name of your favorite cartoon character?'
        'What is the name of your favorite fictional character?'
        'What is the title of your favorite book?'
        'Where did you go on your first date?'
        'What is the your best friends last name?'
        'What is the your dream occupation?')
    end
    object SecretAnswerEdit: TEdit
      Left = 99
      Top = 250
      Width = 137
      Height = 21
      MaxLength = 31
      TabOrder = 7
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
    end
    object ConfirmEmailEdit: TEdit
      Left = 458
      Top = 58
      Width = 177
      Height = 21
      TabOrder = 9
      OnContextPopup = NameEditContextPopup
      OnKeyDown = EditBoxKeyDown
    end
  end
end
