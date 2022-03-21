unit KASSAinterface;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Menus, Login_, KassaBD,
  CheqPos ,Atypes, SelectTovar ;

const
  BDfile    = 'bd.cnt';
  NoCheque  = '* No opened cheque *';
type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    X1: TMenuItem;
    Z1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Xreport: TMenuItem;
    Zreport: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    NewCheque: TButton;
    ListCheqPos: TListBox;
    summashow: TLabel;
    CheqList: TTabControl;
    PayBut: TButton;
    EditNal: TEdit;
    EditBez: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    AnnuBut: TButton;
    btMore: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N2Click(Sender: TObject);
    procedure X1Click(Sender: TObject);
    procedure ListCheqPosMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListCheqPosDblClick(Sender: TObject);
    procedure NewChequeClick(Sender: TObject);
    procedure CheqListChange(Sender: TObject);
    procedure EditNalKeyPress(Sender: TObject; var Key: Char);
    procedure EditBezKeyPress(Sender: TObject; var Key: Char);
    procedure PayButClick(Sender: TObject);
    procedure AnnuButClick(Sender: TObject);
    procedure btMoreClick(Sender: TObject);
    procedure EditNalExit(Sender: TObject);
    procedure XreportClick(Sender: TObject);
    procedure ZreportClick(Sender: TObject);
    procedure EditBezExit(Sender: TObject);
    procedure ListCheqPosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure onl;
    procedure dis;
    procedure InsertBlankCheqPos(np:integer);
    procedure FillCheqPos(np:integer; nc,co,pr:integer);
    function  CreateCheque:integer;
    procedure CloseCheque(tab:integer);
    procedure ShowCheque(tab:integer);
    procedure EnterNewCheqPos;
    procedure SaleMode;
  public
    { Public declarations }
  end;

  tCheckConn = class (tThread)
    procedure Execute;override;
  end;

var
  Form1: TForm1;
  CheckConn  : tCheckConn;

implementation

uses SelectCart;


{$R *.dfm}

procedure TForm1.ONL;
begin
{  ********** synchronize ************  }
  if RefreshList(Tip) then LoadCB(ChequePosition.cbTip,Tip);
  if RefreshList(Mat) then LoadCB(ChequePosition.cbMat,Mat);
  if RefreshList(Firm) then LoadCB(ChequePosition.cbFirm,Firm);
  if RefreshList(Size) then LoadCB(ChequePosition.cbSize,Size);
  refreshArr(Tovar);
  refreshArr(Cart);
  refreshArr(Sale);
  form1.Caption:=CLname+' -> '+'['+BDnum+'] - '+BDname;
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
    s:string;
begin
      assignfile(ft,BDfile);
      reset(ft);
      readln(ft,CLname);            {client}
      readln(ft,s);                 {host}
      Conserv.c1.Host:=s;
      readln(ft,BDnum);                 {port}
      Nserver:=strtoint(BDnum);
      Conserv.c1.Port:=Nserver+Serverport;
      readln(ft,BDname);             {BDname}
      readln(ft,BDdir);              {BDdir}
      ChDir(BDdir);
      closefile(ft);
      form1.Caption:=CLname;
   {load BD}
  try
    ConServ.c1.Connect(1000);
    CheckConn.Resume;
    N1.Click;
   except
    CheckConn.Suspend;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  shortDateformat:='yyyy.mm.dd';
  longtimeformat:='hh:mm:ss';
  Application.Name:='client';
  BDname:='';
  CLname:='';
  FillChar(A,sizeof(A),0);
  FillChar(L,sizeof(L),0);
  CheckConn:=Tcheckconn.Create(true);
  MyKass.OpenStatus:=false;
  FillChar(MyKass,24,0);
  MyKass.Date:= GetTodayDat;
end;

function CloseKassa:boolean;
begin
{  if MyKass.CheqOpen then
    begin
      ShowMessage('Открытый чек');
      Result:=false;
      exit
    end;    }
  if MyKass.OpenStatus and (MessageDlg('Незакрытая касса?',mtwarning,[mbNo,mbYes],0)=mrNo) then
    begin
      Result:=false;
      exit
    end;
  Result:=true;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CloseKassa then
    begin
      Action:=caFree;
      NCheq:=0;
    end
   else
    Action:=caNone;
end;

procedure TForm1.N2Click(Sender: TObject);
var
  i:integer;
  aa:tArrOpened;
begin   {Open kassa}
  if KassaOpen then
    begin
      N2.Enabled:=false;
      X1.Enabled:=true;
      N4.Enabled:=true;
      Form1.Caption:='Касса №'+inttostr(CLnum)+'  открыта';
      ListCheqPos.Clear;
      NewCheque.Enabled:=true;
      Move(ap.kas.Cash, MyKass.Cash, 12); {cash,cashless,total}
      Ncheq:=ap.ans.count;
      if Ncheq>0 then
        begin
          Move(ap.kas.openedCheq,aa,Ncheq*4);
          if Ncheq=10 then NewCheque.Enabled:=false;
          qp.sl[1]:='F';
          with A[Sale].info do
            for i:=0 to Ncheq-1 do
              with Cheq[i] do
                begin
                  qp.num:=aa[i];
                  ok:=QueryKass;
                  if ok then
                    begin
                      stat:=ap.chs;
                      cheqnum:=aa[i];
                      CheqList.Tabs.Add('№ '+inttostr(cheqnum+ofs));
                      if stat.Npos>0 then
                        begin
                          setlength(pos,ReserveSize(stat.Npos,10));
                          Conserv.c1.ReadBuffer(pos[0],stat.Npos*sizeof(tChequePos));
                        end
                    end
                   else
                    CheqList.Tabs.Add('№ '+inttostr(cheqnum+ofs)+'  ##$$#$ Error')
                end;
          btMore.Enabled:=true;
          AnnuBut.Enabled:=true;
        end;
      CheqList.TabIndex:=Ncheq-1;
      if NewCheque.Enabled then
        NewCheque.SetFocus
       else
        CheqList.SetFocus;
      ShowCheque(CheqList.TabIndex);
      SaleMode;
    end;
end;

procedure TForm1.X1Click(Sender: TObject);
begin   {close kassa}
  if KassaClose then
    begin
      N2.Enabled:=true;
      X1.Enabled:=false;
      N4.Enabled:=false;
      N7.Enabled:=false;
      NewCheque.Enabled:=false;
      Form1.Caption:='Касса №'+inttostr(CLnum)+'  закрыта';
    end
end;

procedure TForm1.InsertBlankCheqPos(np:integer);
var
  i:integer;
begin
  np:=np*4+1;
  for i:=0 to 3 do ListCheqPos.Items.Insert(np,'');
end;

procedure TForm1.FillCheqPos(np:integer; nc,co,pr:integer);
begin
    with C[nc+A[Cart].info.ofs].state.rec.base do
      with T[tov].state do
        with ListCheqPos.Items do
          begin
            np:=np*4+1;
            if ListCheqPos.Count<=np then
              begin
                Add(Lstat[Tip][rec.tip].rec.pos.nam+#32+#32+Lstat[Mat][rec.mat].rec.pos.nam+#32+#32+Lstat[Firm][rec.firm].rec.pos.nam);
                Add(rec.art+#32+#32+rec.opis+' ('+Lstat[Size][siz].rec.pos.nam+')');
                Add(inttostr(co)+'шт по '+IntToStr(pr)+Money+' = '+IntToStr(co*pr)+Money);
                Add('***'+intToStr(nc)+'**'+intToStr(tov)+'**'+intToStr(siz)+'***');
              end
             else
              begin
                Strings[np]:=Lstat[Tip][rec.tip].rec.pos.nam+#32+#32+Lstat[Mat][rec.mat].rec.pos.nam+#32+#32+Lstat[Firm][rec.firm].rec.pos.nam;
                Strings[np+1]:=rec.art+#32+#32+rec.opis+' ('+Lstat[Size][siz].rec.pos.nam+')';
                Strings[np+2]:=inttostr(co)+'шт по '+IntToStr(pr)+Money+' = '+IntToStr(co*pr)+Money;
                Strings[np+3]:='***'+intToStr(nc)+'**'+intToStr(tov)+'**'+intToStr(siz)+'***'
              end
          end;
end;

function TForm1.CreateCheque:integer;
  begin
    if MyKass.OpenStatus and (Ncheq<9)then
      begin
        qp.sl[1]:='N';
        if QueryKass then
          begin
            inc(Ncheq);
            if Ncheq=10 then NewCheque.Enabled:=false;
            with Cheq[Ncheq-1] do
              begin
                cheqNum:=ap.ans.num;
                Result:=Cheqnum;
                ResizeArr(Sale,cheqNum);
                fillchar(stat,sizeof(stat),0);
                stat.Nkas:=CLNum;
                stat.status:=csOpen;
                stat.creat:=ap.ans.timS;
                setlength(pos,0);
              end;
            {writelog create cheque  }
          end
         else
          Result:=-1;
      end
     else
      Result:=-1;
  end;

procedure TForm1.ListCheqPosMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var
    tp:tPoint;
    nn,i:integer;
begin
  tp.X:=x;
  tp.Y:=y;
  nn:=ListCheqPos.ItemAtPos(tp,true);
  if nn>0 then
    with ListCheqPos do
      begin
        nn:=(nn-1)div 4*4 +1;
        if not Selected[nn] then
          for i:=0 to Count-1 do Selected[i]:=false;
        for i:=nn to nn+3 do Selected[i]:=true;
      end
   else
    listCheqPos.Selected[nn]:=false;
end;

procedure TForm1.ListCheqPosDblClick(Sender: TObject);
var
  i,np:integer;
begin
  np:=-1;
  with ListCheqPos do
    for i:=1 to Count-4 do
      if Selected[i] then
        begin
          np:=(i-1)div 4+1;
          break
        end;
  {call edit form}
end;

procedure TForm1.SaleMode;
begin
  with cheq[CheqList.TabIndex] do
    with stat do
      if Sum>0 then
        begin
          SummaShow.Caption:=IntToStr(Sum)+Money;
          EditNal.Enabled:=true;
          EditBez.Enabled:=true;
          EditNal.SetFocus;
          PayBut.Enabled:=true;
        end
       else
        begin
          SummaShow.Caption:='';
          if Ncheq>0 then
            begin
              AnnuBut.Enabled:=true;
              btMore.Enabled:=true;
              btMore.SetFocus;
            end
           else
            begin
              btMore.Enabled:=false;
              AnnuBut.Enabled:=false;
              NewCheque.SetFocus;
            end
        end;
end;

procedure TForm1.EnterNewCheqPos;
  var
    i,nn,mm,X,su:integer;
 function reserve:boolean;
   begin
     with cheq[CheqList.TabIndex] do
       with stat do
         begin          
           qp.num:=cheqnum;
           qp.srp.doc:=CheqNum;
           qp.srp.pos:=Npos;
           Move(ChequePosition.cp,qp.srp.CheqPos,sizeof(tSendCheqPos));
           Result:=ReservePos;
           if Result then
             with ChequePosition do with cp do
               begin
                 SaleSum:=SaleCount*SalePrice;
                 SaleRazn:=SaleSum-C[SaleCart].state.rec.base.price*SaleCount;
                 if Npos=length(pos) then
                   setlength(pos,length(pos)+8);
                 pos[Npos]:=cp;
                 FillCheqPos(Npos,SaleCart,SaleCount,SalePrice);
                 inc(Npos);
                 inc(Sum,SaleSum);
                 inc(Razn,SaleRazn);
               end
         end;
   end;
  {-90-90-870976086897099-0=-0=}
begin
  with ChequePosition do with cp do
    begin
      if rg.ItemIndex<0 then
        begin
          cbTip.Text:='';
          cbMat.Text:='';
          cbFirm.Text:='';
          cbSize.Text:='';
          edArt.Text:='';
          edOpis.Text:='';
          edCart.Text:='';
          edTovar.Text:='';
        end;
      edKol.Enabled:=false;
      edPrice.Enabled:=false;
      while ShowModal<>mrCancel  do
        begin
          if SaleCart<>0 then
            begin
              nn:=0;
              if EnterSum.Checked then
                DivInto(SaleCount,SalePrice,SaleCount,nn,SalePrice);
              if not reserve then
                ShowMessage('Остаток='+inttostr(C[SaleCart].state.rec.ost))
               else
                if nn<>0 then
                  begin
                    SaleCount:=nn;
                    inc(SalePrice);
                    if not reserve then
                      ShowMessage('Остаток='+inttostr(C[SaleCart].state.rec.ost))
                  end
            end
           else
            begin
              if EnterSum.Checked then
                ShowMessage('Not now')
               else
                with SelCart do
                  begin
                    X:=SaleSum-Zakup;
                    for i:=0 to NN-1 do
                      begin
                        SaleCart:=selca[i];
                        with C[SaleCart].state.rec do
                          begin
                            nn:=ost*base.price;
                            su:=round(X*nn/Zakup);
                            DivInto(ost,su+nn,SaleCount,mm,SalePrice);
                            if not Reserve then
                              showMessage('фигня')
                             else
                              if mm>0 then
                                begin
                                  SaleCount:=mm;
                                  inc(SalePrice);
                                  reserve
                                end
                          end
                      end
                  end
            end;
          SummaShow.Caption:=IntToStr(cheq[CheqList.TabIndex].stat.Sum)+Money;
        end;
    with Cheq[CheqList.TabIndex].stat do
      if Sum>0 then
        begin
          EditNal.Text:=inttostr(Sum);
          EditNal.SetFocus
        end
       else
        btMore.SetFocus;
  end;
end;

procedure TForm1.NewChequeClick(Sender: TObject);
var
  nn,tab:integer;
begin
  nn:=CreateCheque;
  if nn<1 then
    begin
      ShowMessage('ошибка создания');
      exit
    end;
  tab:=CheqList.Tabs.Add('№ '+inttostr(nn));
  CheqList.TabIndex:=tab;
  ListCheqPos.Clear;
  ListCheqPos.Items.Add('Чек № '+inttostr(nn));
  if tab=0 then
    begin
      summashow.Caption:='';
      paybut.Enabled:=false;
      EditNal.Text:='';
      EditBez.Text:='';
      EditNal.Enabled:=true;
      EditBez.Enabled:=true;
      AnnuBut.Enabled:=true;
      label2.Enabled:=true;
      label3.Enabled:=true;
    end;
  if tab=9 then NewCheque.Enabled:=false;
  EnterNewCheqPos;
end;

procedure TForm1.ShowCheque(tab:integer);
  var
    i:integer;
begin
  if CheqList.TabIndex>=0 then
    with cheq[CheqList.TabIndex] do
      begin
        listCheqPos.Clear;
        listCheqPos.Items.Add('Чек № '+inttostr(cheqNum)+'   Покупатель № '+inttostr(stat.Buyer));
        for i:=0 to stat.Npos-1 do
          with pos[i] do
            FillCheqPos(i,SaleCart,SaleCount,SalePrice);
        if stat.Sum<>0 then
          begin
            SummaShow.Caption:=IntToStr(stat.Sum)+Money;
            paybut.Enabled:=true;
          end
         else
          begin
            summaShow.Caption:='';
            paybut.Enabled:=false;
          end;
      end
   else
    begin
      summashow.Caption:='';
      EditNal.Text:='';
      EditBez.Text:='';
      EditNal.Enabled:=false;
      EditBez.Enabled:=false;
      AnnuBut.Enabled:=false;
      label2.Enabled:=false;
      label3.Enabled:=false;
      paybut.Enabled:=false;
    end;
end;

procedure TForm1.CheqListChange(Sender: TObject);
begin
  ShowCheque(CheqList.TabIndex);
  SaleMode;
end;

procedure TForm1.EditNalKeyPress(Sender: TObject; var Key: Char);
begin
  if noZifrFiltr(key) then exit;
  if key=#13 then //(EditNal.Text='')or(StrToIntDef(EditNal.Text,-1)>0))then
    EditBez.SetFocus;
end;

procedure TForm1.EditBezKeyPress(Sender: TObject; var Key: Char);
begin
  if noZifrFiltr(key) then exit;
  if key=#13 then
    with Cheq[CheqList.TabIndex].stat do
      begin
        Cashless:=StrToIntDef(EditBez.Text,0);
        if (Cashless>0)or(Cash>0) then
          begin
            PayBut.Enabled:=true;
            PayBut.SetFocus;
          end
         else
          EditNal.SetFocus;
       end
end;

procedure TForm1.PayButClick(Sender: TObject);
var
  ch:Integer;
  outward:boolean;
begin
  with Cheq[CheqList.TabIndex].stat do
    begin
      ch:=Cash+Cashless-Sum;
      if ch<0 then
        begin
          ShowMessage('недостаточно денег');
          EditNal.SetFocus
        end
       else
        begin
          if ch>0 then
            begin
              if Cash<ch then
                begin
                  showmessage('Сдачу безналом не даем !');
                  exit
                end;
              outward:= MessageDlg('Сдача из кассы?',mtwarning,[mbNo,mbYes],0)=mrNo;
              dec(Cash,ch);
            end;
          if SaleCheque(CheqList.TabIndex) then
            begin
              if ch>0 then
                begin
                  if outward then
                    begin
                      if not KassaDeposit(ch) then
                        ShowMessage('ошибка вноса денег в кассу');
                    end
                   else
                    ShowMessage('Сдача '+IntToStr(ch)+money);
                end;
              closeCheque(CheqList.TabIndex);
            end
           else
            ShowMessage('Продажа : ошибка чека');
        end
    end;
end;

procedure TForm1.CloseCheque(tab:integer);
begin
  with CheqList do
    begin
      Tabs.Delete(tab);
      dec(Ncheq);
      if not NewCheque.Enabled then NewCheque.Enabled:=true;
      if Tabs.Count<>tab then TabIndex:=tab
       else TabIndex:=tab-1;
      if TabIndex>=0 then
        begin
          ShowCheque(TabIndex)
        end
       else
        begin
          ListCheqPos.Clear;
          ListCheqPos.Items.Add(NoCheque);
          PayBut.Enabled:=false;
          btMore.Enabled:=false;
          AnnuBut.Enabled:=false;
          EditNal.Text:='';
          EditBez.Text:='';
          SummaShow.Caption:='';
        end
    end
end;

procedure TForm1.AnnuButClick(Sender: TObject);
begin
  if AnnulCheque(CheqList.TabIndex) then
    CloseCheque(CheqList.TabIndex)
end;

procedure TForm1.btMoreClick(Sender: TObject);
begin
  if Ncheq>0 then EnterNewCheqPos;
end;

procedure TForm1.EditNalExit(Sender: TObject);
begin
  with Cheq[CheqList.TabIndex].stat do
    begin
      Cash:=StrToIntDef(EditNal.Text,0);
      if Cash<>0 then PayBut.Enabled:=true;
    end;
end;

procedure TForm1.XreportClick(Sender: TObject);
begin
  if not KassaX then ShowMessage('ошибка кассы Х')
end;

procedure TForm1.ZreportClick(Sender: TObject);
begin
  if not KassaZ then ShowMessage('ошибка кассы Z')
end;

procedure TForm1.EditBezExit(Sender: TObject);
begin
  Cheq[CheqList.TabIndex].stat.Cashless:=StrToIntDef(EditBez.Text,0);
end;

procedure TForm1.ListCheqPosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i,np:integer;
begin
  if (key=46){Del} and (ListCheqPos.SelCount=4) then
    with Cheq[CheqList.TabIndex] do
      begin
        qp.num:=cheqnum;
        qp.sl[1]:='P';
        qp.sl[2]:='D';
        qp.srp.pos:= (ListCheqPos.ItemIndex-1)div 4;
        qp.srp.doc:=qp.num;
        if QueryKass then
          begin
            RefreshArr(Cart);
            ListCheqPos.ItemIndex:=-1;
            for i:=0 to 3 do ListCheqPos.Items.Delete(qp.srp.pos*4+1);
            dec(stat.Sum,pos[qp.srp.pos].SaleSum);
            dec(stat.Razn,pos[qp.srp.pos].SaleRazn);
            dec(stat.Npos);
            for i:=qp.srp.pos to stat.Npos-2 do pos[i]:=pos[i+1];
     //       CutArr(Sale,cheqnum-A[Sale].info.ofs);
     //       SetLastArr(Sale,cheqnum-A[Sale].info.ofs,);
          end;
        SaleMode;
      end;
end;

end.
