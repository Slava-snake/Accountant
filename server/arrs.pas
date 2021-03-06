unit arrs;

interface
uses
  Atypes, data, nums, SyncObjs, SysUtils;

const
  prihDir  = 'Prihod\';
  rashDir  = 'Rashod\';
  SaleDir  = 'Sale\';
  tovarDir = 'Tovars\';
  cartDir  = 'Carts\';

  rashodFile = 'rashod.cnt';
  prihodFile = 'prihod.cnt';
  cartFile   = 'carts.cnt';
  tovarFile  = 'tovar.cnt';
  saleFile   = 'sale.cnt';
{-----------------------------------------------------}
var
  A         : array [Tovar..Sale]  of tMas;
  LockA     : array [Tovar..Sale]  of TCriticalSection;
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

  procedure ArrLock(ar:integer);
  procedure ArrUnLock(ar:integer);
  function CheckArr(ar,nu:integer):boolean;
  procedure SaveArr(ar:integer);
  procedure ChangeLastA(ar,ind:integer);
  function UnlockRecA(ar:integer; anum:integer; const stat:integer=-1):tAnswerHead;
  function CountSendA(ar:integer; const sync:int64; var start:integer):integer;
  function ResizeA(ar:integer; const incA:integer=1):integer;
  function AAddNew(ar:integer; const un:tRecArr; const sync:int64):tAnswerHead;
  function ChangeArr(ar,num:integer; const un:tRecArr; const sync:int64):tAnswerHead;
  function OpenNakl(ar,num:integer):tAnswerHead;
  function AnnNakl(ar,num:integer):tAnswerHead;
  function FreeNakl(ar,num:integer):tAnswerHead;
  function ExecNakl(ar,num:integer):tAnswerHead;
  function CartDec(num,count:integer):tAnswerHead;
  function CartInc(num,count:integer):tAnswerHead;
  function LoadPrihRows(nn:integer):integer;
  function LoadRashRows(nn:integer):integer;

implementation

uses lists,kass;

function CountSendA(ar:integer; const sync:int64; var start:integer):integer;
var
  nn:integer;
  ti:cardinal;
begin
  Result:=0;
  nn:=A[ar].info.last;
  case ar of
      Tovar  : while nn>0 do
                 with T[nn].state do
                   if tim.t64>sync then
                     begin
                       inc(Result);
                       start:=nn;
                       nn:=prev;
                     end
                    else exit;
      Cart   : while nn>0 do
                 with C[nn].state do
                   if tim.t64>sync then
                     begin
                       inc(Result);
                       start:=nn;
                       nn:=prev;
                     end
                    else exit;
      Prihod : while nn>0 do
                 with P[nn].state do
                   if tim.t64>sync then
                     begin
                       inc(Result);
                       start:=nn;
                       nn:=prev;
                     end
                    else exit;
      Rashod : while nn>0 do
                 with R[nn].state do
                   if tim.t64>sync then
                     begin
                       inc(Result);
                       start:=nn;
                       nn:=prev;
                     end
                    else exit;
      Sale   : begin
                 ti:=GetTim(tDatTim(sync));
                 while nn>0 do
                   with TodayArr[nn].header do
                     if stat.tim>ti then
                       begin
                         inc(Result);
                         start:=nn;
                         nn:=prev;
                       end
                      else
                       exit
               end
    end;
end;

  procedure SaveArr(ar:integer);
    var
      cu  : integer;
      fp  : file of tPrihRow;
      fr  : file of tRashRow;
    begin
      ArrLock(ar);
      with A[ar] do
        with info do
        if changed.t64>saved.t64 then
          begin
            cu:=last;
            case ar of
              Tovar   : begin
                          while cu<>0 do
                            with T[cu] do
                              if state.tim.t64>saved.t64 then
                                begin
                                  seek(fileTovar,cu-1);
                                  write(fileTovar,state);
                                  cu:=state.prev;
                                end
                               else
                                cu:=0;
                          closefile(fileTovar);
                          reset(fileTovar);
                        end;
              Cart    : begin
                          while cu<>0 do
                            with C[cu] do
                              if state.tim.t64>saved.t64 then
                                begin
                                  seek(fileCart,cu-1);
                                  write(fileCart,state);
                                  cu:=state.prev;
                                end
                               else
                                cu:=0;
                          closefile(fileCart);
                          reset(fileCart);
                        end;
              Prihod  : begin
                          while cu<>0 do
                            with P[cu] do
                              if state.tim.t64>saved.t64 then
                                begin
                                  seek(filePrihod,cu-1);
                                  write(filePrihod,state);
                                  cu:=state.prev;
                                end
                               else
                                cu:=0;
                          closefile(filePrihod);
                          reset(filePrihod);
                        end;
              Rashod  : begin
                          while cu<>0 do
                            with R[cu] do
                              if state.tim.t64>saved.t64 then
                                begin
                                  seek(fileRashod,cu-1);
                                  write(fileRashod,state);
                                  cu:=state.prev;
                                end
                               else
                                cu:=0;
                          closefile(fileRashod);
                          reset(fileRashod);
                        end;
              Sale : ;
            end;
            seek(fileNum,ar);
            write(fileNum,info);
            saved:=changed;
          end;
      LockNumA(ar);
      case ar of
        Tovar   : with AN[Tovar] do
                    with info do
                      if saved.t64<changed.t64 then
                        begin
                          cu:=last;
                          while cu<>0 do
                            with TNum[cu] do
                              with ctrl do
                                if Ntim.t64<saved.t64 then
                                  begin
                                    SaveInt(arrDir[Tovar]+IntToArt(cu),nums,Nfirst);
                                    cu:=Nprev;
                                  end
                                 else
                                  cu:=0;
                          seek(fileNN,Tovar);
                          write(fileNN,info);
                          saved:=changed;
                        end;
        Cart    : with AN[Cart] do
                    with info do
                      if saved.t64<changed.t64 then
                        begin
                          cu:=last;
                          while cu<>0 do
                            with CNum[cu] do
                              with ctrl do
                                if Ntim.t64<saved.t64 then
                                  begin
                                    SaveDocPos(arrDir[Cart]+IntToArt(cu),ra,Nfirst);
                                    cu:=Nprev;
                                  end
                                 else
                                  cu:=0;
                          seek(fileNN,Cart);
                          write(fileNN,info);
                          saved:=changed;
                        end;
        Prihod  : with AN[Prihod] do
                    with info do
                      if saved.t64<changed.t64 then
                        begin
                          cu:=last;
                          while cu<>0 do
                            with Pnum[cu] do
                              if ctrl.Ntim.t64>saved.t64 then
                                begin
                                  assignfile(fp,arrDir[Prihod]+IntToArt(cu));
                                  rewrite(fp);
                                  blockwrite(fp,rows[0],ctrl.Nrows);
                                  closefile(fp);
                                  cu:= ctrl.Nprev
                                end
                               else
                                cu:=0;
                          seek(fileNN,Prihod);
                          write(fileNN,info);
                          saved:=changed;
                        end;
        Rashod  : with AN[Rashod] do
                    with info do
                      if saved.t64<changed.t64 then
                        begin
                          cu:=last;
                          while cu<>0 do
                            with RNum[cu] do
                              with ctrl do
                                if saved.t64<Ntim.t64 then
                                  begin
                                    assignfile(fp,arrDir[Rashod]+IntToArt(cu));
                                    rewrite(fp);
                                    blockwrite(fp,rows[0],Nrows);
                                    closefile(fp);
                                    cu:=NPrev
                                  end
                                 else
                                  cu:=0;
                          seek(fileNN,Rashod);
                          write(fileNN,info);
                          saved:=changed;
                        end;
      end;
      UnlockNumA(ar);
      ArrUnlock(ar);
    end;

  function CheckHod(ar,nn:integer; ns:integer):boolean;
    begin
      case ar of
        Prihod : with P[nn].state do
                   Result:=((ns=stOpen)and(status=stOpen)and(open.fil=CLnum)and(open.oper=CLoper)) or (status=stReady);
        Rashod : with R[nn].state do
                   Result:=((ns=stOpen)and(status=stOpen)and(open.fil=CLnum)and(open.oper=CLoper)) or (status=stReady);
       else
        Result:=true;
      end
    end;

  procedure ArrLock(ar:integer);
    begin
      LockA[ar].Enter;
      A[ar].lock:=CLlock;
    end;

  procedure ArrUnLock(ar:integer);
    begin
      A[ar].lock.lock:=false;
      LockA[ar].Leave;
    end;

  function CheckArr(ar,nu:integer):boolean;
    begin
      Result:=(nu>0)and(nu<=A[ar].info.N);
    end;

  function ErrorTimeArr(ar:integer):tAnswerHead;
    begin
      Result.prevS:=A[ar].info.changed;
      Result.num:=0;
      Result.timS.t64:=0;
    end;

  function SetLastNumA(ar,nn:integer):tDatTim;
    begin
      LockAnum[ar].Enter;
      with AN[ar] do
        begin
          lock:=CLlock;
          case ar of
            Tovar : with TNum[nn].ctrl do
                      begin
                        if Nprev>0 then TNum[Nprev].ctrl.Nnext:=Nnext;
                        if Nnext>0 then TNum[Nnext].ctrl.Nprev:=Nprev;
                        Nnext:=0;
                        Nprev:=info.last;
                      end;
            Cart  : with CNum[nn].ctrl do
                      begin
                        if Nprev>0 then CNum[Nprev].ctrl.Nnext:=Nnext;
                        if Nnext>0 then CNum[Nnext].ctrl.Nprev:=Nprev;
                        Nnext:=0;
                        Nprev:=info.last;
                      end;
          end;
          if info.last>0 then
            case ar of
              Tovar : TNum[info.last].ctrl.Nnext:=nn;
              Cart  : CNum[info.last].ctrl.Nnext:=nn;
            end;
          info.last:=nn;
          Result:=TimeNow;
          info.changed:=Result;
          lock.lock:=false;
        end;
      LockANum[ar].Leave;
    end;

  procedure SetLastA(ar,nn:integer);
    begin
      with A[ar].info do
        begin
          case ar of
            Tovar   : begin
                        T[nn].state.next:=0;
                        T[nn].state.prev:=last;
                        if last<>0 then T[last].state.next:=nn;
                      end;
            Cart    : begin
                        C[nn].state.next:=0;
                        C[nn].state.prev:=last;
                        if last<>0 then C[last].state.next:=nn;
                      end;
            Prihod  : begin
                        P[nn].state.next:=0;
                        P[nn].state.prev:=last;
                        if last<>0 then P[last].state.next:=nn;
                      end;
            Rashod  : begin
                        R[nn].state.next:=0;
                        R[nn].state.prev:=last;
                        if last<>0 then R[last].state.next:=nn;
                      end;
          end;
          last:=nn;
        end;
    end;

  procedure CutA(ar,ind:integer);
    begin
      case ar of
        Tovar   : with T[ind].state do
                    begin
                      if prev<>0 then T[prev].state.next:=next;
                      if next<>0 then T[next].state.prev:=prev;
                    end;
        Cart    : with C[ind].state do
                    begin
                      if prev<>0 then C[prev].state.next:=next;
                      if next<>0 then C[next].state.prev:=prev;
                    end;
        Prihod  : with P[ind].state do
                    begin
                      if prev<>0 then P[prev].state.next:=next;
                      if next<>0 then P[next].state.prev:=prev;
                    end;
        Rashod  : with R[ind].state do
                    begin
                      if prev<>0 then R[prev].state.next:=next;
                      if next<>0 then R[next].state.prev:=prev;
                    end;
      end;
    end;

  procedure ChangeLastA(ar,ind:integer);
    begin
      if ind<>A[ar].info.last then
        begin
          CutA(ar,ind);
          SetLastA(ar,ind)
        end;
    end;

  procedure LockRecA(ar,num:integer);
    begin
      ArrLock(ar);
      A[ar].lockrec:=num;
      case ar of
        Tovar : CriticalSetLock(T[num].lock);
        Cart  : CriticalSetLock(C[num].lock);
        Prihod: with P[num] do
                  if IsLockNotMine(lock) then CriticalSetLock(lock);
        Rashod: with R[num] do
                  if IsLockNotMine(lock) then CriticalSetLock(lock);
      end;
    end;

  function UnlockRecA(ar:integer; anum:integer; const stat:integer=-1):tAnswerHead;
    begin
      with Result do
        begin
          prevS:=A[ar].info.changed;
          if stat>=0 then
            begin
              timS:=TimeNow;
              num:=anum;
              case ar of
                Tovar  : begin
                           T[anum].state.tim:=timS;
                           ResetLock(T[num].lock.lock);
                         end;
                Cart   : begin
                           C[anum].state.tim:=timS;
                           ResetLock(C[num].lock.lock);
                         end;
                Prihod : with P[anum].state do
                           begin
                             tim:=timS;
                             if stat<stCancel then status:=stat;
                             if stat=stOpen then
                               FillAct(open,timS)
                              else
                               begin
                                 case stat of
                                   stExec: FillAct(exec,timS);
                                   stAnn : FillAct(ann,timS);
                                   stEdit: FillAct(edit,timS);
                                 end;
                                 ResetLock(P[num].lock.lock);
                               end
                           end;
                Rashod : with R[anum].state do
                           begin
                             tim:=timS;
                             if stat<stCancel then status:=stat;
                             if stat=stOpen then
                               FillAct(open,timS)
                              else
                               begin
                                 case stat of
                                   stExec: FillAct(exec,timS);
                                   stAnn : FillAct(ann,timS);
                                   stEdit: FillAct(edit,timS);
                                 end;
                                 ResetLock(R[num].lock.lock);
                               end
                           end;
              end;
              ChangeLastA(ar,anum);
              A[ar].info.changed:=timS;
            end
           else
            begin
              num:=0;
              case ar of
                Tovar  : ResetLock(T[num].lock.lock);
                Cart   : ResetLock(C[num].lock.lock);
                Prihod : ResetLock(P[num].lock.lock);
                Rashod : ResetLock(R[num].lock.lock);
              end;
            end;
        end;
      A[ar].lockrec:=0;
      ArrUnlock(ar);
    end;

  function CheckTovarLists(const tt:tTovarRec):boolean;
    begin
      Result:=CheckListRange(Tip,tt.tip)and CheckListRange(Mat,tt.mat)and
              CheckListRange(Firm,tt.firm)and (tt.opis<>'');
    end;

function ResizeA(ar:integer; const incA:integer=1):integer;
var
  i:integer;
begin
  with A[ar] do
    begin
      Result:=info.N+incA;
      if Result>=Msize then
        begin
          Msize:=ReserveSize(Result,nListStep);
          case ar of
            Tovar     : begin
                          setlength(T,Msize);
                          setlength(TNum,Msize); {filled 0}
                          for i:=info.N+1 to Result do
                            with TNum[i] do
                              begin
                                ctrl.Ntim.t64:=0;
                                setlength(nums,0);
                              end;
                        end;
            Cart      : begin
                          setlength(C,Msize);
                          setlength(Cnum,Msize);
                          for i:=info.N+1 to Result do
                            with CNum[i] do
                              begin
                                ctrl.Ntim.t64:=0;
                                setlength(ra,0);
                              end;
                        end;
            Prihod    : begin
                          setlength(P,Msize);
                          setlength(Pnum,Msize);
                        end;
            Rashod    : begin
                          setlength(R,Msize);
                          setlength(Rnum,Msize);
                        end;
            Sale      : begin
                          setlength(TodayArr,Msize);
                        end;
          end;
        end
    end;
end;

  function AAddNew(ar:integer; const un:tRecArr; const sync:int64):tAnswerHead;
    begin
      ArrLock(ar);
      LockNumA(ar);
      with A[ar].info do
        begin
          Result.prevS:=changed;
          if (ar<>Cart)and((ar<>Tovar)or CheckTovarLists(un.tt)) then
            with Result do
              begin
                num:=ResizeA(ar);
                A[ar].lockrec:=num;
                timS:=TimeNow;
                case ar of
                  Tovar : with T[num] do
                            begin
                              with state do
                                begin
                                  rec:=un.tt;
                                  FillAct(creat,timS);
                                  edit.tim.t64:=0;
                                  tim:=timS;
                                end;
                              lock.lock:=false;
                              if not AddNumL(Tip,un.tt.tip,num) then
                                begin
                                  num:=0;
                                  timS.t64:=0
                                end
                               else
                                if not AddNumL(Mat,un.tt.mat,num) then
                                  begin
                                    DelNumL(Tip,un.tt.tip,num);
                                    num:=0;
                                    timS.t64:=0
                                  end
                                 else
                                  if not AddNumL(Firm,un.tt.firm,num) then
                                   begin
                                     DelNumL(Mat,un.tt.mat,num);
                                     DelNumL(Tip,un.tt.tip,num);
                                     num:=0;
                                     timS.t64:=0
                                   end
                            end;
                  Prihod: with P[num] do
                            begin
                              with state do
                                begin
                                  rec:=un.pp;
                                  rec.Npos:=0;
                                  FillAct(creat,timS);
                                  tim:=timS;
                                  status:=stOpen;
                                  FillAct(open,timS);
                                end;
                              lock:=CLlock;
                              if not AddNumL(Agent,un.pp.agent,num) then
                                begin
                                  num:=0;
                                  timS.t64:=0;
                                end
                            end;
                  Rashod: with R[num] do
                            begin
                              with state do
                                begin
                                  rec:=un.rr;
                                  FillAct(creat,timS);
                                  tim:=timS;
                                  status:=stOpen;
                                  FillAct(open,timS);
                                  Npos:=0;
                                end;
                              lock:=CLlock;
                              if not AddNumL(Agent,un.rr.agent,num) then
                                begin
                                  num:=0;
                                  timS.t64:=0;
                                end
                            end;
                end;
                if num<>0 then
                  begin
                    N:=num;
                    SetLastA(ar,num);
                    changed:=timS;
                  end
            end
           else
            begin
              Result.timS.t64:=0;
              Result.num:=0;
            end;
        end;
      UnlockNumA(ar);
      ArrUnlock(ar);
    end;

  function OpenNakl(ar,num:integer):tAnswerHead;
    begin
      LockRecA(ar,num);
      if ar=Prihod then  {Prihod}
        with P[num] do
          begin
            if (state.status=stReady)or((state.status=stOpen)and(state.open.fil=CLnum)) then
              Result:=UnlockRecA(Prihod,num,stOpen)
             else
              Result:=UnlockRecA(Prihod,num);
          end
       else   { Rashod}
        with R[num] do
          begin
            if (state.status=stReady)or((state.status=stOpen)and(state.open.fil=CLnum)) then
              Result:=UnlockRecA(Rashod,num,stOpen)
             else
              Result:=UnlockRecA(Rashod,num);
          end;
    end;

  function AnnNakl(ar,num:integer):tAnswerHead;
    begin
      LockRecA(ar,num);
      if ar=Prihod then  {Prihod}
        with P[num] do
          begin
            if (state.status=stOpen)and(state.open.fil=CLnum) then
              Result:=UnlockRecA(Prihod,num,stAnn)
             else
              Result:=UnlockRecA(Prihod,num);
          end
       else   { Rashod}
        with R[num] do
          begin
            if (state.status=stOpen)and(state.open.fil=CLnum) then
              Result:=UnlockRecA(Rashod,num,stAnn)
             else
              Result:=UnlockRecA(Rashod,num);
          end;
    end;

  function FreeNakl(ar,num:integer):tAnswerHead;
    begin
      if ar=Prihod then  {Prihod}
        with P[num] do
          begin
            ArrLock(Prihod);
            if IsLockMine(lock) then
              Result:=UnlockRecA(Prihod,num,stReady)
             else
              Result:=UnlockRecA(Prihod,num);
          end
       else   { Rashod}
        with R[num] do
          begin
            ArrLock(Rashod);
            if IsLockMine(lock) then
              Result:=UnlockRecA(Rashod,num,stReady)
             else
              Result:=UnlockRecA(Rashod,num);
          end;
    end;

  function ExecNakl(ar,num:integer):tAnswerHead;
    var
      i:integer;
      ti:tDatTim;
    begin
      case ar of
        Prihod: if IsLockMine(P[num].lock) then
                  begin
                    ArrLock(Prihod);
                    LockNumARec(ar,num);
                    with A[Cart].info do
                      with PNum[num] do
                        begin
                          ArrLock(Cart);
                          ResizeA(Cart,ctrl.Nrows);
                          ti:=TimeNow;
                          Result.count:=N+1;
                          for i:=1 to ctrl.Nrows do
                            begin
                              inc(N);
                              with rows[i-1].pp do
                                with C[N].state do
                                  begin
                                    FillAct(creat,ti);
                                    cartnum:=N;
                                    rec.base:=base;
                                    rec.ost:=rec.base.kol;
                                    rec.nakl:=num;
                                    rec.pos:=i;
                                    tim:=ti;
                                    InsertCartNum(rec.base.tov,N);
                                    SetLastA(Cart,N);
                                  end;
                            end;
                          changed:=ti;
                          ArrUnlock(Cart);
                        end;
                    UnlockNumARec(ar,num);
                    Result:=UnlockRecA(Prihod,num,stExec);
                  end;
        Rashod:
          begin {Rashod}
             ;
          end;
      end;
    end;

  function CartInc(num,count:integer):tAnswerHead;
    begin
      LockRecA(Cart,num);
      with C[num].state.rec do
        begin
          inc(ost,count);
          Result:=UnlockRecA(Cart,num,0);
          Result.count:=base.price;
        end;
    end;

  function CartDec(num,count:integer):tAnswerHead;
    begin
      LockRecA(Cart,num);
      with C[num].state.rec do
        if ost>=count then
          begin
            dec(ost,count);
            Result:=UnlockRecA(Cart,num,0);
            Result.count:=base.price;
          end
         else
          Result:=UnlockRecA(Cart,num);
    end;

  function FindSameArr(ar,num:integer; const un:tRecArr; const sync:int64=0):integer;
    var
      nn:integer;
    begin
      Result:=0;
      nn:=A[ar].info.last;
      case ar of
        Tovar  : while (nn>0)and(nn<>num)do
                   with T[nn].state do
                     begin
                       if tim.t64<=sync then
                         exit
                        else
                         if (rec.tip=un.tt.tip)and(rec.mat=un.tt.mat)and(rec.firm=un.tt.firm)and
                            (AnsiCompareText(rec.art,un.tt.art)=0)and(AnsiCompareText(rec.opis,un.tt.opis)=0) then
                           exit;
                       nn:=prev;
                     end;
        Prihod : ;
        Rashod : ;
      end;
    end;

function ChangeArr(ar,num:integer; const un:tRecArr; const sync:int64):tAnswerHead;
  begin
    if CheckArr(ar,num) then
      begin
        LockRecA(ar,num);
        case ar of
          Tovar  : with T[num] do
                     with state do
                       begin
                         if CheckTovarLists(un.tt) and (FindSameArr(ar,num,un,sync)=0)then
                           begin
                             if rec.tip<>un.tt.tip then MoveNumL(Tip,rec.tip,un.tt.tip,num);
                             if rec.mat<>un.tt.mat then MoveNumL(Mat,rec.mat,un.tt.mat,num);
                             if rec.firm<>un.tt.firm then MoveNumL(Firm,rec.firm,un.tt.firm,num);
                             rec:=un.tt;
                             Result:=UnlockRecA(Tovar,num,stEdit);
                             exit
                           end
                       end;
          Prihod : with P[num] do
                     begin
                       with state do
                         if CheckArr(Prihod,un.pp.agent) and (FindSameArr(Prihod,num,un,sync)=0) then
                           begin
                             if un.pp.agent<>rec.agent then MoveNumL(Agent,rec.agent,un.pp.agent,num);
                             rec:=un.pp;
                             Result:=UnlockRecA(Prihod,num,stEdit);
                             exit
                           end
                     end;
          Rashod : with R[num] do
                     begin
                       with state do
                         if CheckArr(Rashod,un.rr.agent) and (FindSameArr(Rashod,num,un,sync)=0) then
                           begin
                             if un.rr.agent<>rec.agent then MoveNumL(Agent,rec.agent,un.rr.agent,num);
                             rec:=un.rr;
                             Result:=UnlockRecA(Rashod,num,stEdit);
                             exit
                           end
                     end;
        end;
      end;
    Result:=UnlockRecA(ar,num);
  end;

  function LoadPrihRows(nn:integer):integer;
    var
      fp:file of tPrihRow;
      ff:string;
    begin
      ff:=arrDir[Prihod]+IntToArt(nn);
      if fileexists(ff) then
        begin
          assignfile(fp,ff);
          reset(fp);
          Result:=filesize(fp);
          with PNum[nn] do
            with ctrl do
               begin
                CriticalSetLock(Nlock);
                setlength(rows,Result);
                Nrows:=Result;
                if Result>0 then blockread(fp,rows[0],Result);
                ResetLock(Nlock.lock)
              end;
          closefile(fp);
        end
       else
        Result:=-1;
    end;

  function LoadRashRows(nn:integer):integer;
    var
      fr:file of tRashRow;
      ff:string;
    begin
      ff:=arrDir[Rashod]+IntToArt(nn);
      if fileexists(ff) then
        begin
          assignfile(fr,ff);
          reset(fr);
          Result:=filesize(fr);
          with RNum[nn] do
            with ctrl do
              begin
                CriticalSetLock(Nlock);
                setlength(rows,Result);
                Nrows:=Result;
                if Result>0 then blockread(fr,rows[0],Result);
                ResetLock(Nlock.lock);
              end;
          closefile(fr);
        end
       else
        begin
          R[nn].state.Npos:=0;
          Result:=0;
        end  
    end;

end.
