unit SelectTovar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KassaBD, Grids, Atypes;

type
  tSelectedInt = record
    N,S,Cu : integer;
    STA    : tArrInt;
  end;

  TSelTov = class(TForm)
    TG: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TGDblClick(Sender: TObject);
    procedure TGKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SIA       : tSelectedInt;
    tovarmode : boolean;
    procedure add(nu:integer);
    procedure clear;
    procedure del(ind:integer);
  end;


var
  SelTov: TSelTov;

implementation

{$R *.dfm}

procedure SortInt(var se:array of integer);
var
  i,j,n,min:integer;
begin
  n:=length(se);
  if n>1 then
    for i:=0 to n-2 do
      begin
        min:=i+1;
        for j:=i+1 to n-1 do
          if se[j]<se[min] then
            min:=j;
        if min<se[i] then
          begin
            j:=se[i];
            se[i]:=se[min];
            se[min]:=j;
          end
      end;
end;

procedure TSelTov.Add(nu:integer);
begin
  with SIA do
    begin
      if N>=S then
        begin
          inc(S,nListStep);
          setlength(STA,S);
        end;
      STA[N]:=nu;
      inc(N);
    end;
end;

procedure TSelTov.del(ind:integer);
var
  i:integer;
begin
  for i:=ind to SIA.N-2 do
    SIA.STA[i]:=SIA.STA[i+1];
  dec(SIA.N);
end;

procedure TSelTov.clear;
begin
  with SIA do
    begin
      N:=0;
      S:=0;
      setlength(STA,0);
    end;
end;

procedure TSelTov.FormCreate(Sender: TObject);
begin
  TG.Cells[0,0]:='№';
  TG.Cells[1,0]:='код';
  TG.Cells[2,0]:='тип';
  TG.Cells[3,0]:='матер';
  TG.Cells[4,0]:='фирма';
  TG.Cells[5,0]:='артикул';
  TG.Cells[6,0]:='разновидность';
end;


procedure TSelTov.FormShow(Sender: TObject);
var
  i,tt:integer;
begin
  TG.RowCount:=SIA.N+1;
//  TG.Height:=TG.GridHeight+4;
{  SelTov.Height:=SelTov.BevelWidth+SelTov.BorderWidth+(TG.ClientOrigin.Y-SelTov.Top)
                +TG.RowCount*(TG.DefaultRowHeight+TG.GridLineWidth)+6;
}  for i:=1 to SIA.N do
    begin
      tt:=SIA.STA[i-1];
      TG.Cells[0,i]:=inttostr(i);
      TG.Cells[1,i]:=inttostr(tt);
      with T[tt].state do
        begin
          TG.Cells[2,i]:=Lstat[Tip][rec.tip].rec.pos.nam;
          TG.Cells[3,i]:=Lstat[Mat][rec.mat].rec.pos.nam;
          TG.Cells[4,i]:=Lstat[Firm][rec.firm].rec.pos.nam;
          TG.Cells[5,i]:=rec.art;
          TG.Cells[6,i]:=rec.opis;
        end;
    end;
end;

procedure TSelTov.TGDblClick(Sender: TObject);
begin
  if TG.Row>0 then Modalresult:=mrOk;
end;

procedure TSelTov.TGKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    #13 : TGDblClick(Sender);
    #27 : ModalResult:=mrCancel;
  end;
end;

procedure TSelTov.FormDestroy(Sender: TObject);
begin
  setlength(SIA.STA,0);
end;

end.
