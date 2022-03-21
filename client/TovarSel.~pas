unit TovarSel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BDconnect, Atypes;

type
  TTovarSelect = class(TForm)
    TG: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure TGKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    TovSel: cardinal;
    procedure FillTable;
    procedure Clear;
    procedure FillPos(i,tov:integer);
    procedure AddPos(tov:integer);
  end;

var
  TovarSelect: TTovarSelect;

implementation

{$R *.dfm}

procedure TTovarSelect.FormCreate(Sender: TObject);
begin
  TG.Cells[0,0]:='код';
  TG.Cells[1,0]:='тип';
  TG.Cells[2,0]:='матер';
  TG.Cells[3,0]:='фирма';
  TG.Cells[4,0]:='артикул';
  TG.Cells[5,0]:='разновидность';
  TovSel:=0;
end;

procedure TTovarSelect.Clear;
var
  i:integer;
begin
  TG.RowCount:=2;
  TG.Rows[1].Clear;
  {for i:=0 to TG.ColCount-1 do TG.Cells[i,1]:=' ';}
end;

procedure TTovarSelect.FillPos(i,tov:integer);
begin
    with T[tov].state do
      begin
        TovarSelect.TG.Cells[0,i]:=inttostr(tov);
        TovarSelect.TG.Cells[1,i]:=Lstat[Tip][rec.tip].rec.pos.nam;
        TovarSelect.TG.Cells[2,i]:=Lstat[Mat][rec.mat].rec.pos.nam;
        TovarSelect.TG.Cells[3,i]:=Lstat[Firm][rec.firm].rec.pos.nam;
        TovarSelect.TG.Cells[4,i]:=rec.art;
        TovarSelect.TG.Cells[5,i]:=rec.opis;
      end;
end;

procedure TTovarSelect.AddPos(tov:integer);
begin
  if TG.RowCount>2 then
    TG.RowCount:=TG.RowCount+1;
  FillPos(TG.RowCount-1,tov);
end;

procedure TTovarSelect.FillTable;
var
  i,nn:cardinal;
begin
  if length(MyNums)=0 then exit;
  TovarSelect.TG.RowCount:=length(MyNums)+1;
  nn:=0;
  for i:=1 to length(MyNums) do
    FillPos(i,MyNums[nn]);
  TovarSelect.TG.Row:=1;
  TovarSelect.ClientHeight:=TG.Height;
  TovarSelect.ClientWidth:=TG.Width;
  TovarSelect.ShowModal;
end;

procedure TTovarSelect.TGKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13: if TG.Cells[0,TG.Row]<>'' then
           begin
             TovSel:=strtoint(TG.Cells[0,TG.Row]);
             ModalResult:=mrOK;
           end;
    #27: begin
           TovSel:=0;
           ModalResult:=mrCancel
         end;
  end;
end;

end.
