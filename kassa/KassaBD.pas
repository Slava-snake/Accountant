unit KassaBD;

interface
  uses login_,SysUtils,StrUtils,Atypes,StdCtrls,Dialogs;

const
  Money='грн';

type
  tcheq = record
    cheqnum : integer;
    ok      : boolean;
    stat    : tChequeStat;
    pos     : array of tChequePos;
  end;

var
  MyKass  : tKassa;
  Nserver    : integer = 0;
  BDtime,delta: tDatTim;
  qp : tQueryPacket;
  ap : tAnswerPacket;
  sizeofap    : integer=sizeof(tAnswerPacket);
  sizeofqp    : integer=sizeof(tQueryPacket);
  A         : array [Tovar..Sale]  of tMas;
  L         : array [Tip..Agent]   of tMas;
  Lstat     : array [Tip..Agent]   of tLstate;
  Cat       : array [Tip..Agent]   of tMas;
  Cstat     : array [Tip..Agent]   of tCstate;
  T         : array of tTovar;
  C         : array of tCart;
  AN         : array [Tovar..Sale] of tMas;
  LN,CNN,CLN : array [Tip..Agent]  of tMas;
  CNum       : array of tDocPosArr;
  TNum       : array of tNumArr;
  LNum,CatNNum,CatLNum   : array [Tip..Agent]   of tListRecNums;
  Cheq       : array [0..9] of tCheq;
  TodayArr   : array of tTodayCheque;
  Ncheq      : integer=0;

  procedure ResizeCat(ca:integer; const np:integer=1);
  function RefreshCat(ca:integer):boolean;
  function CheckCatRange(ca:integer; po:integer):boolean;

  function CheckArrRange(ar:integer;num:integer):boolean;
  function RefreshArr(ar:integer):boolean;
  procedure ResizeSubArr(ar,num,ns:integer);
  procedure ResizeArr(ar:integer; nu:integer);
  procedure CutArr(ar,num:integer);
  procedure SetLastArr(ar,num:integer);
  function QueryKass:boolean;

  function  GetCBlist(const CB:tComboBox):integer;
  procedure LoadCB(var cb:tComboBox; li:integer);
  function  RefreshList(li:integer):boolean;
  function CheckList(li:integer; const tx:tNam):boolean;
  function FindInList(li,start:integer; const xx:tNam):integer;
  function CheckListRange(li:integer; po:integer):boolean;
  procedure ResizeList(li:integer; const np:integer=1);

function GetTovarCode(tt,tm,tf:integer; const art:tArt; const opis:tOpis):integer;
function  FindCartByTovarSize(SaleTovar,SaleSize:integer):integer;

function  KassaOpen:boolean;
function  KassaDeposit(mon:integer):boolean;
function  KassaWithdrawal(mon:integer):boolean;
function  KassaX:boolean;
function  KassaZ:boolean;
function  KassaClose:boolean;
function  ReservePos:boolean;
function  SaleCheque(tab:integer):boolean;
function  AnnulCheque(tab:integer):boolean;

  function FindMatchList(li,start:integer; const str:string):integer;
  function FindMatchTovar(start,ti,ma,fi:integer; const tar:tArt; const top: tOpis):integer;
  function MatchTovarText(start:integer; const Rti,Rma,Rfi:tNam; const Rar:tArt; const Rop:tOpis):integer;

  function AddNumL(li,ind,nu:integer):boolean;
  function DelNumL(li,ind,nu:integer):boolean;
  function MoveNumL(li,idel,iadd,nu:integer):boolean;
function  NumEmpty(var X:tNumArr):boolean;
function InsertNum(var X:tNumArr; nu:integer):integer;
function InsertDocPos(num,nd,np:integer):boolean;
function DeleteNum(var X:tNumArr; nu:integer):integer;
function DeleteDocPos(num,nd,np:integer):boolean;
procedure InsertCartNum(nn,nu:integer);

implementation

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
        oper:=KassOper;
      end;
  end;

  function IntToArt(n:integer):tArt;
    begin
      Result:=format('%9.9d',[n]);
    end;
{-------------------------------------------------------------}
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
                ShiftNum(X,Result,-1);
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
        {if (Nfirst<>0)and(nums[0]>nu)then
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
          end;   }
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

function  GetCBlist(const CB:tComboBox):integer;
begin
  Result:=CB.Items.indexOf(CB.text);
  if Result>=0 then
    CB.ItemIndex:=Result
   else
    if CB.Text='' then dec(Result);
  inc(Result);
end;

procedure LoadCB(var cb:tComboBox; li:integer);
var
  i:integer;
begin
  cb.Clear;
  for i:=1 to L[li].info.N do
    cb.Items.Append(Lstat[li][i].rec.pos.nam);
end;

  function CheckListRange(li:integer; po:integer):boolean;
    begin
      with L[li].info do
        Result:=(po<=N)and(po>0);
    end;

  function GetListNam(li:integer; nn:integer):tNam;
    begin
      if CheckListRange(li,nn) then Result:=Lstat[li][nn].rec.pos.nam
       else Result:=''
    end;

  function GetNumL(li:integer; const tx:tNam):integer;
    var
      i:integer;
    begin
      if tx<>'' then
        for i:=1 to L[li].info.N do
          if AnsiCompareText(Lstat[li][i].rec.pos.nam,tx)=0 then
            begin
              Result:=i;
              exit
            end;
      Result:=0;
    end;

  function CheckList(li:integer; const tx:tNam):boolean;
    begin
      Result:=GetNumL(li,tx)>0;
    end;

    function ListFindByName(li:integer; const xx:tNam; const excl:integer=0):integer;
      var
        i:integer;
      begin
        for i:=1 to L[li].info.N do
          if (i<>excl)and(AnsiCompareText(xx,Lstat[li][i].rec.pos.nam)=0) then
            begin
              Result:=i;
              exit;
            end;
        Result:=0;
      end;

    function FindInList(li,start:integer; const xx:tNam):integer;
      var
        i:integer;
      begin
        if CheckListRange(li,start) then
          for i:=start to L[li].info.N do
            if MatchInStr(xx,Lstat[li][i].rec.pos.nam) then
              begin
                Result:=i;
                exit
              end;
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
    ap.ans.num:=-1;
    ConServ.c1.WriteBuffer(qp,sizeofqp,true);
    ConServ.c1.ReadBuffer(ap,sizeofap);
    Result:=ap.ans.num>0;
   except
    ConServ.c1.Disconnect;
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
    if not Result then exit;
    if ap.ans.count=1 then
      SetListRec(ap.ans.num)
     else
      begin
        nu:=ap.ans.num;
        for i:=1 to ap.ans.count do
          begin
            ConServ.c1.ReadBuffer(ap.ll,sizeof(tListRec));
            SetListRec(nu);
            nu:=ap.ll.next;
          end;
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
    ap.ans.num:=-1;
    ConServ.c1.WriteBuffer(qp,sizeofqp,true);
    ConServ.c1.ReadBuffer(ap,sizeofap);
    Result:=ap.ans.num>0;
   except
    ConServ.c1.Disconnect;
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
    if not Result then exit;
    if ap.ans.count=1 then
      SetCatRec(ap.ans.num)
     else
      begin
        nu:=ap.ans.num;
        for i:=1 to ap.ans.count do
          begin
            ConServ.c1.ReadBuffer(ap.ca,sizeof(tCatRec));
            SetCatRec(nu);
            nu:=ap.ca.next;
          end;
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
var
  i:integer;
begin
  with A[ar] do
    with info do
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
              Sale          : begin
                                setlength(TodayArr,Msize);
                              end;
            end;
          end;
        if nu>N then N:=nu;
        First:=ofs+1;
      end
    end;

function QueryArr(ar:integer):boolean;
begin
  qp.sync:=A[ar].info.changed.t64;
  qp.sl[0]:='A';
  qp.sl[1]:=ArrChar(ar);
  try
    ap.ans.num:=-1;
    ConServ.c1.CheckForDisconnect(false);
    ConServ.c1.WriteBuffer(qp,sizeofqp,true);
    ConServ.c1.ReadBuffer(ap,sizeofap);
    Result:=ap.ans.num>0;
   except
    ConServ.c1.Disconnect;
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
          Sale   : with TodayArr[num].header do
                     begin
                       if prev<>0 then TodayArr[prev].header.next:=next;
                       if next<>0 then TodayArr[next].header.prev:=prev
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
          Sale   : with TodayArr[num].header do
                     begin
                       if last<>0 then TodayArr[last].header.next:=num;
                       prev:=last;
                       next:=0;
                       last:=num;
                     end
        end;
    case ar of
      Tovar : A[Tovar].info.changed:=T[num].state.tim;
      Cart  : A[Cart].info.changed:=C[num].state.tim;
      Sale  : A[Sale].info.lasttim:=TodayArr[num].header.stat.tim;
    end;
  end;

procedure AddArrRec(ar,num:integer; const mystat:integer=-1);
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
    Sale  : TodayArr[num].header:=ap.tch;
  end;
  SetLastArr(ar,num);
end;

procedure ChangeArrRec(ar,num:integer; const mystat:integer=-1);
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
                     state:=tt;
                   end;
        Cart    : with C[num] do
                   with state.rec do
                    begin
                      if base.tov<>cc.rec.base.tov then MoveNumTovar(base.tov,cc.rec.base.tov,num);
                      state:=cc;
                    end;
        Sale     : TodayArr[num].header:=ap.tch;
      end;
  SetLastArr(ar,num);
end;

function RefreshArr(ar:integer):boolean;
var
  i,nu: integer;
 procedure SetArrRec(num:integer);
   begin
     if num>A[ar].info.N then AddArrRec(ar,num)
      else ChangeArrRec(ar,num);
   end;
begin
    qp.sl[2]:='S';
    Result:=QueryArr(ar);
    if not Result then exit;
    if ap.ans.count=1 then
      SetArrRec(ap.ans.num)
     else
      begin
        nu:=ap.ans.num;
        case ar of
          Tovar  :  for i:=1 to ap.ans.count do
                     begin
                       ConServ.c1.ReadBuffer(ap.tt,sizeof(tTovarState));
                       SetArrRec(nu);
                       nu:=ap.tt.next;
                     end;
          Cart   :  for i:=1 to ap.ans.count do
                     begin
                       ConServ.c1.ReadBuffer(ap.cc,sizeof(tCartState));
                       SetArrRec(nu);
                       nu:=ap.cc.next;
                     end;
          Prihod :  for i:=1 to ap.ans.count do
                     begin
                       ConServ.c1.ReadBuffer(ap.pp,sizeof(tPrihState));
                       SetArrRec(nu);
                       nu:=ap.pp.next;
                     end;
          Rashod :  for i:=1 to ap.ans.count do
                     begin
                       ConServ.c1.ReadBuffer(ap.rr,sizeof(tRashState));
                       SetArrRec(nu);
                       nu:=ap.rr.next;
                     end;
          Sale   : for i:=1 to ap.ans.count do
                     begin
                       Conserv.c1.ReadBuffer(ap.tch,sizeof(tTodayChequeHeader));
                       SetArrRec(nu);
                       nu:=ap.tch.next;
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

  function no0(const X; n:integer):boolean;
    asm
   @comp:
      test byte ptr[eax],$FF
      jnz @ex
      inc eax
      dec edx
      jnz @comp
    @ex:
      ret
    end;

{==++++++++++++++++============+++++++++++++++++++++++++++++++++++++}
  procedure ResizeSubArr(ar,num,ns:integer);
    begin
      case ar of
        Tovar   : ResizeNum(TNum[num],ns);
        Cart    : ResizeRA(num,ns);
      end;
    end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
function QueryKass:boolean;
var
  i:integer;
begin
  qp.sync:=A[Sale].info.changed.t64;
  qp.sl[0]:='K';
  with ConServ.c1 do
    try
      ap.ans.num:=-1;
      WriteBuffer(qp,sizeofqp,true);
      if qp.sl[2]<>'P' then
        begin
          ReadBuffer(ap,sizeofap);
          Result:= ap.ans.num>0;
        end
       else {cheque positions}
        with TodayArr[qp.num+A[Sale].info.ofs] do
         with header.stat do
          begin
            if status>csOpen then setlength(chpos,Npos)
             else setlength(chpos,Nres);
            fillChar(chpos[Npos-1],sizeof(tChequePos),0);
            i:=sizeof(tChequePos)*header.stat.Npos;
            ReadBuffer(chpos[0],i);
            Result:= no0(chpos[Npos-1],sizeof(tChequePos));
          end;
       except
        Disconnect;
        result:=false;
      end;
end;

function  KassaOpen:boolean;
  begin
    qp.sl[1]:='O';
    Result:=QueryKass;
    if Result then
      begin
        MyKass.OpenStatus:=true;
        {writelog KASSA OPENED
           ap.ans.timS           }
        Mykass.Date:=GetTodayDat;
      end
     else
      begin
        MyKass.OpenStatus:=false;
       {writelog OPENNING ERROR };
        if ap.ans.num=-1 then
          showmessage('Сервер не отвечает.');
      end;
  end;

function  KassaDeposit(mon:integer):boolean;
  begin
    qp.sl[1]:='D';
    qp.xx:=mon;
    Result:=QueryKass;
    if Result then
      inc(MyKass.Cash,mon)
     else
      begin
       {writelog  ERROR };
        if ap.ans.num=-1 then
          showmessage('Сервер не отвечает.');
      end;
  end;

function  KassaWithdrawal(mon:integer):boolean;
  begin
    if mon>MyKass.Cash then
      begin
        showmessage('В кассе меньше.');
        exit;
      end;
    qp.sl[1]:='W';
    qp.xx:=mon;
    Result:=QueryKass and (ap.ans.num=CLnum);
    if Result then
      dec(MyKass.Cash,mon)
     else
      begin
       {writelog  ERROR };
        if ap.ans.num=-1 then
          showmessage('Сервер не отвечает.');
      end;
  end;

procedure KassReport;
begin
  with MyKass do
    if CompareMem(@ap.aa,@Cash,12) then
      ShowMessage('    X отчёт'+#13+
                  'Дата: '+DatToStr(date)+#13+
                  'внесено: '+inttostr(Cash-Receipts+Cashless)+#13+
                  'наличные: '+inttostr(Cash)+#13+
                  'безнал: '+inttostr(Cashless)+#13+
                  'Выторг: '+inttostr(Receipts) )
     else
      ShowMessage('    X отчёт не совпадает с сервером !'+#13+#13+
                  'Дата: '+DatToStr(date)+#13+
                  '        эта касса  - сервер'+#13+
                  'внесено: '+inttostr(Cash-Receipts+Cashless)+' - '+inttostr(ap.aa[0]+ap.aa[1]-ap.aa[2])+#13+
                  'наличные: '+inttostr(Cash)+' - '+inttostr(ap.aa[0])+#13+
                  'безнал: '+inttostr(Cashless)+' - '+inttostr(ap.aa[1])+#13+
                  'Выторг: '+inttostr(Receipts)+' - '+inttostr(ap.aa[2]) )

end;

function  KassaX:boolean;
begin
  qp.sl[1]:='X';
  Result:=QueryKass;
  if Result then KassReport
end;

function  KassaZ:boolean;
begin
  qp.sl[1]:='Z';
  Result:=QueryKass;
  if Result then
    begin
      KassReport;
      FillChar(MyKass.Cash,12,0);
    end;
end;

function  KassaClose:boolean;
  begin
    if MyKass.Cash>0  then
      begin
        showmessage('Не сделан вынос из кассы.');
        exit;
      end;
    if MyKass.Receipts>0  then
      begin
        showmessage('Не сделан Z-отчёт кассы.');
        exit;
      end;
    qp.sl[1]:='C';
    Result:=QueryKass;
    if Result then
      begin
        MyKass.OpenStatus:=false;
        {writelog KASSA OPENED
           ap.ans.timS           }
      end
     else
      begin
       {writelog CLOSING ERROR };
        if ap.ans.num=-1 then
          showmessage('Сервер не отвечает.');
      end;
  end;

function ReservePos:boolean;
begin
  qp.sl[1]:='P';
  qp.sl[2]:='A';
  Result:=QueryKass;
  if Result then
    begin
      RefreshArr(Cart);
      with qp.srp do
        begin
          TodayArr[doc].header.stat.tim:=GetTim(ap.ans.timS);
          SetLastArr(Sale,doc);
        end
    end;
end;

procedure CloseCheq(tab:integer);
  var
    i:integer;
  begin
    dec(Ncheq);
    if (Ncheq<>0)or(Ncheq<>tab) then
      for i:=tab to Ncheq-1 do
        Cheq[i]:=Cheq[i+1];
  end;

function AnnulCheque(tab:integer):boolean;
begin
  qp.sl[1]:='A';
  with Cheq[tab] do
    begin
      qp.num:=cheqnum;
      Result:=QueryKass;
      if Result then
        begin
          stat.status:=csAnnul;
          stat.tim:=GetTim(ap.ans.timS);
          TodayArr[cheqnum-A[Sale].info.ofs].header.stat.status:=csAnnul;
          if stat.Npos>0 then
            RefreshArr(Cart);
        end;
    end;
end;

function SaleCheque(tab:integer):boolean;
begin
  with Cheq[tab] do
    with stat do
      begin
        qp.sl[1]:='S';
        qp.num:=cheqnum;
        qp.mon.MonCash:=Cash;
        qp.mon.Monless:=Cashless;
        Result:=QueryKass;
        if Result then
          begin
            status:=csSale;
            tim:=GetTim(ap.ans.timS);
            inc(MyKass.Cash,Cash);
            inc(MyKass.Cashless,Cashless);
            inc(MyKass.Receipts,Cash+Cashless);
            closecheq(tab);
          end
      end;
end;

function  FindCartByTovarSize(SaleTovar,SaleSize:integer):integer;
var
  i:integer;
begin
  with Tnum[SaleTovar] do
    for i:=0 to ctrl.NN-1 do
      with C[nums[i]].state.rec do
        if (ost>0)and(base.siz=SaleSize) then
          begin
            Result:=nums[i];
            exit
          end;
  Result:=0;
end;

{===================================================================================}
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
      ia      : array [0..2] of ^tNumArr;
    begin
      if CheckArrRange(Tovar,start)and(ti<>0)and(ma<>0)and(fi<>0) then
        begin
          n:=0;
          if ti>0 then
            begin
              ia[n]:=@Lnum[Tip][ti];
              ind[n]:=ti;
              inc(n);
            end;
          if ma>0 then
            begin
              ia[n]:=@Lnum[Mat][ma];
              ind[n]:=ma;
              inc(n);
            end;
          if fi>0 then
            begin
              ia[n]:=@Lnum[Firm][fi];
              ind[n]:=fi;
              inc(n);
            end;
          case n of
            3 : begin
                  for n:=0 to 2 do ind[n]:=0;
                  repeat
                    Result:=FindMatch3Int(ia[0]^,ia[1]^,ia[2]^,ind[0],ind[1],ind[2]);
                    for n:=0 to 2 do inc(ind[n]);
                  until (start<=Result)or(Result=0);
                  if (Result>0)and IsTovarTextMatch(Result,tar,top) then exit;
                end;
            2 : begin
                  ind[0]:=0; ind[1]:=0;
                  repeat
                    Result:=FindMatch2Int(ia[0]^,ia[1]^,ind[0],ind[1]);
                    inc(ind[0]); inc(ind[1]);
                  until (start<=Result)or(Result=0);
                  if (Result>0)and IsTovarTextMatch(Result,tar,top) then exit;
                end;
            1 : with ia[0]^ do
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
        if Rti='' then iti:=-1
         else iti:=FindMatchList(Tip,1,Rti);
        if iti=0 then exit;
        repeat
          if Rma='' then ima:=-1
           else ima:=FindMatchList(Mat,ima+1,Rma);
          while ima<>0 do
            begin
              if Rfi='' then ifi:=-1
               else ifi:=FindMatchList(Firm,ifi+1,Rfi);
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



end.
