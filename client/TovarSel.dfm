object TovarSelect: TTovarSelect
  Left = 133
  Top = 86
  Width = 696
  Height = 80
  Caption = 'TovarSelect'
  Color = clBtnFace
  Constraints.MinHeight = 80
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    688
    53)
  PixelsPerInch = 96
  TextHeight = 13
  object TG: TStringGrid
    Left = 0
    Top = 0
    Width = 687
    Height = 72
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 6
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
    OnKeyPress = TGKeyPress
    ColWidths = (
      54
      81
      72
      112
      91
      267)
  end
end
