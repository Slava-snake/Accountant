unit BDconnect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  StdCtrls, StrUtils, ComCtrls, login_, Math, Atypes;

const
  BDfile    = 'bd.cnt';

  numFile   = 'num.cnt';
  numNUM    = 'numCtrl.cnt';

  rashodFile= 'rashod.cnt';
  prihodFile= 'prihod.cnt';
  cartFile  = 'carts.cnt';
  tovarFile = 'tovar.cnt';
  saleFile  = 'sale.cnt';
  rashodIndex = 'rashod.row';
  prihodIndex = 'prihod.row';
  cartIndex   = 'carts.num';
  tovarIndex  = 'tovar.num';
  prihDir  = 'Prihod\';
  rashDir  = 'Rashod\';
  SaleDir  = 'Sale\';
  tovarDir = 'Tovars\';
  cartDir  = 'Carts\';

  tipFile   = 'type.cnt';
  matFile   = 'material.cnt';
  firmFile  = 'firm.cnt';
  sizeFile  = 'size.cnt';
  agentFile = 'agent.cnt';
  tipIndex   = 'type.num';
  matIndex   = 'material.num';
  firmIndex  = 'firm.num';
  sizeIndex  = 'size.num';
  agentIndex = 'agent.num';
  agentDir = 'Agents\';
  firmDir  = 'Firms\';
  tipDir   = 'Types\';
  matDir   = 'Materials\';
  sizeDir  = 'Sizes\';

  catDir    = 'Groups\';
  tipCat    = catDir+'Tip\';
  matCat    = catDir+'Mat\';
  firmCat   = catDir+'Firm\';
  sizeCat   = catDir+'Size\';
  agentCat  = catDir+'Agent\';
  CatTip    = catDir+'tip.cat';
  CatMat    = catDir+'mat.cat';
  CatFirm   = catDir+'firm.cat';
  CatSize   = catDir+'size.cat';
  CatAgent  = catDir+'agent.cat';
  CatIndTip    = catDir+'tip.num';
  CatIndMat    = catDir+'mat.num';
  CatIndFirm   = catDir+'firm.num';
  CatIndSize   = catDir+'size.num';
  CatIndAgent  = catDir+'agent.num';

  pgPrihod = 0;
  pgRashod = 1;
  pgSale   = 2;
  pgPresence =3;

type
  tOperRec =record
      login   : tnam;
      name    : tOpis;
      dolg    : tnam;
      rights  : integer;
    end;
{----------------------------------------------------------------------------}
{-------------------------------------------------------------}
  Tc1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    conn: TButton;
    Save: TButton;
    Cancel: TButton;
    Label1: TLabel;
    TCPc: TIdTCPClient;
    Edit3: TEdit;
    Label2: TLabel;
    procedure connClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure TCPcConnected(Sender: TObject);
    procedure TCPcDisconnected(Sender: TObject);
  private
    { Private declarations }
  public
    nam  :string;
    { Public declarations }
  end;

var
  c1: Tc1;
  ii,CLnum   : integer;
  Nserver    : integer = 0;
  OnLine     : boolean = false;
  wc,CLname,BDdir,BDname : string ;
  BDnum   : tArt;
  BDtime,delta: tDatTim;
  rfrC,rfrL,rfrA:integer;
  myNums: tArrInt;
  qp : tQueryPacket;
  ap : tAnswerPacket;
  sizeofap    : integer=sizeof(tAnswerPacket);
  sizeofqp    : integer=sizeof(tQueryPacket);
  chanL   : array [Tip..Agent] of int64;
  chanC   : array [Tip..Agent] of int64;
  chanA   : array [Tovar..Sale] of int64;
  A         : array [Tovar..Sale]  of tMas;
  L         : array [Tip..Agent]   of tMas;
  Lstat     : array [Tip..Agent]   of tLstate;
  Cat       : array [Tip..Agent]   of tMas;
  Cstat     : array [Tip..Agent]   of tCstate;
  T         : array of tTovar;
  C         : array of tCart;
  P         : array of tPrih;
  R         : array of tRash;
  arrFile   : array [Tovar..Sale] of tFileNam=(tovarFile,CartFile,prihodFile,rashodFile,saleFile);
  arrDir    : array [Tovar..Sale] of tFileNam=(tovarDir,CartDir,prihDir,rashDir,SaleDir);
  fileTovar : file of tTovarState;
  fileCart  : file of tCartState;
  filePrihod: file of tPrihState;
  fileRashod: file of tRashState;
  listfile  : array [Tip..Agent]   of tFileNam=(tipFile,matFile,firmFile,sizeFile,agentFile);
  listIndex : array [Tip..Agent]   of tFileNam=(tipIndex,matIndex,firmIndex,sizeIndex,agentIndex);
  listDir   : array [Tip..Agent]   of tFileNam=(tipDir,matdir,firmDir,sizeDir,agentDir);
  CatFile   : array [Tip..Agent]   of tOpis=(CatTip,CatMat,CatFirm,CatSize,CatAgent);
  CatIndex  : array [Tip..Agent]   of tOpis=(CatIndTip,CatIndMat,CatIndFirm,CatIndSize,CatIndAgent);
  CatDirs   : array [Tip..Agent]   of tOpis=(tipCat,matCat,firmCat,sizeCat,agentCat);
  arrIndex  : array [Tovar..Rashod] of tFileNam=(tovarIndex,CartIndex,prihodIndex,rashodIndex);
  AN         : array [Tovar..Sale] of tMas;
  LN,CNN,CLN : array [Tip..Agent]  of tMas;
  CNum       : array of tDocPosArr;
  PNum,RNum  : array of tNumPR;
  TNum       : array of tNumArr;
  LNum,CatNNum,CatLNum   : array [Tip..Agent]   of tListRecNums;
  arrNumfilename  : array [Tovar..Rashod] of tFileNam=('tovar.num','Cart.num','prihod.num','rashod.num');
  TovarNumfile,CartNumfile : tfileNumCtrl;
  PrihNumfile,RashNumFile  : file of tNumActPR;
  listNumfilename : array [Tip..Agent] of tFileNam=('tip.num','mat.num','firm.num','size.num','agent.num');
  listNumfile     : array[Tip..Agent] of tfileNumCtrl;
  CatNNumfilename : array [Tip..Agent] of tFileNam=('tip.cnn','mat.cnn','firm.cnn','size.cnn','agent.cnn');
  CatNNumfile     : array[Tip..Agent] of tfileNumCtrl;
  CatLNumfilename : array [Tip..Agent] of tFileNam=('tip.cln','mat.cln','firm.cln','size.cln','agent.cln');
  CatLNumfile     : array[Tip..Agent] of tfileNumCtrl;

  function IntToArt(n:integer):tArt;
  function ListChar(li:integer):char;
  procedure LoadCB(var CB:TComboBox; li:integer);

  function AddNumL(li,ind,nu:integer):boolean;
  function DelNumL(li,ind,nu:integer):boolean;
  function MoveNumL(li,idel,iadd,nu:integer):boolean;
procedure ResizeNum(var X:tNumPR; const n:integer=0); overload;
function  NumEmpty(var X:tNumArr):boolean;
function InsertNum(var X:tNumArr; nu:integer):integer;
function InsertDocPos(num,nd,np:integer):boolean;
function DeleteNum(var X:tNumArr; nu:integer):integer;
function DeleteDocPos(num,nd,np:integer):boolean;
procedure InsertCartNum(nn,nu:integer);

  function AddList(li:integer; nod:integer; const sn:tNam):integer;
  function RenameList(li:integer; num:integer;const nam:string):boolean;
  function IndexList(var CB:TcomboBox; li:integer):integer;
  function GetListNam(li:integer; nn:integer):tNam;
  function GetNumL(li:integer; const tx:tNam):integer;
  function CheckList(li:integer; const tx:tNam):boolean;
  function RefreshList(li:integer):boolean;
  function FindInList(li,start:integer; const xx:tNam):integer;
  function CheckListRange(li:integer; po:integer):boolean;
  procedure ResizeList(li:integer; const np:integer=1);

  procedure ResizeCat(ca:integer; const np:integer=1);
  function RefreshCat(ca:integer):boolean;
  function CheckCatRange(ca:integer; po:integer):boolean;
  function AddCat(ca:integer; par:integer; const nam:tNam):integer;
  function RenameCat(ca,num:integer; const nam:tNam):boolean;
  {  procedure ExchLeaves(ca:integer; podel,poad:integer; nu:integer);}

  function GetTovarCode(tt,tm,tf:integer; const art:tArt; const opis:tOpis):integer;
  function FindMatchList(li,start:integer; const str:string):integer;
  function FindMatchTovar(start,ti,ma,fi:integer; const tar:tArt; const top: tOpis):integer;
  function MatchTovarText(start:integer; const Rti,Rma,Rfi:tNam; const Rar:tArt; const Rop:tOpis):integer;
  function CheckArrRange(ar:integer;num:integer):boolean;
  function RefreshArr(ar:integer):boolean;
  function AddNewA(ar:integer; const na:tRecArr):integer;
  function ChangeArr(ar,num:integer; const ch:tRecArr):boolean;
  function ReadA(ar:integer; num:integer):boolean;
  function ChangeNaklStatus(ar,num,stat:integer):boolean;
  procedure ResizeSubArr(ar,num,ns:integer);
  function SendSubArr(ar:integer; num:integer):boolean;
  function ReceiveSubArr(ar:integer; num:integer):boolean;
{  procedure LoadSubArr(ar:integer; num:integer);
  procedure SaveSubArr(ar:integer; num:integer);   }

implementation
uses CatSel;
{$R *.dfm}

type
  pTovarState=^tTovarState;
  pCartState=^tCartState;
  pPrihState=^tPrihState;
  pRashState=^tRashState;

procedure Tc1.connClick(Sender: TObject);
var
  cur:tCursor;
begin
  TCPc.Host:=edit1.Text;
  TCPc.Port:=ServerPort+strtoint(edit2.Text);
  cur:=c1.Cursor;
  c1.Cursor:=crHourGlass;
  try
    TCPc.Connect(2000);
  finally
    c1.Cursor:=cur;
  end;
  if TCPc.Connected then
    begin
      label1.Caption:=TCPc.ReadLn;
      TCPc.WriteLn(Edit3.Text);
      save.SetFocus;
      TCPc.Disconnect
    end
   else
    label1.Caption:=''
end;

procedure Tc1.saveClick(Sender: TObject);
begin
  if edit3.Text<>'' then
    c1.ModalResult:=mrOk
   else Edit3.SetFocus;
end;

procedure Tc1.CancelClick(Sender: TObject);
begin
  c1.ModalResult:=mrCancel;
end;

procedure Tc1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then Edit2.SetFocus
end;

procedure Tc1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then conn.SetFocus;
end;

procedure Tc1.edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13) and (text<>'') then edit1.SetFocus;
end;

procedure Tc1.TCPcConnected(Sender: TObject);
var
  s:string;
begin
  s:=c1.TCPc.ReadLn;  {}
  c1.TCPc.WriteLn(CLname);
  if (Operator=255) and (Login.ShowModal<>mrOk) then
    begin
      c1.TCPc.Disconnect;
      exit
    end;
  c1.TCPc.WriteSmallInt(Operator);
  c1.TCPc.WriteLn(username);
  if BDname=s then
    begin
      CLnum:=c1.TCPc.ReadInteger;
      qp.sl[0]:='T';
      delta:=TimeNow;
      c1.TCPc.WriteBuffer(qp,sizeofqp,true);
      c1.TCPc.Readbuffer(BDtime,8);
      delta.t64:=BDtime.t64-delta.t64;
      Online:=true;
    end
   else
    begin
      showmessage('Error BD');
      c1.TCPc.Disconnect;
    end;
end;

procedure Tc1.TCPcDisconnected(Sender: TObject);
begin
  online:=false;
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

function ReserveSize(n,block:integer):integer;
  begin
    Result:=(n div block +1)*block;
  end;

procedure FillMyAct(var act:tAct; const ti:tDatTim);
  begin
    with act do
      begin
        tim:=ti;
        fil:=CLnum;
        oper:=Operator;
      end;
  end;

  function IntToArt(n:integer):tArt;
    begin
      Result:=format('%9.9d',[n]);
    end;

{nums}
{--------------------------------------------------------------------------}
function  NumEmpty(var X:tNumArr):boolean;
begin
  Result:=X.ctrl.NN=0;
end;

procedure ResizeNum(var X:tNumArr; const n:integer=1); overload;
begin
  with X do
    with ctrl do
      begin
        inc(NN,n);
        if NN>SS then
          begin
            SS:=ReserveSize(NN,nListStep);
            Setlength(nums,SS);
          end
      end;
end;

procedure ResizeRA(ind:integer; const n:integer=1);
begin
  with Cnum[ind] do
    with ctrl do
      begin
        inc(NN,n);
        if NN>SS then
          begin
            SS:=ReserveSize(NN,nListStep);
            Setlength(ra,SS);
          end
      end;
end;

procedure ResizeNum(var X:tNumPR; const n:integer=0); overload;
begin
  with X do
    with ctrl do
      begin
        Nrows:=n;
        Setlength(rows,n);
      end;
end;

procedure ShiftNum(var X:tNumArr; start,count:integer);
  var
    i:integer;
  begin
    if (count=0)or(start<0) then exit;
    ResizeNum(X,count);
    with X do
      if (count>0)and(start<(ctrl.NN-count)) then
        for i:=ctrl.NN-1 downto start+count do nums[i]:=nums[i-count]
       else
        begin
          if start<abs(count) then count:=-start;
          if count<0 then
            for i:=start to ctrl.NN-count-1 do nums[i+count]:=nums[i];
        end;
  end;

  procedure SetLastNumA(ar,nn:integer);
    begin
      with AN[ar].info do
        begin
          case ar of
            Tovar : with TNum[nn].ctrl do
                      begin
                        if Nprev>0 then TNum[Nprev].ctrl.Nnext:=Nnext;
                        if Nnext>0 then TNum[Nnext].ctrl.Nprev:=Nprev;
                        Nnext:=0;
                        Nprev:=last;
                        if last<>0 then
                          TNum[last].ctrl.Nnext:=nn;
                      end;
            Cart  : with CNum[nn].ctrl do
                      begin
                        if Nprev>0 then CNum[Nprev].ctrl.Nnext:=Nnext;
                        if Nnext>0 then CNum[Nnext].ctrl.Nprev:=Nprev;
                        Nnext:=0;
                        Nprev:=last;
                        if last>0 then
                          CNum[last].ctrl.Nnext:=nn;
                      end;
          end;
          last:=nn;
          changed:=TimeNow;
        end;
    end;

  procedure SetLastCatNnum(ca,nn:integer);
    begin
      with CNN[ca].info do
        begin
          with CatNnum[ca][nn].ctrl do
            begin
              if Nprev>0 then CatNnum[ca][Nprev].ctrl.Nnext:=Nnext;
              if Nnext>0 then CatNnum[ca][Nnext].ctrl.Nprev:=Nprev;
              Nnext:=0;
              Nprev:=last;
            end;
          last:=nn;
          changed:=TimeNow;
        end;
  end;

  procedure SetLastCatLnum(ca,nn:integer);
    begin
      with CLN[ca].info do
        begin
          with CatLnum[ca][nn].ctrl do
            begin
              if Nprev>0 then CatLnum[ca][Nprev].ctrl.Nnext:=Nnext;
              if Nnext>0 then CatLnum[ca][Nnext].ctrl.Nprev:=Nprev;
              Nnext:=0;
              Nprev:=last;
            end;
          last:=nn;
          changed:=TimeNow;
        end;
  end;

  procedure SetLastListNum(li,nn:integer);
    begin
      with LN[li].info do
        begin
          with LNum[li][nn].ctrl do
            begin
              if Nprev>0 then LNum[li][Nprev].ctrl.Nnext:=Nnext;
              if Nnext>0 then LNum[li][Nnext].ctrl.Nprev:=Nprev;
              Nnext:=0;
              Nprev:=last;
            end;
          last:=nn;
          changed:=TimeNow;
        end;
  end;

procedure LoadInt(var fn:string; var X:tArrInt; first:integer; const maycount:integer=0);
var
  fi: fint;
  count:integer;
begin
  assignfile(fi,fn);
  reset(fi);
  seek(fi,first);
  if maycount=0 then
    count:=filesize(fi)-first
   else
    count:=maycount;
  if length(X)<count then
    Setlength(X,count);
  blockread(fi,X[0],count);
  closefile(fi);
end;

procedure SaveInt(fn:string; var X:tArrInt; first:integer);
var
  fi : fint;
begin
  assignfile(fi,fn);
  reset(fi);
  seek(fi,first);
  blockwrite(fi,X[0],length(X));
  closefile(fi);
end;

procedure LoadDocPos(fn:string; var X:tArrDocPos; first:integer);
var
  fdp: file of tDocPos;
begin
  assignfile(fdp,fn);
  reset(fdp);
  seek(fdp,first);
  Setlength(X,filesize(fdp)-first);
  blockread(fdp,X[0],filesize(fdp));
  closefile(fdp);
end;

procedure SaveDocPos(fn:string; var X:tArrDocPos; first:integer);
var
  fdp : file of tDocPos;
begin
  assignfile(fdp,fn);
  reset(fdp);
  seek(fdp,first);
  blockwrite(fdp,X[0],length(X));
  closefile(fdp);
end;

function InsertNum(var X:tNumArr; nu:integer):integer;
  function FindPos(lb,rb:integer):integer;
    var
      m:integer;
    begin
      m:=(rb-lb)div 2 + lb;
      if X.nums[m]>nu then
        begin
          if m=lb then
            Result:=lb
           else
            if X.nums[m-1]<nu then
              Result:=m
             else
              Result:=FindPos(lb,m)
        end
       else
        begin
          if m=rb then
            Result:=rb
           else
            if X.nums[m+1]>nu then
              Result:=m+1
             else
              Result:=FindPos(m,rb)
        end;
    end;
  begin
    with X do
      with ctrl do
        begin
          if NN>0 then
            begin
              if nu>X.nums[NN-1] then
                Result:=NN
               else
                Result:=findPos(0,NN-1)
            end
           else Result:=0;
          ShiftNum(X,Result,1);
          X.nums[Result]:=nu;
        end;
  end;

function DeleteNum(var X:tNumArr; nu:integer):integer;
  function FindNum(lb,rb:integer):integer;
    var
      m:integer;
    begin
      if X.nums[rb]=nu then
        Result:=rb
       else
        if lb=rb then
          Result:=-1
         else
          begin
            m:=(rb-lb)div 2 +lb;
            if X.nums[m]=nu then
              Result:=m
             else
              if X.nums[m]>nu then
                Result:=FindNum(lb,m)
               else
                Result:=FindNum(m,rb);
          end;
    end;
  begin
    with X.ctrl do
      begin
        if NN>0 then
          begin
            Result:=FindNum(0,NN-1);
            if (Result>=0)and(Result<NN) then
              begin
                ShiftNum(X,Result+1,-1);
                exit
              end
          end;
      end;
    Result:=-1;
  end;

function InsertDocPos(num,nd,np:integer):boolean;
    var
      no,i:integer;
    function FindDocPos(lb,rb:integer):integer;
      var
        mid:integer;
      begin
        with Cnum[num] do
          if nd>ra[rb].nDoc then
            Result:=rb+1
           else
            if nd<ra[lb].nDoc then
              Result:=lb
             else
              begin
                mid:=(rb-lb)div 2+lb;
                if nd=ra[mid].nDoc then
                  begin
                    if np=ra[mid].nPos then
                      Result:=-1
                     else
                      begin
                        if np>ra[mid].nPos then
                          while (mid<=rb)and(nd=ra[mid].nDoc)and(np<ra[mid].nPos) do inc(mid)
                         else
                          while (mid>lb)and(nd=ra[mid].nDoc)and(np>ra[mid-1].nPos) do dec(mid);
                        if np=ra[mid].nPos then
                          Result:=-1
                      end
                  end
                 else
                  if nd<ra[mid].nDoc then
                    Result:=FindDocPos(lb,mid)
                   else
                    Result:=FindDocPos(mid,rb);
              end;
      end;
  begin
    with Cnum[num] do
      with ctrl do
        begin
          if nd>0 then
            begin
              if NN>0 then
                no:=FindDocPos(pospos,NN-1)
               else
                no:=0;
            end
           else
            begin
              if NN>0 then
                no:=FindDocPos(0,pospos-1)
               else
                no:=0;
              if no>=0 then inc(pospos)
            end;
            Result:=no>=0;
            if Result then
              begin
                ResizeRA(num);
                for i:=NN-1 downto no+1 do ra[i]:=ra[i-1];
                ra[no].nDoc:=nd;
                ra[no].nPos:=np;
                SetLastNumA(Cart,no);
              end;
        end;
  end;

function DeleteDocPos(num,nd,np:integer):boolean;
  begin

  end;

procedure InsertCartNum(nn,nu:integer);
  var
    po:integer;
    fn:string;
    need:boolean;
  begin
    need:=true;
    with TNum[nn] do
      with ctrl do
        if (Nfirst<>0)and(nums[0]>nu)then
          begin
            po:=Nfirst mod 1024;
            fn:=arrDir[Tovar]+IntToArt(nn);
            repeat
              if po=0 then po:=1024;
              ShiftNum(TNum[nn],0,po);
              dec(Nfirst,po);
              LoadInt(fn,nums,Nfirst,po);
              po:=0;
            until (Nfirst=0)or(nums[0]<nu);
            if nums[0]>nu then
              begin
                ShiftNum(TNum[nn],0,1);
                nums[0]:=nu;
                need:=false;
              end;
          end;
    if need then InsertNum(Tnum[nn],nu);
    SetLastNumA(Tovar,nn);
  end;

  function AddNumL(li,ind,nu:integer):boolean;
    begin
      Result:=CheckListRange(li,ind)and (InsertNum(LNum[li][ind],nu)>=0);
      if Result then SetLastListNum(li,ind);
    end;

  function MoveNumL(li,idel,iadd,nu:integer):boolean;
    begin
      if CheckListRange(li,idel)and (DeleteNum(LNum[li][idel],nu)>=0) then SetLastListNum(li,idel);
      Result:=CheckListRange(li,iadd)and (InsertNum(LNum[li][iadd],nu)>=0);
      if Result then SetLastListNum(li,iadd);
    end;

  function DelNumL(li,ind,nu:integer):boolean;
    begin
      Result:=CheckListRange(li,ind)and (DeleteNum(LNum[li][ind],nu)>=0);
      if Result then SetLastListNum(li,ind);
    end;

  function AddNumCatN(ca,ind,nu:integer):boolean;
    begin
      Result:=CheckCatRange(ca,ind)and (InsertNum(CatNNum[ca][ind],nu)>=0);
      if Result then SetLastCatNnum(ca,ind);
    end;

  function MoveNumCatN(ca,idel,iadd,nu:integer):boolean;
    begin
      if CheckCatRange(ca,idel)and (DeleteNum(CatNNum[ca][idel],nu)>=0) then SetLastCatNNum(ca,idel);
      Result:=CheckCatRange(ca,iadd)and (InsertNum(CatNNum[ca][iadd],nu)>=0);
      if Result then SetLastCatNNum(ca,iadd);
    end;

  function AddNumCatL(ca,ind,nu:integer):boolean;
    begin
      Result:=CheckCatRange(ca,ind)and (InsertNum(CatLNum[ca][ind],nu)>=0);
      if Result then SetLastCatLnum(ca,ind);
    end;

  function MoveNumCatL(ca,idel,iadd,nu:integer):boolean;
    begin
      if CheckCatRange(ca,idel)and (DeleteNum(CatLNum[ca][idel],nu)>=0) then SetLastCatLNum(ca,idel);
      Result:=CheckCatRange(ca,iadd)and (InsertNum(CatLNum[ca][iadd],nu)>=0);
      if Result then SetLastCatLNum(ca,iadd);
    end;

  function AddNumTovar(ind,nu:integer):boolean;
    begin
      Result:=CheckArrRange(Tovar,ind)and (InsertNum(TNum[ind],nu)>=0);
      if Result then SetLastNumA(Tovar,ind);
    end;

  function MoveNumTovar(idel,iadd,nu:integer):boolean;
    begin
      if CheckArrRange(Tovar,idel)and (DeleteNum(TNum[idel],nu)>=0) then SetLastNumA(Tovar,idel);
      Result:=CheckArrRange(Tovar,iadd)and (InsertNum(TNum[iadd],nu)>=0);
      if Result then SetLastNumA(Tovar,iadd);
    end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{lists}
  function ListChar(li:integer):char;
    begin
      Case li of
        Tip    : Result:='T';
        Mat    : Result:='M';
        Firm   : Result:='F';
        Size   : Result:='S';
        Agent  : Result:='A'
       else
        Result:=#0
      end;
    end;

  function CheckListRange(li:integer; po:integer):boolean;
    begin
      with L[li].info do
        Result:=(po<=N)and(po>0);
    end;

  function ListFindByNameSync(li,excl:integer; const name:tNam; const sync:int64):integer;
    begin
      Result:=L[li].info.last;
      while (Result>0) do
        with Lstat[li][Result] do
          if (rec.tim.t64>sync) then
            begin
              if (Result<>excl)and(AnsiCompareText(name,rec.pos.nam)=0) then exit;
              Result:=rec.prev;
            end
           else
            Result:=0;
    end;

  function GetListNam(li:integer; nn:integer):tNam;
    begin
      if CheckListRange(li,nn) then Result:=Lstat[li][nn].rec.pos.nam
       else Result:=''
    end;

  function GetNumL(li:integer; const tx:tNam):integer;
    var
      last:int64;
    begin
      if tx<>'' then
        begin
          for Result:=1 to L[li].info.N do
            if AnsiCompareText(Lstat[li][Result].rec.pos.nam,tx)=0 then exit;
          last:=L[li].info.changed.t64;
          if RefreshList(li) then
            begin
              Result:=ListFindByNameSync(li,0,tx,last);
              exit
            end  
        end;
      Result:=0;
    end;

  function CheckList(li:integer; const tx:tNam):boolean;
    begin
      Result:=GetNumL(li,tx)>0;
    end;

    function ListFindByName(li:integer; const xx:tNam; const excl:integer=0):integer;
      begin
        for Result:=1 to L[li].info.N do
          if (Result<>excl)and(AnsiCompareText(xx,Lstat[li][Result].rec.pos.nam)=0) then
            exit;
        Result:=0;
      end;

    function FindInList(li,start:integer; const xx:tNam):integer;
      begin
        if CheckListRange(li,start) then
          for Result:=start to L[li].info.N do
            if MatchInStr(xx,Lstat[li][Result].rec.pos.nam) then
              exit;
        Result:=0;
      end;

  procedure ResizeList(li:integer; const np:integer=1);
    var
      i,old:integer;
    begin
      with L[li] do
        with info do
          begin
            old:=N;
            inc(N,np);
            if N>=Msize then
              begin
                Msize:=ReserveSize(N,nListStep);
                setLength(Lstat[li],Msize);
                setlength(Lnum[li],Msize);
              end;
            for i:=old to N do LNum[li][i].ctrl.Ntim.t64:=0;
          end;
    end;

function QueryList(li:integer):boolean;
begin
  qp.sync:=L[li].info.changed.t64;
  qp.sl[0]:='L';
  qp.sl[1]:=ListChar(li);
  try
    c1.TCPc.WriteBuffer(qp,sizeofqp,true);
    c1.TCPc.ReadBuffer(ap,sizeofap);
    Result:=ap.ans.num<>0;
   except
    c1.TCPc.Disconnect;
    result:=false;
  end;
end;

procedure CutList(li,num:integer);
  begin
    with L[li].info do
      with Lstat[li][num].rec do
        if num<>last then
          begin
            if prev<>0 then Lstat[li][prev].rec.next:=next;
            if next<>0 then Lstat[li][next].rec.prev:=prev
          end;
  end;

procedure SetLastList(li,num:integer);
  begin
    with L[li].info do
      with Lstat[li][num].rec do
        begin
          if last<>num then
            begin
              if last<>0 then Lstat[li][last].rec.next:=num;
              prev:=last;
              next:=0;
              last:=num;
            end;
          changed:=tim;
        end;
  end;

function RefreshList(li:integer):boolean;
  var
    i,nu : integer;
  procedure SetListRec(num:integer);
    begin
      with L[li].info do
        begin
          if num>N then ResizeList(li,num-N)
             else CutList(li,num);
          with Lstat[li][num] do
            begin
            if rec.pos.node<>ap.ll.pos.node then
              begin
                prop:=prop+[prNode];
                MoveNumCatL(li,rec.pos.node,ap.ll.pos.node,num);
              end;
            if rec.pos.nam<>ap.ll.pos.nam then
              prop:=prop+[prNam];
            rec:=ap.ll;
          end;
        end;
      SetLastList(li,num);
    end;
  begin
    qp.sl[2]:='S';
    Result:=QueryList(li);
    rfrL:=ap.ans.count;
    if not Result then exit;
    if rfrL=1 then
      SetListRec(ap.ans.num)
     else
      begin
        nu:=ap.ans.num;
        for i:=1 to rfrL do
          begin
            c1.TCPc.ReadBuffer(ap.ll,sizeof(tListRec));
            SetListRec(nu);
            nu:=ap.ll.next;
          end;
      end;
  end;

function RenameList(li:integer; num:integer; const nam:string):boolean;
  begin
    if CheckListRange(li,num) and (ListFindByName(li,nam,num)=0) then
      begin
        qp.sl[2]:='C';
        qp.sl[3]:='N';
        qp.num:=num;
        qp.ll.nam:=nam;
        Result:=QueryList(li);
        if ap.ans.prevS.t64<>L[li].info.changed.t64 then RefreshList(li)
         else
          if Result then
            begin
              CutList(li,num);
              with Lstat[li][num] do with rec do
                begin
                  pos.nam:=nam;
                  FillMyAct(edit,ap.ans.timS);
                  prop:=prop+[prNam];
                end;
              SetLastList(li,num);
            end;
        end
     else
      Result:=false
  end;

  function MoveList(li,num,newnode:integer):boolean;
    begin
      if CheckListRange(li,num)and CheckCatRange(li,newnode) then
        begin
          qp.sl[2]:='C';
          qp.sl[3]:='P';
          qp.num:=num;
          qp.ll.node:=newnode;
          Result:=QueryList(li);
          if ap.ans.prevS.t64<>L[li].info.changed.t64 then RefreshList(li)
           else
            if Result then
              begin
                CutList(li,num);
                with Lstat[li][num] do with rec do
                  begin
                    MoveNumCatL(li,pos.node,newnode,num);
                    pos.node:=newnode;
                    FillMyAct(edit,ap.ans.timS);
                    prop:=prop+[prNode];
                  end;
                SetLastList(li,num);
              end;
        end
       else
        Result:=false
    end;

  function AddList(li:integer; nod:integer; const sn:tNam):integer;
    begin
      Result:=0;
      if ListFindByName(li,sn)<>0 then exit;
      if nod=0 then
        begin
          nod:=SelectNode(li,true);
          if nod<=0 then exit;
        end;
      qp.sl[2]:='A';
      qp.ll.nam:=sn;
      qp.ll.node:=nod;
      QueryList(li);
      Result:=ap.ans.num;
      if ap.ans.prevS.t64<>L[li].info.changed.t64 then RefreshList(li)
       else
        if Result<>0 then
          begin   {add new}
            ResizeList(li);
            with Lstat[li][ap.ans.num] do
              begin
                lock:=NullLock;
                with rec do
                  begin
                    pos.nam:=sn;
                    pos.node:=nod;
                    tim:=ap.ans.timS;
                    FillMyAct(creat,tim);
                    edit.tim.t64:=0;
                  end;
                viewnodeL:=nil;
              end;
            AddNumCatL(li,nod,Result);
            SetLastList(li,ap.ans.num);
          end;
    end;

{-----------------------------------------------------------------------------}
{catalogs}


  function CheckCatRange(ca:integer; po:integer):boolean;
    begin
      with Cat[ca].info do
        Result:=(po<=N)and(po>0);
    end;

  function GetCatNam(ca:integer; nn:integer):tNam;
    begin
      if CheckCatRange(ca,nn) then Result:=Cstat[ca][nn].rec.pos.nam
       else Result:=''
    end;

  function GetNumCat(ca:integer; const tx:tNam):integer;
    var
      i:integer;
    begin
      if tx<>'' then
        for i:=1 to Cat[ca].info.N do
          if AnsiCompareText(Cstat[ca][i].rec.pos.nam,tx)=0 then
            begin
              Result:=i;
              exit
            end;
      Result:=0;
    end;

  function CatFindByName(ca:integer; const xx:tNam; const excl:integer=0):integer;
    var
      i:integer;
    begin
      if xx<>'' then
        for i:=1 to Cat[ca].info.N do
          if (i<>excl)and(AnsiCompareText(xx,Cstat[ca][i].rec.pos.nam)=0) then
            begin
              Result:=i;
              exit;
            end;
      Result:=0;
    end;

  function CheckCat(ca:integer; const tx:tNam):boolean;
    begin
      Result:=GetNumCat(ca,tx)>0;
    end;

  procedure ResizeCat(ca:integer; const np:integer=1);
    var
      i,old:integer;
    begin
      with Cat[ca] do
        with info do
          begin
            old:=N;
            inc(N,np);
            if N>=Msize then
              begin
                Msize:=ReserveSize(N,nListStep);
                setLength(Cstat[ca],Msize);
                setlength(CatNnum[ca],Msize);
                setlength(CatLnum[ca],Msize);
              end;
            if old=0 then inc(old);
            for i:=old to N do CatNNum[ca][i].ctrl.Ntim.t64:=0;
            for i:=old to N do CatLNum[ca][i].ctrl.Ntim.t64:=0;
          end;
    end;

function QueryCat(ca:integer):boolean;
begin
  qp.sync:=Cat[ca].info.changed.t64;
  qp.sl[0]:='C';
  qp.sl[1]:=ListChar(ca);
  try
    c1.TCPc.WriteBuffer(qp,sizeofqp,true);
    c1.TCPc.ReadBuffer(ap,sizeofap);
    Result:=ap.ans.num<>0;
   except
    c1.TCPc.Disconnect;
    result:=false;
  end;
end;

procedure CutCat(ca,num:integer);
  begin
    with Cat[ca].info do
      with Cstat[ca][num].rec do
        if num<>last then
          begin
            if prev<>0 then Cstat[ca][prev].rec.next:=next;
            if next<>0 then Cstat[ca][next].rec.prev:=prev
          end;
  end;

procedure SetLastCat(ca,num:integer);
  begin
    with Cat[ca].info do
      with Cstat[ca][num].rec do
        begin
          if last<>num then
            begin
              if last<>0 then Cstat[ca][last].rec.next:=num;
              prev:=last;
              next:=0;
              last:=num;
            end;
          changed:=tim;
        end;
  end;

function RefreshCat(ca:integer):boolean;
  var
    i,nu : integer;
  procedure SetCatRec(num:integer);
    begin
      with Cat[ca].info do
        begin
          if num>N then ResizeCat(ca,num-N)
           else CutCat(ca,num);
          with Cstat[ca][num] do
            begin
              if rec.pos.node<>ap.ca.pos.node then
                begin
                  prop:=prop+[prNode];
                  MoveNumCatN(ca,rec.pos.node,ap.ca.pos.node,num);
                end;
              if rec.pos.nam<>ap.ca.pos.nam then
                prop:=prop+[prNam];
              rec:=ap.ca;
            end;
        end;
      SetLastCat(ca,num);
    end;
  begin
    qp.sl[2]:='S';
    Result:=QueryCat(ca);
    rfrC:=ap.ans.count;
    if not Result then exit;
    if rfrC=1 then
      SetCatRec(ap.ans.num)
     else
      begin
        nu:=ap.ans.num;
        for i:=1 to rfrC do
          begin
            c1.TCPc.ReadBuffer(ap.ca,sizeof(tCatRec));
            SetCatRec(nu);
            nu:=ap.ca.next;
          end;
      end;
  end;

function RenameCat(ca:integer; num:integer; const nam:tNam):boolean;
  begin
    if CheckCatRange(ca,num) and (CatFindByName(ca,nam,num)=0) then
      begin
        qp.sl[2]:='C';
        qp.sl[3]:='N';
        qp.num:=num;
        qp.ll.nam:=nam;
        Result:=QueryCat(ca);
        if ap.ans.prevS.t64<>Cat[ca].info.changed.t64 then RefreshCat(ca)
         else
          if Result then
            begin
              CutCat(ca,num);
              with Cstat[ca][num] do with rec do
                begin
                  pos.nam:=nam;
                  FillMyAct(edit,ap.ans.timS);
                  prop:=prop+[prNam];
                end;
              SetLastCat(ca,num);
            end;
        end
     else
      Result:=false
  end;

  function MoveCat(ca,num,newnode:integer):boolean;
    begin
      if CheckCatRange(ca,num)and CheckCatRange(ca,newnode) then
        begin
          qp.sl[2]:='C';
          qp.sl[3]:='P';
          qp.num:=num;
          qp.ll.node:=newnode;
          Result:=QueryCat(ca);
          if ap.ans.prevS.t64<>Cat[ca].info.changed.t64 then RefreshCat(ca)
           else
            if Result then
              begin
                CutCat(ca,num);
                with Cstat[ca][num] do with rec do
                  begin
                    MoveNumCatN(ca,pos.node,newnode,num);
                    pos.node:=newnode;
                    FillMyAct(edit,ap.ans.timS);
                    prop:=prop+[prNode];
                  end;
                SetLastCat(ca,num);
              end;
        end
       else
        Result:=false
    end;

  function AddCat(ca:integer; par:integer; const nam:tNam):integer;
    begin
      Result:=0;
      if CatFindByName(ca,nam)<>0 then exit;
      if (par=0)and(Cat[ca].info.N<>0) then
        begin
          par:=SelectNode(ca,true);
          if par<=0 then exit;
        end;
      qp.sl[2]:='A';
      qp.ll.nam:=nam;
      qp.ll.node:=par;
      QueryCat(ca);
      Result:=ap.ans.num;
      if ap.ans.prevS.t64<>Cat[ca].info.changed.t64 then RefreshCat(ca)
       else
        if Result<>0 then
          begin   {add new}
            ResizeCat(ca);
            with Cstat[ca][ap.ans.num] do
              begin
                lock:=NullLock;
                with rec do
                  begin
                    pos.nam:=nam;
                    pos.node:=par;
                    tim:=ap.ans.timS;
                    FillMyAct(creat,tim);
                    edit.tim.t64:=0;
                  end;
                viewnodeC:=nil
              end;
            AddNumCatN(ca,par,Result);
            SetLastCat(ca,Result);
          end;
    end;

{_____________________________________________________________________________}

{arrays}
  function ArrChar(ar:integer):char;
    begin
      case ar of
        Tovar   : Result:='T';
        Cart    : Result:='C';
        Prihod  : Result:='P';
        Rashod  : Result:='R';
        Sale    : Result:='S';
       else
        Result:='*'
      end;
    end;

procedure ResizeArr(ar:integer; nu:integer);
begin
  with A[ar] do with info do
    if nu>N then
      begin
        dec(nu,ofs);
        if nu>=Msize then
          begin
            Msize:=ReserveSize(nu,nListStep*2);
            case ar of
              Tovar         : begin
                                setlength(T,Msize);
                                setlength(TNum,Msize);
                              end;
              Cart          : begin
                                inc(Msize,nListStep*2);
                                setlength(C,Msize);
                                setlength(CNum,Msize);
                              end;
              Prihod        : begin
                                setlength(P,Msize);
                                setlength(PNum,Msize);
                              end;
              Rashod        : begin
                                setlength(R,Msize);
                                setlength(RNum,Msize);
                              end;
            end;
          end;
        if nu>N then N:=nu;
      end
    end;

function QueryArr(ar:integer):boolean;
begin
  qp.sync:=A[ar].info.changed.t64;
  qp.sl[0]:='A';
  qp.sl[1]:=ArrChar(ar);
  try
    c1.TCPc.WriteBuffer(qp,sizeofqp,true);
    c1.TCPc.ReadBuffer(ap,sizeofap);
    Result:=ap.ans.num<>0;
   except
    c1.TCPc.Disconnect;
    result:=false;
  end;
end;

procedure CutArr(ar,num:integer);
  begin
    with A[ar].info do
      if num<>last then
        case ar of
          Tovar  : with T[num].state do
                     begin
                       if prev<>0 then T[prev].state.next:=next;
                       if next<>0 then T[next].state.prev:=prev
                     end;
          Cart   : with C[num].state do
                     begin
                       if prev<>0 then C[prev].state.next:=next;
                       if next<>0 then C[next].state.prev:=prev
                     end;
          Prihod : with P[num].state do
                     begin
                       if prev<>0 then P[prev].state.next:=next;
                       if next<>0 then P[next].state.prev:=prev
                     end;
          Rashod : with R[num].state do
                     begin
                       if prev<>0 then R[prev].state.next:=next;
                       if next<>0 then R[next].state.prev:=prev
                     end;
        end;
  end;

procedure SetLastArr(ar,num:integer);
  begin
    with A[ar].info do
      if last<>num then
        case ar of
          Tovar  : with T[num].state do
                     begin
                       if last<>0 then T[last].state.next:=num;
                       prev:=last;
                       next:=0;
                       last:=num;
                     end;
          Cart   : with  C[num].state do
                     begin
                       if last<>0 then C[last].state.next:=num;
                       prev:=last;
                       next:=0;
                       last:=num;
                     end;
          Prihod : with P[num].state do
                     begin
                       if last<>0 then P[last].state.next:=num;
                       prev:=last;
                       next:=0;
                       last:=num;
                     end;
          Rashod : with R[num].state do
                     begin
                       if last<>0 then R[last].state.next:=num;
                       prev:=last;
                       next:=0;
                       last:=num;
                     end;
        end;
    case ar of
      Tovar : A[Tovar].info.changed:=T[num].state.tim;
      Cart  : A[Cart].info.changed:=C[num].state.tim;
      Prihod: A[Prihod].info.changed:=P[num].state.tim;
      Rashod: A[Rashod].info.changed:=R[num].state.tim;
    end;
  end;

procedure AddArrRec(ar,num:integer; const my:boolean=false; const mystat:integer=-1);
begin
  ResizeArr(ar,num);
 with ap do
  case ar of
    Tovar : with T[num] do
              with state do
                begin
                  lock:=NullLock;
                  AddNumL(Tip,tt.rec.tip,num);
                  AddNumL(Mat,tt.rec.mat,num);
                  AddNumL(Firm,tt.rec.firm,num);
                  if my then
                    begin
                      rec:=tt.rec;
                      tim:=ans.timS;
                      FillMyAct(creat,ans.timS);
                      edit.tim.t64:=0;
                    end
                   else
                    state:=tt;
                end;
    Cart  : with C[num] do
              with state do
                begin
                  lock:=NullLock;
                  AddNumL(Size,cc.rec.base.siz,num);
                  AddNumTovar(cc.rec.base.tov,num);
                  state:=cc;
                end;
    Prihod: with P[num] do
              with state do
                begin
                  lock:=NullLock;
                  AddNumL(Agent,pp.rec.agent,num);
                  if my then
                    begin
                      rec:=pp.rec;
                      status:=stOpen;
                      tim:=ap.ans.timS;
                      FillMyAct(creat,ans.timS);
                      FillMyAct(open,ans.timS);
                      FillMyAct(edit,ans.timS);
                      ann.tim.t64:=0;
                      exec.tim.t64:=0;
                    end
                   else
                    state:=pp;
                end;
    Rashod: ;
    Sale  : ;
  end;
  SetLastArr(ar,num);
end;

procedure ChangeArrRec(ar,num:integer; const my:boolean=false; const mystat:integer=-1);
begin
  CutArr(ar,num);
  with ap do
  case ar of
    Tovar   :  with T[num] do
                 with state do
                   begin
                     if rec.tip<>tt.rec.tip then MoveNumL(Tip,rec.tip,tt.rec.tip,num);
                     if rec.mat<>tt.rec.mat then MoveNumL(Mat,rec.mat,tt.rec.mat,num);
                     if rec.firm<>tt.rec.firm then MoveNumL(Firm,rec.firm,tt.rec.firm,num);
                     if my then
                       begin
                         rec:=tt.rec;
                         tim:=ans.timS;
                         FillMyAct(edit,tim);
                       end
                      else
                       state:=tt;
                   end;
        Cart    : with C[num] do
                    with state.rec.base do
                      begin
                        if tov<>cc.rec.base.tov then
                          MoveNumTovar(tov,cc.rec.base.tov,num);
                        if siz<>cc.rec.base.siz then
                          MoveNumL(Size,siz,cc.rec.base.siz,num);
                        state:=cc;
                      end;
        Prihod  : with P[num] do
                    if my and (mystat>=stReady)then
                      begin
                        state.status:=mystat;
                        state.tim:=ans.timS;
                        case mystat of
                          stOpen : FillMyAct(state.open,ans.timS);
                          stExec : FillMyAct(state.exec,ans.timS);
                          stAnn  : FillMyAct(state.ann,ans.timS);
                        end;
                 //       state.rec:=pp.rec ;
                      end
                     else
                      begin
                        if state.rec.agent<>pp.rec.agent then
                          MoveNumL(Agent,state.rec.agent,pp.rec.agent,num);
                        state:=pp;
                      end;
        Rashod  : with R[num] do
                    if my and (mystat>=stReady)then
                      begin
                        state.status:=mystat;
                        state.tim:=ans.timS;
                        case mystat of
                          stOpen : FillMyAct(state.open,ans.timS);
                          stExec : FillMyAct(state.exec,ans.timS);
                          stAnn  : FillMyAct(state.ann,ans.timS);
                        end;
                   //     state.rec:=rr.rec ;
                      end
                     else
                      begin
                        if state.rec.agent<>rr.rec.agent then
                          MoveNumL(Agent,state.rec.agent,rr.rec.agent,num);
                        state:=rr;
                      end;
      end;
  SetLastArr(ar,num);
end;

function RefreshArr(ar:integer):boolean;
  var
    i,nu: integer;
  procedure SetArrRec;
    begin
      if nu>A[ar].info.N then AddArrRec(ar,nu)
                 else ChangeArrRec(ar,nu);
    end;
  begin
    qp.sl[2]:='S';
    Result:=QueryArr(ar);
    if not Result then exit;
    nu:=ap.ans.num;
    if ap.ans.count=1 then
      SetArrRec
     else
      begin
        case ar of
          Tovar  :  for i:=1 to ap.ans.count do
                     begin
                       c1.TCPc.ReadBuffer(ap.tt,sizeof(tTovarState));
                       SetArrRec;
                       nu:=ap.tt.next;
                     end;
          Cart   :  for i:=1 to ap.ans.count do
                     begin
                       c1.TCPc.ReadBuffer(ap.cc,sizeof(tCartState));
                       SetArrRec;
                       nu:=ap.cc.next;
                     end;
          Prihod :  for i:=1 to ap.ans.count do
                     begin
                       c1.TCPc.ReadBuffer(ap.pp,sizeof(tPrihState));
                       SetArrRec;
                       nu:=ap.pp.next;
                     end;
          Rashod :  for i:=1 to ap.ans.count do
                     begin
                       c1.TCPc.ReadBuffer(ap.rr,sizeof(tRashState));
                       SetArrRec;
                       nu:=ap.rr.next;
                     end;
        end
      end;
    end;

  function GetTovarCode(tt,tm,tf:integer; const art:tArt; const opis:tOpis):integer;
    var
      i,j,k,nt:integer;
    begin
      for i:=0 to Lnum[Tip][tt].ctrl.NN-1 do
        begin
          nt:=Lnum[Tip][tt].nums[i];
          for j:=0 to Lnum[Mat][tm].ctrl.NN-1 do
            if nt=Lnum[Mat][tm].nums[j] then
              for k:=0 to Lnum[Firm][tf].ctrl.NN-1 do
                if (nt=Lnum[Firm][tf].nums[k])and
                   (AnsiCompareText(T[nt].state.rec.opis,opis)=0)and
                   (AnsiCompareText(T[nt].state.rec.art,art)=0) then
                  begin
                    Result:=nt;
                    exit
                  end;
        end;
      Result:=0;
    end;

  function CheckArrRange(ar:integer;num:integer):boolean;
    begin
      Result:=(num<=A[ar].info.N)and(num>0);
    end;

  function AddNewA(ar:integer; const na: tRecArr):integer;
    begin
      qp.sl[2]:='A';
      qp.recA:=na;
      QueryArr(ar);
      Result:=ap.ans.num;
      if ap.ans.prevS.t64<>A[ar].info.changed.t64 then RefreshArr(ar)
       else
        if Result<>0 then
          begin
            Move(na,ap.tt,sizeof(tRecArr));
            AddArrRec(ar,Result,true);
          end;
    end;

function ChangeArr(ar,num:integer; const ch:tRecArr):boolean;
begin
  if CheckArrRange(ar,num) {and FindSame(ar,ch,num)=0} then
    begin
      qp.sl[2]:='C';
      qp.num:=num;
      qp.recA:=ch;
      Result:=QueryArr(ar);
      if ap.ans.prevS.t64<>A[ar].info.changed.t64 then RefreshArr(ar)
       else
        if Result then
          begin
            Move(ch,ap.tt,sizeof(tRecArr));
            ChangeArrRec(ar,num,true);
          end;
    end
   else
    Result:=false;
end;

function CheckHod(ar,num,stat:integer):boolean;
var
  os:integer;
begin
  if ar=Prihod then os:=P[num].state.status
   else os:=R[num].state.status;
  Result:=(os<=stOpen)and( ((os=stReady)and(stat=stOpen))or(os=stOpen));
end;

function ChangeNaklStatus(ar,num,stat:integer):boolean;
var
  i:integer;
begin
  if CheckArrRange(ar,num) and CheckHod(ar,num,stat) then
    begin
      case stat of
        stReady : qp.sl[2]:='F';
        stOpen  : qp.sl[2]:='O';
        stExec  : qp.sl[2]:='E';
        stAnn   : qp.sl[2]:='N';
      end;
      qp.num:=num;
      qp.xx:=stat;
      Result:=QueryArr(ar);
      if ap.ans.prevS.t64<>A[ar].info.changed.t64 then RefreshArr(ar)
       else
        if Result then
          ChangeArrRec(ar,num,true,stat);
      if Result and (stat=stExec) then
        if ar=Prihod then
          with PNum[qp.num] do
            for i:=0 to ctrl.Nrows-1 do
              rows[i].pp.cartnum:=ap.ans.count+i
         else {Rashod};
    end
   else
    Result:=false;
end;

function ReadA(ar:integer; num:integer):boolean;
begin
  qp.sl[2]:='R';
  qp.num:=num;
  Result:=QueryArr(ar);
  if ap.ans.prevS.t64<>A[ar].info.changed.t64 then RefreshArr(ar)
   else
    if Result then
      ChangeArrRec(ar,num);
end;

  function FindMatchList(li,start:integer; const str:string):integer;
    begin
      if CheckListRange(li,start) then
        for Result:=start to L[li].info.N do
          if MatchInStr(str, Lstat[li][Result].rec.pos.nam) then
            exit;
      Result:=0;
    end;

  function IsTovarTextMatch(tov:integer; const tar:tArt; const top: tOpis):boolean;
    begin
      with T[tov].state.rec do
        Result:=MatchInStr(tar,art) and
                MatchInStr(top,opis);
    end;

  function FindMatchTovar(start,ti,ma,fi:integer; const tar:tArt; const top: tOpis):integer;
    var
      n : integer;
      ind     : array [0..2] of integer;
      ia      : array [0..2] of tNumArr;
    begin
      if CheckArrRange(Tovar,start)and(ti<>0)and(ma<>0)and(fi<>0) then
        begin
          n:=0;
          if ti>0 then
            begin
              ia[n]:=Lnum[Tip][ti];
          //    ind[n]:=ti;
              inc(n);
            end;
          if ma>0 then
            begin
              ia[n]:=Lnum[Mat][ma];
          //    ind[n]:=ma;
              inc(n);
            end;
          if fi>0 then
            begin
              ia[n]:=Lnum[Firm][fi];
          //    ind[n]:=fi;
              inc(n);
            end;
          case n of
            3 : begin
                  for n:=0 to 2 do ind[n]:=0;
                  repeat
                    Result:=FindMatch3Int(ia[0],ia[1],ia[2],ind[0],ind[1],ind[2]);
                  until (start<=Result)or(Result=0);
                  Result:=Result*ord(IsTovarTextMatch(Result,tar,top));
                //  if (Result>0)and IsTovarTextMatch(Result,tar,top) then
                  exit;
                end;
            2 : begin
                  ind[0]:=0; ind[1]:=0;
                  repeat
                    Result:=FindMatch2Int(ia[0],ia[1],ind[0],ind[1]);
                  until (start<=Result)or(Result=0);
                  Result:=Result*ord(IsTovarTextMatch(Result,tar,top));
      //           if (Result>0)and IsTovarTextMatch(Result,tar,top) then
                  exit;
                end;
            1 : with ia[0] do
                  for n:=0 to ctrl.NN-1 do
                    begin
                      Result:=nums[n];
                      if (Result>=start) and IsTovarTextMatch(Result,tar,top) then exit;
                    end;
            0 : for Result:=start to A[Tovar].info.N do
                  if IsTovarTextMatch(Result,tar,top) then exit;
          end;
        end;
      Result:=0;
    end;

function MatchTovarText(start:integer; const Rti,Rma,Rfi:tNam; const Rar:tArt; const Rop:tOpis):integer;
  var
    iti,ima,ifi:integer;
  begin
    Result:=0;
    if CheckArrRange(Tovar,start) then
      begin
        iti:=-1;
        if Rti<>'' then iti:=FindMatchList(Tip,1,Rti);
        if iti=0 then exit;
        repeat
          ima:=-1;
          if Rma<>'' then ima:=FindMatchList(Mat,ima+1,Rma);
          while ima<>0 do
            begin
              ifi:=-1;
              if Rfi<>'' then ifi:=FindMatchList(Firm,ifi+1,Rfi);
              while ifi<>0 do
                begin
                  Result:=FindMatchTovar(start,iti,ima,ifi,Rar,Rop);
                  if Result<>0 then exit;
                  if ifi>0 then ifi:=FindMatchList(Firm,ifi+1,Rfi);
                end;
              if ima>0 then ima:=FindMatchList(Mat,ima+1,Rma);
            end;
          if ifi>0 then ifi:=FindMatchList(Tip,iti+1,Rti);
        until iti<=0;
      end;
   end;

  procedure ResizeSubArr(ar,num,ns:integer);
    begin
      case ar of
        Tovar   : ResizeNum(TNum[num],ns);
        Cart    : ResizeRA(num,ns);
        Prihod  : ResizeNum(PNum[num],ns);
        Rashod  : ResizeNum(RNum[num],ns);
      end;
    end;

{  procedure SaveSubArr(ar:integer; num:integer);
   var
     fi:file of integer;
     fc:file of integer;
     fp:file of tPrihRow;
     fr:file of tRashRow;
   begin
     case ar of
       Tovar   : with T[num] do
                   begin
                     assignfile(fc,TovarDir+IntToHex(num,8));
                     rewrite(fc);
                     BlockWrite(fc,ca[0],length(ca));
                     closefile(fc);
                     notsaved:=false;
                   end;
       Cart    : with C[num] do
                   begin
                     assignfile(fi,CartDir+IntToArt(num));
                     rewrite(fi);
                     BlockWrite(fi,ra[0],length(ra));
                     closefile(fi);
                     notsaved:=false
                   end;
       Prihod  : with P[num] do
                   begin
                     assignfile(fp,PrihDir+IntToArt(num));
                     rewrite(fp);
                     BlockWrite(fp,rows[0],state.Npos);
                     closefile(fp);
                     notsaved:=false;
                   end;
       Rashod  : with R[num] do
                   begin
                     assignfile(fr,RashDir+IntToArt(num));
                     rewrite(fr);
                     BlockWrite(fr,rows[0],state.Npos);
                     closefile(fr);
                     notloaded:=false;
                   end;
     end;
    end;

  procedure LoadSubArr(ar:integer; num:integer);
   var
     fi:file of integer;
     fc:file of integer;
     fp:file of tPrihRow;
     fr:file of tRashRow;
     lf:string;
     nn:integer;
   begin
     case ar of
       Tovar   : begin
                   lf:=TovarDir+IntToArt(num);
                   if fileexists(lf) then
                     with T[num] do
                       begin
                         assignfile(fc,lf);
                         reset(fc);
                         nn:=filesize(fc)-state.nust.first;
                         seek(fc,state.nust.first);
                         resizeSubArr(ar,num,nn);
                         BlockRead(fc,ca[0],nn);
                         closefile(fc);
                         notsaved:=false;
                       end;
                 end;
       Cart    : begin
                   lf:=TovarDir+IntToArt(num);
                   if fileexists(lf) then
                     begin
                       assignfile(fi,lf);
                       reset(fi);
                       nn:=filesize(fi);
                       resizeSubArr(ar,num,nn);
                       BlockRead(fi,C[num].ra[0],nn);
                       closefile(fi);
                     end;
                   C[num].flags:=[flSaved]+[flLoaded];
                 end;
       Prihod  : begin
                   lf:=TovarDir+IntToArt(num);
                   if fileexists(lf) then
                     begin
                       assignfile(fp,lf);
                       reset(fp);
                       nn:=filesize(fp);
                       P[num].state.Npos:=nn;
                       resizeSubArr(ar,num,nn);
                       BlockRead(fp,P[num].rows[0],nn);
                       closefile(fp);
                     end;
                   P[num].flags:=[flSaved]+[flLoaded];
                 end;
       Rashod  : begin
                   lf:=TovarDir+IntToArt(num);
                   if fileexists(lf) then
                     begin
                       assignfile(fr,lf);
                       reset(fr);
                       nn:=filesize(fr);
                       R[num].state.Npos:=nn;
                       resizeSubArr(ar,num,nn);
                       BlockRead(fr,R[num].rows[0],nn);
                       closefile(fr);
                     end;
                   R[num].flags:=[flSaved]+[flLoaded];
                 end;
     end;
    end;
}
  function ReceiveSubArr(ar:integer; num:integer):boolean;
    var
      i:integer;
    begin
      qp.sl[2]:='Q';
      qp.num:=num;
      Result:=QueryArr(ar);
      if Result and(num=ap.ans.num) then
        begin
          resizeSubArr(ar,ap.ans.num,ap.ans.count);
          case ar of
             Tovar  : with TNum[num] do
                        begin
                          ctrl.Ntim:=ap.ans.timS;
                          c1.TCPc.ReadBuffer(nums[0],ap.ans.count*4);
                        end;
             Cart   : with CNum[num] do
                        begin
                          ctrl.Ntim:=ap.ans.timS;
                          c1.TCPc.readbuffer(ra[0],ap.ans.count*sizeof(tArrDocPos));
                        end;
             Prihod : with PNum[num] do
                        begin
                          ctrl.Ntim:=ap.ans.timS;
                          if ap.ans.count<=4 then
                            for i:=0 to ap.ans.count-1 do
                              rows[i]:=ap.na[i]
                           else
                            begin
                              for i:=0 to 3 do
                                rows[i]:=ap.na[i];
                              for i:=4 to ap.ans.count-1 do
                                c1.TCPc.readbuffer(rows[i],sizeof(tNaklRow));
                            end
                        end;
             Rashod : with RNum[num] do
                        begin
                          ctrl.Ntim:=ap.ans.timS;
                          c1.TCPc.readbuffer(rows[0],ap.ans.count*sizeof(tNaklRow));
                        end;
           end;
       end;
    end;

  function SendSubArr(ar:integer; num:integer):boolean;
    begin
      qp.sl[2]:='T';
      qp.num:=num;
      case ar of
        Prihod: begin
                  qp.xx:=PNum[num].ctrl.Nrows;
                  qp.tim:=PNum[num].ctrl.Ntim;
                end;
        Rashod: begin
                  qp.xx:=RNum[num].ctrl.Nrows;
                  qp.tim:=RNum[num].ctrl.Ntim;
                end
       else
        qp.xx:=0;
      end;
      try
        c1.TCPc.WriteBuffer(qp,sizeofqp,true);
          case ar of
            Prihod   : with PNum[num] do
                         c1.TCPc.writebuffer(rows[0],ctrl.Nrows*sizeof(tNaklRow),true);
            Rashod   : with RNum[num] do
                         c1.TCPc.writebuffer(rows[0],ctrl.Nrows*sizeof(tNaklRow),true);
          end;
        Result:=true;
       except
          showmessage('не отправляется');
          Result:=false;
      end;
    end;
{___________________________________________________________________________________________}
{working}
function IndexList(var CB:TcomboBox; li:integer):integer;
begin
  for Result:=1 to L[li].info.N do
    if AnsiSameText(CB.Text,Lstat[li][Result].rec.pos.nam) then Exit;
  Result:=0;
end;

procedure LoadCB(var CB:TComboBox; li:integer);
var
  i:integer;
begin
  CB.Items.Clear;
  for i:=1 to L[li].info.N do CB.Items.Add(Lstat[li][i].rec.pos.nam);
end;

end.

