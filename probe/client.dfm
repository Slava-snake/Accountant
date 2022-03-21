object Form1: TForm1
  Left = 196
  Top = 109
  Width = 770
  Height = 455
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
    428)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 24
    Width = 761
    Height = 385
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
    Height = 409
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
        370)
      object PG: TStringGrid
        Left = 0
        Top = 32
        Width = 753
        Height = 337
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        ParentFont = False
        TabOrder = 0
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
        Date = 43307.965359328700000000
        Format = 'yyyy.MM.dd'
        Time = 43307.965359328700000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object PD1: TCheckBox
        Left = 104
        Top = 8
        Width = 17
        Height = 17
        TabOrder = 2
      end
      object Pdp2: TDateTimePicker
        Left = 120
        Top = 0
        Width = 105
        Height = 28
        Date = 43307.968584699080000000
        Format = 'yyyy.MM.dd'
        Time = 43307.968584699080000000
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Visible = False
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
        TabOrder = 4
      end
      object Pa1: TCheckBox
        Left = 736
        Top = 8
        Width = 17
        Height = 17
        Anchors = [akTop, akRight]
        TabOrder = 5
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
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
    end
    object TabSheet5: TTabSheet
      Caption = 'TabSheet5'
      ImageIndex = 4
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
    Top = 409
    Width = 762
    Height = 19
    Color = clMaroon
    Panels = <>
    SimplePanel = True
  end
  object TCPc: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = TCPcDisconnected
    Host = 'localhost'
    OnConnected = TCPcConnected
    Port = 0
    Left = 672
  end
end
