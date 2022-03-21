unit lists;

interface
uses
  data, Atypes, nums, ComCtrls, SyncObjs, SysUtils;

const
  agentDir = 'Agents\';
  firmDir  = 'Firms\';
  tipDir   = 'Types\';
  matDir   = 'Material\';
  sizeDir  = 'Sizes\';

  listsFile = 'lists.cnt';
  listsNum  = 'listsnum.cnt';
  tipFile   = 'type.cnt';
  matFile   = 'material.cnt';
  firmFile  = 'firm.cnt';
  sizeFile  = 'size.cnt';
  agentFile = 'agent.cnt';

var
  LockL     : array [Tip..Agent]   of TCriticalSection;
  L         : array [Tip..Agent]   of tMas;
  Lstat     : array [Tip..Agent]   of tLstate;
  listfile  : array [Tip..Agent]   of tFileNam=(tipFile,matFile,firmFile,sizeFile,agentFile);
  listDir   : array [Tip..Agent]   of tFileNam=(tipDir,matdir,firmDir,sizeDir,agentDir);
  fileList  : array [Tip..Agent]   of file of tListRec;

  procedure SaveList(li:integer);
  procedure ListLock(li:integer);
  procedure ListUnLock(li:integer);
  procedure ListUnlockRec(li,ind:integer);

  function CheckListRange(li:integer; po:integer):boolean;
  function CountSendL(li:integer; const sync:int64; var start:integer):integer;

  function LAddNew(li:integer; const newpos:tListPos; const sync:int64):tAnswerHead;
  function RenameL(li:integer; ind:integer; const newname:tNam; const sync:int64=-1):tAnswerHead;
  function ChangeLnode(li:integer; ind,newnode:integer):tAnswerHead;

implementation

uses arrs,cats;

function CountSendL(li:integer; const sync:int64; var start:integer):integer;
var
  no:integer;
begin
  Result:=0;
  start:=0;
  no:=L[li].info.last;
  while no>0 do
    with Lstat[li][no] do
      if (rec.tim.t64>sync) then
        begin
          inc(Result);
          start:=no;
          no:=rec.prev;
        end
       else
        exit
end;

  procedure ListLock(li:integer);
    begin
      LockL[li].Enter;
      L[li].lock:=CLlock;
    end;

  procedure ListUnLock(li:integer);
    begin
      L[li].lock.lock:=false;
      LockL[li].Leave;
    end;

  procedure ListLockRec(li,ind:integer);
    begin
      ListLock(li);
      CriticalSetLock(Lstat[li][ind].lock);
      L[li].lockrec:=ind;
    end;

  procedure ListUnlockRec(li,ind:integer);
    begin
      L[li].lockrec:=0;
      ResetLock(Lstat[li][ind].lock.lock);
      ListUnlock(li);
    end;

  function ErrorAnswerList(li:integer):tAnswerHead;
    begin
      Result.prevS:=L[li].info.changed;
      Result.timS.t64:=0;
      Result.num:=0;
    end;

  procedure SetLastL(Li,nn:integer);
    begin
      with L[li].info do
        with Lstat[li][nn].rec do
          begin
            next:=0;
            prev:=last;
            Lstat[li][last].rec.next:=nn;
            last:=nn;
          end;
    end;

  procedure CutL(li,ind:integer);
    begin
      with Lstat[li][ind].rec do
        begin
          if prev<>0 then Lstat[li][prev].rec.next:=next;
          if next<>0 then Lstat[li][next].rec.prev:=prev;
        end;
    end;

  procedure ChangeLastL(li,ind:integer);
    begin
      if ind<>L[li].info.last then
        begin
          CutL(li,ind);
          SetLastL(li,ind)
        end;
    end;

  function GoodAnswerL(li,ind:integer; var ti:tDatTim):tAnswerHead;
    begin
      Result.prevS:=L[li].info.changed;
      Result.timS:=ti;
      Result.num:=ind;
      ChangeLastL(li,ind);
      L[li].info.changed:=ti;
    end;

  function CheckListRange(li:integer; po:integer):boolean;
    begin
      Result:=(L[li].info.N>0)and(po<=L[li].info.N)and(po>0);
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

  function ListNamFails(li,excl:integer; const name:tNam; const sync:int64):boolean;
    begin
      Result:=ListFindByNameSync(li,excl,name,sync)=0
    end;

  function LAddNew(li:integer; const newpos:tListPos; const sync:int64):tAnswerHead;
    var
      i:integer;
    begin
      if CatCheckRange(li,newpos.node) and(newpos.nam<>'')then
        begin
          ListLock(li);
          if ListNamFails(li,0,newpos.nam,sync) then
            with L[li] do
              begin
                i:=info.N+1;
                LockNumL(li);
                if Msize<=i then
                  begin
                    inc(Msize,nListStep);
                    setlength(Lstat[li],Msize);
                    setlength(LNum[li],Msize);
                  end;
                with LNum[li][i] do
                  begin
                    ctrl.Ntim.t64:=0;
                    setlength(nums,0);
                  end;
                with Lstat[li][i] do
                  begin
                    lock.lock:=false;
                    viewnodeL:=nil;
                    with rec do
                      begin
                        pos:=newpos;
                        tim:=TimeNow;
                        FillAct(creat,tim);
                        edit.tim.t64:=0;
                        Result:=GoodAnswerL(li,i,tim);
                      end;
                  end;
                AddCatLeaf(li,newpos.node,i);
                UnlockNumL(li);
                info.N:=i;
            end
        end
       else
        Result:=ErrorAnswerList(li);
      ListUnLock(li);
    end;

  function RenameL(li:integer; ind:integer; const newname:tNam; const sync:int64=-1):tAnswerHead;
    begin
      if CheckListRange(li,ind) then
        begin
          ListLockRec(li,ind);
          if ListNamFails(li,ind,newname,sync) then
            with Lstat[li][ind] do
              begin
                prop:=prop+[prNam];
                rec.pos.nam:=newname;
                rec.tim:=TimeNow;
                FillAct(rec.edit,rec.tim);
                Result:=GoodAnswerL(li,ind,rec.tim);
              end
           else
            Result:=ErrorAnswerList(li);
          ListUnlockRec(li,ind);
        end
       else
        Result:=ErrorAnswerList(li);
    end;

  function ChangeLnode(li:integer; ind,newnode:integer):tAnswerHead;
    begin
      if CheckListRange(li,ind) then
        begin
          ListLockRec(li,ind);
          with Lstat[li][ind] do
            if (rec.pos.node<>newnode)and MoveCatLeaf(li,rec.pos.node,newnode,ind) then
              begin
                prop:=prop+[prNode];
                rec.pos.node:=newnode;
                rec.tim:=TimeNow;
                FillAct(rec.edit,rec.tim);
                Result:=GoodAnswerL(li,ind,rec.tim);
              end
             else
              Result:=ErrorAnswerList(li);
          ListUnlockRec(li,ind);
        end
       else
        Result:=ErrorAnswerList(li);
    end;

  procedure SaveList(li:integer);
    var
      cu:integer;
    begin
      ListLock(li);
      with L[li] do
        with info do
          if saved.t64<changed.t64 then
            begin
              cu:=last;
              while cu<>0 do
                with Lstat[li][cu] do
                  if rec.tim.t64>saved.t64 then
                    begin
                      seek(fileList[li],cu-1);
                      write(fileList[li],rec);
                      cu:=rec.prev;
                    end
                   else
                    cu:=0;
              closefile(fileList[li]);
              reset(fileList[li]);
              seek(fileNum,5+li);
              write(fileNum,info);
              saved:=changed;
            end;
      LockNumL(li);
      with LN[li] do with info do
        if saved.t64<changed.t64 then
          begin
            cu:=last;
            while cu<>0 do
              with LNum[li][cu]  do
                with ctrl do
                  if Ntim.t64>saved.t64 then
                    begin
                      SaveInt(ListDir[li]+IntToArt(cu),nums,Nfirst);
                      cu:=Nprev;
                    end
                   else
                    cu:=0;
            closefile(listNumfile[li]);
            reset(listNumfile[li]);
            saved:=changed;
            seek(fileNN,5+li);
            write(fileNN,info);
          end;
      UnlockNumL(li);
      ListUnlock(li);
    end;

end.
