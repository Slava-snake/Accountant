unit Atypes;
interface
uses
  Graphics, Windows, ComCtrls, SysUtils, StrUtils, Grids;
const
  clMaroon=TColor($3040AF);
  ServerPort=8888;
  ServRun=8887;

  nListStep=64;

  Tip   = 0;
  Mat   = 1;
  Firm  = 2;
  Size  = 3;
  Agent = 4;

  Tovar   = 0;
  Cart    = 1;
  Prihod  = 2;
  Rashod  = 3;
  Sale    = 4;

  stReady = 0;
  stOpen  = 1;
  stExec  = 2;
  stAnn   = 3;
  stCancel= 4;
  stEdit  = 5;


type
  tstrgrid=class(TStringgrid)
  public
    procedure MoveRow(FromIndex,ToIndex:integer);
  end;

  fint      = file of integer;
  tprop     = set of (prNam,prNode);
  t2str     = string[2];
  t3str     = string[3];
  tNam      = string[31];            {32}
  tArt      = string[11];            {12}
  tHexN     = string[8];             {9}
  tOpis     = string[47];            {48}
  tTim      = string[8]; {hh:mm:ss}  {9}
  tTimMs    = string[12]; {hh:mm:ss:uuu} {13}
  tDat      = string[10];{yyyy.mm.dd} {11}
  tFileNam  = string[12];{filename.ext} {13}
  tCharComm = array [0..3] of char; {4}
  tDatTim   = record
    case integer of
      0 : (ft :tFileTime);
      1 : (t64:int64);
    end;
  tLock = packed record {4}
      lock : boolean;
      res1 : byte;
      fil  : byte;
      oper : byte;
    end;
  tAct = packed record   {10}{12}
      tim  : tDatTim;
      fil  : byte;
      oper : byte;
    end;
  tMasInfo = record  {48}
      N,ofs,First,Last : integer;  {16}
      changed,saved    : tDatTim;  {16}
      lasttim          : cardinal; {4}
      reserve          : array[0..2]of integer;{12}
    end;
  tMas = record  {64}
      lock        : tLock;    {4}
      lockrec     : integer;  {4}
      Msize       : integer;  {4}
      res         : integer;   {4}
      info        : tMasInfo; {48}
    end;
  tArrInt   = array of integer;
  tDocPos   = record
      nDoc,nPos:integer;
    end;
  tArrDocPos= array of tDocPos;
  tNumAct   = record   {40}
      NLock               : tLock; {4}
      NN,SS,Nfirst,Nnext,Nprev,Nlast,Nn0: integer; {28}
      Ntim               : tDatTim; {8}
    end;
  tNumActPR = record
      Nlock : tLock;
      Nnext,Nprev,Nrows : integer;
      Ntim        : tDatTim;
    end;
  tAnswerHead = record {24}
      prevS,timS : tDatTim;
      num,count  : integer;
    end;
  tCartBase = record {16}
      tov          : integer;
      siz          : integer;
      kol          : integer;
      price        : integer;
    end;
  tPrihRow = record  {32}
      base         : tCartBase; {16}
      tsum,tprice  : integer; {8}
      cartnum ,res : integer;  {8}
    end;
  tRashRow = record  {32}
      base             : tCartBase; {16}
      tsum,tprice,raz  : integer;  {12}
      cartnum          : integer;  {4}
    end;
  tNumArr = record
      ctrl : tNumAct;
      nums : tArrInt;
    end;
  tNaklRow = record
      case byte of
        0: (pp:tPrihRow);
        1: (rr:tRashRow);
    end;
  tNaklRows = array of tNaklRow;
  tNumPR = record
      ctrl : tNumActPR;
      rows : tNaklRows;
    end;
  tDocPosArr = record
      ctrl  : tNumAct;
      ra    : tArrDocPos;
      pospos: integer;
    end;
  tListRecNums = array of tNumArr;
  tfileNumctrl = file of tNumAct;
  tTovarRec = record {72}
      tip,mat,firm : integer;     {12}
      art          : tArt;     {12}
      opis         : tOpis;    {48}
    end;
  tTovarState = record {116}
      rec          : tTovarRec;{72}
      tim          : tDatTim; {8}
      next,prev    : integer;   {8}
      recom        : integer;   {4}
      creat        : tAct;     {12}
      edit         : tAct;     {12}
    end;
  tTovar = record  {120}
      state        : tTovarState; {116}
      lock         : tLock;    {4}
    end;
  tCartRec = record  {32}
      base         : tCartBase;{20}
      ost          : integer; {4}
      nakl,pos     : integer;  {8}
    end;
  tCartState = record  {64}
      rec          : tCartRec; {32}
      creat        : tAct;{12}
      tim          : tDatTim; {8}
      next,prev    : integer;   {8}
    end;
  tCart = record   {68}
      state        : tCartState;  {64}
      lock         : tLock;   {4}
    end;
  tPrihPos =   record  {52}
      agent        : integer;   {4}
      agdat        : integer;   {4}
      sum          : integer; {4}
      agnum        : tNam;     {32}
      data         : integer;  {4}
      Npos         : integer; {4}
    end;
  tPrihState = record    {140}
      rec          : tPrihPos;  {48}
      status       : integer;  {4}
      creat,exec,
      ann,open,edit: tAct; {60}
      tim          : tDatTim; {8}
      next,prev    : integer;   {8}
    end;
  tPrih =record  {144}
      state    : tPrihState;  {118}
      lock     : tLock;        {4}
      loaded   : boolean; {8}
    end;
  tRashPos = record   {52}
      agent        : integer;     {4}
      agdat        : integer;     {4}
      agnum        : tNam;     {32}
      data         : integer;  {4}
      sum,raz      : integer; {8}
    end;
  tRashState = record   {126}
      rec          : tRashPos; {68}
      status       : integer;  {4}
      creat,exec,
      ann,open,edit: tAct; {60}
      tim          : tDatTim; {8}
      next,prev    : integer;   {8}
      Npos         : integer; {4}
    end;
  tRash  = record  {148}
      lock         : tLock;    {4}
      loaded       : boolean;
      state        : tRashState; {122}
    end;
  tRecArr = record
      case integer of
        Tovar  : (tt:tTovarRec);
        Cart   : (cc:tCartRec);
        Prihod : (pp:tPrihPos);
        Rashod : (rr:tRashPos);
      end;
  tStateArr = record
      case integer of
        Tovar  : (tt:tTovarState);
        Cart   : (cc:tCartState);
        Prihod : (pp:tPrihState);
        Rashod : (rr:tRashState);
      end;

  tListPos = record  {36}
      nam        : tNam; {32}
      node       : integer; {4}
    end;
  tListRec = record
      pos        : tListPos;   {36}
      creat,edit : tAct;  {20}
      tim        : tDatTim;
      next,prev  : integer;
    end;
  tListState = record
      rec        : tListRec;
      lock       : tLock;     {4}
      viewnodeL  : tTreeNode; {4}
      prop       : tprop;   {4}
    end;
  tLstate = array of tListState;

  tCatRec= record
      pos        : tListPos;   {36}
      creat,edit : tAct;  {20}
      tim        : tDatTim;
      next,prev  : integer;
    end;
  tCatNode = record
               rec       : tCatRec;
               lock      : tLock;     {4}
               viewnodeC : tTreeNode; {4}
               prop      : tprop;{4}
     end;
  tCstate = array of tCatNode;

  tMoneyMove = record
      MonCash,Monless:integer;
    end;
  pMoneyMove = ^tMoneyMove;
  tKassaAction=(caOpenKassa,caCloseKassa,caDeposit,caWithdrawal,caSale,caXreport,caZreport,caReturn);
  tChequeStatus=(csUndef,csOpen,csAnnul,csSale,csReturn);
  tChequePosAct = (cpAdd,cpDel,cpChange,cpIns);
  tChequePos = record  {24}
      SaleCart,SaleCount         : integer;
      SalePrice,SaleSum,SaleRazn : integer;
      tim                        : cardinal;
    end;
  tChequeStat = record   {44}
      status                 : tChequeStatus;  {4}
      tim                    : cardinal;  {4}
      Nkas,Npos              : integer;   {8}
      Sum,Razn,Cash,Cashless : integer; {16}
      creat                  : tDatTim;   {8}
      buyer                  : integer;  {4}
    end;
  tTodayChequeHeader = record  {52}
      stat             : tChequeStat;     {44}
      prev,next        : integer; {8}
    end;
  tTodayCheque = record   {64}
      header  : tTodayChequeHeader;   {52}
      chpos   : array of tChequePos; {4}
      Nres    : integer;  {4}
      res1    : integer; {4}
    end;
  tKassaOperation = record
      tim      : cardinal;
      KassaAct : tKassaAction;
      MoneyCash,MoneyCashless,CurrCash,CurrCashless,
      CurrKassa    : integer;
    end;
  tKassa = record   {24}
      OpenStatus,Active  : boolean;  {8}
      Date               : integer;   {4}
      Cash,Cashless      : integer;  {8}
      Receipts           : integer;  {4}
    end;
  tSendCheqPos = record   {12}
      Ncart,scount,sprice :integer;
    end;
  tSendReservePos = record {20}
      doc,pos :integer;
      CheqPos   : tSendCheqPos;
    end;
  tReservedPos = record   {32}
      tim:tDatTim;
      Nkas:integer;
      ResPos:tSendReservePos;
    end;
  tArrOpened = array [0..9] of integer;
  tReopenKass  = record
      Cash,Cashless,Receipts : integer;
      openedCheq : tArrOpened;
    end;

  tarrnum     =array[0..33]of integer;
  tarrdocpos16=array[0..16]of tDocPos;
  tarrnaklrow =array[0..3]of tnaklRow;
  tQueryPacket = record
      sync : int64; {8}
      sl   : tCharComm; {4}
      num  : integer;   {4}
      xx   : integer;   {4}
      case byte of
        0: (recA:tRecArr);
        1: (ll:tListPos);
        2: (srp:tSendReservePos);
        3: (mon:tMoneyMove);
        4: (tim:tDatTim);
        5: (cheqpos:tChequePos);
    end;
  tAnswerPacket = record
      ans : tAnswerHead;
      case byte of
        0: (tt:tTovarState);
        1: (cc:tCartState);
        2: (pp:tPrihState);
        3: (rr:tRashState);
        4: (ca:tCatRec);
        5: (ll:tListRec);
        6: (aa:tarrnum);
        7: (na:tarrnaklRow);
        8: (dp:tarrDocPos16);
        9: (kas:tReopenKass);
       10: (tch:tTodayChequeHeader);
       11: (chs:tChequeStat);
       12: (chp:tChequePos);
    end;

  tKont = record  {128}
      tel          : string[31];
      email        : string[31];
      adr          : string[63];
    end;
  tTimHMSm = record
      iHour,iMinute,iSecond,iMSec:integer;
    end;

const
  NullLock :tLock = (lock:false;res1:0;fil:0;oper:0);
  MinuteIn100nsec = 600000000;
  Days100nsecs : int64 = 864000000000;
var
  TimeBias:int64=int64(120)*int64(MinuteIn100nsec);
  day256:cardinal=$c92a69c0;
  hour256:cardinal=$0861c468;
  min256:cardinal=$0023c346;
  sec256:cardinal=39062;
  msec256:cardinal=39;

procedure SetTimeBias;
function TimeNow:tDatTim;
function GetTodayDat:integer;
procedure SplitTimDat(const dt:tDatTim; var ti:cardinal; var da:integer);
function GetDat(const dt:tDatTim):integer;
function TimToStr(ti:integer):tTim; overload;
function TimToStr(const ti:tDatTim;  const ms:boolean=false; const ch:char=':'):tTimMs; overload;
function DatToStr(dat:integer):tDat; overload;
function DatToStr(const dt:tDatTim):tDat; overload;
function DatTimToStr(const dt:tDatTim):string;
function DatTimToFileName(const dt:tDatTim):string;
function DateTimeToDat(const dt:tDateTime):integer;
function DatToDateTime(dat:integer):tDateTime;
function GetTim(const dt:tDatTim):cardinal;
function SumStrInt(const s1,s2:string):string;

function ReserveSize(n,block:integer):integer;
function noZifrFiltr(var key:char):boolean;
procedure DivInto(num,sum:integer; var n1,n2,lowprice:integer);
function MatchInStr(const st1:string; st2:tOpis):boolean;
function FindMatch2Int(const a1,a2:tNumArr; var i1,i2:integer):integer;
function FindMatch3Int(const a1,a2,a3:tNumArr; var i1,i2,i3:integer):integer;

procedure StringGridBlockShiftUp(tsg:TStringGrid; start,count:integer; step:integer=1);
procedure StringGridBlockShiftDown(tsg:TStringGrid; start,count:integer; step:integer=1);
procedure StringGridInsertRows(tsg:TStringGrid; index,count:integer);
procedure StringGridInsertBlankRows(tsg:TStringGrid; index,count:integer);
procedure StringGridMoveRow(tsg:TStringGrid; index1,index2:integer);

implementation

procedure SetTimeBias;
  var
    tzi:tTimeZoneInformation;
  begin
    GetTimeZoneInformation(tzi);
    TimeBias:=int64(MinuteIn100nsec)*tzi.Bias;
  end;

function TimeNow:tDatTim;
  begin
    GetSystemTimeAsFileTime(Result.ft);
    dec(Result.t64,TimeBias);
  end;

function GetDat(const dt:tDatTim):integer;
  asm
    push edx
    mov edx,[eax+4]
    mov eax,[eax]
    mov al,dl
    shr edx,8
    ror eax,8
    div Day256
    pop edx
  end;

procedure SplitTimDat(const dt:tDatTim; var ti:cardinal; var da:integer);
  asm
    push edx
    mov edx,[eax+4]
    mov eax,[eax]
    mov al,dl
    shr edx,8
    ror eax,8
    div Day256
    mov [ecx],eax {dat}
    pop eax
    mov [eax],edx  {tim}
  end;

function GetTodayDat:integer;
  begin
    Result:=GetDat(TimeNow);
  end;

function GetTim(const dt:tDatTim):cardinal;
  asm
    mov edx,[eax+4]
    mov eax,[eax]
    mov al,dl
    shr edx,8
    ror eax,8
    div Day256
    mov eax,edx  {tim}
  end;

function intto2str(nn:integer):t2str;
  asm
    mov [edx],byte(2)
    aam
    add ax,$3030
    mov [edx+1],ah
    mov [edx+2],al
  end;

function intto3str(nn:integer):t3str;
  asm
    push ecx
    mov [edx],byte(3)
    mov ch,$64{0A}
    div ch
    add al,$30
    mov [edx+1],al
    mov al,ah
    aam
    add ax,$3030
    mov [edx+2],ah
    mov [edx+3],al
    pop ecx
  end;

function TimToTimHMSm(const ti:integer):tTimHMSm;
  asm
    push ecx
    mov ecx,edx
    xor edx,edx
    div hour256
    mov [ecx],eax
    mov eax,edx
    cdq
    div min256
    mov [ecx+4],eax
    mov eax,edx
    cdq
    div sec256
    mov [ecx+8],eax
    mov eax,edx
    cdq
    div msec256
    mov [ecx+12],eax
    pop ecx
  end;

function TimToStr(ti:integer):tTim; overload;
var
  tms:tTimHMSm;
begin
  tms:=TimToTimHMSm(ti);
  Result:=intto2str(tms.iHour)+':'+intto2str(tms.iMinute)+':'+intto2str(tms.iSecond);
end;

function TimToStr(const ti:tDatTim;  const ms:boolean=false; const ch:char=':'):tTimms; overload;
  var
    st:tSystemTime;
  begin
    FileTimeToSystemTime(ti.ft,st);
    Result:=intto2str(st.wHour)+ch+intto2str(st.wMinute)+ch+intto2str(st.wSecond);
    if ms then Result:=Result+ch+intto3str(st.wMilliseconds);
  end;

function DatToStr(const dt:tDatTim):tDat; overload;
  var
    st:tSystemTime;
  begin
    FileTimeToSystemTime(dt.ft,st);
    Result:=inttostr(st.wYear)+'.'+intto2str(st.wMonth)+'.'+intto2str(st.wDay);
  end;

function DatToStr(dat:integer):tDat; overload;
  var
    dt:tDatTim;
  begin
    dt.t64:=int64(dat)*Days100nsecs;
    Result:=DatToStr(dt);
  end;

function DatTimToStr(const dt:tDatTim):string;
  var
    st:tSystemTime;
  begin
    FileTimeToSystemTime(dt.ft,st);
    Result:=inttostr(st.wYear)+'.'+intto2str(st.wMonth)+'.'+intto2str(st.wDay)+#32+
            intto2str(st.wHour)+':'+intto2str(st.wMinute)+':'+intto2str(st.wSecond);
  end;

function DatTimToFileName(const dt:tDatTim):string;
  var
    st:tSystemTime;
  begin
    FileTimeToSystemTime(dt.ft,st);
    Result:=inttostr(st.wYear)+'.'+intto2str(st.wMonth)+'.'+intto2str(st.wDay)+'_'+
            intto2str(st.wHour)+'-'+intto2str(st.wMinute)+'-'+intto2str(st.wSecond)+'.'+intto3str(st.wMilliseconds);
  end;

function DateTimeToDat(const dt:tDateTime):integer;
  var
    st:tSystemTime;
    ft:tDatTim;
  begin
    DateTimeToSystemTime(dt,st);
    SystemTimeToFileTime(st,ft.ft);
    Result:=GetDat(ft);
  end;

function DatToDateTime(dat:integer):tDateTime;
  var
    dt:tDatTim;
    st:tSystemTime;
  begin
    dt.t64:=int64(dat)*Days100nsecs;
    FileTimeToSystemTime(dt.ft,st);
    Result:=SystemTimeToDateTime(st);
  end;

function ReserveSize(n,block:integer):integer;
  asm     {Result:=(n div block +1)*block;}
    mov ecx,edx
    cdq
    div ecx
    inc eax
    mul ecx
  end;

function  noZifrFiltr(var key:char):boolean;
begin
  if (key<>#13)and(key<>#8)and((key<'0')or(key>'9'))then Key:=#0;
  Result:=Key=#0;
end;

procedure DivInto(num,sum:integer; var n1,n2,lowprice:integer);
begin
  lowprice:=sum div num;
  n2:=sum-lowprice*num;
  n1:=num-n2;
end;

  function MatchInStr(const st1:string; st2:tOpis):boolean;
    var
      i,m,len:integer;
      sub:tOpis;
    begin
      Result:= st1='';
      if Result then exit;
      i:=1;
      len:=length(st1);
      repeat
        m:=posex(' ',st1,i);
        if m=0 then m:=len+1;
        sub:=copy(st1,i,m-i);
        if not AnsiContainsText(st2,sub) then exit;
        i:=m+1;
      until i>len;
      Result:=true;
    end;

function Min012(a,b,c:integer):integer;
begin
  Result:=4;
  if a<b then
    begin
      if a<c then
        begin
          Result:=1;
          exit
        end;
      if a=c then
        begin
          Result:=5;
          exit
        end;
    end;
  if a=b then
    begin
      if a<c then Result:=3;
      exit
    end;
  if b<c then  result:=2
   else
    if b=c then result:=6
end;

function FindMatch2Int(const a1,a2:tNumArr; var i1,i2:integer):integer;
begin
  while (i1<a1.ctrl.NN)and(i2<a2.ctrl.NN) do
    begin
      Result:= a1.nums[i1];
      if Result=a2.nums[i2] then
        begin
          inc(i1); inc(i2);
          exit;
        end;
      if Result<a2.nums[i2] then inc(i1)
       else inc(i2);
    end;
  Result:=0;
end;

function FindMatch3Int(const a1,a2,a3:tNumArr; var i1,i2,i3:integer):integer;
var
  i:integer;
begin
  while (i1<a1.ctrl.NN)and(i2<a2.ctrl.NN)and(i3<a3.ctrl.NN) do
    begin
      Result:= a1.nums[i1];
      if (Result=a2.nums[i2])and(a3.nums[i3]=a2.nums[i2]) then
        begin
          inc(i1); inc(i2); inc(i3);
          exit;
        end;
      i:=Min012(Result,a2.nums[i2],a3.nums[i3]);
      if (i and 1)<>0 then inc(i1);
      if (i and 2)<>0 then inc(i2);
      if (i and 4)<>0 then inc(i3);
    end;
  Result:=0;
end;

procedure Tstrgrid.MoveRow(FromIndex,ToIndex:integer);
begin
  inherited ;
end;

procedure StringGridBlockShiftDown(tsg:TStringGrid; start,count:integer; step:integer=1);
var
  i,j:integer;
begin
    with tsg do
      begin
        if RowCount<(start+count+step) then
          RowCount:=start+count+step;
        for i:=start+count-1 downto start do
          for j:=0 to ColCount-1 do Cols[j].Exchange(i,i+step);
      end;
end;

procedure StringGridBlockShiftUp(tsg:TStringGrid; start,count:integer; step:integer=1);
var
  i,j:integer;
begin
    with tsg do
      begin
        for i:=start to start+count-1 do
          for j:=0 to ColCount-1 do Cols[j].Exchange(i,i-step);
      end;
end;

procedure StringGridInsertRows(tsg:TStringGrid; index,count:integer);
var
  i,j:integer;
begin
  with tsg do
    begin
      RowCount:=RowCount+count;
      for i:=RowCount-count-1 downto index do
        for j:=0 to ColCount-1 do
          Cols[j].Exchange(i,i+count);
    end;
end;

procedure StringGridInsertBlankRows(tsg:TStringGrid; index,count:integer);
var
  i,j:integer;
begin
  StringGridInsertRows(tsg,index,count);
  for i:=index to index+count-1 do
    for j:=0 to tsg.ColCount-1 do
      tsg.Cells[j,i]:='';
end;

procedure StringGridMoveRow(tsg:TStringGrid; index1,index2:integer);
var
  j:integer;
begin
  for j:=0 to tsg.ColCount-1 do
    tsg.Cols[j].Move(index1,index2);
end;

function SumStrInt(const s1,s2:string):string;
begin
  result:=inttostr(strtoint(s1)+strtoint(s2));
end;

end.
