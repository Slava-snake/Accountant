unit kass;

interface
  uses arrs,lists,data,SysUtils,nums,Atypes;

const
  chequeFile = 'cheque.cnt';
  cReservePos = 10;
var
  Kassa          : array [0..9] of tKassa;
  ChequeHeap     : array of tChequePos;
  ChequeArr      : array of tChequeStat;
  TodayArr       : array of tTodayCheque;   {Sale}

{  threadvar CLkassa  : file of tKassaOperation;   }

function KassaAct(action: tKassaAction; const MonCash:integer=0; const Monless:integer=0; const nn:integer=0):tAnswerHead;
function CheqPosAction(cpAct: tChequePosAct; const cheqp:tSendReservePos):tAnswerHead;
function CheqAct(chAct:tChequeStatus; const nch:integer=0; const mm:pMoneyMove=nil; const buy:integer=0):tAnswerHead;
function CountOpenedCheq(kass:integer; var ta:tArrOpened):integer;
function NotTodayCheque(nn:integer; var mm:integer):boolean;

implementation

function AllowKasOp(nk:integer):boolean;
begin
  Result:=(nk=CLnum)or(not Kassa[nk].OpenStatus and (nk=0));
end;

procedure SetLastCheq(nn:integer; const ti:tDatTim);
begin
  with A[Sale].info do
    with TodayArr[nn].header do
      begin
        if last<>nn then
          begin
            if prev<>0 then TodayArr[prev].header.next:=next;
            if next<>0 then TodayArr[next].header.prev:=prev;
            prev:=last;
            TodayArr[last].header.next:=nn;
            last:=nn;
            next:=0;
          end;
        lasttim:=GetTim(ti);
        changed:=ti;
      end;
end;

function TodayIndex(nn:integer):integer;
begin
  Result:=nn-A[Sale].info.ofs;
end;

function NotTodayCheque(nn:integer; var mm:integer):boolean;
begin
  mm:=TodayIndex(nn);
  Result:= (mm<=0)or(mm>A[Sale].info.N);
end;

function CheqAct(chAct:tChequeStatus; const nch:integer=0; const mm:pMoneyMove=nil; const buy:integer=0):tAnswerHead;
  function CompleteCheq(var ti:tDatTim):boolean;
    var
      i,su,ra:integer;
    begin
      Result:=true;
       with TodayArr[nch] do
         with header.stat do
           begin
             if chAct<>csAnnul then
               begin
                 su:=0; ra:=0;
                 for i:=0 to Npos-1 do
                   with chpos[i] do
                     begin
                       inc(su,SaleSum);
                       inc(ra,SaleRazn);
                     end;
                 with mm^ do
                   begin
                     Result:=(Sum=su)and(ra=Razn)and((MonCash+Monless)=su)and((chAct=csReturn)and(su<0))or((chAct=csSale)and(su>0));
                     if not Result then exit;
                     LockNumA(Cart);
                     for i:=0 to Npos-1 do
                       with chpos[i] do
                         begin
                           InsertDocPos(SaleCart,nch,i);
                           SetLastNumA(Cart,SaleCart);
                         end;
                     UnlockNumA(Cart);
                     Cash:=MonCash;
                     Cashless:=Monless;
                     {SplitTimDat(TimeNow,tim,dat); }
                   end;
               end
              else
               begin
                 for i:=0 to Npos-1 do
                   with chpos[i] do
                     CartInc(SaleCart,SaleCount);
                 ti:=TimeNow;
           {      SplitTimDat(ti,tim,dat);}
               end;
             tim:=GetTim(TimeNow);
             Nkas:=CLnum;
             status:=chAct;
           end;
    end;
begin
  if Kassa[CLnum].OpenStatus and ((nch=0)or CheckArr(Sale,nch))and(chAct>=csOpen)and(chAct<=csReturn)then
    with Result do
      with A[Sale].info do
        begin
          ArrLock(Sale);
          prevS:=changed;
          if nch=0 then
            begin
              if chAct=csOpen then
                begin
                  timS:=TimeNow;
                  N:=resizeA(Sale);
                  num:=N;
                  with TodayArr[N].header.stat do
                    begin
                      creat:=tims;
                      Nkas:=CLnum;
                      status:=csOpen;
                    end;
                  SetLastCheq(num,timS);
                end
               else
                ZeroAnswer(Result);
            end
           else
            begin
              with TodayArr[nch].header.stat do
                case chAct of
                  csOpen : if (status=csUndef)or ((status=csOpen)and AllowKasOp(Nkas)) then
                             begin
                               status:=csOpen;
                               Nkas:=CLnum;
                               num:=nch;
                               timS:=TimeNow;
                              end
                             else
                              ZeroAnswer(Result);
                  csAnnul: if (status=csUndef)or ((status=csOpen)and AllowKasOp(Nkas))
                              and CompleteCheq(Result.timS) then
                             num:=nch
                            else
                             ZeroAnswer(Result)
                 else {sale/return}
                  if (status=csOpen)and AllowKasOp(Nkas)and
                     (Npos>0)and CompleteCheq(Result.timS) then
                    begin
                      if chAct=csSale then
                        Result:=KassaAct(caSale,mm^.MonCash,mm^.Monless,nch)
                       else
                        Result:=KassaAct(caReturn,mm^.MonCash,mm^.Monless,nch);
                      num:=nch;
                    end
                   else
                    ZeroAnswer(Result);
                end;
                if num<>0 then SetLastCheq(nch,tims)
              end;
          ArrUnlock(Sale);
        end
   else
    ZeroAnswer(Result);
end;

function CheqPosAction(cpAct: tChequePosAct; const cheqp:tSendReservePos):tAnswerHead;
  var
    i:integer;
  procedure FillCheqPos(np:integer);
    begin
      with TodayArr[cheqp.doc] do
        with header.stat do
          with chpos[np] do
            with cheqp.CheqPos do
              begin
                SaleCart:=Ncart;
                SaleCount:=scount;
                SalePrice:=sprice;
                SaleSum:=scount*sprice;
                SaleRazn:=scount*(sprice-Result.count);
                tim:=GetTim(Result.timS);
                inc(Sum,SaleSum);
                inc(Razn,SaleRazn);
              end;
    end;
  function incCheq:integer;
    begin
      with TodayArr[cheqp.doc] do
        with header.stat do
          begin
            Result:=Npos;
            inc(Npos);
            if Npos>=Nres then
              begin
                inc(Nres,cReservePos);
                setlength(chpos,Nres);
              end;
          end;
    end;
begin
  if CheckArr(Sale,cheqp.doc)and(cpAct<=cpIns) then
    begin
      ArrLock(Sale);
      with cheqp do
        with CheqPos do
          with TodayArr[doc] do
            with header.stat do
              begin
                case cpAct of
                  cpDel    : if (pos<Npos)and(pos>=0) then
                               with chpos[pos] do
                                 begin
                                   Result:=CartInc(SaleCart,SaleCount);
                                   dec(Sum,SaleSum);
                                   dec(Razn,SaleRazn);
                                   dec(Npos);
                                   for i:=pos to Npos-2 do chpos[i]:=chpos[i+1];
                                   Result.num:=doc;
                                 end
                              else
                               ZeroAnswer(Result);
                  cpAdd    : begin
                               Result:=CartDec(Ncart,scount);
                               if Result.num<>0 then
                                 begin
                                   FillCheqPos(incCheq);
                                   Result.num:=doc;
                                   Result.count:=Npos;
                                 end
                                else
                                 ZeroAnswer(Result);
                             end;
                  cpIns    : if (pos>=0)and(pos<Npos)  then
                               begin
                                 Result:=CartDec(Ncart,scount);
                                 if Result.num<>0 then
                                   begin
                                     incCheq;
                                     for i:=Npos-1 downto pos+1 do chpos[i]:=chpos[i-1];
                                     FillCheqPos(pos);
                                     Result.num:=doc;
                                     Result.count:=Npos;
                                   end
                                  else
                                   ZeroAnswer(Result);
                               end
                              else
                               ZeroAnswer(Result);
                cpChange : if (pos>=0)and(pos<Npos) then
                             with chpos[pos] do
       {not ready!!!!!!!}      begin
                                 if Ncart<>SaleCart then
                                   begin
                                     Result:=CartDec(Ncart,scount);
                                     if Result.num<>0 then
                                       begin
                                         Result:=CartInc(SaleCart,SaleCount);
                             //            inc(Sum,FillCheqPos(pos,Result.timS)-SaleSum);
                             //            inc(Razn,mm-i);
                                         Result.num:=doc;
                                       end
                                      else
                                       ZeroAnswer(Result);
                                   end
                               end
                          else
                           ZeroAnswer(Result);
                end;
                if Result.num>0 then
                  begin
                    SetLastCheq(doc,Result.timS);
                    tim:=GetTim(Result.timS);
                  end;
              end;
      ArrUnlock(Sale);
    end
   else
    ZeroAnswer(Result)
end;

function CountOpenedCheq(kass:integer; var ta:tArrOpened):integer;
  var
    i:integer;
  begin
    Result:=0;
    ArrLock(Sale);
    for i:=1 to A[Sale].info.N do
      with TodayArr[i].header.stat do
        if (status=csOpen)and(Nkas=kass) then
          begin
            ta[Result]:=i;
            inc(Result);
            if Result=10 then break;
          end;
    ArrUnlock(Sale);
  end;

function KassaAct(action: tKassaAction;
      const MonCash:integer=0;
      const Monless:integer=0;
      const nn:integer=0):tAnswerHead;
  begin
    with Kassa[CLnum] do
      case action of
        caOpenKassa  : begin
                         ResultOk(Result);
                         if OpenStatus then
                           WriteLog('Переподключение к кассе.')
                          else
                           begin
                             WriteLog('Касса №'+inttostr(CLnum)+' @'+CLname+' открыта.');
                             OpenStatus:=true;
                             Date:=ServerToday;
                             Cash:=0;
                             Cashless:=0;
                             Receipts:=0;
                           end;
                         Exit;
                       end;
        caCloseKassa : if OpenStatus and (Cash=0) then
                         begin
                           ResultOk(Result);
                           OpenStatus:=false;
                           WriteLog('Касса №'+inttostr(CLnum)+' закрыта. Баланс Нал= '+CurrToStr(Kassa[CLnum].Cash)+' Безнал= '+CurrToStr(Kassa[CLnum].Cashless)+'   Итог='+CurrToStr(Receipts));
                           exit
                         end
                        else
                         WriteLog('Закрытие закрытой кассы.');
        caXreport    : if OpenStatus then
                         begin
                           ResultOk(Result);
                           WriteLog('X => нал. '+IntToStr(Cash)+
                                    '     безнал. '+IntToStr(Cashless)+
                                    '  Выторг '+IntTostr(Receipts)+
                                    '     вносено '+IntToStr(Cash-Receipts+Cashless));
                           exit
                         end;
        caZreport    : if OpenStatus then
                         begin
                           WriteLog('Z-Report:'+#13+#10+
                                    '    нал. '+IntToStr(Cash)+
                                    '    безнал. '+IntToStr(Cashless)+
                                    '  Выторг '+IntTostr(Receipts)+
                                    '    вносено '+IntToStr(Cash-Receipts+Cashless));
   {add Receipts }
   {call counts department}
                           Result:=KassaAct(caWithdrawal,Cash,0);
                           if Result.num=0 then exit;
                           Fillchar(Cash,12,0);
                           ResultOk(Result);
                           exit
                         end;
        caDeposit    : if OpenStatus and (MonCash>0) and (Monless=0) then
                         begin
                           ResultOk(Result);
                           inc(Cash,MonCash);
                           WriteLog('Внос в кассу '+IntToStr(MonCash)+'. Касса нал='+IntToStr(Cash));
                           exit
                         end;
        caWithdrawal : if OpenStatus and (MonCash>0) and (Monless=0) then
                         begin
                           ResultOk(Result);
                           dec(Cash,MonCash);
                           WriteLog('Вынос из кассы ='+IntToStr(MonCash)+'. Касса нал='+IntToStr(Cash));
                           exit
                         end;
        caSale     :     begin
                           ResultOk(Result);
                           inc(Cash,MonCash);
                           inc(Cashless,Monless);
                           inc(Receipts,MonCash+Monless);
                           Writelog('ЧЕК #'+inttostr(nn)+' сумма='+IntToStr(MonCash+Monless)+
                                    '     @ Касса='+IntTostr(Receipts));
                           exit
                         end;
        caReturn     :   begin
                           ResultOk(Result);
                           dec(Cash,MonCash);
                           dec(Cashless,Monless);
                           dec(Receipts,Moncash+Monless);
                           Writelog('ЧЕК возврата #'+IntToStr(nn)+' сумма='+IntToStr(MonCash+Monless)+
                                    '     @ Касса='+IntToStr(Cash+Cashless));
                           exit
                         end;
      end;
    ZeroAnswer(Result);
  end;

end.
