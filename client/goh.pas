unit goh;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BDconnect, StdCtrls, Atypes;


type
  Tgoods = class(TForm)
    goh: TStringGrid;
    CheckSimple: TCheckBox;
    ButtonCSV: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CheckSimpleClick(Sender: TObject);
    procedure gohKeyPress(Sender: TObject; var Key: Char);
    procedure CheckSimpleKeyPress(Sender: TObject; var Key: Char);
    procedure gohMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonCSVClick(Sender: TObject);
  private
    { Private declarations }
    savedfull,savedsimple:boolean;
  public
    { Public declarations }
    gohssort:integer;
    procedure clear;
    function MayAdd(li,num:integer):boolean;
    procedure GohAdd(nu:integer);
    procedure GohFill;
  end;

var
  goods     : Tgoods;
  gohcat    : array [Tip..Size] of tNumArr;
  gohp,gohd : tArrInt;
  gohNN     : integer;


implementation

{$R *.dfm}

procedure Tgoods.FormCreate(Sender: TObject);
begin
  goh.Cells[0,0]:='???';
  goh.Cells[1,0]:='????????';
  goh.Cells[2,0]:='?????';
  goh.Cells[3,0]:='???????';
  goh.Cells[4,0]:='????????';
  goh.Cells[5,0]:='??????';
  goh.Cells[6,0]:='???????';
  goh.Cells[7,0]:='?????';
  goh.Cells[8,0]:='????????';
end;

procedure Tgoods.clear;
var
  i:integer;
begin
  for i:=Tip to Size do
    begin
      setlength(gohcat[i].nums,0);
      gohcat[i].ctrl.NN:=0;
    end;
  goh.RowCount:=2;
  for i:=0 to goh.ColCount-1 do
    goh.Cells[i,1]:='';
end;

function Tgoods.MayAdd(li,num:integer):boolean;
var
  i:integer;
begin
  Result:=false;
  for i:=0 to gohcat[li].ctrl.NN-1  do
    if gohcat[li].nums[i]=num then exit;
  InsertNum(gohcat[li],num);
  Result:=true;
end;

procedure tGoods.GohAdd(nu:integer);
begin
  setlength(gohp,gohNN+1);
  gohp[gohNN]:=nu;
  inc(gohNN);
end;

procedure tGoods.GohFill;
var
  i:integer;
begin
  CheckSimple.Checked:=false;
  goh.RowCount:=gohNN+1;
  for i:=1 to gohNN do
    with C[gohp[i-1]].state.rec do
      with T[base.tov].state do
        begin
          goh.Cells[0,i]:=Lstat[Tip][rec.tip].rec.pos.nam;
          goh.Cells[1,i]:=Lstat[Mat][rec.mat].rec.pos.nam;
          goh.Cells[2,i]:=Lstat[Firm][rec.firm].rec.pos.nam;
          goh.Cells[3,i]:=rec.art;
          goh.Cells[4,i]:=rec.opis;
          goh.Cells[5,i]:=Lstat[Size][base.siz].rec.pos.nam;
          goh.Cells[6,i]:=inttostr(ost);
          goh.Cells[7,i]:=inttostr(base.tov);
          goh.Cells[8,i]:=inttostr(gohp[i-1]);
        end;
  ButtonCSV.Enabled:=not savedfull;
end;

procedure Tgoods.CheckSimpleClick(Sender: TObject);
var
  i,j,n,k:integer;
begin
  if checkSimple.Checked then
    begin
      ButtonCSV.Enabled:=not savedsimple;
      i:=1;
      while i<(goh.RowCount-1) do
        begin
          goh.Cells[8,i]:='';
          j:=i+1;
          while j<=(goh.RowCount-1) do
            begin
              if (goh.Cells[5,i]=goh.Cells[5,j])and(goh.Cells[7,i]=goh.Cells[7,j])then
                begin
                  goh.Cells[6,i]:=inttostr(strtoint(goh.Cells[6,i])+strtoint(goh.Cells[6,j]));
                  for n:=j to goh.RowCount-2 do
                    begin
                      for k:=0 to goh.ColCount-2 do
                        goh.Cells[k,n]:=goh.Cells[k,n+1];
                      goh.Cells[8,n]:='';
                    end;
                  goh.RowCount:=goh.RowCount-1;
                end;
              inc(j);
            end;
          inc(i);
        end;
    end
   else
    GohFill;
end;

procedure Tgoods.gohKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then goods.Close;
end;

procedure Tgoods.CheckSimpleKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then goods.Close;
end;

procedure Tgoods.gohMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  co,ro,n,i,j,n1,n2:integer;
 procedure ExchRow(r1,r2:integer);
   var
     k:integer;
   begin
     for k:=0 to goh.ColCount-1 do goh.Cols[k].Exchange(r1,r2);
   end;
begin
  goh.MouseToCell(X,Y,co,ro) ;
  if ro=0 then
    for i:=1 to goh.RowCount-2 do
      for j:=i+1 to goh.RowCount-1 do
        if co<6 then
          begin
            if goh.Cells[co,i]>goh.Cells[co,j] then
              ExchRow(i,j)
             else
              if goh.Cells[co,i]=goh.Cells[co,j] then
                begin
                  n:=co+1;
                  while (n<goh.ColCount)and(goh.Cells[n,i]=goh.Cells[n,j]) do inc(n);
                  if (n<goh.ColCount)and(goh.Cells[co,i]>goh.Cells[co,j]) then
                    ExchRow(i,j);
                end
          end
         else
          begin
            n1:=strtoint(goh.Cells[co,i]);
            n2:=strtoint(goh.Cells[co,j]);
            if n1>n2 then
              ExchRow(i,j)
             else
              if n1=n2 then
                begin
                  n:=co+1;
                  while (n<goh.ColCount)and
                        trystrtoint(goh.Cells[n,i],n1)and
                        trystrtoint(goh.Cells[n,n],n2)and
                        (n1=n2) do inc(n);
                  if (n<goh.ColCount)and(n2<>0)and(n1>n2) then
                    ExchRow(i,j);
                end
          end

end;

procedure Tgoods.ButtonCSVClick(Sender: TObject);
var
  i:integer;
  tx:Textfile;
  nam:string;
begin
  if not DirectoryExists('reports') then CreateDir('reports');
  nam:=DatTimToStr(TimeNow);
  for i:=1 to length(nam) do if nam[i]=':' then nam[i]:='-';
  assignfile(tx,'reports\'+nam+'.csv');
  rewrite(tx);
  writeln(tx,'        ??????? ???????  '+BDname+' ['+BDnum+'] '+nam+'  ');
  for i:=0 to goh.RowCount-1 do
    begin
      goh.Rows[i].Delimiter:=';';
      writeln(tx,goh.Rows[i].delimitedText);
    end;
  closefile(tx);
  buttonCSV.Enabled:=false;
  if checkSimple.Checked then
    savedsimple:=true
   else
    savedfull:=true;
end;

end.
