object c1: Tc1
  Left = 605
  Top = 68
  Width = 419
  Height = 157
  Caption = 'BD connect'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    411
    130)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 48
    Width = 345
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 41
    Height = 20
    Caption = ' client'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 0
    Top = 24
    Width = 409
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 0
    Top = 48
    Width = 57
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    OnKeyPress = Edit2KeyPress
  end
  object conn: TButton
    Left = 0
    Top = 72
    Width = 409
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'connect'
    TabOrder = 3
    OnClick = connClick
  end
  object Save: TButton
    Left = 0
    Top = 104
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save'
    ModalResult = 1
    TabOrder = 4
    OnClick = SaveClick
  end
  object Cancel: TButton
    Left = 336
    Top = 104
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
    OnClick = CancelClick
  end
  object Edit3: TEdit
    Left = 48
    Top = 0
    Width = 361
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'client0'
    OnKeyPress = Edit3KeyPress
  end
  object TCPc: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = TCPcDisconnected
    Host = 'localhost'
    OnConnected = TCPcConnected
    Port = 0
    Left = 80
    Top = 104
  end
end
