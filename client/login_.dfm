object Login: TLogin
  Left = 591
  Top = 278
  Width = 433
  Height = 170
  Caption = 'Login'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 24
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 72
    Height = 24
    Caption = 'Login     '
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 92
    Height = 24
    Caption = 'Password  '
  end
  object LogEdit: TEdit
    Left = 104
    Top = 24
    Width = 313
    Height = 32
    TabOrder = 0
    OnKeyPress = LogEditKeyPress
  end
  object PasEdit: TEdit
    Left = 104
    Top = 56
    Width = 313
    Height = 32
    TabOrder = 1
    OnEnter = PasEditEnter
    OnKeyPress = PasEditKeyPress
  end
  object ButEnter: TButton
    Left = 8
    Top = 104
    Width = 153
    Height = 33
    Caption = 'Enter'
    TabOrder = 2
    OnClick = ButEnterClick
  end
  object ButCancel: TButton
    Left = 264
    Top = 104
    Width = 153
    Height = 33
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = ButCancelClick
  end
end
