unit PrihNak;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DateUtils, Grids, StdCtrls, ComCtrls, BDconnect, TovarSel, Atypes;

const
  mdView = 0;
  mdEdit = 1;

  pCod=1;
  pTip=2;
  pMat=3;
  pFirm=4;
  pArt=5;
  pOpis=6;
  pSize=7;
  pCount=8;
  pPrice=9;
  pSum=10;
  pCart=11;

type
  TPrihNakl = class(TForm)
    save: TButton;
    Cancel: TButton;
    Label1: TLabel;
    DTp: TDateTimePicker;
    Num: TLabel;
    PA: TComboBox;
    PG: TStringGrid;
    Exec: TButton;
    Label2: TLabel;
    Label3: TLabel;
    NA: TEdit;
    DTa: TDateTimePicker;
    pcb: TComboBox;
    Label4: TLabel;
    labelPrihSum: TLabel;
    procedure FormResize(Sender: TObject);
    procedure PAKeyPress(Sender: TObject; var Key: Char);
    procedure DTpKeyPress(Sender: TObject; var Key: Char);
    procedure NAKeyPress(Sender: TObject; var Key: Char);
    procedure DTaKeyPress(Sender: TObject; var Key: Char);
    procedure PAKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PAEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PGKeyPress(Sender: TObject; var Key: Char);
    procedure ExecClick(Sender: TObject);
    procedure PGKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PGSelectCell(Sender: TObject; ACol, ARow: Integer;  var CanSelect: Boolean);
    procedure pcbKeyPress(Sender: TObject; var Key: Char);
    procedure pcbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure saveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pcbExit(Sender: TObject);
    procedure pcbEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PGEnter(Sender: TObject);
    procedure PGMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    waschanged,pcbok,tovarbad:boolean;
    delrow:integer;
    prihhead:tPrihPos;
    function getPrihRowErr(ro:integer; var tpr:tPrihRow):boolean;
    function PrihRowBad(ro:integer):boolean;
    function PrihTestTovRow(ro:integer):boolean;
  public
    { Public declarations }
    PrihNaklChanged:boolean;
    md:integer;
    procedure ShowRows;
    procedure PrihodMode(const mm:integer=-1);
    function  ShowPCB(co:integer; ro:integer):boolean;
    procedure DeleteEmptyRows;
    procedure InsertBlankRow(nr:integer);
    procedure InsertCopyRow(nr:integer);
    procedure DeleteRow(nr:integer; const edit:boolean=false);
    function EmptyRow(nr:integer):boolean;
    function OpenPrihNakl(prihnum:integer):boolean;
    function CellEmpty:boolean;
    function Cell_0_G(var nu:integer):boolean;
    function Cell_0_GE(var nu:integer):boolean;
    function Col_0_GE(co:integer; var nu:integer):boolean;
    function PrihodGetTovarCod(ro:integer; var cod,ttip,tmat,tfirm:integer):integer;
    procedure FillPrihTovarRow(cod:integer);
    function CheckPrihod:boolean;
    function SaveNakl:boolean;
    function PrihChanged:boolean;
  end;

var
  PrihNakl: TPrihNakl;
  pcbList:integer=-1;
  prnum: integer=0;


implementation
uses login_;

 {$R *.dfm}

function TPrihNakl.PrihChanged:boolean;
  var
    i:integer;
    po:tPrihRow;
    emp:boolean;
  begin
    emp:=EmptyRow(1);
    Result:=( (Prihhead.data<>DateTimeToDat(DTp.Date))or(prihhead.agent<>IndexList(PA,Agent))or
                    (prihhead.agnum<>NA.Text)or(prihhead.agdat<>DateTimeToDat(DTa.Date)) or
                    ((Emp and (prihhead.Npos<>0))or(not Emp and(prihhead.Npos<>(PG.RowCount-1))))or
                    ((prnum<>0)and(prihhead.sum<>P[prnum].state.rec.sum)) );
    if not Result and not emp then
      for i:=1 to PG.RowCount-1 do
        begin
          if GetPrihRowErr(i,po) then
            begin
              Result:=true;
              exit
            end;
          Result:= not CompareMem(@po,@PNum[prnum].rows[i-1].pp,sizeof(tPrihRow));
          if result then
            begin
              PrihNaklChanged:=true;
              exit;
            end;
        end
  end;

function TPrihNakl.PrihRowBad(ro:integer):boolean;
var
  pp,cc,ss:integer;
begin
  Result:=not PrihTestTovRow(ro);
  if Result then exit;
  Result:=true;
  if not(TryStrToInt(PG.Cells[pCount,ro],cc))then
    begin
      PG.Col:=pCount;
      exit;
    end;
  if not(TryStrToInt(PG.Cells[pPrice,ro],pp))then
    begin
      PG.Col:=pPrice;
      exit;
    end;
  if not(TryStrToInt(PG.Cells[pSum,ro],ss))then
    begin
      PG.Col:=pSum;
      exit;
    end;
  Result:=not(cc*pp=ss);
  if Result then PG.Col:=pCount;
end;

function TPrihNakl.PrihTestTovRow(ro:integer):boolean;
var
  cod,tt,mm,ff:integer;
begin
  Result:=(PrihodGetTovarCod(ro,cod,tt,mm,ff)=cod)and(cod>0);
end;

procedure TPrihNakl.PrihodMode(const mm:integer=-1);
  begin
    if mm>=0 then md:=mm;
    if md=mdEdit then
      begin
        PrihNakl.Color:=clBtnface;
        PG.FixedColor:=clBtnFace;
        PG.Color:=clWindow;
        PG.ColCount:=11;
        DTp.Enabled:=true;
        DTa.Enabled:=true;
        PA.Enabled:=true;
        NA.Enabled:=true;
        save.Enabled:=true;
        Exec.Enabled:=true;
        PrihNakl.TabOrder:=1;
        PG.Options:= PG.Options +[goEditing]-[goRowSelect];
        WasChanged:=false;
      end
     else
      begin
        pcb.Visible:=false;
        with P[prnum].state do
          case status of
            stExec  : begin
                        Num.Font.Style:=[fsUnderLine];
                        PG.Color:=clMoneyGreen;
                        PG.ColCount:=12;
                        PG.ColWidths[11]:=64;
                        PG.Cells[11,0]:='карточка';
                        Pg.Color:=clMoneyGreen;
                        PrihNakl.Color:=clMoneyGreen;
                        PG.FixedColor:=clMoneyGreen;
                        labelPrihSum.Caption:=inttostr(rec.sum);
                      end;
            stAnn   : begin
                        labelPrihSum.Caption:=' ';
                                  PG.Color:=clSilver;
                                  Num.Font.Style:=[fsStrikeOut];
                      {  Pg.Color:=$8080C0;    }
                        PrihNakl.Color:=$8080C0;
                        PG.FixedColor:=$8080C0;
                      end;
          end;
        PG.Options:=PG.Options-[goEditing]+[goRowSelect];
        PG.Row:=1;
        save.Enabled:=false;
        Exec.Enabled:=false;
        PA.Enabled:=false;
        DTp.Enabled:=false;
        NA.Enabled:=false;
        DTa.Enabled:=false;
      end;
    ShowRows;
    PrihNakl.Resize;
  end;

procedure TPrihNakl.ShowRows;
var
  j,ro:integer;
begin
  if prnum=0 then
    begin
      PG.RowCount:=2;
      for j:=1 to PG.RowCount-1 do PG.Rows[j].Clear;
      label4.Visible:=false;
      labelPrihSum.Visible:=false;
      PG.Row:=1;
      PG.Col:=1;
      PG.Cells[0,1]:='1';
      Num.Caption:='';
      PA.ItemIndex:=-1;
      PA.Text:='';
      DTp.DateTime:=Now;
      NA.Text:='';
      DTa.DateTime:=Now;
      tovarbad:=true;
      prihhead.agent:=0;
      prihhead.agdat:=DateTimeToDat(DTa.DateTime);
      prihhead.agnum:='';
      prihhead.data:=DateTimeToDat(Dtp.DateTime);
      prihhead.sum:=0;
      prihhead.Npos:=0;
    end
   else
    begin
      with P[prnum].state do
        begin
          Num.Caption:=inttostr(prnum);
          PA.Text:=GetListNam(Agent,rec.agent);
          DTp.Date:=DatToDateTime(rec.data);
          NA.Text:=rec.agnum;
          DTa.Date:=DatToDateTime(rec.agdat);
          label4.Visible:=true;
          labelPrihSum.Visible:=true;
        end;
      with PNum[prnum] do
        begin
          if ctrl.Nrows=0 then
            begin
              PG.RowCount:=2;
              PG.Rows[1].Clear;
              exit
            end
           else
            PG.RowCount:=ctrl.Nrows+1;
          for j:=0 to ctrl.Nrows-1 do
            with rows[j].pp do
              begin
                ro:=j+1;
                PG.Cells[0,ro]:=inttostr(ro);
                PG.Cells[1,ro]:=inttostr(base.tov);
                with T[base.tov].state do
                  begin
                    PG.Cells[2,ro]:=GetListNam(Tip,rec.tip);
                    PG.Cells[3,ro]:=GetListNam(Mat,rec.mat);
                    PG.Cells[4,ro]:=GetListNam(Firm,rec.firm);
                    PG.Cells[5,ro]:=rec.art;
                    PG.Cells[6,ro]:=rec.opis;
                  end;
                PG.Cells[7,ro]:=GetListNam(Size,base.siz);
                PG.Cells[8,ro]:=inttostr(base.kol);
                PG.Cells[9,ro]:=Inttostr(base.price);
                PG.Cells[10,ro]:=Inttostr(tsum);
                if PG.ColCount=12 then PG.Cells[11,ro]:=inttostr(cartnum);
            end
        end;
    end
end;

function TPrihNakl.OpenPrihNakl(prihnum:integer):boolean;
var
  ct: tDatTim;
begin
  prnum:=prihnum;
  Result:=false;
  PrihNaklChanged:=false;
  if prnum=0 then {new}
    md:=mdEdit
   else
    begin {open}
      with c1.TCPc do
        begin
          with P[prnum] do
           with state do
            begin
              if (status<=stOpen)and not ChangeNaklStatus(Prihod,prnum,stOpen) then
                begin
                  ShowMessage('не открывается');
                  exit
                end;
              case status of
                stOpen: if {not loaded and} ReceiveSubArr(Prihod,prnum) then
                          begin
                                  ct:=edit.tim;
                                  if ct.t64=0 then ct:=creat.tim;

                                  md:=mdEdit;
                               {   prihhead.status:=stOpen;      }
                                  prihhead:=rec;
                                end;
                stExec: if {not loaded and} ReceiveSubArr(Prihod,prnum) then
                          begin
                                  md:=mdView;
                                end;
                stAnn         : begin
                                  ct:=ann.tim;
                                  md:=mdView
                                end
              end;
            end;
        end;
    end;
  PrihodMode;
  ShowModal;
  Result:=PrihNaklChanged;
end;

function DifferPrihRow(const pr,sr:tPrihRow):boolean;
begin
  Result:=(pr.base.tov<>sr.base.tov)or(pr.base.siz<>sr.base.siz)or(pr.base.kol<>sr.base.kol)or
          (pr.base.price<>sr.base.price)or(pr.tsum<>sr.tsum)or(pr.tprice<>sr.tprice);
end;

function TPrihNakl.getPrihRowErr(ro:integer; var tpr:tPrihRow):boolean;
  begin
    Result:=true;
    with tpr do
      if not (TryStrToInt(PG.Cells[pCod,ro],base.tov)and(base.tov>0))then
        PG.Col:=pCod
       else
        if not(TryStrToInt(PG.Cells[pCount,ro],base.kol)and(base.kol>=0))then
          PG.Col:=pCount
         else
          if not(TryStrToInt(PG.Cells[pPrice,ro],base.price)and(base.price>=0))then
            PG.Col:=pPrice
           else
            if not(TryStrToInt(PG.Cells[pSum,ro],tsum)and(tsum>=0))then
              PG.Col:=pSum
             else
              begin
                base.siz:=GetNumL(size,PG.Cells[pSize,ro]);
                if base.siz=0 then
                  PG.Col:=pSize
                 else
                  begin
                    tprice:=base.price;
                    cartnum:=0;
                    res:=0;
                    Result:=false
                  end;
              end;
  end;

function TPrihNakl.SaveNakl:boolean;
  var
    pr  : tPrihRow;
    i,j,nn: integer;
    ur  : tRecArr;
    eq  : boolean;
    ti  : tDatTim;
begin
  Result:=false;
  RefreshArr(Tovar);
  nn:=GetnumL(Agent,PA.Text);
  if nn<1 then
    begin
      showMessage('Agent?');
      PA.SetFocus;
      exit
    end;
  if CheckPrihod or EmptyRow(1) then
    begin
      with ur do
        begin
          pp.agdat:=DateTimeToDat(DTa.DateTime);
          pp.agnum:=NA.text;
          pp.data:=DateTimeToDat(DTp.Date);
          pp.agent:=nn;
          pp.sum:=0;
          if not EmptyRow(1) then
            begin
              i:=1; {объединение одинаковых позиций}
              while i<PG.RowCount do
                begin
                  j:=i+1;
                  while j<PG.RowCount do
                    begin
                      if (PG.Cells[pCod,i]=PG.Cells[pCod,j]) and
                         (PG.Cells[pSize,i]=PG.Cells[pSize,j]) and
                         (PG.Cells[pPrice,i]=PG.Cells[pPrice,j]) then
                        begin
                          PG.Cells[pCount,i]:=SumStrInt(PG.Cells[pCount,i],PG.Cells[pCount,j]);
                          PG.Cells[pSum,i]:=SumStrInt(PG.Cells[pSum,i],PG.Cells[pSum,j]);
                          DeleteRow(j);
                        end;
                      inc(j);
                    end;
                  inc(i);
                end;
              nn:=PG.RowCount-1;
            end
           else nn:=0;
          pp.Npos:=nn;
          for i:=1 to nn do pp.sum:=pp.sum+StrToInt(PG.Cells[pSum,i]);
          labelPrihSum.Caption:=inttostr(pp.sum);
          if prnum=0 then {new}
            begin
              prnum:=AddNewA(Prihod,ur);
              if prnum=0 then
                begin
                  showmessage('отказ создания');
                  exit;
                end;
              ti:=P[prnum].state.creat.tim;
              PrihNakl.Num.Caption:=inttostr(prnum);
              eq:=false;
            end
           else
            begin
              eq:=(pp.agent=prihhead.agent)and(pp.agdat=prihhead.agdat)and
                  (pp.sum=prihhead.sum)and(pp.agnum=trim(prihhead.agnum))and
                  (pp.data=prihhead.data)and(pp.Npos=prihhead.Npos);
              if not eq then
                ChangeArr(Prihod,prnum, ur);
              ti:=TimeNow;
            end;
          ResizeNum(PNum[prnum],nn);
          eq:=eq and (nn=P[prnum].state.rec.Npos);
      {    if not eq then ResizeSubArr(Prihod,prnum,nn);    }
          for i:=1 to nn do
            begin
              if GetPrihRowErr(i,pr) then exit;
              with PNum[prnum] do
                begin
                  if eq and DifferPrihRow(pr,rows[i-1].pp) then eq:=false;
                  if not eq then rows[i-1].pp:=pr;
                end;
            end;
        end;
      if not eq then
        begin
          PrihNaklChanged:=true;
          PNum[prnum].ctrl.Ntim:=ti;
          P[prnum].state.rec.Npos:=nn;
          SendSubArr(Prihod,prnum);
        {  SaveSubArr(Prihod,prnum);   }
          WasChanged:=false;
          prihhead:=P[prnum].state.rec;
          label4.Visible:=true;
          labelPrihSum.Visible:=true;
   //       labelPrihSum.Caption:=inttostr(P[prnum].state.rec.sum);
        end;
      Result:=true;
    end;
  end;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
function TprihNakl.CellEmpty:boolean;
  begin
    Result:=trim(PG.Cells[PG.Col,PG.Row])='';
  end;

function TprihNakl.Cell_0_GE(var nu:integer):boolean;
  begin
    Result:=Col_0_GE(PG.Col,nu);
  end;

function TprihNakl.Cell_0_G(var nu:integer):boolean;
  begin
    Result:=Cell_0_GE(nu) and (nu>0);
  end;

function TprihNakl.Col_0_GE(co:integer; var nu:integer):boolean;
  begin
    Result:=TryStrToInt(PG.Cells[co,PG.Row],nu)and (nu>=0);
  end;

procedure TPrihNakl.ExecClick(Sender: TObject);
begin
  if (num.Caption='')and(PA.Text='')and(NA.Text='')and(PG.Cells[1,1]='')then
    begin
      ShowMessage(' пусто ');
      exit
    end;
  if GetnumL(agent,PA.Text)=0 then
    begin
      PA.SetFocus;
      exit
    end;
  if MessageDlg(' Точно провести ?',mtConfirmation,[mbYes,mbNo],0)=mrNo then exit;
  if not SaveNakl then
    begin
      showmessage('не сохранилась');
      exit;
    end;
  if not ChangeNaklStatus(Prihod,prnum,stExec) then
    begin
      showmessage('не проводится');
    end
   else
    begin
      RefreshArr(Cart);
      PrihodMode(mdView);
    end;
end;

procedure TPrihNakl.FormResize(Sender: TObject);
begin
  label1.Left:=(prihNakl.width-label1.Width) div 2;
  num.Left:=PrihNakl.Width div 2;
  Exec.Left:=(PrihNakl.Width-Exec.Width)div 2;
  if PG.ColCount=11 then PG.ColWidths[pOpis]:=PG.Width-654
   else PG.ColWidths[pOpis]:=PG.Width-655-PG.ColWidths[11];
end;

procedure TPrihNakl.DTpKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then PA.SetFocus;
end;

procedure TPrihNakl.PAKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13)and(IndexList(PA,agent)<>0) then NA.SetFocus;
end;

procedure TPrihNakl.NAKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then DTa.SetFocus;
end;

procedure TPrihNakl.DTaKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then PG.SetFocus;
end;

procedure TPrihNakl.PAKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) then
    case key of
      13: begin
            if Addlist(agent,0,PA.text)<>0 then {add list agent}
              NA.SetFocus;
            key:=0
          end;
    end;
end;

procedure TPrihNakl.PAEnter(Sender: TObject);
begin
  if PA.Items.Count=L[Agent].info.N then exit;
  LoadCB(PA,Agent);
end;

procedure TPrihNakl.FormCreate(Sender: TObject);
begin
  PG.Cells[0,0]:='№';
  PG.Cells[1,0]:='код';
  PG.Cells[2,0]:='тип';
  PG.Cells[3,0]:='матер';
  PG.Cells[4,0]:='фирма';
  PG.Cells[5,0]:='артикул';
  PG.Cells[6,0]:='разновидность';
  PG.Cells[7,0]:='размер';
  PG.Cells[8,0]:='кол';
  PG.Cells[9,0]:='цена';
  PG.Cells[10,0]:='сумма';
  PG.ColWidths[0]:=28;
  PG.ColWidths[1]:=36;
  PG.ColWidths[2]:=90;
  PG.ColWidths[3]:=74;
  PG.ColWidths[4]:=110;
  PG.ColWidths[5]:=60;
  PG.ColWidths[6]:=150;
  PG.ColWidths[7]:=60;
  PG.ColWidths[8]:=45;
  PG.ColWidths[9]:=65;
  PG.ColWidths[10]:=72;
  pcb.Height:=PG.DefaultRowHeight;
  pcb.Parent:=PG;
  pcb.Height:=pcb.Height*pcb.DropDownCount;
end;

procedure TPrihNakl.InsertBlankRow(nr:integer);
  var
    i,j,nn:integer;
  begin
    if nr=PG.RowCount then  {last row}
      PG.RowCount:=nr+1
     else
      begin
        nn:=PG.RowCount;
        PG.RowCount:=nn+1;
        PG.Cells[0,nn]:=inttostr(nn);
        For i:=nn downto nr+1 do
          begin
            for j:=1 to PG.ColCount-1 do
              PG.Cells[j,i]:=PG.Cells[j,i-1];
            PG.Cells[0,i]:=inttostr(i);
          end;
      end;
    PG.Rows[nr].Clear;
    PG.Row:=nr;
    PG.Cells[0,nr]:=inttostr(nr);
    PG.Col:=pCod;
  end;

procedure TPrihNakl.InsertCopyRow(nr:integer);
  var
    nn,i,j:integer;
  begin
    if PG.Cells[pCod,nr-1]='' then exit;
    if nr=PG.RowCount then {last row}
      PG.RowCount:=nr+1
     else
      begin
        nn:=PG.RowCount;
        PG.RowCount:=nn+1;
        PG.Cells[0,nn]:=inttostr(nn);
        For i:=nn downto nr+1 do
          for j:=1 to PG.ColCount-1 do
            PG.Cells[j,i]:=PG.Cells[j,i-1];
      end;
    for j:=1 to PG.ColCount-2 do
      PG.Cells[j,nr]:=PG.Cells[j,nr-1];
    PG.Row:=nr;
    PG.Cells[0,nr]:=inttostr(nr);
    PG.Cells[pSum,nr]:='';
    if PG.ColCount=pCart then PG.Cells[pCart,nr]:='';
    PG.Col:=pSize;
  end;

procedure TPrihNakl.PGKeyPress(Sender: TObject; var Key: Char);
var
  nt,n1,n2,co,sum,cur:integer;
  na: tRecArr;
begin
  case PG.Col of
    pPrice,pSum,pCod,pCount : if noZifrFiltr(Key) then exit;
  end;
  if key=#10 then key:=#13;
  if(key=#13)and(md=mdEdit) then
    case PG.Col of
      pCod: if CellEmpty then PG.Col:=pTip
           else
             begin
               if Cell_0_GE(nt)and (nt<=A[Tovar].info.N) then
                 begin
                   FillPrihTovarRow(nt);
                   PG.Col:=pSize;
                 end
                else
                 begin
                   PG.Cells[1,PG.Row]:='';
                   exit
                 end
             end;
      pOpis : {описание}
              begin
                nt:=PrihodGetTovarCod(PG.Row,co,na.tt.tip,na.tt.mat,na.tt.firm);
                if nt<0 then exit;
                if (nt=0)and(MessageDlg('новый товар ?',mtConfirmation,[mbYes,mbNo],0)=mrYes) then
                  begin
                    na.tt.art:=PG.cells[pArt,PG.row];
                    na.tt.opis:=PG.cells[pOpis,PG.Row];
                    nt:=AddNewA(Tovar,na);
                    if nt>0 then
                      PG.Cells[pCod,PG.Row]:=inttostr(nt)
                     else
                      begin
                        ShowMessage('отказ создания товара');
                        PG.Col:=pCod;
                        exit;
                      end
                  end
                 else
                  begin
                    PG.Cells[pCod,PG.Row]:=inttostr(nt);
                    FillPrihTovarRow(nt);
                  end;
                PG.Col:=PG.Col+1;
              end;
      pCount: {кол-во} if Cell_0_GE(nt) then PG.Col:=pPrice;
      pPrice: {цена}   if CellEmpty then
           begin
             PG.Col:=pSum;
             exit
           end
          else
           if Cell_0_GE(cur) and Col_0_GE(pCount,nt) then
             begin
               PG.Cells[pSum,PG.Row]:=CurrToStr(cur*nt);
               PG.Col:=pSum;
             end;
      pSum: {сумма}
            begin
              if not Cell_0_GE(sum) or
                 ((trim(PG.Cells[pPrice,PG.Row])<>'') and
                   (not (Col_0_GE(pCount,n1)and Col_0_GE(pPrice,n2)and (n1*n2=sum)))) then
                PG.Col:=pCount
               else
                begin
                  if (trim(PG.Cells[pPrice,PG.Row])='')and Col_0_GE(pCount,nt) then
                  if (nt>0) then
                    begin
                      DivInto(nt,sum,n1,n2,cur);
                      PG.Cells[pPrice,PG.Row]:=IntToStr(cur);
                      if n2<>0 then
                        begin
                          PG.Cells[pCount,PG.Row]:=inttostr(n1);
                          PG.Cells[pSum,PG.Row]:=IntToStr(n1*cur);
                          InsertCopyRow(PG.Row+1);
                          inc(cur);
                          PG.Cells[pCount,PG.Row]:=inttostr(n2);
                          PG.Cells[pPrice,PG.Row]:=IntToStr(cur);
                          PG.Cells[pSum,PG.Row]:=IntToStr(n2*cur);
                        end
                    end
                   else
                    begin
                      PG.Col:=pCount;
                      exit
                    end;
                {new row}
                  if not EmptyRow(PG.Row) then
                    InsertBlankRow(PG.Row+1);
              {    if (prnum<>0) then P[prnum].loaded:=[];   }
                end
            end
     else
      PG.Col:=PG.Col+1;
    end;
end;

function TPrihNakl.EmptyRow(nr:integer):boolean;
  var
    j,nn:integer;
  begin
    nn:=PG.ColCount-1;
    Result:=False;
    for j:=1 to nn do
      if trim(PG.Cells[j,nr])<>'' then exit
       else
        if j=nn then Result:=true;
  end;

procedure TPrihNakl.DeleteRow(nr:integer; const edit:boolean=false);
  var
    i:integer;
  begin
    delrow:=nr;
    if PG.RowCount=2 then
      begin
        for i:=1 to PG.ColCount-1 do PG.Cells[i,1]:='';
        if edit then
          begin
            PG.Row:=1;
            PG.Col:=1;
          end
      end
     else
      begin
        if (PG.RowCount-1)=nr then
          PG.Row:=PG.Row-1
         else{not last}
          begin
            for i:=PG.Row to PG.RowCount-2 do
              begin
                PG.Rows[i]:=PG.Rows[i+1];
                PG.Cells[0,i]:=inttostr(i);
              end;
          end;
        PG.RowCount:=PG.RowCount-1;
        if edit then PG.Col:=pSum;
      end;
    delrow:=0;
  end;

procedure TPrihNakl.PGKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  tt:integer;
begin
  if not PG.EditorMode then exit;
  if not (ssShift in Shift) then
    begin
    {CTRL only}
      if (ssCtrl in Shift) and not (ssAlt in Shift) then
        case key of
       {ins} 45: if Col_0_GE(pCod,tt) and (tt>0){ and (tt<=A[tovar].N) } then InsertBlankRow(PG.Row);
       {del} 46: for tt:=1 to PG.ColCount-1 do PG.Cells[tt,PG.Row]:='';
        {Y}  89: begin
                   DeleteRow(PG.row,true);
                   delrow:=0;
                 end;
        end;
     {ALT only}
      if (ssAlt in Shift)and not (ssCtrl in Shift) then
        case Key of
        {enter} 13: if PG.col=pOpis then
                      begin
                        TovarSelect.Clear;
                        tt:=1;
                        repeat
                          tt:=MatchTovarText(tt,PG.Cells[pTip,PG.Row],PG.Cells[pMat,PG.Row],PG.Cells[pFirm,PG.Row],PG.Cells[pArt,PG.Row],PG.Cells[pOpis,PG.Row]);
                          if tt<>0 then TovarSelect.AddPos(tt);
                        until tt=0;
                        TovarSelect.ShowModal;
                        if (TovarSelect.ModalResult=mrOk) and (TovarSelect.TovSel<>0) then
                          begin
                            PG.Cells[pCod,PG.Row]:=TovarSelect.TG.Cells[0,TovarSelect.TG.Row];
                            FillPrihTovarRow(TovarSelect.TovSel);
                            PG.Col:=pSize;
                          end;
                      end;
        end;
      if not(ssAlt in Shift) and not (ssCtrl in Shift)and(key=27) then
        if PG.Col=1 then PG.Cells[1,PG.Row]:=''
         else PG.Col:=PG.Col-1;
    end;
end;

function ConvPrihColToList(Acol:integer):integer;
  begin
    case Acol of
      pTip : Result:=Tip;
      pMat : Result:=Mat;
      pFirm: Result:=Firm;
      pSize: Result:=Size
     else Result:=-1
    end
  end;

function TPrihNakl.ShowPCB(co:integer;ro:integer):boolean;
var
  newpcb:integer;
begin
  if ((co>=pTip)and(co<=pFirm))or(co=pSize) then
    begin
      newpcb:=ConvPrihColToList(co);
      if newpcb<>pcbList then
        begin
          pcbList:=newpcb;
          LoadCB(pcb,pcbList);
        end;
      pcb.Text:=PG.Cells[co,ro];
      pcb.BoundsRect:=pg.CellRect(co,ro);
      pcb.Show;
      pcb.SetFocus;
      Result:=true;
    end
   else
    begin
      Result:=false;
      pcb.Hide;
    end;
end;

procedure TPrihNakl.PGSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if md=mdView then exit;
  if delrow<>0 then exit;
  if (ARow=PG.Row) then
    begin
      if ACol<pSize then
        tovarbad:=true
       else
        if tovarbad then
          begin
            tovarbad:=not PrihTestTovRow(PG.Row);
            if tovarbad then
              begin
                CanSelect:=false;
                exit;
              end
          end
    end;
  if (ARow<>PG.Row)and PrihRowBad(PG.Row) then
    begin
      CanSelect:=false;
      exit
    end;
  if ShowPCB(Acol,Arow) then exit;
  PG.EditorMode:=true;
end;

procedure TPrihNakl.pcbKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key=#13)or(key=#10)) then
    begin
      pcbok:=true;
      PG.SetFocus;
    end
   else
    if key=#27 then
      begin
        PG.SetFocus;
        PG.col:=PG.Col-1;
      end;
end;

procedure TPrihNakl.pcbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  keych:char;
begin
  if (ssCtrl in Shift) then
    begin
      case key of
        13: if addList(pcbList,0,pcb.text)<>0 then
              begin
                Keych:=#13;
                pcbKeyPress(self,keych);
               end
      end;
    end;
end;

procedure TPrihNakl.FillPrihTovarRow(cod:integer);
  begin
    with T[cod].state do
      begin
        PG.Cells[pTip,PG.Row] :=GetListNam(tip,rec.tip);
        PG.Cells[pMat,PG.Row] :=GetListNam(mat,rec.mat);
        PG.Cells[pFirm,PG.Row]:=GetListNam(firm,rec.firm);
        PG.Cells[pArt,PG.Row] :=rec.art;
        PG.Cells[pOpis,PG.Row]:=rec.opis;
      end
  end;

function TPrihNakl.PrihodGetTovarCod(ro:integer; var cod,ttip,tmat,tfirm:integer):integer;
  begin
    Result:=-1;
    if EmptyRow(ro) then exit;
    cod:=StrToIntDef(PG.cells[pcod,ro],-1);
    if cod=0 then
      begin
        PG.Col:=pcod;
        exit
      end;
    ttip:=GetNumL(tip,PG.cells[ptip,ro]);
    if ttip=0 then
      begin
        PG.Col:=ptip;
        exit
      end;
    tmat:=GetNumL(mat,PG.cells[pmat,ro]);
    if tmat=0 then
      begin
        PG.col:=pmat;
        exit
      end;
    tfirm:=GetNumL(firm,PG.cells[pfirm,ro]);
    if tfirm=0 then
      begin
        PG.col:=pfirm;
        exit
      end;
    if PG.Cells[popis,ro]='' then
      begin
        PG.col:=pCod;
        exit
      end;
    Result:=GetTovarCode(ttip,tmat,tfirm,PG.Cells[pArt,ro],PG.cells[pOpis,ro]);
    if (cod>0)and(Result<>cod)then
      Result:=-1;
  end;

procedure TPrihNakl.DeleteEmptyRows;
  var
    i:integer;
  begin
    i:=1;
    while (i<PG.RowCount) do {delete empty row}
      begin
        if EmptyRow(i) then DeleteRow(i);
        inc(i)
      end;
    delrow:=0;
  end;

function TPrihNakl.CheckPrihod:boolean;
 var
   i{,ttip,tmat,tfirm,num,pr,sum,co}:integer;
begin
  DeleteEmptyRows;
  for i:=1 to PG.RowCount-1 do
    begin
      PG.Row:=i;
      if PrihRowBad(i) then
{      (PrihodGetTovarCod(i,co,ttip,tmat,tfirm)=0)or not Col_0_GE(pCount,num)
            or not Col_0_GE(pPrice,pr) or not Col_0_GE(pSum,sum) or (sum<>num*pr) then}
          begin
            Result:=false;
            exit
          end;
    end;
  Result:=true;
end;

procedure TPrihNakl.saveClick(Sender: TObject);
begin
  if (num.Caption='')and(PA.Text='')and(NA.Text='')and(PG.Cells[1,1]='')then
    begin
      exit
    end;
  SaveNakl;
end;

{procedure TPrihNakl.PGEnter(Sender: TObject);
begin
  if pcb.Visible then
    begin
      pcb.BringToFront;
      pcb.SetFocus;
    end;
 { rownum:=PG.row;
end; }

procedure TPrihNakl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if md=mdView then exit;
  DeleteEmptyRows;
  WasChanged:=wasChanged or PrihChanged;
  if WasChanged then
    begin
      if (MessageDlg('Сохранить изменения ?',mtConfirmation,[mbYes,mbNo],0)=mrYes) then
        begin
          if SaveNakl then
            begin
              ChangeNaklStatus(Prihod,prnum,stReady);
              exit
            end;
          Action:=caNone;
          exit
        end;
     end;
  if prnum<>0 then
    ChangeNaklStatus(Prihod,prnum,stReady);
  ModalResult:=mrCancel;
end;

procedure TPrihNakl.pcbExit(Sender: TObject);
var
  id:integer;
begin
  if pcbok then
    begin
      id:=IndexList(pcb,pcbList);
      if id>0 then
        begin
          pcb.Hide;
          PG.Cells[PG.Col,PG.Row]:=Lstat[pcbList][id].rec.pos.nam;
          PG.Col:=PG.Col+1;
       {   PG.EditorMode:=true;}
        end
       else
        pcb.SetFocus;
    end
   else
    begin
          pcb.Hide;
{          PG.EditorMode:=true;
          PG.Col:=PG.Col-1;     }
    end;
end;

procedure TPrihNakl.pcbEnter(Sender: TObject);
begin
  pcbok:=false;
end;

procedure TPrihNakl.FormShow(Sender: TObject);
begin
  if prnum=0 then
    DTp.SetFocus
   else
    PrihNakl.SelectNext(Self,true,true);
end;

procedure TPrihNakl.PGEnter(Sender: TObject);
begin
  ShowPCB(PG.Col,PG.Row);
end;

procedure TPrihNakl.PGMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  co,ro:integer;
begin
  PG.MouseToCell(x,y,co,ro);
  showpcb(PG.Col,PG.Row);// if pcb.Visible then pcb.BringToFront;
 { if (ro>0)and(co>0) then
    begin
      PG.Row:=ro;
      PG.Col:=co;
    end; }
end;


end.

