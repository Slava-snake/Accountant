unit cats;

interface
uses
  data, Atypes, nums, lists, SyncObjs, SysUtils, ComCtrls;

const
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

var
  LockC     : array [Tip..Agent]   of TCriticalSection;
  Cat       : array [Tip..Agent]   of tMas;
  Cstat     : array [Tip..Agent]   of tCstate;
  CatFile   : array [Tip..Agent]   of tOpis=(CatTip,CatMat,CatFirm,CatSize,CatAgent);
  CatDirs   : array [Tip..Agent]   of tOpis=(tipCat,matCat,firmCat,sizeCat,agentCat);
  fileCat   : array [Tip..Agent]   of file of tCatRec;

  procedure SaveCat(ca:integer);
  procedure CatLock(no:integer);
  procedure CatUnLock(no:integer);
  procedure UnlockCatRec(ca,ind:integer);
  function CatCheckRange(ca:integer; ind:integer):boolean;
  function CountSendC(ca:integer; const sync:int64; var start:integer):integer;

  function AddCatNode(ca:integer; const newnode:tListPos; const sync:int64):tAnswerHead;
  function AddCatLeaf(ca:integer; node,num:integer):boolean;
  function ChangeNode(ca:integer; nod,newnode:integer):tAnswerHead;
  function RenameNode(ca:integer; nod:integer; const newname:tNam; const sync:int64=-1):tAnswerHead;
  function MoveCatLeaf(ca,prevNode,newNode,leaf:integer):boolean;

implementation

  function CatCheckRange(ca:integer; ind:integer):boolean;
    begin
      Result:=(ind<=Cat[ca].info.N)and(ind>0);
    end;

  procedure CatLock(no:integer);
    begin
      LockC[no].Enter;
      Cat[no].lock:=CLlock;
    end;

  procedure CatUnLock(no:integer);
    begin
      Cat[no].lock.lock:=false;
      LockC[no].Leave;
    end;

  function ErrorTimeCat(ca:integer):tAnswerHead;
    begin
      Result.PrevS:=Cat[ca].info.changed;
      Result.timS.t64:=0;
      Result.num:=0;
    end;

  procedure SetLastC(ca,nn:integer);
    begin
      with Cat[ca].info do
        begin
          with Cstat[ca][nn].rec do
            begin
              next:=0;
              prev:=last;
              changed:=tim;
            end;
          if last<>0 then Cstat[ca][last].rec.next:=nn;
          last:=nn;
        end;
    end;

  procedure ChangeLastC(ca,ind:integer);
    begin
      if ind<>Cat[ca].info.last then
        begin
          with Cstat[ca][ind].rec do
            begin
              if prev<>0 then Cstat[ca][prev].rec.next:=next;
              if next<>0 then Cstat[ca][next].rec.prev:=prev;
            end;
          SetLastC(ca,ind)
        end;
    end;

  function GoodAnswerCat(ca,ind:integer; var ti:tDatTim):tAnswerHead;
    begin
      Result.PrevS:=Cat[ca].info.changed;
      Result.timS:=ti;
      Result.num:=ind;
      ChangeLastC(ca,ind);
    end;

procedure LockCatRec(ca,ind:integer);
begin
  CatLock(ca);
  CriticalSetLock(Cstat[ca][ind].lock);
  Cat[ca].lockrec:=ind;
end;

procedure UnlockCatRec(ca,ind:integer);
begin
  ResetLock(Cstat[ca][ind].lock.lock);
  CatUnLock(ca);
end;

function CountSendC(ca:integer; const sync:int64; var start:integer):integer;
var
  no:integer;
begin
  no:=Cat[ca].info.last;
  start:=0;
  Result:=0;
  while no>0 do
    with Cstat[ca][no] do
      if (rec.tim.t64>sync) then
        begin
          inc(Result);
          start:=no;
          no:=rec.prev;
        end
       else
        exit
end;

  function CatFindByName(ca:integer; const name:tNam; const sync:int64; const excl:integer=0):integer;
    begin
      Result:=Cat[ca].info.last;
      while (Result>0) do
        with Cstat[ca][Result] do
          if (rec.tim.t64>sync) then
            begin
              if (Result<>excl) then
                begin
                  if(AnsiCompareText(name,rec.pos.nam)=0) then exit;
                  Result:=rec.prev;
                end
            end
           else
            Result:=0;
    end;

  function CatNameFails(ca:integer; const name:tNam; const sync:int64; const excl:integer=0):boolean;
    begin
      Result:=CatFindByName(ca,name,sync,excl)=0;
    end;

  function AddCatNode(ca:integer; const newnode:tListPos; const sync:int64):tAnswerHead;
    var
      nn:integer;
    begin
      CatLock(ca);
      with Cat[ca] do
        with info do
          if (({parent}newnode.node=0)and(N=0){root})or
             (CatCheckRange(ca,newnode.node) and CatNameFails(ca,newnode.nam,sync)) then
            begin
              nn:=N+1;
              LockNumCN(ca);
              LockNumCL(ca);
              if nn>=Msize then
                begin
                  inc(Msize,nListStep);
                  setlength(Cstat[ca],Msize);
                  SetLength(CatNnum[ca],Msize);
                  SetLength(CatLnum[ca],Msize);
                end;
              CatNNum[ca][nn].ctrl.Ntim.t64:=0;
              CatLNum[ca][nn].ctrl.Ntim.t64:=0;
              if newnode.node>0 then
                begin
                  CNN[ca].lockrec:=newnode.node;
                  if InsertNum(CatNnum[ca][newnode.node],nn)>=0 then
                    SetLastCatNnum(ca,newnode.node);
                end;
              UnlockNumCL(ca);
              UnlockNumCN(ca);
              with Cstat[ca][nn] do
                begin
                  lock.lock:=false;
                  viewnodeC:=nil;
                  prop:=[prNam,prNode];
                  with rec do
                    begin
                      tim:=TimeNow;
                      pos:=newnode;
                      FillAct(creat,tim);
                      edit.tim.t64:=0;
                      Result:=GoodAnswerCat(ca,nn,tim);
                    end;
                end;
              N:=nn;
            end
       else
        Result:=ErrorTimeCat(ca);
      CatUnLock(ca);
    end;

  function RenameNode(ca:integer; nod:integer; const newname:tNam; const sync:int64=-1):tAnswerHead;
    begin
      CatLock(ca);
      if CatCheckRange(ca,nod) and CatNameFails(ca,newname,sync,nod) then
        with Cstat[ca][nod] do
          begin
            CriticalSetLock(lock);
            Cat[ca].lockrec:=nod;
            prop:=prop+[prNam];
            with rec do
              begin
                pos.nam:=newname;
                tim:=TimeNow;
                FillAct(edit,tim);
                Result:=GoodAnswerCat(ca,nod,tim);
              end;
            ResetLock(lock.lock);
          end
       else
        Result:=ErrorTimeCat(ca);
      CatUnlock(ca);
    end;

  function ChangeNode(ca:integer; nod,newnode:integer):tAnswerHead;
    var
      old:integer;
    begin
      CatLock(ca);
      if CatCheckRange(ca,nod) and CatCheckRange(ca,newnode)and(nod<>newnode) then
        with Cstat[ca][nod] do
          begin
            CriticalSetLock(lock);
            Cat[ca].lockrec:=nod;
            with rec do
              if pos.node<>newnode then
                begin
                  old:=pos.node;
                  LockNumCNrec(ca,pos.node);
                  if DeleteNum(CatNnum[ca][pos.node],nod)>=0 then
                    begin
                      CriticalSetLock(CatNnum[ca][newnode].ctrl.Nlock);
                      CNN[ca].lockrec:=newnode;
                      if InsertNum(CatNnum[ca][newnode],nod)>=0 then
                      begin
                        prop:=prop+[prNode];
                        SetLastCatNNum(ca,pos.node);
                        pos.node:=newnode;
                        tim:=TimeNow;
                        SetLastCatNNum(ca,newnode);
                        ResetLock(CatNnum[ca][newnode].ctrl.Nlock.lock);
                        UnlockNumCNrec(ca,old);
                        FillAct(rec.edit,tim);
                        Result:=GoodAnswerCat(ca,nod,tim);
                      end
                     else
                      begin
                        ResetLock(CatNnum[ca][newnode].ctrl.Nlock.lock);
                        UnlockNumCNrec(ca,old);
                        Result:=ErrorTimeCat(ca);
                      end;
                    end
                end
               else
                Result:=ErrorTimeCat(ca);
            ResetLock(lock.lock);
          end
       else
        Result:=ErrorTimeCat(ca);
      CatUnlock(ca)
    end;

  function AddCatLeaf(ca:integer; node,num:integer):boolean;
    begin
      if CatCheckRange(ca,node) then
        begin
          LockNumCLrec(ca,node);
          Result:=InsertNum(CatLnum[ca][node],num)>=0;
          if Result then SetLastCatLNum(ca,node);
          UnlockNumCLrec(ca,node);
        end
       else
        Result:=False;
    end;

  function MoveCatLeaf(ca,prevNode,newNode,leaf:integer):boolean;
    begin
      if CatCheckRange(ca,prevNode) and CatCheckRange(ca,newNode) then
        begin
          LockNumCLrec(ca,prevNode);
          if DeleteNum(CatLnum[ca][prevNode],leaf)>=0 then
            begin
              SetLastCatLnum(ca,prevNode);
              ResetLock(CatLNum[ca][prevNode].ctrl.Nlock.lock);
              CriticalSetLock(CatLNum[ca][newNode].ctrl.Nlock);
              CLN[ca].lockrec:=newNode;
              Result:=InsertNum(CatLnum[ca][newNode],leaf)>=0;
              SetLastCatLnum(ca,newNode);
              UnlockNumCLrec(ca,newNode);
            end
           else
            begin
              Result:=false;
              UnlockNumCLrec(ca,prevNode);
            end
        end
       else
        Result:=false;
    end;


  procedure SaveCat(ca:integer);
    var
      cu:integer;
    begin
      CatLock(ca);
      with Cat[ca] do
        with info do
          if saved.t64<changed.t64 then
            begin
              cu:=last;
              while cu<>0 do
                with Cstat[ca][cu] do
                  if rec.tim.t64>saved.t64 then
                    begin
                      seek(fileCat[ca],cu-1);
                      write(fileCat[ca],rec);
                      cu:=rec.prev;
                    end
                   else
                    cu:=0;
              saved:=changed;
              closefile(fileCat[ca]);
              reset(fileCat[ca]);
              seek(fileNum,10+ca);
              write(fileNum,info);
            end;
      CatUnlock(ca);
      LockCatN[ca].Enter;
      with CNN[ca].info do
        if saved.t64<changed.t64 then
          begin
            cu:=last;
            while cu<>0 do
              with CatNNum[ca][cu] do
                with ctrl do
                  if saved.t64<Ntim.t64 then
                    begin
                      SaveInt(CatDirs[ca]+'n'+IntToArt(cu),nums,Nfirst);
                      cu:=Nprev;
                    end
                   else
                    cu:=0;
            saved:=changed;
          end;
      LockCatN[ca].Leave;
      LockCatL[ca].Enter;
      with CLN[ca].info do
        if saved.t64<changed.t64 then
          begin
            cu:=last;
            while cu<>0 do
              with CatLNum[ca][cu] do
                with ctrl do
                  if saved.t64<Ntim.t64 then
                    begin
                      SaveInt(CatDirs[ca]+'l'+IntToArt(cu),nums,Nfirst);
                      cu:=Nprev;
                    end
                   else
                    cu:=0;
            saved:=changed;
          end;
      LockCatL[ca].Leave;
    end;

end.
