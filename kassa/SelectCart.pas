unit SelectCart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Atypes, KassaBD;

type
  TSelCart = class(TForm)
    sg: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure sgDblClick(Sender: TObject);
    procedure sgKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    SS    : integer;
  public
    { Public declarations }
    NN    : integer;
    selca : tArrInt;
    procedure clear;
    procedure add(n:integer);

  end;

var
  SelCart: TSelCart;

implementation

{$R *.dfm}

procedure TSelCart.FormCreate(Sender: TObject);
begin
  sg.Cells[0,0]:='?';
  sg.Cells[1,0]:='???';
  sg.Cells[2,0]:='????????';
  sg.Cells[3,0]:='?????';
  sg.Cells[4,0]:='???????';
  sg.Cells[5,0]:='????????';
  sg.Cells[6,0]:='??????';
  sg.Cells[7,0]:='????';
  sg.Cells[8,0]:='???????';
  sg.Cells[9,0]:='?????';
  sg.Cells[10,0]:='????????';
  SS:=0;
  NN:=0;
end;

procedure TSelCart.sgDblClick(Sender: TObject);
begin
  if sg.Row>0 then ModalResult:=mrOk;
end;

procedure TSelCart.sgKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    #13 : sgDblClick(Sender);
    #27 : ModalResult:=0;
  end;
end;

procedure TSelCart.clear;
begin
  NN:=0;
end;

procedure TSelCart.add(n:integer);
begin
  if NN=SS then
    begin
      inc(SS,10);
      setlength(selca,SS);
    end;
  selca[NN]:=n;
  inc(NN);
end;

procedure TSelCart.FormDestroy(Sender: TObject);
begin
  setlength(selca,0);
end;

procedure TSelCart.FormShow(Sender: TObject);
var
  i:integer;
begin
  sg.RowCount:=NN+1;
  for i:=1 to NN do
    with C[selca[i-1]].state.rec do
      begin
        sg.Cells[0,i]:=inttostr(i);
        with T[base.tov].state do
          begin
            sg.Cells[1,i]:=Lstat[Tip][rec.tip].rec.pos.nam;
            sg.Cells[2,i]:=Lstat[Mat][rec.mat].rec.pos.nam;
            sg.Cells[3,i]:=Lstat[Firm][rec.firm].rec.pos.nam;
            sg.Cells[4,i]:=rec.art;
            sg.Cells[5,i]:=rec.opis;
          end;
        sg.Cells[6,i]:=Lstat[Size][base.siz].rec.pos.nam;
        sg.Cells[7,i]:=inttostr(base.price);
        sg.Cells[8,i]:=inttostr(ost);
        sg.Cells[9,i]:=inttostr(base.tov);
        sg.Cells[10,i]:=inttostr(selca[i-1]);
      end;
end;

end.
