object Form1: TForm1
  Left = 182
  Top = 115
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
  object Button4: TButton
    Left = 464
    Top = 320
    Width = 75
    Height = 25
    Caption = 'saveDB'
    TabOrder = 5
  end
  object PageCtrl1: TPageControl
    Left = 0
    Top = 0
    Width = 0
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
    OnResize = PageCtrl1Resize
    object TabSheet1: TTabSheet
      Caption = #1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
      DesignSize = (
        0
        280)
      object ConnG: TStringGrid
        Left = 0
        Top = 24
        Width = 643
        Height = 254
        Anchors = [akLeft, akTop, akRight, akBottom]
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnDblClick = ConnGDblClick
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
        0
        280)
      object PG: TStringGrid
        Left = 0
        Top = 32
        Width = 641
        Height = 241
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 6
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        ColWidths = (
          68
          92
          60
          92
          160
          64)
      end
      object Pgroup: TRadioGroup
        Left = 0
        Top = 0
        Width = 433
        Height = 30
        Anchors = [akLeft, akTop, akRight]
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
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1088#1072#1089#1093#1086#1076
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = #1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 3
      DesignSize = (
        0
        280)
      object SG: TStringGrid
        Left = 0
        Top = 32
        Width = 641
        Height = 241
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 10
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        ColWidths = (
          64
          20
          70
          70
          70
          70
          80
          160
          88
          32)
      end
      object Sgroup: TRadioGroup
        Left = 0
        Top = 0
        Width = 433
        Height = 30
        Anchors = [akLeft, akTop, akRight]
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
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1090#1086#1074#1072#1088
      ImageIndex = 4
      DesignSize = (
        0
        280)
      object TG: TStringGrid
        Left = 0
        Top = 24
        Width = 641
        Height = 257
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 6
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
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
      DesignSize = (
        0
        280)
      object CG: TStringGrid
        Left = 0
        Top = 32
        Width = 645
        Height = 241
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 8
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        ColWidths = (
          50
          40
          40
          50
          80
          50
          40
          283)
      end
      object Cgroup: TRadioGroup
        Left = 0
        Top = 0
        Width = 644
        Height = 30
        Anchors = [akLeft, akTop, akRight]
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
      end
    end
    object TabSheet7: TTabSheet
      Caption = #1082#1083#1080#1077#1085#1090#1099
      ImageIndex = 6
      DesignSize = (
        0
        280)
      object CLlist: TStringGrid
        Left = 0
        Top = 24
        Width = 638
        Height = 249
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 4
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        OnKeyPress = CLlistKeyPress
        ColWidths = (
          32
          99
          200
          298)
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
        0
        280)
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
        TabOrder = 0
        OnClick = CatGroupClick
      end
    end
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
  object Button1: TButton
    Left = 5
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
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect]
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
    Left = 512
    Top = 320
  end
  object TCPrun: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    BoundIP = '127.0.0.1'
    BoundPort = 8887
    Host = '127.0.0.1'
    Port = 0
    Left = 544
    Top = 320
  end
  object PopupMenu1: TPopupMenu
    Left = 80
    Top = 320
    object N1: TMenuItem
      Caption = #1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    end
    object N2: TMenuItem
      Caption = #1086#1090#1082#1083#1102#1095#1080#1090#1100
      OnClick = DisconnectClient
    end
  end
  object CatMenu: TPopupMenu
    Left = 480
    Top = 320
    object N3: TMenuItem
      Caption = #1087#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #1091#1076#1072#1083#1080#1090#1100' '#1075#1088#1091#1087#1087#1091
    end
    object N5: TMenuItem
      Caption = #1076#1086#1073#1072#1074#1080#1090#1100' '#1075#1088#1091#1087#1087#1091
      OnClick = N5Click
    end
    object N6: TMenuItem
      Caption = #1076#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087
      OnClick = N6Click
    end
    object N7: TMenuItem
      Caption = #1087#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100
    end
  end
end
