unit server;

interface

uses  Dialogs, Menus, IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdComponent, IdTCPServer, ComCtrls, StdCtrls, ExtCtrls, Controls, Grids,
  Classes, Graphics, SyncObjs, FileCtrl, windows, Messages, Forms, Types, SysUtils,
  data,nums,lists,arrs,cats,kass,clients_, Atypes;

type
  TMyTreeView = class(TTreeView)
  published
    property OnCancelEdit;
  end;
  TForm1 = class(TForm)
    Button1: TButton;
    BG: TStringGrid;
    Button2: TButton;
    Button3: TButton;
    TCPserv: TIdTCPServer;
    TCPrun: TIdTCPClient;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    PageCtrl1: TPageControl;
     TabSheet1: TTabSheet; {connections}
      ConnG: TStringGrid;
      actBut: TButton;
     TabSheet2: TTabSheet; {receipt invoices}
      PG: TStringGrid;
      Pgroup: TRadioGroup;
     TabSheet3: TTabSheet;  {expense invoices}
     TabSheet4: TTabSheet;  {sales}
      SG: TStringGrid;
      Sgroup: TRadioGroup;
     TabSheet5: TTabSheet;  {goods}
      TG: TStringGrid;
     TabSheet6: TTabSheet;  {carts}
      CG: TStringGrid;
      Cgroup: TRadioGroup;
     TabSheet7: TTabSheet;  {clients}
      CLlist: TStringGrid;
      AddClientButton: TButton;
      EditClientButton: TButton;
     TabSheet8: TTabSheet;  {cataloges}
      CatGroup: TRadioGroup;
      CatMenu: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure BGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure Button2Click(Sender: TObject);
    procedure BGKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Enter(Sender: TObject);
    procedure Button1Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditMode;
    procedure SelectMode;
    procedure BGKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    function  getnum(i:integer):integer;
    procedure BDrefresh;
    procedure TCPservExecute(AThread: TIdPeerThread);
    procedure BGEnter(Sender: TObject);
    procedure BGExit(Sender: TObject);
    procedure Button2Enter(Sender: TObject);
    procedure Button2Exit(Sender: TObject);
    procedure Button3Enter(Sender: TObject);
    procedure Button3Exit(Sender: TObject);
    procedure BGDblClick(Sender: TObject);
    procedure TCPservDisconnect(AThread: TIdPeerThread);
    procedure TCPservConnect(AThread: TIdPeerThread);
    procedure ButClientClick(Sender: TObject);
    procedure DisconnectClient(Sender: TObject);
    procedure ConnGDblClick(Sender: TObject);
    procedure PageCtrl1Change(Sender: TObject);
    procedure actButClick(Sender: TObject);
    procedure EditClientButtonClick(Sender: TObject);
    procedure AddClientButtonClick(Sender: TObject);
    procedure EditClientMode;
    procedure SelectClientMode;
    procedure CLlistKeyPress(Sender: TObject; var Key: Char);
    procedure CatGroupClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure CatTVCancelEdit(Sender: TObject; Node: TTreeNode);
    procedure CatTVEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure CatTVCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure N6Click(Sender: TObject);
    procedure PageCtrl1Resize(Sender: TObject);
  private
    { Private declarations }
    myCatTV:array[Tip..Agent]of TmyTreeView;
    procedure Load;
    procedure SaveDB;
  public
    { Public declarations }
    CatTV     : tMyTreeView;
  end;
  tShowThr = class (tThread)
      procedure Execute; override;
    end;

var
  Form1       : TForm1;
  AppAct, AppDeact : TNotifyEvent;
  ShowThr     : tShowThr;
  thr         : cardinal;
  ServerRun   : boolean = false;
  SHOWrefresh : integer = 1000;
  adnod       : tTreeNode;
  noddata     : integer;
  nodtx       : tNam;
  sizeofap    : integer=sizeof(tAnswerPacket);


  EditClient: boolean ;
  CatN      : integer=0;
  CatMode   : integer=0;

implementation
{$R *.dfm}
var
  ChanAr:array[Tovar..Sale]of int64=(0,0,0,0,0);
  ChanLi:array[Tip..Agent] of int64=(0,0,0,0,0);
  ChanCa:array[Tip..Agent] of int64=(0,0,0,0,0);

procedure TForm1.SaveDB;
  var
    i   :integer;
  begin
    for i:=Tovar to Sale do SaveArr(i);
    for i:=Tip to Agent do
      begin
        SaveList(i);
        SaveCat(i);
      end;
  end;

procedure TForm1.Load;
  var
    fna,fnn : file of tNumAct;
    fdp : file of tDocPos;
    z,i,j,nn,m:integer;
    ff:string;
  begin
    {load A,L,Cat}
    reset(fileNum);
    reset(fileNN);
    for z:=Tovar to Sale do
      begin
        with A[z] do
          begin
            read(fileNum,info);
            lock.lock:=false;
          end;
        with AN[z] do
          begin
            read(fileNN,info);
            lock.lock:=false;
          end
      end;
    setlength(T,ReserveSize(A[Tovar].info.N,nListStep*4));
    setlength(C,ReserveSize(A[Cart].info.N,nListStep*8));
    setlength(P,ReserveSize(A[Prihod].info.N,nListStep));
    setlength(R,ReserveSize(A[Rashod].info.N,nListStep));
    setlength(ChequeArr,ReserveSize(A[Sale].info.N,nListStep*8));
    setlength(TNum,length(T));
    setlength(CNum,length(C));
    setlength(PNum,length(P));
    setlength(RNum,length(R));
    for z:=Tip to Agent do
      begin
        with L[z] do
          begin
            read(fileNum,info);
            lock.lock:=false;
            nn:=ReserveSize(info.N,nListStep);
            setlength(Lstat[z],nn);
            setlength(Lnum[z],nn);
          end;
        with LN[z] do
          begin
            read(fileNN,info);
            lock.lock:=false;
          end;
      end;
    for z:=Tip to Agent do
      begin
        with Cat[z] do
          begin
            if not eof(fileNum) then
              read(fileNum,info);
            lock.lock:=false;
            nn:=ReserveSize(info.N,nListStep);
            setlength(Cstat[z],nn);
            setlength(CatNnum[z],nn);
            setlength(CatLnum[z],nn);
          end;
        with CNN[z] do
          begin
            if not eof(fileNN) then
              read(fileNN,info);
            lock.lock:=false;
          end;
      end;
    for z:=Tip to Agent do
      with CLN[z] do
        begin
          if not eof(fileNN) then
            read(fileNN,info);
          lock.lock:=false;
        end;
    {load lists: tip,mat,firm,size,agent}
    {load catalogs}
    for z:=Tip to Agent do
      begin
        with L[z].info do
          begin
            reset(fileList[z]);
            seek(fileList[z],first);
            for i:=1 to N do
              with Lstat[z][i] do
                begin
                  read(fileList[z],rec);
                  lock.lock:=false;
                  viewnodeL:=nil;
                  prop:=[prNam,prNode];
                end;
            reset(listNumfile[z]);
            seek(listNumfile[z],LN[z].info.First);
            for i:=1 to N do read(listNumfile[z],LNum[z][i].ctrl);
            for i:=1 to N do
              begin
                ff:=ListDir[z]+IntToArt(i);
                with LNum[z][i] do
                if fileexists(ff)and(ctrl.NN<>0) then
                  LoadInt(ff,nums,ctrl.Nfirst)
                 else
                  setlength(nums,0);
              end
          end;
      {catalogs}
        with Cat[z].info do
          begin
            reset(fileCat[z]);
            seek(fileCat[z],first);
            for i:=1 to N do
              with Cstat[z][i] do
                begin
                  lock.lock:=false;
                  viewnodeC:=nil;
                  prop:=[prNam,prNode];
                  read(fileCat[z],rec);
                end;
            reset(CatNNumfile[z]);
            seek(CatNNumfile[z],CNN[z].info.First);
            for i:=1 to N do read(CatNNumfile[z],CatNNum[z][i].ctrl);
            for i:=1 to N do
              begin
                ff:=CatDir[z]+'n'+IntToArt(i);
                with CatNNum[z][i] do
                if fileexists(ff)and(ctrl.NN<>0) then
                  LoadInt(ff,nums,ctrl.Nfirst)
                 else
                  setlength(nums,0);
              end;
            reset(CatLNumfile[z]);
            seek(CatLNumfile[z],CLN[z].info.First);
            for i:=1 to N do read(CatLNumfile[z],CatLNum[z][i].ctrl);
            for i:=1 to N do
              begin
                ff:=CatDir[z]+'l'+IntToArt(i);
                with CatLNum[z][i] do
                if fileexists(ff)and(ctrl.NN<>0) then
                  LoadInt(ff,nums,ctrl.Nfirst)
                 else
                  setlength(nums,0);
              end
          end;
     end;
  {load numbers for tov,cart,prih,rash,sale}
  {tovar}
    reset(fileTovar);
    with A[Tovar].info do
      begin
        seek(fileTovar,first);
        for i:=1 to N do read(fileTovar,T[i].state);
        reset(TovarNumfile);
        seek(TovarNumfile,First);
        for i:=1 to N do read(TovarNumfile,TNum[i].ctrl);
        for i:=1 to N do
          with TNum[i] do
            if ctrl.NN>0 then
              begin
                ff:=ArrDir[Tovar]+IntToArt(i);
                if fileexists(ff) then
                  LoadInt(ff,nums,ctrl.Nfirst)
                 else
                  setlength(nums,0);
              end
             else
              setlength(nums,0);
      end;
  {cart}
    reset(fileCart);
    with A[Cart].info do
      begin
        seek(fileCart,first);
        for i:=1 to N do read(fileCart,C[i].state);
        reset(CartNumfile);
        seek(CartNumfile,First);
        for i:=1 to N do read(CartNumfile,CNum[i].ctrl);
        for i:=1 to N do
          with CNum[i] do
            if ctrl.NN>0 then
              begin
                ff:=ArrDir[Cart]+IntToArt(i);
                if fileexists(ff) then
                  LoadDocPos(ff,ra,ctrl.Nfirst)
                 else
                  setlength(ra,0);
              end
             else
              setlength(ra,0);
      end;
  {prihod}
    reset(filePrihod);
    with A[prihod].info do
      begin
        seek(filePrihod,first);
        for i:=1 to N do
          with P[i] do
            begin
              read(filePrihod,state);
              loaded:=false;
              lock.lock:=false;
            end;
      end;
  {rash}
    reset(fileRashod);
    with A[Rashod].info do
      begin
        seek(fileRashod,first);
        for i:=1 to N do
          with R[i] do
            begin
              read(fileRashod,state);
              loaded:=false;
              lock.lock:=false;
            end;
      end;
  {clients}
    reset(fileCL);
    ClientCount:=filesize(fileCl);
    if ClientCount>0 then
      begin
        Form1.CLlist.RowCount:=ClientCount+1;
        for i:=1 to ClientCount do
          begin
            read(fileCl,Clients[i].client);
            Clients[i].tim.t64:=0;
            CLlist.Cells[0,i]:=inttostr(i);
            CLlist.Cells[1,i]:=Clients[i].client.login;
            CLlist.Cells[2,i]:=Clients[i].client.name;
            CLlist.Cells[3,i]:=Clients[i].client.addr;
          end;
      end;
    EditClient:=false;
  end;

{_____________________________________________________________________________}

function TForm1.getnum(i:integer):integer;
  begin
    Result:= StrToInt(bg.Cells[0,i])-1;
  end;

procedure TForm1.Button1Click(Sender: TObject);{run}
  var
    x,i:integer;
  procedure fill0masinfo(var X:tMasInfo);
    begin
      with X do
        begin
          N:=0;
          First:=0;
          Last:=0;
          changed.t64:=0;
          saved.t64:=0;
        end;
    end;
begin
  BDrefresh;
  x:=getnum(BG.row);
  if (BD[x].state>=$80) then
    begin
      showmessage('Already run');
      exit
    end;
  if (BD[x].folder<>'') then
    begin
      if not directoryExists(BD[x].folder) then
        forcedirectories(BD[x].folder);
      if IsReadable then
        begin
          filesetreadonly(ServFile,false);
          filesetreadonly(ServFile,true);
        end;
      BDtime:=fileage(ServFile);
      chdir(BD[x].folder);
      CatTV.BringToFront;
      FileMode:=2;
      assignfile(fileCL,clientFile);
      assignfile(fileNum,numfile);
      assignfile(fileNN,numNUM);
      for i:=Tip to Agent do
        begin
          assignfile(fileList[i],listFile[i]);
          assignfile(listNumfile[i],listNumfilename[i]);
          assignfile(fileCat[i],CatFile[i]);
          assignfile(CatNNumfile[i],CatNNumfilename[i]);
          assignfile(CatLNumfile[i],CatLNumfilename[i]);
        end;
      assignfile(fileTovar,TovarFile);
      assignfile(TovarNumfile,arrNumfilename[Tovar]);
      assignfile(fileCart,CartFile);
      assignfile(CartNumfile,arrNumfilename[Cart]);
      assignfile(filePrihod,prihodFile);
      assignfile(fileRashod,RashodFile);
      if fileExists(NumFile) then
        Load
       else
        begin {new folders}
          rewrite(fileNum);
          rewrite(fileNN);
          MkDir(Clientdir);
          MkDir(catDir);
          FillChar(A,Sizeof(A),0);
          FillChar(AN,Sizeof(AN),0);
          for i:=Tovar to Sale do
            begin
              write(fileNum,A[0].info);
              write(fileNN,AN[0].info);
              MkDir(arrDir[i]);
              rewrite(fileTovar);
              rewrite(TovarNumfile);
              rewrite(fileCart);
              rewrite(CartNumfile);
              rewrite(filePrihod);
              rewrite(fileRashod);
            end;
          rewrite(fileCL);
          FillChar(L,sizeof(L),0);
          FillChar(LN,Sizeof(LN),0);
          FillChar(Cat,Sizeof(Cat),0);
          FillChar(CLN,Sizeof(CLN),0);
          FillChar(CNN,Sizeof(CNN),0);
          for i:=Tip  to Agent do
            begin
              write(fileNum,L[0].info);
              write(fileNN,LN[0].info);
              write(fileNN,LN[0].info);
              write(fileNN,LN[0].info);
              MkDir(listDir[i]);
              MkDir(catDirs[i]);
              rewrite(fileCat[i]);
              rewrite(fileList[i]);
              rewrite(CatNNumFile[i]);
              rewrite(CatLNumFile[i]);
              rewrite(ListNumFile[i]);
            end;
          fileclose(filecreate(LogError));
          ClientCount:=0;
        end;
      Application.OnActivate:=AppAct;
      Application.OnDeactivate:=AppDeact;
      bg.Hide;
      button1.Hide;
      button2.Hide;
      button3.Hide;
      CLname:='';
{_____________________RUN____________________________________________________________}
      SetTimeBias;
      ServerToday:=GetTodayDat;
      ServerRun:=true;
      BDname:=BD[x].name;
      inc(x);
      form1.Caption:='['+inttostr(x)+'] - '+BDname;
      PageCtrl1.Visible:=true;
      fillchar(kassa,10*sizeof(tKassa),0);
      FormClient.caption:=BDname+' - Clients';
      inc(x,ServerPort);
      TCPserv.Bindings.DefaultPort:=x;
      for i:=0 to TCPserv.Bindings.Count-1 do
        begin
          TCPserv.Bindings.Items[i].Port:=x;
        end;
      for i:=Tovar to Sale do
        begin
          LockA[i]:=TCriticalSection.Create;
          LockANum[i]:=TCriticalSection.Create;
        end;
      for i:=Tip to Agent do
        begin
          LockL[i]:=TCriticalSection.Create;
          LockC[i]:=TCriticalSection.Create;
          LockCatN[i]:=TCriticalSection.Create;
          LockCatL[i]:=TCriticalSection.Create;
          LockLNum[i]:=TCriticalSection.Create;
        end;
      logsect:=TcriticalSection.Create;
      Form1.Color:=clMoneyGreen;
      ShowThr:=tShowThr.Create(false);
      TCPserv.Active:=true;
      PageCtrl1.Width:=651;
    end
   else
    ShowMessage('Incorrect path.');
end;

{88888888888888888888888888888888888888888888888888888888888888888888888888888888888}
procedure tShowThr.Execute;
  type tSorty=record
    NN,SS,sorttype : integer;
    aa : tArrInt;
   end;
  var
    nc,i,j,k,x : integer;
    n64: int64;
    ti : cardinal;
    ch : array [0..9] of tSorty ;
 function Add2node(no:integer):TTreeNode; forward;
 function TextFilOper(fi,op:integer):tNam;
    begin
      Result:=inttostr(fi)+':'+inttostr(op);
    end;
  procedure PrihFillRow(o:integer);
    begin
         with form1.PG do
           with P[nc] do with state do
            begin
              cells[0,i]:=inttostr(nc+o);
              cells[1,i]:=DatToStr(rec.data);
              case status of
                stReady: cells[2,i]:='';
                stOpen : cells[2,i]:='O';
                stExec : cells[2,i]:='*';
                stAnn  : cells[2,i]:='-'
               else
                cells[2,i]:='Error';
              end;
              if lock.lock then
                cells[2,i]:=cells[2,i]+#32+TextFilOper(lock.fil,lock.oper);
              cells[3,i]:=inttostr(rec.sum);
              cells[4,i]:=dattimtostr(tim);
              cells[5,i]:=Lstat[Agent][rec.agent].rec.pos.nam+' №'+rec.agnum+' от '+DatToStr(rec.agdat);
          end;
    end;
  procedure TovarFillRow(o:integer);
    begin
      with Form1.TG do
        with T[nc].state do
          begin
            Cells[0,i]:=inttostr(nc+o);
            Cells[1,i]:=Lstat[Tip][rec.tip].rec.pos.nam;
            Cells[2,i]:=Lstat[Mat][rec.mat].rec.pos.nam;
            Cells[3,i]:=Lstat[Firm][rec.firm].rec.pos.nam;
            Cells[4,i]:=rec.art;
            Cells[5,i]:=rec.opis;
          end;
    end;
  procedure SaleFillRow(o:integer);
    var
      emp:boolean;
      zz :integer;
    begin
      with TodayArr[nc].header.stat do
        with Form1.SG do
          begin
            Cells[0,i]:=inttostr(nc+o);
            emp:=false;
            case status of
              csUndef : Cells[1,i]:=' ';
              csOpen  : Cells[1,i]:='O';
              csAnnul : begin
                          Cells[1,i]:='A';
                          emp:=true;
                        end;
              csSale  : Cells[1,i]:='*';
              csReturn: Cells[1,i]:='**';
            end;
            if emp then
              for zz:=2 to 5 do Cells[zz,i]:='-'
             else
              begin
                Cells[2,i]:=inttostr(Sum);
                Cells[3,i]:=inttostr(Cash);
                Cells[4,i]:=inttostr(Cashless);
                Cells[5,i]:=inttostr(Razn);
              end;
            Cells[6,i]:=inttostr(Nkas);
            Cells[7,i]:=DatTimToStr(creat);
            Cells[8,i]:=TimToStr(tim);
            Cells[9,i]:=inttostr(buyer);
          end;
    end;
  procedure CartFillRow(o:integer);
    begin
      with C[nc].state.rec do
        with Form1.CG do
          begin
            Cells[0,i]:=inttostr(nc+o);
            Cells[1,i]:=inttostr(base.tov);
            Cells[2,i]:=Lstat[Size][base.siz].rec.pos.nam;
            Cells[3,i]:=inttostr(base.kol);
            Cells[4,i]:=CurrToStr(base.price);
            Cells[5,i]:=inttostr(ost);
            Cells[6,i]:=inttostr(nakl)+':'+inttostr(pos);
            Cells[7,i]:=DatToStr(P[nakl].state.rec.data)+#32+Lstat[Agent][P[nakl].state.rec.agent].rec.pos.nam;
          end;
    end;
  function ParentNode(no:integer):TTreeNode;
    begin
      with Cstat[CatN][no] do
        begin
          if ViewNodeC=nil then
            viewnodeC:=Add2node(no);
          Result:=ViewnodeC;
        end;
    end;
  function Add2node(no:integer):TTreeNode;
    begin
      with Cstat[CatN][no] do
        begin
          if no=1 then
            ViewnodeC:=Form1.CatTv.Items.AddChild(nil,rec.pos.nam)
           else
            viewnodeC:=Form1.CatTV.Items.AddChild(ParentNode(rec.pos.node),rec.pos.nam);
          viewnodeC.Data:=pointer(no);
          Result:=viewnodeC;
        end;
    end;
 function ResizeSG(tsg:TStringGrid; n1:integer):integer;
  begin
    with ch[Form1.PageCtrl1.ActivePageIndex] do
      begin
        Result:=n1-NN;
        if Result>0 then
          begin
            NN:=n1;
            if NN>1 then {StringGridInsertRows(tsg,tsg.FixedRows,Result);}
              tsg.RowCount:=tsg.FixedRows+n1;
            if NN>SS then
              begin
                SS:=ReserveSize(NN,50);
                setlength(aa,SS);
              end;
          end
      end;
  end;
begin
  fillchar(ch,10*sizeof(tSorty),0);
  CLnum:=0;
  Priority:={tpHigher}{tpNormal}tpLower{tpLowest}{tpIdle};
  FreeOnTerminate:=true;
  FillChar(ChanAr,40,0);
  FillChar(ChanLi,40,0);
  FillChar(ChanCa,40,0);
  while not Terminated do
    with Form1 do
     with ch[PageCtrl1.ActivePageIndex] do
      begin
        case PageCtrl1.ActivePageIndex of
            1{prihod} : with A[Prihod] do  with info do
                          begin
                            if lock.lock then  form1.PG.Color:=$8080F0
                             else Form1.PG.Color:=clWindow;
                            if (sorttype<>Pgroup.ItemIndex)or(ChanAr[prihod]<changed.t64) then
                                begin
                                  res:=ResizeSG(PG,N);
                                  case Pgroup.ItemIndex of
                           {номер}  0: if (sorttype=0)and(res=0) then
                                         begin
                                           nc:=last;
                                           x:=PG.FixedRows+N;
                                           while nc>0 do
                                             with P[nc].state do
                                               if tim.t64>ChanAr[Prihod] then
                                                 begin
                                                   i:=x-nc;
                                                   PrihFillRow(ofs);
                                                   nc:=prev;
                                                 end
                                                else
                                                 break;
                                         end
                                        else
                                         begin
                                           nc:=N;
                                           for i:=PG.FixedRows to PG.RowCount-1 do
                                             begin
                                               PrihFillRow(ofs);
                                               dec(nc);
                                             end;
                                           sorttype:=0;
                                         end;
                          {изменен} 1: if (sorttype<>1)or(res>0) then
                                         begin
                                           nc:=last;
                                           j:=0;
                                           for i:=PG.FixedRows to PG.RowCount-1 do
                                             begin
                                               PrihFillRow(ofs);
                                               aa[nc-1]:=j;
                                               nc:=P[nc].state.prev;
                                               if nc=0 then break;
                                               inc(j);
                                             end;
                                           sorttype:=1;
                                         end
                                        else
                                         begin
                                           nc:=last;
                                           j:=0;
                                           i:=PG.FixedRows;
                                           while P[nc].state.tim.t64>ChanAr[Prihod] do
                                             begin
                                               x:=aa[nc-1];
                                               TStrGrid(PG).MoveRow(x+PG.FixedRows,i);
                                               PrihFillRow(ofs);
                                               for k:=NN-1 downto 0 do
                                                 if aa[k]<x then inc(aa[k]);
                                               aa[nc-1]:=j;
                                               nc:=P[nc].state.prev;
                                               inc(i);
                                               if (nc=0)or(PG.RowCount=i) then break;
                                               inc(j);
                                             end;
                                         end
                                  end;
                                  ChanAr[prihod]:=changed.t64;
                                end;
                           end;
            2{rashod} : ;
            3{sale}   : with A[Sale] do
                          with info do
                            begin
                              if lock.lock then  TG.Color:=$8080F0
                               else TG.Color:=clWindow;
                              if (sorttype<>Sgroup.ItemIndex)or(ChanAr[Sale]<changed.t64) then
                                begin
                                  res:=ResizeSG(SG,N);
                                  ti:=GetTim(tDatTim( ChanAr[Sale]) );
                                  case Sgroup.ItemIndex of
                           {номер}  0: if (sorttype=0)and(res=0) then
                                         begin
                                           nc:=last;
                                           x:=SG.FixedRows+N;
                                           while nc>0 do
                                             with TodayArr[nc].header do
                                               if lasttim>ti then
                                                 begin
                                                   i:=x-nc;
                                                   SaleFillRow(ofs);
                                                   nc:=prev;
                                                 end
                                                else
                                                 break;
                                         end
                                        else
                                         begin
                                           nc:=N;
                                           for i:=SG.FixedRows to SG.RowCount-1 do
                                             begin
                                               SaleFillRow(ofs);
                                               dec(nc);
                                             end;
                                           sorttype:=0;
                                         end;
                          {изменен} 1: if (sorttype<>1)or(res>0) then
                                         begin
                                           nc:=last;
                                           j:=0;
                                           for i:=SG.FixedRows to SG.RowCount-1 do
                                             begin
                                               SaleFillRow(ofs);
                                               aa[nc-1]:=j;
                                               nc:=TodayArr[nc].header.prev;
                                               if nc=0 then break;
                                               inc(j);
                                             end;
                                           sorttype:=1;
                                         end
                                        else
                                         begin
                                           nc:=last;
                                           j:=0;
                                           i:=SG.FixedRows;
                                           while nc>0 do
                                             with TodayArr[nc].header do
                                               if stat.tim>ti then
                                                 begin
                                                   x:=aa[nc-1];
                                                   TStrGrid(PG).MoveRow(x+SG.FixedRows,i);
                                                   SaleFillRow(ofs);
                                                   for k:=NN-1 downto 0 do
                                                     if aa[k]<x then inc(aa[k]);
                                                   aa[nc-1]:=j;
                                                   nc:=TodayArr[nc].header.prev;
                                                   inc(i);
                                                   if SG.RowCount=i then break;
                                                   inc(j);
                                                 end;
                                         end
                                  end;
                                  ChanAr[Sale]:=changed.t64;
                                end
                            end;
            4{товар}  : with A[Tovar] do
                          with info do
                            begin
                              if lock.lock then  TG.Color:=$8080F0
                               else TG.Color:=clWindow;
                              n64:=changed.t64;
                              for i:=Tip to Firm do
                                with L[i].info.changed do
                                  if n64<t64 then n64:=t64;
                              if ChanAr[tovar]<n64 then
                                begin
                                  res:=ResizeSG(TG,N);
                                  if res>0 then
                                    begin
                                      nc:=N;
                                      for i:=TG.FixedRows to TG.RowCount-1 do
                                        begin
                                          TovarFillRow(ofs);
                                          dec(nc);
                                        end
                                    end
                                   else
                                    begin
                                      nc:=last;
                                      x:=TG.FixedRows+N;
                                      while nc>0 do
                                        with T[nc].state do
                                          begin
                                            i:=x-nc;
                                            if tim.t64>ChanAr[Tovar] then
                                              TovarFillRow(ofs)
                                             else
                                              if ChanAr[Tovar]<L[Tip].info.changed.t64 then
                                                TG.Cells[1,i]:=Lstat[Tip][T[nc].state.rec.tip].rec.pos.nam
                                               else
                                                if ChanAr[Tovar]<L[Mat].info.changed.t64 then
                                                  TG.Cells[2,i]:=Lstat[Mat][T[nc].state.rec.mat].rec.pos.nam
                                                 else
                                                  if ChanAr[Tovar]<L[Firm].info.changed.t64 then
                                                    TG.Cells[3,i]:=Lstat[Firm][T[nc].state.rec.firm].rec.pos.nam
                                                   else
                                                    break;
                                            nc:=prev
                                          end
                                    end;
                                  ChanAr[Tovar]:=n64;
                                end;
                            end;
           5{карточки}:with A[Cart] do  with info do
                         begin
                           if lock.lock then CG.Color:=$8080F0
                            else Form1.CG.Color:=clWindow;
                            if (sorttype<>Cgroup.ItemIndex)or(ChanAr[Cart]<changed.t64) then
                                begin
                                  res:=ResizeSG(CG,N);
                                  case Cgroup.ItemIndex of
                           {номер}  0: if (sorttype=0)and(res=0) then
                                         begin
                                           nc:=last;
                                           x:=CG.FixedRows+N;
                                           while nc>0 do
                                             with C[nc].state do
                                               if tim.t64>ChanAr[Cart] then
                                                 begin
                                                   i:=x-nc;
                                                   CartFillRow(ofs);
                                                   nc:=prev;
                                                 end
                                                else
                                                 break;
                                         end
                                        else
                                         begin
                                           nc:=N;
                                           for i:=CG.FixedRows to CG.RowCount-1 do
                                             begin
                                               CartFillRow(ofs);
                                               dec(nc);
                                             end;
                                           sorttype:=0;
                                         end;
                          {изменен} 1: if (sorttype<>1)or(res>0) then
                                         begin
                                           nc:=last;
                                           j:=0;
                                           for i:=CG.FixedRows to CG.RowCount-1 do
                                             begin
                                               CartFillRow(ofs);
                                               aa[nc-1]:=j;
                                               nc:=C[nc].state.prev;
                                               if nc=0 then break;
                                               inc(j);
                                             end;
                                           sorttype:=1;
                                         end
                                        else
                                         begin
                                           nc:=last;
                                           j:=0;
                                           i:=CG.FixedRows;
                                           while C[nc].state.tim.t64>ChanAr[Cart] do
                                             begin
                                               x:=aa[nc-1];
                                               TStrGrid(CG).MoveRow(x+CG.FixedRows,i);
                                               CartFillRow(ofs);
                                               for k:=NN-1 downto 0 do
                                                 if aa[k]<x then inc(aa[k]);
                                               aa[nc-1]:=j;
                                               nc:=C[nc].state.prev;
                                               inc(i);
                                               if (nc=0)or(CG.RowCount=i) then break;
                                               inc(j);
                                             end;
                                         end
                                  end;
                                  ChanAr[Cart]:=changed.t64;
                                end;
                         end;
            7{каталог}:begin
                     with Cat[CatN]do with info do
                       if ChanCa[CatN]<changed.t64 then
                         begin
                           if lock.lock then  form1.CatTV.Color:=$8080F0
                            else Form1.CatTV.Color:=clWindow;
                           if CountSendC(CatN,ChanCa[CatN],nc)>0 then
                             repeat
                               with Cstat[CatN][nc] do
                                 begin
                                   CriticalSetLock(lock);
                                   if viewnodeC=nil then Add2node(nc)
                                    else
                                     begin
                                       if prNam in prop then
                                         viewnodeC.Text:=rec.pos.nam;
                                       if prNode in prop then
                                         begin
                                           if Cstat[CatN][rec.pos.node].viewnodeC=nil then
                                             Add2node(rec.pos.node);
                                           viewnodeC.MoveTo(Cstat[CatN][rec.pos.node].viewnodeC,naAddChild);
                                         end;
                                       prop:=[];
                                     end;
                                   ChanCa[CatN]:=rec.tim.t64;
                                   nc:=rec.next;
                                   ResetLock(lock.lock);
                                 end;
                             until nc=0;
                         end;
                     with L[CatN].info do
                       if (ChanLi[CatN]<changed.t64)and (countSendL(catN,ChanLi[CatN],nc)>0) then
                         repeat
                           with Lstat[CatN][nc] do
                             begin
                               CriticalSetLock(lock);
                               if viewnodeL=nil then
                                 begin
                                   viewnodeL:=Form1.CatTV.Items.AddChild(ParentNode(rec.pos.node),rec.pos.nam);
                                   viewnodeL.Data:=pointer(-nc);
                                 end
                                else
                                 begin
                                   if prNam in prop then
                                     viewnodeL.Text:=rec.pos.nam;
                                   if prNode in prop then
                                     viewnodeL.MoveTo(ParentNode(rec.pos.node),naAddChild);
                                 end;
                               prop:=[];
                               ChanLi[CatN]:=rec.tim.t64;
                               nc:=rec.next;
                               ResetLock(lock.lock);
                             end;
                         until nc=0;
                   end;
        end;
        sleep(SHOWrefresh);
      end;
  for i:=0 to 9 do setlength(ch[i].aa,0);    
end;
{0000000000000000000000000000000000000000000000000000000000000000000000000000}

procedure TForm1.EditMode;
begin
  filesetreadonly(ServFile,false);
  button1.Enabled:=false;
  button2.Enabled:=false;
  button3.Enabled:=false;
  bg.SetFocus;
  bg.Options:=bg.Options + [goEditing]-[goRowSelect];
  bg.Col:=1;
  bg.EditorMode:=true;
end;

procedure TForm1.SelectMode;
begin
  if BDcreat then
    begin
      BDcreat:=false;
    end;
  if BDedit then
    begin
      BDedit:=false;
    end;
  bg.Options:=bg.Options-[goEditing]+[goRowSelect];
  button1.Enabled:=true;
  Button2.Enabled:=true;
  button3.Enabled:=true;
  filesetreadonly(ServFile,true);
  bg.EditorMode:=false;
  bg.SetFocus;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  shortDateformat:='yyyy.mm.dd';
  longtimeformat:='hh:mm:ss';
  wc:=GetCurrentDir;
  AppAct   := Application.OnActivate;
  AppDeact := Application.OnDeActivate;
  Application.OnActivate:=form1.OnActivate;
  Application.OnDeactivate:=form1.OnDeactivate;
  bg.ColWidths[0]:=40;
  bgtop:=0;
  BGpos:=0;
  BDtime:=0;

{  FillChar(Kassa,sizeof(Kassa),0);   }
  CLlist.Cells[0,0]:='№';
  Cllist.Cells[1,0]:='LogIn';
  Cllist.Cells[2,0]:='описание';
  Cllist.Cells[3,0]:='адрес';
  if not fileexists(ServFile) then
    begin
      fileclose( filecreate(ServFile));{new}
      fileSetReadOnly(ServFile,true);
      BDnum:=0;
    end;
  SG.Cells[0,0]:='чек №';
  SG.Cells[1,0]:='статус';
  SG.Cells[2,0]:='сумма';
  SG.Cells[3,0]:='наличные';
  SG.Cells[4,0]:='безнал';
  SG.Cells[5,0]:='прибыль';
  SG.Cells[6,0]:='касса №';
  SG.Cells[7,0]:='создан';
  SG.Cells[8,0]:='изменен';
  SG.Cells[9,0]:='#клиент';
  TG.Cells[0,0]:='№';
  TG.Cells[1,0]:='тип';
  TG.Cells[2,0]:='материал';
  TG.Cells[3,0]:='фирма';
  TG.Cells[4,0]:='артикул';
  TG.Cells[5,0]:='описание';
  CG.Cells[0,0]:='№';
  CG.Cells[1,0]:='#товар';
  CG.Cells[2,0]:='размер';
  CG.Cells[3,0]:='количество';
  CG.Cells[4,0]:='цена';
  CG.Cells[5,0]:='остаток';
  CG.Cells[6,0]:='приход';
  CG.Cells[7,0]:='накладная';
      for i:=Tip to Agent do
        begin
          myCatTV[i]:=TmyTreeView.Create(Form1);
          with myCatTV[i] do
            begin
              Parent:=TabSheet8;
              Width:=450;
              Height:=279;
              Taborder:=0;
              Anchors:=[akLeft,akTop,akRight,akBottom];
              OnCustomDrawItem:=CatTVCustomDrawItem;
              OnCancelEdit:=CatTVCancelEdit;
              OnEdited:=CatTVEdited;
              PopupMenu:=CatMenu;
            end;
        end;
      CatTV:=myCatTV[Tip];
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if width<256 then form1.Width:=256;
  if height<256 then height:=256;
  bg.ColWidths[1]:=bg.Width-bg.ColWidths[0]-7;
  button2.Left:=(width-button2.Width-12) div 2;
{  TG.Width:=width-14;
  TG.ColWidths[5]:=TG.Width-450;
  CLlist.Width:=width-14;
  PG.Width:=width-14;
  for i:=0 to 2 do CLlist.ColWidths[3]:=CLlist.ColWidths[3]-CLlist.ColWidths[i]-1;
  CG.Width:=width-14;
  CG.ColWidths[7]:=CG.Width-362;      }
end;

procedure CycleWait;
  begin
    if (fileGetAttr(ServFile) and faReadOnly)=0 then
      begin
        showmessage('List is updating...');
        while (fileGetAttr(ServFile) and faReadOnly)=0 do
          sleep(1000);
      end;
  end;

procedure TForm1.BDrefresh;
  var
    t,i:integer;
    f:file of tServBase;
  begin
    if IsChanged and not ServerRun then
      begin
        if IsReadable then
          begin
            BDtime:=fileage(wc+'\'+ServFile);
            assignfile(f,wc+'\'+ServFile);
            filemode:=0;
            reset(f);
            t:=filesize(f);
            BDnum:=t;
            if t>0 then
              begin
                setlength(BD,t);
                bg.RowCount:=t;
                i:=0;
                t:=0;
                repeat
                  read(f,BD[i]);
                  if (BD[i].state and 1)=0 then
                    begin
                      bg.Cells[0,t]:=inttostr(i+1);
                      bg.cells[1,t]:=BD[i].name;
                      BD[i].state:=BD[i].state or $80;
                      inc(t);
                      TCPrun.Port:=Serverport+i+1;
                      try TCPrun.Connect(50);  except    BD[i].state:=BD[i].state and $7f;
                      end;
                      TCPrun.Disconnect
                    end;
                  inc(i);
                until eof(f);
                bg.RowCount:=t;
                bg.TopRow:=Bgtop;
                bg.Row:=BGpos;
              end;
            closefile(f);
          end
         else
          CycleWait;
      end;
  end;

procedure TForm1.PageCtrl1Resize(Sender: TObject);
var
  i,nn,mm:integer;
 procedure SetLastColWidth(tsg:tStringGrid);
   var
     i:integer;
   begin
     nn:=0;
     for i:=0 to tsg.ColCount-2 do
       inc(nn,tsg.ColWidths[i]+1);
     nn:=tsg.Width-nn-4;
     if nn<12 then nn:=12;
     tsg.ColWidths[tsg.ColCount-1]:=nn;
   end;
begin
  ConnG.Width:=PageCtrl1.width-8;
  SetLastColWidth(ConnG);

  PG.Width:=ConnG.Width;
  SetLastColWidth(PG);
  Pgroup.Width:=ConnG.Width;

  SG.Width:=ConnG.Width;
  SetLastColWidth(SG);
  Sgroup.Width:=ConnG.Width;

  TG.Width:=ConnG.Width;
  SetLastColWidth(TG);

  CG.Width:=ConnG.Width;
  SetLastColWidth(CG);
  Cgroup.Width:=ConnG.Width;

  CLlist.Width:=ConnG.Width;
  SetLastColWidth(CLlist);
  EditClientButton.Left:=ConnG.Width-EditClientButton.Width-8;

  CatGroup.Left:=PageCtrl1.Width-CatGroup.Width-8;
  mm:=CatGroup.Left-4;
  nn:=PageCtrl1.Height-40;
  for i:=Tip to Agent do
    with myCatTv[i] do
      begin
        Width:=mm;
        Height:=nn;
      end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if not(BDcreat or BDedit) then BDrefresh
end;

procedure TForm1.FormDeactivate(Sender: TObject);
begin
  BGpos:=bg.Row;
  BGtop:=bg.TopRow;
end;

procedure TForm1.BGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  c,i:integer;
  b:byte;
begin
  if (BDnum>0) then
    begin
      if {bg.EditorMode and} (BDedit or BDcreat)and (bg.col<>1) and (BGedit<>bg.Row) then
        begin
          Selectmode;
          {exit;}
        end;
      c:=0;
      i:=getnum(Arow);
      b:=BD[i].state;
      if b>=128  then c:=c or $BF;
      if (b and 2)<>0  then c:=c or $AF00;
      if bg.Row=Arow then
        c:=c or $D04040;
      if c=0 then c:=clwindow;
      bg.Canvas.Brush.Color:=c;
      bg.Canvas.FillRect(rect);
      bg.Canvas.TextRect(rect,rect.Left+2,rect.Top+4,bg.Cells[Acol,Arow]);
    end
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  BDrefresh;
  BDcreat:=true;
  BGpos:=BG.Row;
  if BDnum>0 then
    bg.RowCount:=bg.RowCount+1;
  bg.Row:=bg.RowCount-1;
  bg.Cells[0,bg.Row]:=inttostr(BDnum+1);
  bg.Cells[1,bg.Row]:='';
  EditMode;
end;

procedure TForm1.BGKeyPress(Sender: TObject; var Key: Char);
var
  d:string;
  i,x:integer;
begin
  if (key=#13) and not (BDcreat or BDedit) and (BDnum>0) then
    button1.SetFocus;
  if (key=#13) and (bg.Col=1) then
    begin
      if BDcreat then
        d:=getcurrentdir
       else
        d:=BD[getnum(BGedit)].folder;
      repeat
      until SelectDirectory(d,[sdAllowCreate, sdPerformCreate, sdPrompt],0);
      chdir(wc);
      x:=getnum(Bg.row);
      if BDnum>0 then
      for i:=0 to BDnum-1 do
        if i<>x then
          begin
            if BD[i].name=bg.Cells[1,bg.Row] then
              begin
                showmessage('Duplicate name');
                exit
              end;
            if BD[i].folder=d then
              begin
                showmessage('Duplicate folder');
                exit
              end;
          end;
      if BDcreat then
        begin
          inc(BDnum);
          setlength(BD,BDnum);
          BD[x].state:=0;
        end;
      BD[x].name:=bg.Cells[1,BG.Row];
      BD[x].folder:=d;
      WriteServFile(x);
      selectMode;
    end;
  if key=#27 then
    begin
      if BDcreat then
        begin
          bg.RowCount:=bg.RowCount-1;
          bg.Row:=BGpos;
        end
       else
        bg.Cells[1,bg.Row]:=BD[getnum(bg.Row)].name;
      selectmode;
    end;
end;

procedure TForm1.Button1Enter(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.Button1Exit(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i,j:integer;
begin
  ShowThr.Terminate;
 { SaveDB; }
  for i:=Tip to Agent do myCatTV[i].Destroy;
  closefile(fileCL);
  closefile(fileTovar);
  closefile(fileCart);
  closefile(filePrihod);
  closefile(fileRashod);
{  closefile(CLkassa);
  closefile(fileCheqSt);
  closefile(fileCheqRec);    }
  TCPserv.Active:=false;
  if BDcreat or BDedit then
    filesetreadonly(ServFile,true);
  if ServerRun then
    begin
      for i:=Tovar to Sale do
        begin
          LockA[i].Destroy;
          LockANum[i].Destroy;
        end;
      logsect.Destroy;
      for i:=Tip to Agent do
        begin
          LockL[i].Destroy;
          LockLnum[i].Destroy;
          LockC[i].Destroy;
          LockCatN[i].Destroy;
          LockCatL[i].Destroy;
        end;
    end;
  for i:=Tip to Agent do
    begin
    {lists}
      closefile(fileList[i]);
      for j:=1 to L[i].info.N do setlength(LNum[i][j].nums,0);
      setlength(Lstat[i],0);
    {catalogs}
      closefile(fileCat[i]);
      for j:=1 to Cat[i].info.N do
        begin
          Setlength(CatNnum[i][j].nums,0);
          Setlength(CatLNum[i][j].nums,0);
        end;
      setlength(Cstat[i],0);
    end;

  for j:=1 to A[tovar].info.N do setlength(TNum[j].nums,0);
  setlength(T,0);
  for j:=1 to A[Cart].info.N do setlength(CNum[j].ra,0);
  setlength(C,0);
  for j:=1 to A[Prihod].info.N do setlength(PNum[j].rows,0);
  setlength(P,0);
  for j:=1 to A[Rashod].info.N do setlength(RNum[j].rows,0);
  setlength(R,0);
  for j:=1 to A[Sale].info.N do setlength(TodayArr[j].chpos,0);
  setlength(TNum,0);
  setlength(CNum,0);
  setlength(ChequeHeap,0);
  setlength(ChequeArr,0);
  setlength(TodayArr,0);
  setlength(Clname,0);
  setlength(BD,0);
end;

procedure TForm1.BGKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  x:integer;
begin
  {Ctrl+E = edit}
  if (ssCtrl in Shift) and (key=69) then
    button3.SetFocus;
  {Ctrl+D = delete}
  if (ssCtrl in Shift) and (key=68) and (MessageDlg('Delete ? ',mtConfirmation,[mbYes,mbNo],0)=mrYes) then
    begin
      x:=getnum(Bg.Row);
      if BD[x].state<128 then
        begin
          cyclewait;
          BD[x].state:=1;
          fileSetReadOnly(ServFile,false);
          WriteServFile(x);
          fileSetReadOnly(ServFile,true);
          x:=bg.RowCount-1;
          bg.Cols[0].Exchange(bg.Row,x);
          bg.Cols[1].Exchange(bg.Row,x);
          bg.RowCount:=x;
        end
       else
        showmessage('Database is running now.');
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  BDrefresh;
  if BD[getnum(bg.Row)].state<128 then
    begin
      BDedit:=true;
      BGedit:=BG.Row;
      EditMode;
    end;
end;

procedure TForm1.BGEnter(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.BGExit(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.Button2Enter(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.Button2Exit(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.Button3Enter(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.Button3Exit(Sender: TObject);
begin
  BDrefresh;
end;

procedure TForm1.BGDblClick(Sender: TObject);
begin
  Button1Click(Sender);
end;

{==================================================================================}

procedure TForm1.ButClientClick(Sender: TObject);
  begin
    FormClient.Show;
  end;

procedure TForm1.PageCtrl1Change(Sender: TObject);
begin
  case PageCtrl1.ActivePageIndex of
    1..5,7 : if ShowThr.Suspended then ShowThr.Resume;
   else
    if not ShowThr.Suspended then ShowThr.Suspend;
  end;
end;

procedure TForm1.actButClick(Sender: TObject);
begin
  try
    TCPserv.Active:= not TCPserv.Active;
    Pagectrl1.Width:=0
   finally
    if TCPserv.Active then
      begin
        actbut.Caption:='dis';
        Form1.Color:=clMoneyGreen;
      end
     else
      begin
        actbut.Caption:='Activate';
        Form1.Color:=clMaroon;
      end;
    Pagectrl1.Width:=Form1.Width-7;
  end;
end;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

procedure TForm1.TCPservDisconnect(AThread: TIdPeerThread);
var
  n,pp,i:integer;
  sx:string[15];
begin
  if CLerr then
    begin
      if CLname='' then writeLogNO(athread.Connection.Socket.Binding.PeerIP+':'+inttostr(athread.Connection.Socket.Binding.PeerPort)+' UNNAMED disconnected');
      exit
    end;
  {unlock ALL locks}
  for i:=Tip to Agent do if Cat[i].lock.lock and (Cat[i].lock.fil=CLnum) then
    UnlockCatRec(i,Cat[i].lockrec);
  for i:=Tip to Agent do if L[i].lock.lock and (L[i].lock.fil=CLnum) then
    ListUnlockRec(i,L[i].lockrec);
   { begin
      ResetLock(L[i].lock.lock);
      ListUnlock(i);
    end;  }
  for i:=Tovar to Sale do if A[i].lock.lock and (A[i].lock.fil=CLnum) then
    UnlockRecA(i,A[i].lockrec);
    {begin
      ResetLock(A[i].lock.lock);
      ArrUnlock(i);
    end;   }
  {====================}
  CLients[CLnum].tim.t64:=0;
  Kassa[CLnum].Active:=false;
{  if Kassa[CLnum].OpenStatus then closefile(CLkassa); }
  n:=ConnG.RowCount-1;
  pp:=ConnG.Cols[0].IndexOf(inttostr(Athread.ThreadID));
  if CLitself then sx:=''
   else sx:=' by server.';
  writelog(ConnG.Cells[1,pp]+':'+ConnG.Cells[2,pp]+' disconnected'+sx);
  if n>0 then
    begin
      for i:=0 to ConnG.ColCount-1 do ConnG.Cols[i].Exchange(pp,n);
      ConnG.RowCount:=n;
    end
   else
    ConnG.Rows[0].Clear;
end;

procedure TForm1.TCPservConnect(AThread: TIdPeerThread);
var
  n,i:integer;
  us:tNam;
  nam:string;
begin
  if (Athread.Connection.Socket.Binding.PeerPort<>ServRun) then
    begin
      AThread.Connection.WriteLn(BDname);
      Clname:=Athread.Connection.ReadLn;
      CLoper:=Athread.Connection.ReadSmallInt;
      us:=Athread.Connection.Readln;
      if CLname<>'' then
        begin
          i:=IsClient(CLname);
          if i<>0 then
            begin
              CLnum:=i;
              Athread.Connection.WriteInteger(i);
              Clients[i].tim:=TimeNow;
              n:=ConnG.RowCount;
              if ConnG.Cells[0,0]<>'' then
                ConnG.RowCount:=n+1
               else
                n:=0;
              ConnG.Cells[0,n]:=inttostr(Athread.ThreadID);
              ConnG.Cells[1,n]:=Athread.Connection.Socket.Binding.PeerIP;
              ConnG.Cells[2,n]:=inttostr(Athread.Connection.Socket.Binding.Peerport);
              ConnG.Cells[3,n]:=Clname;
              ConnG.Cells[4,n]:=Clients[i].client.name;
              writeLog(ConnG.Cells[1,n]+':'+ConnG.Cells[2,n]+' connected  -oper: ['+inttostr(CLoper)+']-'+us);
              CLerr:=false;
              CLitself:=true;
              CLlock.lock:=true;
              CLlock.fil:=CLnum;
              CLlock.oper:=CLoper;
              Kassa[CLnum].Active:=true;
              nam:=SaleDir+Clname+'\'+DatToStr(GetDat(TimeNow))+'.chq';
              if not FileExists(nam) then
                begin
                  if not DirectoryExists(SaleDir+CLname) then
                    ForceDirectories(SaleDir+Clname);
                  fileclose(filecreate(nam));
                end;
{              assignfile(CLkassa,nam);
              reset(CLkassa);
              if Kassa[CLnum].OpenStatus then
                seek(CLkassa,filesize(CLkassa));    }
              inc(CLcount);
{  Athread.Connection.ReadTimeout:=1000;   }
              exit
            end;
        end
       else
        CLname:='''UNKNOWN''';
      writelogNO(athread.Connection.Socket.Binding.PeerIP+':'+inttostr(athread.Connection.Socket.Binding.PeerPort)+CLname+' try connect');
    end;
  CLerr:=true;
  Athread.Connection.Disconnect;
end;

procedure TForm1.ConnGDblClick(Sender: TObject);
var
  tl:tList;
  i:integer;
begin
  tl:=tList.Create;
  try
    tl.Assign(TCPserv.Threads.LockList);
    for i:=0 to tl.Count-1 do
      with TidPeerThread(tl[i]) do
        try
          connection.CheckForDisconnect(false,false);
        except
        end;
    TCPserv.Threads.UnlockList;
   finally
    tl.Free;
  end
end;

procedure TForm1.DisconnectClient(Sender: TObject);
var
  tl:tList;
  i:integer;
  tt:tidPeerThread;
begin
  if ConnG.Cells[0,0]<>'' then
    begin
      thr:= strtoint(ConnG.Cells[0,ConnG.row]);
      tt:=nil;
      tl:=Tlist.Create;
      tl.Assign(tcpserv.ThreadMgr.ActiveThreads.LockList);
      for i:=0 to tl.Count-1 do
        if TidPeerThread(tl[i]).ThreadID=thr then
          begin
            tt:=TidPeerThread(tl[i]);
            break
          end;
      tl.Free;
      tcpserv.ThreadMgr.ActiveThreads.UnLockList;
      if tt<>nil then tt.Connection.DisconnectSocket;
    end;
end;

procedure TForm1.EditClientMode;
begin
  CLlist.Options:=CLlist.Options-[goRowSelect]+[goEditing];
  CLlist.EditorMode:=true;
  CLlist.Col:=1;
end;

procedure TForm1.SelectClientMode;
begin
  CLlist.Options:=CLlist.Options+[goRowSelect]-[goEditing];
  CLlist.EditorMode:=false;
  EditClient:=false;
end;


procedure TForm1.AddClientButtonClick(Sender: TObject);
begin
  CLlist.SetFocus;
  if ClientCount>0 then
    CLlist.RowCount:=CLlist.RowCount+1;
  CLlist.Row:=CLlist.RowCount-1;
  CLlist.Cells[0,CLlist.Row]:=inttostr(CLlist.Row);
  editClientMode;
end;

procedure TForm1.EditClientButtonClick(Sender: TObject);
begin
  CLlist.SetFocus;
  EditClient:=true;
  editClientMode;
end;

procedure TForm1.CLlistKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13) and CLlist.EditorMode then
    begin
      if Cllist.Col=3 then
        begin
          if CLlist.Cells[1,CLlist.Row]='' then
            begin
              CLlist.Col:=1;
              exit;
            end;
          if EditClient then
            renamefile(ClientDir+Clients[CLlist.Row].client.login,ClientDir+CLlist.Cells[1,CLlist.Row])
           else
            begin
              inc(ClientCount);
              Createdir(clientDir+CLlist.Cells[1,CLlist.Row]);
            end;
          Clients[ClientCount].client.login:=CLlist.Cells[1,CLlist.Row];
          Clients[ClientCount].client.name:=CLlist.Cells[2,CLlist.Row];
          Clients[ClientCount].client.addr:=CLlist.Cells[3,CLlist.Row];
          WriteClient(ClientCount);
          SelectClientMode;
          exit
        end;
      CLlist.Col:=CLlist.Col+1;
    end;
  if key=#27 then
    begin
      if Clients[CLlist.Row].client.login='' then
        CLlist.RowCount :=CLlist.RowCount-1
       else
        begin
          CLlist.Cells[1,CLlist.Row]:=Clients[CLlist.Row].client.login;
          CLlist.Cells[2,CLlist.Row]:=Clients[CLlist.Row].client.name;
          CLlist.Cells[3,CLlist.Row]:=Clients[CLlist.Row].client.addr;
        end;
      SelectClientMode
    end;
end;

procedure TForm1.CatGroupClick(Sender: TObject);
begin
  CatTV:=myCatTV[CatGroup.ItemIndex];
  CatTV.BringToFront;
  CatN:=CatGroup.ItemIndex;
end;

{******************************************************************************************************}
  {------------------------------------------------------------------}
function IsCatNode(nod:tTreeNode):boolean;
  begin
    Result:=integer(nod.Data)>0;
  end;

function GetNodeItemNum(nod:tTreeNode; var num:integer):boolean;
  begin
    num:=integer(nod.Data);
    Result:=num>0;
    if not Result then num:=-num;
  end;

procedure TForm1.N3Click(Sender: TObject);  {rename}
begin
  if CatTV.Selected<>nil then
    begin
      ShowThr.Suspend;
      CatTv.ReadOnly:=false;
      CatMode:=1;
      CatTV.Selected.EditText;
    end;
end;

procedure TForm1.N5Click(Sender: TObject);  {add node}
var
   no:tTreeNode;
begin
  if ((CatTV.Selected<>nil) and IsCatNode(CatTV.Selected)) or (CatTV.Items.Count=0){root} then
    begin
      ShowThr.Suspend;
      CatTv.ReadOnly:=false;
      cattv.Font.Style:=[fsBold,fsItalic];
      no:=CatTV.Items.AddChild(CatTV.Selected,'*****');
      no.Selected:=true;
      CatMode:=2;
      no.EditText;
    end;
end;

procedure TForm1.N6Click(Sender: TObject);  {add list}
 var
   no:tTreeNode;
begin
  if (CatTV.Selected<>nil) and IsCatNode(CatTV.Selected) then
    begin
      ShowThr.Suspend;
      CatTV.ReadOnly:=false;
      cattv.Font.Style:=[fsUnderline];
      no:=CatTV.Items.AddChild(CatTV.Selected,'***');
      no.Selected:=true;
      CatMode:=3;
      no.EditText;
    end;
end;

procedure TForm1.CatTVCancelEdit(Sender: TObject; Node: TTreeNode);
begin
  if node.Data=nil then node.Delete;
end;

procedure TForm1.CatTVEdited(Sender: TObject; Node: TTreeNode; var S: String);
var
  nn,par:integer;
  lp:tListPos;
  ans:tAnswerHead;
begin
  case CatMode of
    1:if GetNodeItemNum(node,nn) then {rename node}
        begin
          if RenameNode(CatN,nn,S).timS.t64=0 then node.EndEdit(false)
           else with Cstat[CatN][nn] do prop:=prop-[prNam];
        end
       else {rename list}
        begin
          if RenameL(CatN,nn,S).timS.t64=0 then node.EndEdit(false)
           else with Lstat[CatN][nn] do prop:=prop-[prNam];
        end;
    2:{new node}
      if S<>'' then
        begin
          if Node.Parent=nil then par:=0;
          if (par=0)or GetNodeItemNum(Node.Parent,par)then
            begin
              lp.nam:=trim(S);
              lp.node:=par;
              ans:=AddCatNode(CatN,lp,-1);
              if ans.num=0 then Node.Delete
               else
                begin
                  Node.Data:=pointer(ans.num);
                  with Cstat[CatN][ans.num] do
                    begin
                      viewnodeC:=Node;
                      prop:=[]
                    end
                end;
            end;
        end
       else
        Node.Delete;
    3:{new list}
      if (node.Parent<>nil)and GetNodeItemNum(node.Parent,par) then
        begin
          lp.nam:=trim(S);
          lp.node:=par;
          ans:=LAddNew(CatN,lp,$FFFFFFFFFFFFFFFF);
          if ans.num=0 then node.Delete
           else
            begin
              with Lstat[CatN][ans.num] do
                begin
                  prop:=[];
                  viewNodeL:=node
                end;
              node.Data:=pointer(-ans.num);
            end;
        end
  end;
  CatTV.ReadOnly:=true;
  CatMode:=0;
  ShowThr.Resume;
end;

procedure TForm1.CatTVCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  with CatTV.Canvas.Font do
    if integer(node.Data)>=0 then
      Style:=[fsBold,fsItalic]
     else
      Style:=[fsUnderline];
  DefaultDraw:=true;
end;

{********************************************************************************************************}

procedure TForm1.TCPservExecute(AThread: TIdPeerThread);
  var
    mm,nn,i,li,ar:integer;
    need:boolean;
    ti: tDatTim;
    qp: tQueryPacket;
    ap: tAnswerPacket;
    ch:tArrInt;
 {-------------}

begin  {}
  {++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
  with Athread.Connection do
    try
      readbuffer(qp,sizeof(qp));
     with qp do
      case sl[0] of
            'T': begin {synchronize time}
                   ti:=TimeNow;
                   writebuffer(ti,8,true);
                 end;
            'S': begin {synchronize DATA}
                   for i:=Tip to Agent do   {catalogs}
                     writebuffer(Cat[i].info.changed,8);
                   for i:=Tip to Agent do   {lists}
                     writebuffer(L[i].info.changed,8);
                   for i:=Tovar to Rashod do  {arrays}
                     writebuffer(A[i].info.changed,8,i=Rashod);
                 end;
{arrays}    'A': begin
                   ar:=ConvA(sl[1]);
                   if ar>=0 then
                   case sl[2] of
        {add}        'A': begin
                            ap.ans:=AAddNew(ar,recA,sync);
                            writebuffer(ap,sizeofap,true);
                          end;
        {change}     'C': begin
                            ap.ans:=ChangeArr(ar,qp.num,qp.recA,qp.sync);
                            writebuffer(ap,sizeofap,true);
                          end;
       {read}        'R': begin
                            ap.ans.prevS:=A[ar].info.changed;
                            case ar of
                              Tovar  : with T[num] do
                                         begin
                                           CriticalSetLock(lock);
                                           ap.tt:=state;
                                           ResetLock(lock.lock);
                                         end;
                              Cart   : with C[num] do
                                         begin
                                           CriticalSetLock(lock);
                                           ap.cc:=state;
                                           ResetLock(lock.lock);
                                         end;
                              Prihod : with P[num] do
                                         if (state.status<stExec)or(state.status>stAnn) then
                                           begin
                                             CriticalSetLock(lock);
                                             ap.pp:=state;
                                             ResetLock(lock.lock);
                                           end
                                          else
                                           ap.pp:=state;
                              Rashod : with R[num] do
                                         if (state.status<stExec)or(state.status>stAnn) then
                                           begin
                                             CriticalSetLock(lock);
                                             ap.rr:=state;
                                             ResetLock(lock.lock);
                                           end
                                          else
                                           ap.rr:=state;
                              end;
                            writebuffer(ap,sizeofap,true);
                          end;
     {synchronize}   'S': if A[ar].info.changed.t64>sync then
                          begin
                            ArrLock(ar);
                            ap.ans.prevS:=A[ar].info.changed;
                            ap.ans.count:=CountSendA(ar,sync,mm);
                            ap.ans.num:=mm;
                            if ap.ans.count=1 then
                              case ar of
                                Tovar  : ap.tt:=T[mm].state;
                                Cart   : ap.cc:=C[mm].state;
                                Prihod : ap.pp:=P[mm].state;
                                Rashod : ap.rr:=R[mm].state;
                                Sale   : ap.tch:=TodayArr[mm].header;
                              end;
                            Writebuffer(ap,sizeofap,true);
                            if ap.ans.count>1 then
                              for i:=1 to ap.ans.count do
                                case ar of
                                  Tovar : with T[mm] do
                                            begin
                                              writebuffer(state,sizeof(tTovarState),i=ap.ans.count);
                                              mm:=state.next;
                                            end;
                                  Cart  : with C[mm] do
                                            begin
                                              writebuffer(state,sizeof(tCartState),i=ap.ans.count);
                                              mm:=state.next;
                                            end;
                                  Prihod: with P[mm] do
                                            begin
                                              writebuffer(state,sizeof(tPrihState),i=ap.ans.count);
                                              mm:=state.next;
                                            end;
                                  Rashod: with R[mm] do
                                            begin
                                              writebuffer(state,sizeof(tRashState),i=ap.ans.count);
                                              mm:=state.next;
                                            end;
                                  Sale  : with TodayArr[mm] do
                                            begin
                                              writebuffer(header,sizeof(tTodayChequeHeader),i=ap.ans.count);
                                              mm:=header.next;
                                            end
                                end;
                            ArrUnlock(ar);
                          end
                           else
                            begin
                              ap.ans.num:=0;
                              ap.ans.count:=0;
                              writebuffer(ap,sizeofap,true);
                            end;
      {reQuest}      'Q': begin
                            ap.ans.prevS:=AN[ar].info.changed;
                            case ar of
                              Tovar   : with TNum[num] do
                                          begin
                                            CriticalSetLock(ctrl.Nlock);
                                            ap.ans.timS:=ctrl.Ntim;
                                            ap.ans.num:=num;
                                            ap.ans.count:=ctrl.NN;
                                            if ctrl.NN<=34 then
                                              for i:=0 to ctrl.NN-1 do ap.aa[i]:=nums[i]
                                             else
                                              for i:=0 to 33 do ap.aa[i]:=nums[i];
                                            writebuffer(ap,sizeofap,true);
                                            if ctrl.NN>34 then
                                            writebuffer(nums[34],(Ctrl.NN-34)*4,true);
                                            ResetLock(ctrl.Nlock.lock)
                                          end;
                               Cart    : with CNum[num] do
                                          begin
                                            CriticalSetLock(ctrl.Nlock);
                                            ap.ans.timS:=ctrl.Ntim;
                                            ap.ans.num:=num;
                                            ap.ans.count:=ctrl.NN;
                                            if ctrl.NN<=17 then
                                              for i:=0 to ctrl.NN-1 do ap.dp[i]:=ra[i]
                                             else
                                              for i:=0 to 16 do ap.dp[i]:=ra[i];
                                            writebuffer(ap,sizeofap,true);
                                            if ctrl.NN>17 then
                                            writebuffer(ra[17],(Ctrl.NN-17)*8,true);
                                            ResetLock(ctrl.Nlock.lock)
                                          end;
                               Prihod  : with PNum[num] do
                                          begin
                                            CriticalSetLock(ctrl.Nlock);
                                            ap.ans.timS:=ctrl.Ntim;
                                            ap.ans.num:=num;
                                            ap.ans.count:=ctrl.Nrows;
                                            if ctrl.Nrows<=4 then
                                              for i:=0 to ctrl.Nrows-1 do ap.na[i]:=rows[i]
                                             else
                                              for i:=0 to 3 do ap.na[i]:=rows[i];
                                            writebuffer(ap,sizeofap,true);
                                            if ctrl.Nrows>4 then
                                            writebuffer(rows[4],(Ctrl.Nrows-4)*sizeof(tNaklRow),true);
                                            ResetLock(ctrl.Nlock.lock)
                                          end;
                               Rashod  : with RNum[num] do
                                          begin
                                            CriticalSetLock(ctrl.Nlock);
                                            ap.ans.timS:=ctrl.Ntim;
                                            ap.ans.num:=num;
                                            ap.ans.count:=ctrl.Nrows;
                                            if ctrl.Nrows<4 then
                                              for i:=0 to ctrl.Nrows-1 do ap.na[i]:=rows[i]
                                             else
                                              for i:=0 to 3 do ap.na[i]:=rows[i];
                                            writebuffer(ap,sizeofap,true);
                                            if ctrl.Nrows>4 then
                                            writebuffer(rows[4],(Ctrl.Nrows-4)*sizeof(tNaklRow),true);
                                            ResetLock(ctrl.Nlock.lock)
                                          end;
                            end;
                          end;
      {Transceiving} 'T' : if (num>0)and(xx>0)and((ar=Prihod)or(ar=Rashod)) then
                             begin
                               LockNumArec(ar,num);
                               ap.ans.prevS:=AN[ar].info.changed;
                               if ar=Prihod then
                                 with Pnum[num] do
                                   with ctrl do
                                     begin
                                       ResizeNum(Pnum[num],xx);
                                       for i:=0 to xx-1 do readbuffer(rows[i],sizeof(tNaklRow));
                                       P[num].state.rec.Npos:=xx;
                                       Ntim:=tim;
                                       SetLastNumA(Prihod,num);
                                     end
                                else
                                 with Rnum[num] do
                                   with ctrl do
                                     begin
                                       ResizeNum(Rnum[num],xx);
                                       for i:=0 to xx-1 do readbuffer(rows[i],sizeof(tNaklRow));
                                       Ntim:=tim;
                                       SetLastNumA(Rashod,num);
                                     end;
                               ap.ans.timS:=AN[ar].info.changed;
                               UnlockNumArec(ar,num);
                             end;
                     else
                      if (ar=Prihod)or(ar=Rashod)then
                        begin
                          case sl[2] of
                            'O': ap.ans:=OpenNakl(ar,num);
                            'E': ap.ans:=ExecNakl(ar,num);
                            'N': ap.ans:=AnnNakl(ar,num);
                            'F': ap.ans:=FreeNakl(ar,num);
                          end;
                          writebuffer(ap,sizeofap,true);
                        end
                   end
                 end;
{lists}     'L': begin
                   li:=ConvL(sl[1]); {kind of list}
                   if li>=0 then
                     case sl[2] of
        {Add}          'A': begin       {}
                              ap.ans:=LAddNew(li,ll,sync);
                              WriteBuffer(ap,sizeofap,true);
                            end;
        {Change}       'C': case sl[3] of
                              'N': begin       {}
                                     ap.ans:=RenameL(li,num,ll.nam,sync);
                                     WriteBuffer(ap,sizeofap,true);
                                   end;
                              'P': begin
                                     ap.ans:=ChangeLnode(li,num,xx);
                                     WriteBuffer(ap,sizeofap,true);
                                   end;
                            end;
        {Read}         'R': if CheckListRange(li,num) then
                              with Lstat[li][num] do
                                begin
                                  ap.ans.prevS:=L[li].info.changed;
                                  ap.ans.num:=num;
                                  ap.ll:=rec;
                                  WriteBuffer(ap,sizeofap,true);
                                end;
        {Synchronize}  'S':if L[li].info.changed.t64>sync then
                            begin
                              ListLock(li);
                              ap.ans.prevS:=L[li].info.changed;
                              ap.ans.count:=CountSendL(li,sync,mm);
                              ap.ans.num:=mm;
                              if ap.ans.count=1 then
                                ap.ll:=Lstat[li][mm].rec;
                              Writebuffer(ap,sizeofap,true);
                              if ap.ans.count>1 then
                                for i:=1 to ap.ans.count do
                                  with Lstat[li][mm] do
                                    begin
                                      writebuffer(rec,sizeof(tListRec),i=ap.ans.count);
                                      mm:=rec.next;
                                    end;
                              ListUnlock(li);
                            end
                           else
                            begin
                              ap.ans.num:=0;
                              ap.ans.count:=0;
                              writebuffer(ap,sizeofap,true);
                            end;
                     end;
                 end;
{catalogs}  'C': begin
                   li:=ConvL(sl[1]);
                   if li>=0 then
                     case sl[2] of
        {Add}          'A': begin {NodeName}
                              ap.ans:=AddCatNode(li,ll,sync);
                              WriteBuffer(ap,sizeofap,true);
                            end;
        {Change}       'C': case sl[3] of
                              'P': begin  {parent node}
                                     ap.ans:=ChangeNode(li,num,xx);
                                     WriteBuffer(ap,sizeofap,true);
                                   end;
                              'N': begin {change node's name}
                                     ap.ans:=RenameNode(li,num,ll.nam,sync);
                                     WriteBuffer(ap,sizeofap,true);
                                   end
                            end;
        {Read}         'R': if CatCheckRange(li,num) then
                              with Cstat[li][num] do
                                begin
                                  ap.ans.prevS:=Cat[li].info.changed;
                                  ap.ans.num:=num;
                                  ap.ca:=rec;
                                  WriteBuffer(ap,sizeofap,true);
                                end;
        {Synchronize}  'S':if Cat[li].info.changed.t64>sync then
                            begin
                              CatLock(li);
                              ap.ans.prevS:=Cat[li].info.changed;
                              ap.ans.count:=CountSendC(li,sync,mm);
                              ap.ans.num:=mm;
                              if ap.ans.count=1 then
                                ap.ca:=Cstat[li][mm].rec;
                              Writebuffer(ap,sizeofap,true);
                              if ap.ans.count>1 then
                                for i:=1 to ap.ans.count do
                                  with Cstat[li][mm] do
                                    begin
                                      writebuffer(rec,sizeof(tCatRec),i=ap.ans.count);
                                      mm:=rec.next;
                                    end;
                              CatUnlock(li);
                            end
                           else
                            begin
                              ap.ans.num:=0;
                              ap.ans.count:=0;
                              writebuffer(ap,sizeofap,true);
                            end;
                     end;
                 end;
{kassa }    'K': begin
                     case sl[1] of
                       'O','C','X','Z' : begin
                                           case sl[1] of
                                             'O': begin
                                                    ap.ans:=KassaAct(caOpenKassa);
                                                    ap.ans.count:=CountOpenedCheq(CLnum,ap.kas.openedCheq);
                                                    Move(Kassa[CLnum].Cash, ap.kas.Cash, 12);
                                                  end;
                                             'C': ap.ans:=KassaAct(caCloseKassa);
                                             'X': begin
                                                    Move(Kassa[CLnum].Cash,ap.aa,12);
                                                    ap.ans:=KassaAct(caXreport);
                                                  end;
                                             'Z': begin
                                                    Move(Kassa[CLnum].Cash,ap.aa,12);
                                                    ap.ans:=KassaAct(caZreport);
                                                  end;
                                           end;
                                           writebuffer(ap,sizeofap,true);
                                         end;
  {deposit}            'D' : begin
                               ap.ans:=KassaAct(caDeposit,xx,0);
                               writebuffer(ap,sizeofap,true);
                             end;
  {withdrawal}         'W' : begin
                               ap.ans:=KassaAct(caWithdrawal,mon.MonCash,0);
                               writebuffer(ap,sizeofap,true);
                             end;
 {annulate cheque }    'A' : begin
                               ap.ans:=CheqAct(csAnnul,num);
                               writebuffer(ap,sizeofap,true);
                             end;
  {get open cheques}   'G' : begin   {34 max}
                               ap.ans.num:=num;
                               ap.ans.count:=CountOpenedCheq(CLnum,ap.kas.openedCheq);
                               writebuffer(ap,sizeofap,true)
                             end;
  {change buyer}       'B' : begin
                               if Kassa[CLnum].OpenStatus then
                                 begin
                                   ArrLock(Sale);
                                   if CheckArr(Sale,num) then
                                     begin
                                       TodayArr[num].header.stat.buyer:=xx;
                                       ap.ans.num:=num;
                                     end
                                    else ZeroAnswer(ap.ans);
                                   ArrUnlock(Sale);
                                 end
                                else
                                 ZeroAnswer(ap.ans);
                               writebuffer(ap,sizeofap,true)
                             end;
  {new cheque}         'N' : begin
                               ap.ans:=CheqAct(csOpen);
                               writebuffer(ap,sizeofap,true)
                             end;
  {cheque position}
                       'P' : begin
                               case sl[2] of
                                 'A' : ap.ans:=CheqPosAction(cpAdd,srp);
                                 'C' : ap.ans:=CheqPosAction(cpChange,srp);
                                 'D' : ap.ans:=CheqPosAction(cpDel,srp);
                                 'I' : ap.ans:=CheqPosAction(cpIns,srp);
                               end;
                               writebuffer(ap,sizeofap,true)
                             end;
{stat cheque info    } 'I' : begin
                               //i:=-1;
                               if Kassa[CLnum].OpenStatus then
                                 begin
                                   ArrLock(Sale);
                                   if CheckArr(Sale,num) then
                                     begin
                                       ap.chs:=TodayArr[num].header.stat;
                                       ap.ans.num:=num;
                                     end
                                    else
                                     ZeroAnswer(ap.ans);
                                   ArrUnlock(Sale);
                                 end
                                else
                                 ZeroAnswer(ap.ans);
                               writebuffer(ap,sizeofap,true);
                             end;
{full cheque info}     'F' : begin
                               need:=true;
                               if Kassa[CLnum].OpenStatus then
                                 begin
                                   ArrLock(Sale);
                                   if CheckArr(Sale,num) then
                                     with TodayArr[num] do
                                      with header.stat do
                                       begin
                                         ap.tch:=header;
                                         ap.ans.num:=num;
                                         need:=Npos>0;
                                         writebuffer(ap,sizeofap,not need);
                                         if need then
                                           writebuffer(chpos[0],sizeof(tChequePos)*Npos,true);
                                         need:=false;
                                       end
                                    else
                                     ZeroAnswer(ap.ans);
                                   ArrUnlock(Sale);
                                 end
                                else
                                 ZeroAnswer(ap.ans);
                               if need then writebuffer(ap,sizeofap,true);
                             end;
  {Sale by cheque}     'S' : begin
                              ap.ans:=CheqAct(csSale,num,@mon);
                              writebuffer(ap,sizeofap,true);
                             end;
  {Return on cheque}
                       'R' : begin
                              ap.ans:=CheqAct(csReturn,num,@mon);
                              writebuffer(ap,sizeofap,true);
                             end;
                     end;
                 end;
          end;
     except
       if (thr=Athread.ThreadID) then thr:=0;
       CheckForDisconnecT(FALSE);
     end;

end;

end.
