unit client;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  StdCtrls, Sockets, FileCtrl, Grids, ComCtrls, BDconnect, login_, PrihNak,
  ExtCtrls, CatSel, goh, Atypes;

const
  psDate   = 0;
  psNum    = 1;
  psSum    = 2;
  psAgent  = 3;
  psChan   = 4;


type

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    PG: TStringGrid;
    Pdp1: TDateTimePicker;
    PD1: TCheckBox;
    Pdp2: TDateTimePicker;
    PA: TComboBox;
    Pa1: TCheckBox;
    Pcreat: TButton;
    Button1: TButton;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Button2: TButton;
    GroupBox1: TGroupBox;
    cbTip: TComboBox;
    bTip: TButton;
    GroupBox2: TGroupBox;
    cbMat: TComboBox;
    bMat: TButton;
    GroupBox3: TGroupBox;
    cbFirm: TComboBox;
    bFirm: TButton;
    GroupBox4: TGroupBox;
    cbSize: TComboBox;
    bSize: TButton;
    edArt: TEdit;
    edOpis: TEdit;
    bFind: TButton;
    MemTip: TListBox;
    MemMat: TListBox;
    MemFirm: TListBox;
    MemSize: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    function EditConnect:boolean;
    procedure PcreatClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;State: TGridDrawState);
    procedure PD1Click(Sender: TObject);
    procedure PGMouseDown(Sender: TObject; Button: TMouseButton;   Shift: TShiftState; X, Y: Integer);
    procedure PGKeyPress(Sender: TObject; var Key: Char);
    procedure PAEnter(Sender: TObject);
    procedure PAKeyPress(Sender: TObject; var Key: Char);
    procedure Pa1KeyPress(Sender: TObject; var Key: Char);
    procedure Pdp1KeyPress(Sender: TObject; var Key: Char);
    procedure PD1KeyPress(Sender: TObject; var Key: Char);
    procedure Pdp2KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure PGDblClick(Sender: TObject);
    procedure PGKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbTipKeyPress(Sender: TObject; var Key: Char);
    procedure bTipClick(Sender: TObject);
    procedure cbMatKeyPress(Sender: TObject; var Key: Char);
    procedure cbFirmKeyPress(Sender: TObject; var Key: Char);
    procedure cbSizeKeyPress(Sender: TObject; var Key: Char);
    procedure bMatClick(Sender: TObject);
    procedure bFirmClick(Sender: TObject);
    procedure bSizeClick(Sender: TObject);
    procedure bFindClick(Sender: TObject);
    procedure MemTipKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemMatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemFirmKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemSizeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure onl;
    procedure dis;
    procedure SortPrihod;
    procedure FilterPrihod;
    procedure FindPrihod(num:integer);
    function IsPrihVis(nu:integer):boolean;
  public
    { Public declarations }
    PrihVect : boolean;
    PrihSort : integer;
  end;

  tCheckConn = class (tThread)
    procedure Execute;override;
  end;

var
  Form1      : TForm1;
  CheckConn  : tCheckConn;
  listfile   : array [Tip..Agent] of tFileNam=(tipFile,matFile,firmFile,sizeFile,agentFile);


implementation

{$R *.dfm}

var
  PrihVis: tArrInt;
  PrihNum: integer=0;

procedure TForm1.PGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  ii,fon:integer;
begin
  if gdFixed in State then
    begin
      PG.Canvas.Brush.Color:=clTeal;
      PG.Canvas.DrawFocusRect(Rect);
      PG.Font.Color:=clWindowText;
      case Acol of
        0 : PG.Canvas.TextRect(Rect,2,2,'дата');
        1 : PG.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,'номер');
        2 : PG.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,'сумма');
        3 : PG.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,'поставщик');
      end;
      exit
    end;
  if (Arow>0)and(PG.cells[1,ARow]<>'') then
    begin
      if trystrtoInt(PG.Cells[1,ARow],ii) then
        case P[ii].state.status of
          stReady : fon:=$90B090;
          stOpen  : fon:=$c4A080;
          stExec  : fon:=$90CF60;
          stAnn   : fon:=$708080;
         else
          fon:=0;
        end
       else
        fon:=0;
      if ARow=PG.Row then fon:=$8FFF80 or fon ;
  {     else fon:=$A0A080 or fon ;              }
      PG.Canvas.Brush.Color:=fon;
      PG.Canvas.FillRect(Rect);
      case ACol of
        0 : PG.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+4,PG.Cells[Acol,Arow]);
        1 : PG.Canvas.TextRect(Rect,Rect.Right-Pg.Canvas.TextWidth(PG.Cells[Acol,Arow])-2,Rect.Top+4,PG.Cells[Acol,Arow]);
        2 : PG.Canvas.TextRect(Rect,Rect.Right-Pg.Canvas.TextWidth(PG.Cells[Acol,Arow])-2,Rect.Top+4,PG.Cells[Acol,Arow]);
        3 : PG.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+4,PG.Cells[Acol,Arow]);
      end;
    end;
end;

function TForm1.EditConnect:boolean;
var
  f:textfile;
  s:string;
begin
  c1.label1.Caption:=BDname;
  c1.Edit1.Text:=c1.TCPc.Host;
  c1.Edit2.Text:=inttostr(c1.TCPc.Port);
  c1.Edit3.Text:=CLname;
  if c1.ShowModal=mrOk then
    begin
      while not SelectDirectory(BDdir,[sdAllowCreate, sdPerformCreate, sdPrompt],0) do;
      assignfile(f,wc+'\'+BDfile);
      rewrite(f);
      s:=c1.Edit3.Text; {client}
      writeln(f,s);
      s:=c1.Edit1.Text; {host}
      writeln(f,s);
      s:=c1.Edit2.Text; {port}
      writeln(f,s);
      s:=c1.Label1.Caption; {BDname}
      writeln(f,s);
      writeln(f,BDdir);        {BDdir}
      closefile(f);
      Result:=true
    end
   else
    Result:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  shortDateformat:='yyyy.mm.dd';
  longtimeformat:='hh:mm:ss';
  Application.Name:='client';
  wc:=getcurrentdir;
  BDname:='';
  CLname:='';
  FillChar(A,sizeof(A),0);
  FillChar(L,sizeof(L),0);
  FillChar(C,sizeof(C),0);
  PrihVect:=false;
  PrihSort:=psDate;
  CheckConn:=Tcheckconn.Create(true);
end;

procedure TForm1.ONL;
var
  i:integer;
begin
{  ********** synchronize ************  }
  qp.sl[0]:='S';
  c1.TCPc.Writebuffer(qp,sizeofqp,true);
  c1.TCPc.ReadBuffer(chanC[0],(Agent-Tip+1)*8);{cats}
  c1.TCPc.ReadBuffer(chanL[0],(Agent-Tip+1)*8);{lists}
  c1.TCPc.ReadBuffer(chanA[0],(Rashod-Tovar+1)*8); {arrays}
  for i:=Tip to Agent  do if (chanC[i]>Cat[i].info.changed.t64) then RefreshCat(i);
  for i:=Tip to Agent  do if (chanL[i]>L[i].info.changed.t64) then RefreshList(i);
  for i:=Tovar to Rashod do if (chanA[i]>A[i].info.changed.t64) then RefreshArr(i);
  form1.Caption:=CLname+' -> '+'['+BDnum+'] - '+BDname;
  filterPrihod;

  form1.StatusBar1.Color:=clGreen
end;

procedure TForm1.dis;
begin
  form1.StatusBar1.Color:=clMaroon;
  Form1.Caption:=CLname+' ..................................................';
end;

procedure tCheckConn.Execute;
  var
    last:boolean;
  begin
    last:=false;
    while not Terminated do
      begin
{        if not c1.TCPc.Connected then
          try
            c1.TCPc.Connect(500);
          except
          end;
}        if last<>online then
          begin
            last:=online;
            if online then
              CheckConn.Synchronize(form1.onl)
             else
              CheckConn.Synchronize(form1.dis);
          end;
        sleep(800);
      end;
    ReturnValue:=0;
  end;

procedure TForm1.FormActivate(Sender: TObject);
  var
    ft:textfile;
    f :file of byte;
    s:string;
    i:integer;
begin
  if Operator=255 then
    begin
{      if Login.ShowModal=mrCancel then exit;
      if not fileExists(OperFile) then
        begin
          fileclose(filecreate(OperFile));
          Oper:=addoper(UserName,Password)
        end
       else
        begin
          Oper:=SelectOper(UserName,Password);
          if Oper=255 then Close;
        end;
}
   operator:=0;
{++++++}
      label1.Visible:=false;
      PageControl1.Visible:=true;
      if not fileExists(BDfile) then
        fileclose(filecreate(BDfile));
      assignfile(f,BDfile);
      reset(f);
      if filesize(f)=0 then
        begin
          BDdir:=wc;
          closefile(f);
          if not EditConnect then exit;
          chDir(BDdir);
          fileclose(filecreate(numfile));
          MkDir(catDir);
          for i:=Tip  to Agent do
            begin
              MkDir(listDir[i]);
              MkDir(catDirs[i]);
              fileclose(filecreate(CatFile[i]));
              fileclose(filecreate(CatIndex[i]));
              fileclose(filecreate(ListFile[i]));
              fileclose(filecreate(ListIndex[i]));
            end;
{SALE -->}for i:=Tovar to Sale do     {  <--------------------}
            begin
              MkDir(arrDir[i]);
              fileclose(filecreate(ArrFile[i]));
              fileclose(filecreate(ArrIndex[i]));
            end;
          ChDir(wc);
        end
       else
        closefile(f);
      if c1.TCPc.Connected then exit;
      assignfile(ft,BDfile);
      reset(ft);
      readln(ft,CLname);            {client}
      readln(ft,s);                 {host}
      c1.TCPc.Host:=s;
      readln(ft,BDnum);                 {port}
      Nserver:=strtoint(BDnum);
      c1.TCPc.Port:=Nserver+Serverport;
      readln(ft,BDname);             {BDname}
      readln(ft,BDdir);              {BDdir}
      ChDir(BDdir);
      closefile(ft);
      form1.Caption:=CLname;
        {load BD}
      try
        c1.TCPc.Connect(1000);
      finally
        CheckConn.Resume;
      end;
      PageControl1.ActivePageIndex:=0;
      Pdp1.SetFocus;
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ix:integer;
  j:integer;
begin
  CheckConn.Terminate;
  SetLength(MyNums,0);
  CheckConn.WaitFor;
  c1.TCPc.Disconnect;
  for j:=Tip to Agent do
    CatSelect.treeCat[j].Destroy;
  ix:=Tip ;
  while ix<=Agent do
    begin
      for j:=1 to L[ix].info.N do
        setlength(LNum[ix][j ].nums,0);
      setlength(Lstat[ix],0);
      setlength(Lnum[ix],0);
      for j:=1 to Cat[ix].info.N do
        begin
          setlength(CatNnum[ix][j].nums,0);
          setlength(CatLnum[ix][j].nums,0)
        end;
      setlength(Cstat[ix],0);
      setlength(CatNnum[ix],0);
      setlength(CatLnum[ix],0);
      inc(ix);
    end;
  for j:=1 to A[Tovar].info.N do setlength(TNum[j].nums,0);
  setlength(T,0);
  setlength(Tnum,0);
  for j:=1 to A[Cart].info.N do setlength(CNum[j].ra,0);
  setlength(C,0);
  setlength(CNum,0);
  for j:=1 to A[Prihod].info.N do setlength(PNum[j].rows,0);
  setlength(P,0);
  setlength(PNum,0);
  for j:=1 to A[Rashod].info.N do setlength(RNum[j].rows,0);
  setlength(R,0);
  setlength(Rnum,0);

end;

{_____________________________________________________________________}

procedure TForm1.FindPrihod(num:integer);
var
  i:integer;
begin
  FilterPrihod;
  for i:=1 to PrihNum do
    if PrihVis[i]=num then
      begin
        PG.Row:=i;
        exit
      end;
  PG.Row:=0;
end;

function TForm1.IsPrihVis(nu:integer):boolean;
begin
  with P[nu].state do
    Result:=((PA.ItemIndex<0)or((PA.ItemIndex+1)=rec.agent))and
           (trunc(PDp1.Date)<=rec.Data) and
           ((PD1.Checked and (trunc(PDp2.Date)>=rec.data))or not PD1.Checked) and
           (not Pa1.Checked or (status<=stOpen));
end;

procedure TForm1.PcreatClick(Sender: TObject);
begin
  if PrihNakl.OpenPrihNakl(0) then
    if (prnum<>0)and IsPrihVis(prnum) then FindPrihod(prnum);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if c1.TCPc.Connected then
    begin
      c1.TCPc.Disconnect;
      exit
    end;
  if not Online and ((Operator<>255)or(Login.ShowModal=mrOk)) then
    begin
      Operator:=0; //SelectOper(UserName,Password);
      if Operator<>255 then
        begin
          c1.TCPc.Connect;
          PageControl1.Visible:=true
        end;
    end;
end;

procedure TForm1.FilterPrihod;
  var
    d1,d2,i:integer;
  procedure vis(nu:integer);
    begin
      with P[nu].state do
        if (d1<=rec.data) and (rec.data<d2) and
           (not PA1.Checked or (status<=stOpen)) then
          begin
            inc(PrihNum);
            PrihVis[PrihNum]:=nu;
          end
    end;
  begin
    with A[prihod].info do
      begin
        if N=0 then exit;
        setlength(PrihVis,N+1);
        d1:=DateTimeToDat(pdp1.Date);
        if pd1.Checked then d2:=DateTimeToDat(pdp2.Date)+1
         else d2:=MaxInt;
        PrihNum:=0;
        if PA.ItemIndex>=0 then
          with LNum[agent][PA.ItemIndex+1] do
            for i:=0 to ctrl.NN-1 do vis(nums[i])
         else
          for i:=1 to N do vis(i);
        if PrihNum>0 then
          begin
            PG.RowCount:=PrihNum+1;
            SortPrihod;
          end
         else
          begin
            PG.RowCount:=2;
            for i:=0 to PG.ColCount-1 do PG.Cells[i,1]:=' ';
          end
      end
  end;

procedure TForm1.SortPrihod;
  var
    i,j:integer;
  procedure exchangePOS(n1,n2:integer);
    var
      old:integer;
    begin
       old:=PrihVis[n1];
       PrihVis[n1]:=PrihVis[n2];
       PrihVis[n2]:=old;
    end;
  begin
    case PrihSort of
      psDate : for i:=1 to PrihNum-1 do
                 with P[PrihVis[i]].state.rec do
                   for j:=i+1 to PrihNum do
                     if prihVect then
                       begin if data>P[PrihVis[j]].state.rec.data then exchangePOS(i,j); end
                      else
                       if data<P[PrihVis[j]].state.rec.data then exchangePOS(i,j);
      psNum  : for i:=1 to PrihNum-1 do
                 for j:=i+1 to PrihNum do
                   if prihVect then
                     begin if PrihVis[i]>PrihVis[j] then exchangePOS(i,j); end
                    else
                     if PrihVis[i]<PrihVis[j] then exchangePOS(i,j);
      psSum  : for i:=1 to PrihNum-1 do
                 with P[PrihVis[i]].state.rec do
                   for j:=i+1 to PrihNum do
                     if prihVect then
                       begin if P[PrihVis[j]].state.rec.sum<sum then exchangePOS(i,j); end
                      else if P[PrihVis[j]].state.rec.sum>sum then exchangePOS(i,j);
      psAgent: for i:=1 to PrihNum-1 do
                 with Lstat[Agent][P[PrihVis[i]].state.rec.agent].rec.pos do
                   for j:=i+1 to PrihNum do
                     if prihVect then
                       begin if nam>Lstat[agent][P[PrihVis[j]].state.rec.agent].rec.pos.nam then exchangePOS(i,j); end
                      else if nam<Lstat[agent][P[PrihVis[j]].state.rec.agent].rec.pos.nam then exchangePOS(i,j);
      psChan : for i:=1 to PrihNum-1 do
                 with P[PrihVis[i]].state do
                   for j:=i+1 to PrihNum do
                     if prihVect then
                       begin if tim.t64>P[PrihVis[j]].state.tim.t64 then exchangePOS(i,j); end
                      else if tim.t64<P[PrihVis[j]].state.tim.t64 then exchangePOS(i,j);
    end;
    for i:=1 to PrihNum do
      with P[PrihVis[i]].state do
        begin
          PG.Cells[0,i]:=DatToStr(rec.data);
          PG.Cells[1,i]:=inttostr(PrihVis[i]);
          PG.Cells[2,i]:=Inttostr(rec.sum);
          PG.Cells[3,i]:=getListNam(agent,rec.agent)+'   --> №'+rec.agnum+' от '+DatToStr(rec.agdat);
        end;
  end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  if not c1.TCPc.Connected then exit;
  case Pagecontrol1.ActivePageIndex of
    pgPrihod  : RefreshArr(prihod);
    pgRashod  : RefreshArr(rashod);
    pgPresence: begin
                  RefreshCat(Tip);
                  RefreshCat(Mat);
                  RefreshCat(Firm);
                  RefreshCat(Size);
                  if RefreshList(Tip) or (cbTip.Items.Count<>L[Tip].info.N) then
                    LoadCB(cbTip,Tip);
                  if RefreshList(Mat) or (cbMat.Items.Count<>L[Mat].info.N) then
                    LoadCB(cbMat,Mat);
                  if RefreshList(Firm) or (cbFirm.Items.Count<>L[Firm].info.N) then
                    LoadCB(cbFirm,Firm);
                  if RefreshList(Size) or (cbSize.Items.Count<>L[Size].info.N) then
                    LoadCB(cbSize,Size);
                end;
  end;
end;

procedure TForm1.PD1Click(Sender: TObject);
begin
  Pcreat.Visible:=not PD1.Checked;
  Pdp2.Visible:=Pd1.Checked;
end;

procedure TForm1.PGMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  co,ro:integer;
begin
  PG.MouseToCell(X,Y,co,ro);
  if (ro=0) and (ssCtrl in Shift) then
    begin
      if prihsort=co then prihVect:=not Prihvect
        else prihsort:=co;
      filterPrihod;
    end;
end;

procedure TForm1.PGKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    #27: PA.SetFocus;
    #13: if PG.Cells[0,1]<>'' then PGDblClick(Self);
  end;
end;

procedure TForm1.PAEnter(Sender: TObject);
begin
  if PA.Items.Count<>L[Agent].info.N then
    begin
      RefreshList(Agent);
      LoadCB(PA,Agent);
    end;
end;

procedure TForm1.PAKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13) then
    begin
      filterPrihod;
      if PrihNum<>0 then Pa1.SetFocus;
    end;
end;

procedure TForm1.Pa1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    begin
      if Pa1.Checked then filterPrihod;
      if PrihNum<>0 then PG.SetFocus
       else PA.SetFocus;
    end;
end;

procedure TForm1.Pdp1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    begin
      filterPrihod;
      PD1.SetFocus;
    end;
end;

procedure TForm1.PD1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    begin
      if PD1.Checked then Pdp2.SetFocus
        else PA.SetFocus;
    end;
end;

procedure TForm1.Pdp2KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    begin
      filterPrihod;
      PA.SetFocus;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  CatSelect.setCatMode(3);
  CatSelect.ShowModal;
end;

procedure TForm1.PGDblClick(Sender: TObject);
var
  num:integer;
begin
  if PG.Cells[0,1]='' then exit;
  if trystrtoint(PG.Cells[1,PG.Row],num)and
     PrihNakl.OpenPrihNakl(num)and
     IsPrihVis(num) then
    FindPrihod(num);
end;

procedure TForm1.PGKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if (key=116)and RefreshArr(Prihod) then
    FindPrihod(prnum);
end;

procedure TForm1.cbTipKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13)and(cbTip.ItemIndex>=0)and goods.MayAdd(Tip,cbTip.ItemIndex+1) then
    begin
      MemTip.Items.Add(Lstat[Tip][cbTip.ItemIndex+1].rec.pos.nam);
      cbTip.ItemIndex:=-1;
    end;
end;

procedure TForm1.cbMatKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13)and(cbMat.ItemIndex>=0)and goods.MayAdd(Mat,cbMat.ItemIndex+1) then
    begin
      MemMat.Items.Add(Lstat[Mat][cbMat.ItemIndex+1].rec.pos.nam);
      cbMat.ItemIndex:=-1;
    end;
end;

procedure TForm1.cbFirmKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13)and(cbFirm.ItemIndex>=0)and goods.MayAdd(Firm,cbFirm.ItemIndex+1) then
    begin
      MemFirm.Items.Add(Lstat[Firm][cbFirm.ItemIndex+1].rec.pos.nam);
      cbFirm.ItemIndex:=-1;
    end;
end;

procedure TForm1.cbSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13)and(cbSize.ItemIndex>=0)and goods.MayAdd(Size,cbSize.ItemIndex+1) then
    begin
      MemSize.Items.Add(Lstat[Size][cbSize.ItemIndex+1].rec.pos.nam);
      cbSize.ItemIndex:=-1;
    end;
end;

procedure TForm1.bTipClick(Sender: TObject);
var
  i,nn:integer;
begin
  CatSelect.SetCat(Tip);
  CatSelect.SetCatMode(4);
  if CatSelect.ShowModal=mrOk then
    for i:=0 to CatSelect.TV.SelectionCount-1 do
      begin
        nn:=-integer(CatSelect.TV.Selections[i].Data);
        if goods.MayAdd(Tip,nn)then MemTip.Items.Add(Lstat[Tip][nn].rec.pos.nam);
      end
end;

procedure TForm1.bMatClick(Sender: TObject);
var
  i,nn:integer;
begin
  CatSelect.SetCat(Mat);
  CatSelect.SetCatMode(4);
  if CatSelect.ShowModal=mrOk then
    for i:=0 to CatSelect.TV.SelectionCount-1 do
      begin
        nn:=-integer(CatSelect.TV.Selections[i].Data);
        if goods.MayAdd(Mat,nn)then MemMat.Items.Add(Lstat[Mat][nn].rec.pos.nam);
      end
end;

procedure TForm1.bFirmClick(Sender: TObject);
var
  i,nn:integer;
begin
  CatSelect.SetCat(Firm);
  CatSelect.SetCatMode(4);
  if CatSelect.ShowModal=mrOk then
    for i:=0 to CatSelect.TV.SelectionCount-1 do
      begin
        nn:=-integer(CatSelect.TV.Selections[i].Data);
        if goods.MayAdd(Firm,nn)then MemFirm.Items.Add(Lstat[Firm][nn].rec.pos.nam);
      end
end;

procedure TForm1.bSizeClick(Sender: TObject);
var
  i,nn:integer;
begin
  CatSelect.SetCat(Size);
  CatSelect.SetCatMode(4);
  if CatSelect.ShowModal=mrOk then
    for i:=0 to CatSelect.TV.SelectionCount-1 do
      begin
        nn:=-integer(CatSelect.TV.Selections[i].Data);
        if goods.MayAdd(Size,nn)then MemSize.Items.Add(Lstat[Size][nn].rec.pos.nam);
      end
end;

procedure TForm1.bFindClick(Sender: TObject);
var
  i,j,n,card,iti,ima,ifi,isi,i1,i2:integer;
  ii:array[Tip..Size]of integer;
  cb:tComboBox;
 function MayBe:boolean;
   var
     k:integer;
   begin
     Result:=false;
     for k:=Tip to Size do
       if ii[k]=gohcat[k].ctrl.NN then exit;
     Result:=true;
   end;
begin
  GohNN:=0;
  RefreshArr(Cart);
  setlength(gohp,0);
  if (gohcat[Tip].ctrl.NN=0)and(cbTip.Text='')and
     (gohcat[Mat].ctrl.NN=0)and(cbMat.Text='')and
     (gohcat[Firm].ctrl.NN=0)and(cbFirm.Text='')and
     (gohcat[Size].ctrl.NN=0)and(cbSize.Text='')and
     (edArt.Text='')and(edOpis.Text='')then
    begin {all}
      with A[Cart].info do
        for i:=first to N do
          if C[i].state.rec.ost>0 then
            goods.GohAdd(i)
    end
   else
    begin
      for i:=Tip to Size do
        with gohcat[i].ctrl do
        begin
          case i of
            Tip  : cb:=cbTip;
            Mat  : cb:=cbMat;
            Firm : cb:=cbFirm;
            Size : cb:=cbSize;
          end;
          if NN=0 then
            begin
              if cb.Text='' then ii[i]:=-1
               else {fill list by substring}
                begin
                  ii[i]:=0;
                  j:=0;
                  repeat
                    j:=FindMatchList(i,j+1,cb.Text);
                    if j<>0 then InsertNum(gohcat[i],j);
                  until j=0;
                  if NN=0 then
                    begin
                      showMessage('нет совпадений'+#13+#10+cb.Text);
                      cb.SetFocus;
                    end
                end
            end
           else ii[i]:=0;
        end;
      n:=0;
      if (ii[Size]<>-2)and(ii[Tip]<>-2)and(ii[Mat]<>-2)and(ii[Firm]<>-2) then
       begin
        if ii[Tip]<0 then iti:=-1
         else iti:=0;
        if ii[Mat]<0 then ima:=-1
         else ima:=0;
        if ii[Firm]<0 then ifi:=-1
         else ifi:=0;
        repeat
          if iti>=0 then iti:=gohcat[Tip].nums[ii[Tip]];
          if ima>=0 then ii[Mat]:=0;
          repeat
            if ima>=0 then ima:=gohcat[Mat].nums[ii[Mat]];
            if ifi>=0 then ii[Firm]:=0;
            repeat
              if ifi>=0 then ifi:=gohcat[Firm].nums[ii[Firm]];
              repeat
                n:=FindMatchTovar(n+1,iti,ima,ifi,edArt.Text,edOpis.Text);
                if n<>0 then {find cart}
                  if ii[Size]=-1 then
                    with Tnum[n] do
                      for i:=0 to ctrl.NN-1 do
                        begin
                          card:=nums[i];
                          if C[card].state.rec.ost>0 then
                            goods.GohAdd(card);
                        end
                   else
                    with gohcat[Size] do
                      for i:=0 to ctrl.NN-1 do
                        begin
                          i1:=0; i2:=0;
                          repeat
                            j:=FindMatch2Int(Tnum[n],LNum[Size][nums[i]],i1,i2);
                            if (j>0)and (C[j].state.rec.ost>0) then goods.GohAdd(j);
                          until j=0;
                        end
              until (n=0);
              if ifi>=0 then inc(ii[Firm])
               else break;
            until (ii[Firm]=gohcat[Firm].ctrl.NN);
            if ima>=0 then inc(ii[Mat])
             else break;
          until (ii[Mat]=gohcat[Mat].ctrl.NN);
          if iti>=0 then inc(ii[Tip])
           else break;
        until (ii[Tip]=gohcat[Tip].ctrl.NN);
       end
    end;
{      if gohcatN[Tip]=0 then ii[0,
       else
      if gohcatN[Tip]=0 then
        begin
          for i:=1 to L[Tip].info.N do
            with Lnum[Tip][i] do
              for j:=0 to ctrl.NN-1 do
                with T[nums[j]].state do
                  if Exists(Mat,nums[j]) and Exists(Firm,nums[j])and
                     MatchInStr(trim(edArt.Text),rec.art)and MatchInStr(trim(edOpis.Text),rec.opis) then
                    for k:=0 to Tnum[nums[j]].ctrl.NN-1 do
                      begin
                        card:=Tnum[nums[j]].nums[k];
                        with C[card].state.rec do
                          if (card>=n)and(ost>0)and Exists(Size,card) then
                            goods.GohAdd(card);
                      end;
        end
       else
        begin
          for i:=0 to gohcatN[Tip]-1 do
            with Lnum[Tip][gohcat[Tip][i]] do
              for j:=0 to ctrl.NN-1 do
                with T[nums[j]].state do
                  if Exists(Mat,nums[j]) and Exists(Firm,nums[j])and
                     MatchInStr(trim(edArt.Text),rec.art)and MatchInStr(trim(edOpis.Text),rec.opis) then
                    for k:=0 to Tnum[nums[j]].ctrl.NN-1 do
                      begin
                        card:=Tnum[nums[j]].nums[k];
                        with C[card].state.rec do
                          if (card>=n)and(ost>0)and Exists(Size,card) then
                            goods.GohAdd(card);
                      end;
        end
    end;             }

  if GohNN>0 then
    begin
      goods.GohFill;
      goods.Show;
    end
   else
    showmessage('ничего нет');
  for i:=Tip to Size do
    with gohcat[i].ctrl do
      case i of
        Tip  : if MemTip.Count=0 then NN:=0;
        Mat  : if MemMat.Count=0 then NN:=0;
        Firm : if MemFirm.Count=0 then NN:=0;
        Size : if MemSize.Count=0 then NN:=0;
      end;
end;

procedure TForm1.MemTipKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if (key=46)and (MemTip.ItemIndex>=0) then
    begin
      DeleteNum(gohcat[Tip],GetNumL(Tip,MemTip.Items[MemTip.ItemIndex]));
      MemTip.Items.Delete(MemTip.ItemIndex);
    end
end;

procedure TForm1.MemMatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=46)and (MemMat.ItemIndex>=0) then
    begin
      DeleteNum(gohcat[Mat],GetNumL(Mat,MemMat.Items[MemMat.ItemIndex]));
      MemMat.Items.Delete(MemMat.ItemIndex);
    end
end;

procedure TForm1.MemFirmKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=46)and (MemFirm.ItemIndex>=0) then
    begin
      DeleteNum(gohcat[Firm],GetNumL(Firm,MemFirm.Items[MemFirm.ItemIndex]));
      MemFirm.Items.Delete(MemFirm.ItemIndex);
    end
end;

procedure TForm1.MemSizeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=46)and (MemSize.ItemIndex>=0) then
    begin
      DeleteNum(gohcat[Size],GetNumL(Size,MemSize.Items[MemSize.ItemIndex]));
      MemSize.Items.Delete(MemSize.ItemIndex);
    end
end;

end.

