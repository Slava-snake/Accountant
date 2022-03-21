unit data;

interface
uses
  Graphics, SyncObjs, SysUtils, StrUtils, Windows, Math, Atypes;

const
  servFile  = 'ServName.sb';
  clientDir = 'Clients\';
  clientFile= 'clients.cnt';
  LogError  = clientDir+'!error.cnt';
  numFile   = 'num.cnt';
  numNUM    = 'numCtrl.cnt';

type

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  tServBase = record
      state : byte;
      name  : string[254];
      folder: string[255];
    end;

var
  WC,BDname   : string;
  BD          : array of tServBase;
  BDnum       : integer;
  BDtime      : integer;
  BGpos       : integer;
  BGtop       : integer;
  BGedit      : integer;
  BDcreat     : boolean = false;
  BDedit      : boolean = false;
  CLcount     : integer = 0;
  ServerToday : integer;
  logsect     : TcriticalSection;
  fileNum,fileNN  : file of tMasInfo;

  threadvar CLpos    : integer;
  threadvar CLlock   : tLock;
  threadvar CLname   : tNam;
  threadvar CLnum    : byte;
  threadvar CLoper   : byte;
  threadvar CLerr    : boolean;
  threadvar CLitself : boolean;

function SetLockBitFault(var X:boolean):boolean;
procedure ResetLock(var X:boolean);
procedure CriticalSetLock(var X:tLock);
function IsLockMine(const X:tLock):boolean;
function IsLockNotMine(const X:tLock):boolean;
procedure ZeroAnswer(var ans:tAnswerHead);

function NullNumAct: tNumAct;
function ConvA(ch:char):integer;
function ConvL(ch:char):integer;
function HexToInt(st:tHexN):integer;
function IntToArt(n:integer):tArt;
function ArtToInt(st:tArt):integer;
function IsChanged:boolean;
function IsAccessible:boolean;
function IsReadable:boolean;

procedure ResultOk(var res:tAnswerHead);
procedure FillAct(var ac:tAct; const ti:tDatTim);

procedure SaveSome0(fn:TFileNam; c:integer);
procedure WriteLogNo(st:string);
procedure WriteLog(st:string);
procedure WriteServFile(x:integer);

procedure LoadDocPos(fn:string; var X:tArrDocPos; first:integer);
procedure SaveDocPos(fn:string; var X:tArrDocPos; first:integer);
procedure LoadInt(var fn:string; var X:tArrInt; first:integer; const maycount:integer=0);
procedure SaveInt(fn:string; var X:tArrInt; first:integer);

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
implementation

procedure ZeroAnswer(var ans:tAnswerHead);
  begin
    fillchar(ans,sizeof(tAnswerHead),0);
  end;

function NullNumAct: tNumAct;
  begin
    with Result do
      begin
        Nlock.lock:=false;
        NN:=0;
        Nfirst:=0; Nlast:=0;
        Nnext:=0;
        Nprev:=0;
        Ntim.t64:=0;
      end;
  end;

function SetLockBitFault(var X:boolean):boolean; assembler; register;
asm
  lock bts [eax],0
       sbb eax,eax
       ret
end;

procedure ResetLock(var X:boolean); assembler; register;
asm
  lock btr [eax],0
       ret
end;

procedure CriticalSetLock(var X:tLock);
begin
  with X do
    begin
      while SetLockBitFault(X.lock) do sleep(0);
      fil:=CLnum;
      oper:=CLoper;
    end;
end;

function IsLockMine(const X:tLock):boolean;
  begin
    Result:=X.lock and (X.fil=CLnum) and (X.oper=CLoper);
  end;

function IsLockNotMine(const X:tLock):boolean;
  begin
    Result:=not IsLockMine(X);
  end;

function HexToInt(st:tHexN):integer;
  var
    i,n:integer;
    w,ca:cardinal;
  begin
    w:=$10000000;
    ca:=0;
    for i:=1 to 8 do
      begin
        if st[i]>='A' then n:=ord(st[i])-55
         else n:=ord(st[i])-48;
        inc(ca,n*w);
        w:=w shr 4;
      end;
    Result:=ca;
  end;

procedure ResultOk(var res:tAnswerHead);
  begin
    res.timS:=TimeNow;
    res.num:=CLnum;
  end;

procedure FillAct(var ac:tAct; const ti:tDatTim);
  begin
    with ac do
      begin
        tim:=ti;
        fil:=CLnum;
        oper:=CLoper;
      end
  end;

  function ConvL(ch:char):integer;
    begin
      case ch of
        'T' : Result:=Tip;
        'M' : Result:=Mat;
        'F' : Result:=Firm;
        'S' : Result:=Size;
        'A' : Result:=Agent
       else
         Result:=-1;
      end;
    end;

  function ConvA(ch:char):integer;
    begin
      case ch of
        'T' : Result:=Tovar;
        'C' : Result:=Cart;
        'P' : Result:=Prihod;
        'R' : Result:=Rashod;
        'S' : Result:=Sale;
       else
        Result:=-1;
      end;
    end;

procedure SaveSome0(fn:TFileNam; c:integer);
  var
    fi:integer;
    x:byte;
  begin
    if c<=0 then exit;
    fi:=fileopen(fn,1);
    x:=0;
    repeat
      filewrite(fi,x,1);
      dec(c);
    until c=0;
    fileclose(fi);
  end;

procedure WriteLogNo(st:string);
var
  logNo:textfile;
begin
  logsect.Enter;
  assignfile(LogNo,LogError);
  append(LogNo);
  writeln(LogNo,DatTimTostr(TimeNow)+#32+st);
  closefile(LogNo);
  logsect.Leave
end;

procedure WriteLog(st:string);
var
  logfile:textfile;
  log:string;
  ti:tDatTim;
begin
  ti:=TimeNow;
  log:=clientDir+CLname+'\'+DatToStr(ti)+'.log';
  assignfile(logfile,log);
  if fileexists(log) then
    append(logfile)
   else
    rewrite(logfile);
  writeln(logfile,TimToStr(ti)+#32+st);
  closefile(logfile);
end;

procedure WriteServFile(x:integer);
  var
    f:file of tServBase;
  begin
      assignfile(f,ServFile);
      filemode:=1;
      reset(f);
      seek(f,x);
      write(f,BD[x]);
      closefile(f);
      filemode:=0;
  end;

{=================================================================}
function IntToArt(n:integer):tArt;
  begin
    Result:=format('%9.9d',[n]);
  end;

function ArtToInt(st:tArt):integer;
  begin
    if not TryStrToInt(st,Result) then Result:=-1;
  end;

function IsChanged:boolean;
  begin
    Result:=BDtime<>fileage(ServFile);
  end;

function IsAccessible:boolean;
  begin
    Result:=((fileGetAttr(ServFile) and faReadOnly)=0);
  end;

function IsReadable:boolean;
  begin
    Result:=not IsAccessible;
  end;

procedure LoadInt(var fn:string; var X:tArrInt; first:integer; const maycount:integer=0);
var
  fi: fint;
  count:integer;
begin
  assignfile(fi,fn);
  reset(fi);
  seek(fi,first);
  if maycount<0 then
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

end.

