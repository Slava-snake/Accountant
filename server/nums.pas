unit nums;

interface
  uses data, Atypes, SyncObjs, SysUtils;


var
  LockANum  : array [Tovar..Sale]  of TCriticalSection;
  LockLNum  : array [Tip..Agent]   of TCriticalSection;
  LockCatN,LockCatL      : array [Tip..Agent]   of TCriticalSection;

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

procedure LockNumA(ar:integer);
procedure UnLockNumA(ar:integer);
procedure LockNumArec(ar,nn:integer);
procedure UnlockNumArec(ar,nn:integer);

procedure LockNumL(li:integer);
procedure UnLockNumL(li:integer);
procedure LockNumLrec(li,nn:integer);
procedure UnlockNumLrec(li,nn:integer);
  function AddNumL(li,ind,nu:integer):boolean;
  function DelNumL(li,ind,nu:integer):boolean;
  function MoveNumL(li,idel,iadd,nu:integer):boolean;

procedure LockNumCN(ca:integer);
procedure UnLockNumCN(ca:integer);
procedure LockNumCNrec(ca,nn:integer);
procedure UnlockNumCNrec(ca,nn:integer);

procedure LockNumCL(ca:integer);
procedure UnLockNumCL(ca:integer);
procedure LockNumCLrec(ca,nn:integer);
procedure UnlockNumCLrec(ca,nn:integer);

procedure ResizeNum(var X:tNumPR; const n:integer=0); overload;
function  NumEmpty(var X:tNumArr):boolean;
function InsertNum(var X:tNumArr; nu:integer):integer;
function InsertDocPos(num,nd,np:integer):boolean;
function DeleteNum(var X:tNumArr; nu:integer):integer;
procedure SetLastCatNnum(ca,nn:integer);
procedure SetLastCatLnum(ca,nn:integer);
procedure SetLastListNum(li,nn:integer);
procedure SetLastNumA(ar,nn:integer);
procedure InsertCartNum(nn,nu:integer);

implementation
uses arrs;

procedure LockNumA(ar:integer);
begin
  LockANum[ar].Enter;
  CriticalSetLock(AN[ar].lock);
end;

procedure LockNumArec(ar,nn:integer);
begin
  LockNumA(ar);
  case ar of
    Tovar  : CriticalSetLock(TNum[nn].ctrl.Nlock);
    Cart   : CriticalSetLock(CNum[nn].ctrl.Nlock);
    Prihod : CriticalSetLock(PNum[nn].ctrl.Nlock);
    Rashod : CriticalSetLock(RNum[nn].ctrl.Nlock);
  end;
  AN[ar].lockrec:=nn;
end;

procedure UnlockNumArec(ar,nn:integer);
begin
  case ar of
    Tovar  : ResetLock(TNum[nn].ctrl.Nlock.lock);
    Cart   : ResetLock(CNum[nn].ctrl.Nlock.lock);
    Prihod : ResetLock(PNum[nn].ctrl.Nlock.lock);
    Rashod : ResetLock(RNum[nn].ctrl.Nlock.lock);
  end;
  AN[ar].lockrec:=0;
  UnlockNumA(ar);
end;

procedure UnLockNumA(ar:integer);
begin
  ResetLock(AN[ar].lock.lock);
  LockANum[ar].Leave
end;
{------------------------------}
procedure LockNumL(li:integer);
begin
  LockLNum[li].Enter;
  CriticalSetLock(LN[li].lock);
end;

procedure LockNumLrec(li,nn:integer);
begin
  LockNumL(li);
  CriticalSetLock(LNum[li][nn].ctrl.Nlock);
  LN[li].lockrec:=nn;
end;

procedure UnLockNumL(li:integer);
begin
  ResetLock(LN[li].lock.lock);
  LockLNum[li].Leave
end;

procedure UnlockNumLrec(li,nn:integer);
begin
  ResetLock(LNum[li][nn].ctrl.Nlock.lock);
  LN[li].lockrec:=0;
  UnlockNumL(li);
end;

{-----------------------------------------}
procedure LockNumCN(ca:integer);
begin
  LockCatN[ca].Enter;
  CriticalSetLock(CNN[ca].lock);
end;

procedure LockNumCNrec(ca,nn:integer);
begin
  LockNumCN(ca);
  CriticalSetLock(CatNnum[ca][nn].ctrl.Nlock);
  CNN[ca].lockrec:=nn;
end;

procedure UnLockNumCN(ca:integer);
begin
  ResetLock(CNN[ca].lock.lock);
  LockCatN[ca].Leave
end;

procedure UnlockNumCNrec(ca,nn:integer);
begin
  ResetLock(CatNNum[ca][nn].ctrl.Nlock.lock);
  CNN[ca].lockrec:=0;
  UnlockNumCN(ca);
end;

{-----------------------------------------}

procedure LockNumCL(ca:integer);
begin
  LockCatL[ca].Enter;
  CriticalSetLock(CLN[ca].lock)
end;

procedure LockNumCLrec(ca,nn:integer);
begin
  LockNumCL(ca);
  CriticalSetLock(CatLnum[ca][nn].ctrl.Nlock);
  CLN[ca].lockrec:=nn;
end;

procedure UnLockNumCL(ca:integer);
begin
  ResetLock(CLN[ca].lock.lock);
  LockCatL[ca].Leave
end;

procedure UnlockNumCLrec(ca,nn:integer);
begin
  ResetLock(CatLNum[ca][nn].ctrl.Nlock.lock);
  CLN[ca].lockrec:=0;
  UnlockNumCL(ca);
end;

{-----------------------------------------}

  function AddNumL(li,ind,nu:integer):boolean;
    begin
      LockNumLrec(li,ind);
      Result:=InsertNum(LNum[li][ind],nu)>=0;
      if Result then SetLastListNum(li,ind);
      UnLockNumLrec(li,ind);
    end;

  function MoveNumL(li,idel,iadd,nu:integer):boolean;
    begin
      LockNumLrec(li,idel);
      if DeleteNum(LNum[li][idel],nu)>=0 then SetLastListNum(li,idel);
      CriticalSetLock(LNum[li][iadd].ctrl.Nlock);
      Result:=InsertNum(LNum[li][iadd],nu)>=0;
      if Result then SetLastListNum(li,iadd);
      ResetLock(LNum[li][iadd].ctrl.Nlock.lock);
      UnLockNumLrec(li,idel);
    end;

  function DelNumL(li,ind,nu:integer):boolean;
    begin
      LockNumLrec(li,ind);
      Result:=DeleteNum(LNum[li][ind],nu)>=0;
      if Result then SetLastListNum(li,ind);
      UnLockNumLrec(li,ind);
    end;

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
        CriticalSetLock(Nlock);
        if NN>0 then
          begin
            Result:=FindNum(0,NN-1);
            if (Result>=0)and(Result<NN) then
              begin
                ShiftNum(X,Result,-1);
                ResetLock(Nlock.lock);
                exit
              end
          end;
        ResetLock(Nlock.lock);
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
          CriticalSetLock(Nlock);
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
          ResetLock(ctrl.NLock.lock);
        end;
  end;

procedure InsertCartNum(nn,nu:integer);
  var
    po:integer;
    fn:string;
    need:boolean;
  begin
    need:=true;
    LockNumARec(Tovar,nn);
    with TNum[nn] do
      with ctrl do
        if (Nfirst<>0)and(nums[0]>nu)then
          begin
            CriticalSetLock(Nlock);
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
            ResetLock(Nlock.lock);
          end;
    if need then InsertNum(Tnum[nn],nu);
    SetLastNumA(Tovar,nn);
    UnlockNumARec(Tovar,nn);
  end;

end.
