object Form1: TForm1
  Left = 366
  Top = 97
  AutoScroll = False
  Caption = 'Server'
  ClientHeight = 348
  ClientWidth = 650
  Color = clMaroon
  Constraints.MinHeight = 256
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnResize = FormResize
  DesignSize = (
    650
    348)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 0
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    BiDiMode = bdRightToLeft
    Caption = #1079#1072#1087#1091#1089#1082
    ParentBiDiMode = False
    TabOrder = 1
    OnClick = Button1Click
    OnEnter = Button1Enter
    OnExit = Button1Exit
  end
  object BG: TStringGrid
    Left = 0
    Top = 0
    Width = 649
    Height = 281
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSelect]
    TabOrder = 0
    OnDblClick = BGDblClick
    OnDrawCell = BGDrawCell
    OnEnter = BGEnter
    OnExit = BGExit
    OnKeyDown = BGKeyDown
    OnKeyPress = BGKeyPress
    ColWidths = (
      64
      615)
  end
  object Button2: TButton
    Left = 256
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = #1089#1086#1079#1076#1072#1090#1100
    TabOrder = 2
    OnClick = Button2Click
    OnEnter = Button2Enter
    OnExit = Button2Exit
  end
  object Button3: TButton
    Left = 573
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 3
    OnClick = Button3Click
    OnEnter = Button3Enter
    OnExit = Button3Exit
  end
  object PageCtrl1: TPageControl
    Left = 0
    Top = 0
    Width = 651
    Height = 313
    ActivePage = TabSheet8
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    TabPosition = tpBottom
    Visible = False
    OnChange = PageCtrl1Change
    object TabSheet1: TTabSheet
      Caption = #1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
      DesignSize = (
        643
        280)
      object SG: TStringGrid
        Left = 0
        Top = 24
        Width = 643
        Height = 254
        Anchors = [akLeft, akTop, akRight, akBottom]
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnDblClick = SGDblClick
        ColWidths = (
          60
          116
          64
          72
          320)
        RowHeights = (
          24)
      end
      object actBut: TButton
        Left = 0
        Top = 0
        Width = 97
        Height = 23
        Cursor = crHandPoint
        Caption = 'dis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = actButClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1087#1088#1080#1093#1086#1076
      ImageIndex = 1
      DesignSize = (
        643
        280)
      object PG: TStringGrid
        Left = 0
        Top = 32
        Width = 641
        Height = 241
        Anchors = [akLeft, akTop, akRight, akBottom]
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        TabOrder = 0
        ColWidths = (
          68
          92
          60
          92
          144)
      end
      object RadioGroup1: TRadioGroup
        Left = 0
        Top = 0
        Width = 433
        Height = 30
        Columns = 5
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          #1085#1086#1084#1077#1088
          #1080#1079#1084#1077#1085#1077#1085)
        ParentFont = False
        TabOrder = 1
        OnClick = RadioGroup1Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1088#1072#1089#1093#1086#1076
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = #1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 3
    end
    object TabSheet5: TTabSheet
      Caption = #1090#1086#1074#1072#1088
      ImageIndex = 4
      DesignSize = (
        643
        280)
      object TG: TStringGrid
        Left = 0
        Top = 24
        Width = 641
        Height = 257
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 6
        RowCount = 2
        TabOrder = 0
        ColWidths = (
          64
          81
          77
          101
          90
          218)
      end
    end
    object TabSheet6: TTabSheet
      Caption = #1082#1072#1088#1090#1086#1095#1082#1080
      ImageIndex = 5
    end
    object TabSheet7: TTabSheet
      Caption = #1082#1083#1080#1077#1085#1090#1099
      ImageIndex = 6
      DesignSize = (
        643
        280)
      object CLlist: TStringGrid
        Left = 3
        Top = 24
        Width = 638
        Height = 249
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 4
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        ScrollBars = ssVertical
        TabOrder = 0
        OnKeyPress = CLlistKeyPress
        ColWidths = (
          32
          99
          200
          283)
      end
      object AddClientButton: TButton
        Left = 8
        Top = 1
        Width = 75
        Height = 22
        Caption = '+'
        TabOrder = 1
        OnClick = AddClientButtonClick
      end
      object EditClientButton: TButton
        Left = 560
        Top = 1
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '<>'
        TabOrder = 2
        OnClick = EditClientButtonClick
      end
    end
    object TabSheet8: TTabSheet
      Caption = #1082#1072#1090#1072#1083#1086#1075
      ImageIndex = 7
      DesignSize = (
        643
        280)
      object CatMat: TTreeView
        Left = 0
        Top = 0
        Width = 449
        Height = 281
        Anchors = [akLeft, akTop, akRight, akBottom]
        Indent = 19
        TabOrder = 2
      end
      object CatSize: TTreeView
        Left = 0
        Top = 0
        Width = 449
        Height = 281
        Anchors = [akLeft, akTop, akRight, akBottom]
        Indent = 19
        TabOrder = 3
      end
      object CatAgent: TTreeView
        Left = 0
        Top = 0
        Width = 449
        Height = 281
        Anchors = [akLeft, akTop, akRight, akBottom]
        Indent = 19
        TabOrder = 4
      end
      object CatFirm: TTreeView
        Left = 0
        Top = 0
        Width = 449
        Height = 281
        Anchors = [akLeft, akTop, akRight, akBottom]
        Indent = 19
        TabOrder = 5
      end
      object CatTip: TTreeView
        Left = 0
        Top = 0
        Width = 449
        Height = 281
        Anchors = [akLeft, akTop, akRight, akBottom]
        Indent = 19
        TabOrder = 0
      end
      object CatGroup: TRadioGroup
        Left = 456
        Top = 0
        Width = 185
        Height = 273
        Anchors = [akTop, akRight, akBottom]
        Caption = #1082#1072#1090#1072#1083#1086#1075
        Color = clSkyBlue
        ItemIndex = 0
        Items.Strings = (
          #1090#1080#1087
          #1084#1072#1090#1077#1088#1080#1072#1083
          #1092#1080#1088#1084#1072
          #1088#1072#1079#1084#1077#1088
          #1072#1075#1077#1085#1090)
        ParentColor = False
        TabOrder = 1
        OnClick = CatGroupClick
      end
    end
  end
  object TCPserv: TIdTCPServer
    Bindings = <
      item
        IP = '0.0.0.0'
        Port = 0
      end
      item
        IP = '127.0.0.1'
        Port = 0
      end>
    CommandHandlers = <>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = TCPservConnect
    OnExecute = TCPservExecute
    OnDisconnect = TCPservDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    ReuseSocket = rsTrue
    Left = 168
    Top = 304
  end
  object TCPrun: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    BoundIP = '127.0.0.1'
    BoundPort = 8887
    Host = '127.0.0.1'
    Port = 0
    Left = 56
    Top = 296
  end
  object PopupMenu1: TPopupMenu
    Left = 16
    Top = 288
    object N1: TMenuItem
      Caption = #1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    end
    object N2: TMenuItem
      Caption = #1086#1090#1082#1083#1102#1095#1080#1090#1100
      OnClick = N2Click
    end
  end
end
