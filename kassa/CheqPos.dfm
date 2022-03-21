object ChequePosition: TChequePosition
  Left = 405
  Top = 344
  Width = 619
  Height = 185
  Caption = #1087#1086#1079#1080#1094#1080#1103' '#1074' '#1095#1077#1082#1077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 0
    Width = 17
    Height = 13
    Caption = #1090#1080#1087
    Enabled = False
  end
  object Label2: TLabel
    Left = 272
    Top = 0
    Width = 49
    Height = 13
    Caption = #1084#1072#1090#1077#1088#1080#1072#1083
    Enabled = False
  end
  object Label3: TLabel
    Left = 416
    Top = 0
    Width = 34
    Height = 13
    Caption = #1092#1080#1088#1084#1072
    Enabled = False
  end
  object Label4: TLabel
    Left = 128
    Top = 40
    Width = 40
    Height = 13
    Caption = #1072#1088#1090#1080#1082#1091#1083
    Enabled = False
  end
  object Label5: TLabel
    Left = 248
    Top = 40
    Width = 48
    Height = 13
    Caption = #1086#1087#1080#1089#1072#1085#1080#1077
    Enabled = False
  end
  object Label6: TLabel
    Left = 128
    Top = 120
    Width = 44
    Height = 13
    Caption = #1082#1072#1088#1090'-'#1082#1086#1076
    Enabled = False
  end
  object Label7: TLabel
    Left = 128
    Top = 80
    Width = 50
    Height = 13
    Caption = #1090#1086#1074#1072#1088'-'#1082#1086#1076
    Enabled = False
  end
  object Label8: TLabel
    Left = 256
    Top = 80
    Width = 38
    Height = 13
    Caption = #1088#1072#1079#1084#1077#1088
    Enabled = False
  end
  object cbTip: TComboBox
    Left = 128
    Top = 16
    Width = 145
    Height = 21
    Color = clMoneyGreen
    Enabled = False
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbTipChange
    OnKeyPress = cbTipKeyPress
  end
  object cbMat: TComboBox
    Left = 272
    Top = 16
    Width = 145
    Height = 21
    Color = clMoneyGreen
    Enabled = False
    ItemHeight = 13
    TabOrder = 2
    OnChange = cbMatChange
    OnKeyPress = cbMatKeyPress
  end
  object cbFirm: TComboBox
    Left = 416
    Top = 16
    Width = 145
    Height = 21
    Color = clMoneyGreen
    Enabled = False
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbFirmChange
    OnKeyPress = cbFirmKeyPress
  end
  object edArt: TEdit
    Left = 128
    Top = 56
    Width = 121
    Height = 21
    Color = clMoneyGreen
    Enabled = False
    TabOrder = 4
    OnChange = edArtChange
    OnKeyPress = edArtKeyPress
  end
  object edOpis: TEdit
    Left = 248
    Top = 56
    Width = 313
    Height = 21
    Color = clMoneyGreen
    Enabled = False
    TabOrder = 5
    OnChange = edOpisChange
    OnKeyPress = edOpisKeyPress
  end
  object edCart: TEdit
    Left = 128
    Top = 136
    Width = 121
    Height = 21
    Color = clAqua
    Enabled = False
    TabOrder = 6
    OnExit = edCartExit
    OnKeyPress = edCartKeyPress
  end
  object edTovar: TEdit
    Left = 128
    Top = 96
    Width = 121
    Height = 21
    Color = clAqua
    Enabled = False
    TabOrder = 7
    OnEnter = edTovarEnter
    OnExit = edTovarExit
    OnKeyPress = edTovarKeyPress
  end
  object cbSize: TComboBox
    Left = 256
    Top = 96
    Width = 81
    Height = 21
    Color = clMoneyGreen
    Enabled = False
    ItemHeight = 13
    TabOrder = 8
    OnChange = cbSizeChange
    OnEnter = cbSizeEnter
    OnExit = cbSizeExit
    OnKeyPress = cbSizeKeyPress
  end
  object Animate1: TAnimate
    Left = 0
    Top = 96
    Width = 121
    Height = 57
    Cursor = crHourGlass
    Color = clBlack
    ParentColor = False
    Visible = False
  end
  object edKol: TLabeledEdit
    Left = 344
    Top = 128
    Width = 89
    Height = 28
    EditLabel.Width = 89
    EditLabel.Height = 20
    EditLabel.Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086
    EditLabel.Color = clBtnFace
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentColor = False
    EditLabel.ParentFont = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnEnter = edKolEnter
    OnExit = edKolExit
    OnKeyPress = edKolKeyPress
  end
  object edPrice: TLabeledEdit
    Left = 440
    Top = 128
    Width = 97
    Height = 28
    EditLabel.Width = 36
    EditLabel.Height = 20
    EditLabel.Caption = #1094#1077#1085#1072
    EditLabel.Color = clBtnFace
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentColor = False
    EditLabel.ParentFont = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnEnter = edPriceEnter
    OnExit = edPriceExit
    OnKeyPress = edPriceKeyPress
  end
  object btNext: TButton
    Left = 544
    Top = 84
    Width = 67
    Height = 73
    Caption = 'NEXT'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    WordWrap = True
    OnClick = btNextClick
    OnEnter = btNextEnter
    OnExit = btNextExit
  end
  object rg: TRadioGroup
    Left = 0
    Top = 0
    Width = 121
    Height = 89
    Caption = #1090#1080#1087' '#1074#1074#1086#1076#1072
    Items.Strings = (
      'Scan Barcode'
      #1074#1074#1086#1076' '#1082#1086#1076#1072
      #1086#1087#1080#1089#1072#1085#1080#1077)
    TabOrder = 0
    TabStop = True
    OnClick = rgClick
    OnEnter = rgEnter
  end
  object FreshBut: TButton
    Left = 592
    Top = 0
    Width = 17
    Height = 17
    Caption = 'F'
    TabOrder = 13
    OnClick = FreshButClick
  end
  object EnterSum: TCheckBox
    Left = 448
    Top = 88
    Width = 81
    Height = 17
    Caption = #1074#1074#1086#1076' '#1089#1091#1084#1084#1099
    TabOrder = 14
    OnClick = EnterSumClick
  end
end
