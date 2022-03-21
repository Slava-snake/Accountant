unit PrihNak;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls;

type
  TForm3 = class(TForm)
    save: TButton;
    Cancel: TButton;
    Label1: TLabel;
    DTp: TDateTimePicker;
    Num: TLabel;
    PA: TComboBox;
    PG: TStringGrid;
    procedure NumClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrihNakl: TForm3;

implementation

{$R *.dfm}


end.
