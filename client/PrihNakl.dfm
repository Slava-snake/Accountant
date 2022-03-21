object Form3: TForm3
  Left = 76
  Top = 102
  Width = 945
  Height = 372
  Caption = #1087#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    937
    345)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 0
    Width = 484
    Height = 24
    Caption = 
      #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' '#8470'                                           ' +
      '   '#1086#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object Num: TLabel
    Left = 243
    Top = 0
    Width = 105
    Height = 25
    AutoSize = False
    Caption = '000000000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = NumClick
  end
  object save: TButton
    Left = 0
    Top = 320
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 0
  end
  object Cancel: TButton
    Left = 856
    Top = 320
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
  end
  object DTp: TDateTimePicker
    Left = 352
    Top = 0
    Width = 105
    Height = 28
    Date = 43308.900780162040000000
    Time = 43308.900780162040000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object PA: TComboBox
    Left = 496
    Top = 0
    Width = 441
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 20
    ParentFont = False
    TabOrder = 3
  end
  object PG: TStringGrid
    Left = 0
    Top = 32
    Width = 937
    Height = 281
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 8
    DefaultColWidth = 36
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    ColWidths = (
      36
      49
      387
      63
      41
      88
      105
      154)
  end
end
