object Form1: TForm1
  Left = 291
  Top = 113
  AutoScroll = False
  Caption = #1050#1072#1089#1089#1072
  ClientHeight = 329
  ClientWidth = 725
  Color = clBtnFace
  Constraints.MinHeight = 375
  Constraints.MinWidth = 733
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    725
    329)
  PixelsPerInch = 96
  TextHeight = 13
  object summashow: TLabel
    Left = 616
    Top = 152
    Width = 105
    Height = 33
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 640
    Top = 224
    Width = 65
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = #1073#1077#1079#1085#1072#1083#1080#1095#1085#1072#1103
    Enabled = False
  end
  object Label3: TLabel
    Left = 640
    Top = 184
    Width = 47
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = #1085#1072#1083#1080#1095#1085#1072#1103
    Enabled = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 310
    Width = 725
    Height = 19
    Color = clMaroon
    Panels = <>
  end
  object NewCheque: TButton
    Left = 640
    Top = 0
    Width = 83
    Height = 41
    Cursor = crHandPoint
    Anchors = [akTop, akRight]
    Caption = #1085#1086#1074#1099#1081' '#1095#1077#1082
    Enabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Georgia'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    WordWrap = True
    OnClick = NewChequeClick
  end
  object ListCheqPos: TListBox
    Left = 0
    Top = 0
    Width = 593
    Height = 283
    AutoComplete = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    Items.Strings = (
      '* No opened cheque *')
    MultiSelect = True
    ParentFont = False
    TabOrder = 1
    OnDblClick = ListCheqPosDblClick
    OnKeyDown = ListCheqPosKeyDown
    OnMouseDown = ListCheqPosMouseDown
  end
  object CheqList: TTabControl
    Left = 0
    Top = 283
    Width = 593
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    TabPosition = tpBottom
    OnChange = CheqListChange
  end
  object PayBut: TButton
    Left = 640
    Top = 266
    Width = 83
    Height = 41
    Anchors = [akRight, akBottom]
    Caption = #1086#1087#1083#1072#1090#1072
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = PayButClick
  end
  object EditNal: TEdit
    Left = 640
    Top = 200
    Width = 81
    Height = 24
    Anchors = [akRight, akBottom]
    AutoSize = False
    BiDiMode = bdRightToLeft
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 4
    OnExit = EditNalExit
    OnKeyPress = EditNalKeyPress
  end
  object EditBez: TEdit
    Left = 640
    Top = 240
    Width = 81
    Height = 24
    Anchors = [akRight, akBottom]
    AutoSize = False
    BiDiMode = bdRightToLeft
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 5
    OnExit = EditBezExit
    OnKeyPress = EditBezKeyPress
  end
  object AnnuBut: TButton
    Left = 648
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1072#1085#1085#1091#1083#1080#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 6
    OnClick = AnnuButClick
  end
  object btMore: TButton
    Left = 600
    Top = 200
    Width = 33
    Height = 105
    Anchors = [akRight, akBottom]
    Caption = #1045#1065#1025
    Enabled = False
    TabOrder = 7
    OnClick = btMoreClick
  end
  object MainMenu1: TMainMenu
    Left = 696
    Top = 48
    object N1: TMenuItem
      Caption = #1050#1072#1089#1089#1072' '
      object N2: TMenuItem
        Caption = #1086#1090#1082#1088#1099#1090#1100
        OnClick = N2Click
      end
      object X1: TMenuItem
        Caption = #1079#1072#1082#1088#1099#1090#1100
        Enabled = False
        OnClick = X1Click
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object N3: TMenuItem
        Caption = #1074#1099#1093#1086#1076
        OnClick = N3Click
      end
    end
    object N4: TMenuItem
      Caption = #1076#1077#1081#1089#1090#1074#1080#1077
      Enabled = False
      object N5: TMenuItem
        Caption = #1074#1085#1086#1089' '#1076#1077#1085#1077#1075
      end
      object Xreport: TMenuItem
        Caption = 'X '#1086#1090#1095#1105#1090
        OnClick = XreportClick
      end
      object Zreport: TMenuItem
        Caption = 'Z '#1086#1090#1095#1105#1090
        OnClick = ZreportClick
      end
      object N6: TMenuItem
        Caption = #1074#1099#1085#1086#1089' '#1076#1077#1085#1077#1075
      end
    end
    object N7: TMenuItem
      Caption = #1074#1086#1079#1074#1088#1072#1090
      Enabled = False
    end
  end
end
