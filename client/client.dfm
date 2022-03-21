object Form1: TForm1
  Left = 228
  Top = 81
  Width = 770
  Height = 466
  Caption = 'client -> '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    762
    439)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 24
    Width = 761
    Height = 396
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'ACCOUNTANT'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -91
    Font.Name = 'Arial Black'
    Font.Style = [fsBold, fsItalic, fsUnderline]
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 761
    Height = 420
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    HotTrack = True
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = #1087#1088#1080#1093#1086#1076
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsItalic]
      ParentFont = False
      DesignSize = (
        753
        381)
      object PG: TStringGrid
        Left = 0
        Top = 32
        Width = 753
        Height = 348
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 4
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking]
        ParentFont = False
        TabOrder = 5
        OnDblClick = PGDblClick
        OnDrawCell = PGDrawCell
        OnKeyDown = PGKeyDown
        OnKeyPress = PGKeyPress
        OnMouseDown = PGMouseDown
        ColWidths = (
          69
          64
          82
          527)
      end
      object Pdp1: TDateTimePicker
        Left = 0
        Top = 0
        Width = 105
        Height = 28
        Date = 36526.965359328700000000
        Format = 'yyyy.MM.dd'
        Time = 36526.965359328700000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnKeyPress = Pdp1KeyPress
      end
      object PD1: TCheckBox
        Left = 104
        Top = 8
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = PD1Click
        OnKeyPress = PD1KeyPress
      end
      object Pdp2: TDateTimePicker
        Left = 120
        Top = 0
        Width = 105
        Height = 28
        Date = 43307.968584699080000000
        Format = 'yyyy.MM.dd'
        Time = 43307.968584699080000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Visible = False
        OnKeyPress = Pdp2KeyPress
      end
      object PA: TComboBox
        Left = 224
        Top = 0
        Width = 513
        Height = 28
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 20
        ParentFont = False
        TabOrder = 3
        OnEnter = PAEnter
        OnKeyPress = PAKeyPress
      end
      object Pa1: TCheckBox
        Left = 736
        Top = 8
        Width = 17
        Height = 17
        Anchors = [akTop, akRight]
        TabOrder = 4
        OnKeyPress = Pa1KeyPress
      end
      object Pcreat: TButton
        Left = 120
        Top = 0
        Width = 102
        Height = 28
        Caption = #1057#1086#1079#1076#1072#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = PcreatClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1088#1072#1089#1093#1086#1076
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = #1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = #1085#1072#1083#1080#1095#1080#1077
      ImageIndex = 3
      DesignSize = (
        753
        381)
      object Label2: TLabel
        Left = 480
        Top = 16
        Width = 69
        Height = 20
        Caption = #1072#1088#1090#1080#1082#1091#1083
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 480
        Top = 72
        Width = 80
        Height = 20
        Caption = #1086#1087#1080#1089#1072#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 158
        Height = 380
        Anchors = [akLeft, akTop, akBottom]
        Caption = #1090#1080#1087
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          158
          380)
        object cbTip: TComboBox
          Left = 4
          Top = 22
          Width = 150
          Height = 28
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 0
          OnKeyPress = cbTipKeyPress
        end
        object bTip: TButton
          Left = 4
          Top = 53
          Width = 150
          Height = 25
          Caption = #1075#1088#1091#1087#1087#1072
          TabOrder = 1
          OnClick = bTipClick
        end
        object MemTip: TListBox
          Left = 4
          Top = 81
          Width = 150
          Height = 295
          Anchors = [akLeft, akTop, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 2
          OnKeyDown = MemTipKeyDown
        end
      end
      object GroupBox2: TGroupBox
        Left = 160
        Top = 0
        Width = 158
        Height = 380
        Anchors = [akLeft, akTop, akBottom]
        Caption = #1084#1072#1090#1077#1088#1080#1072#1083
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        DesignSize = (
          158
          380)
        object cbMat: TComboBox
          Left = 4
          Top = 22
          Width = 150
          Height = 28
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 0
          OnKeyPress = cbMatKeyPress
        end
        object bMat: TButton
          Left = 4
          Top = 53
          Width = 150
          Height = 25
          Caption = #1075#1088#1091#1087#1087#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bMatClick
        end
        object MemMat: TListBox
          Left = 4
          Top = 81
          Width = 150
          Height = 295
          Anchors = [akLeft, akTop, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 2
          OnKeyDown = MemMatKeyDown
        end
      end
      object GroupBox3: TGroupBox
        Left = 320
        Top = 0
        Width = 158
        Height = 380
        Anchors = [akLeft, akTop, akBottom]
        Caption = #1073#1088#1101#1085#1076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        DesignSize = (
          158
          380)
        object cbFirm: TComboBox
          Left = 4
          Top = 22
          Width = 150
          Height = 28
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 0
          OnKeyPress = cbFirmKeyPress
        end
        object bFirm: TButton
          Left = 4
          Top = 53
          Width = 150
          Height = 25
          Caption = #1075#1088#1091#1087#1087#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = bFirmClick
        end
        object MemFirm: TListBox
          Left = 4
          Top = 81
          Width = 150
          Height = 295
          Anchors = [akLeft, akTop, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 2
          OnKeyDown = MemFirmKeyDown
        end
      end
      object GroupBox4: TGroupBox
        Left = 480
        Top = 135
        Width = 158
        Height = 245
        Anchors = [akLeft, akTop, akBottom]
        Caption = #1088#1072#1079#1084#1077#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        DesignSize = (
          158
          245)
        object cbSize: TComboBox
          Left = 4
          Top = 22
          Width = 150
          Height = 28
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 0
          OnKeyPress = cbSizeKeyPress
        end
        object bSize: TButton
          Left = 4
          Top = 53
          Width = 150
          Height = 25
          Caption = #1075#1088#1091#1087#1087#1072
          TabOrder = 1
          OnClick = bSizeClick
        end
        object MemSize: TListBox
          Left = 4
          Top = 81
          Width = 150
          Height = 160
          Anchors = [akLeft, akTop, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 2
          OnKeyDown = MemSizeKeyDown
        end
      end
      object edArt: TEdit
        Left = 480
        Top = 40
        Width = 273
        Height = 28
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object edOpis: TEdit
        Left = 480
        Top = 96
        Width = 273
        Height = 28
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object bFind: TButton
        Left = 648
        Top = 144
        Width = 91
        Height = 225
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #1085#1072#1081#1090#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 6
        WordWrap = True
        OnClick = bFindClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'TabSheet5'
      ImageIndex = 4
      object Button2: TButton
        Left = 672
        Top = 0
        Width = 75
        Height = 25
        Caption = #1075#1088#1091#1087#1087#1099
        TabOrder = 0
        OnClick = Button2Click
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'TabSheet6'
      ImageIndex = 5
    end
  end
  object Button1: TButton
    Left = 736
    Top = 0
    Width = 25
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'O'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 420
    Width = 762
    Height = 19
    Color = clMaroon
    Panels = <>
    SimplePanel = True
  end
end
