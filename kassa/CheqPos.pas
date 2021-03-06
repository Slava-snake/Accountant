unit CheqPos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Atypes, KassaBD, SelectTovar, SelectCart;

type
  TChequePosition = class(TForm)
    cbTip: TComboBox;
    cbMat: TComboBox;
    cbFirm: TComboBox;
    edArt: TEdit;
    edOpis: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edCart: TEdit;
    edTovar: TEdit;
    Label7: TLabel;
    cbSize: TComboBox;
    Label8: TLabel;
    Animate1: TAnimate;
    edKol: TLabeledEdit;
    edPrice: TLabeledEdit;
    btNext: TButton;
    rg: TRadioGroup;
    FreshBut: TButton;
    EnterSum: TCheckBox;
    procedure edKolEnter(Sender: TObject);
//    procedure rbCodKeyPress(Sender: TObject; var Key: Char);
    procedure edCartKeyPress(Sender: TObject; var Key: Char);
    procedure edTovarKeyPress(Sender: TObject; var Key: Char);
    procedure cbSizeKeyPress(Sender: TObject; var Key: Char);
    procedure rgClick(Sender: TObject);
    procedure FreshButClick(Sender: TObject);
    procedure cbTipKeyPress(Sender: TObject; var Key: Char);
    procedure cbMatKeyPress(Sender: TObject; var Key: Char);
    procedure cbFirmKeyPress(Sender: TObject; var Key: Char);
    procedure edArtKeyPress(Sender: TObject; var Key: Char);
    procedure edOpisKeyPress(Sender: TObject; var Key: Char);
    procedure edKolKeyPress(Sender: TObject; var Key: Char);
    procedure edPriceKeyPress(Sender: TObject; var Key: Char);
    procedure btNextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgEnter(Sender: TObject);
    procedure cbSizeEnter(Sender: TObject);
    procedure btNextEnter(Sender: TObject);
    procedure btNextExit(Sender: TObject);
    procedure edTovarEnter(Sender: TObject);
    procedure edCartExit(Sender: TObject);
    procedure edTovarExit(Sender: TObject);
    procedure edPriceExit(Sender: TObject);
    procedure edPriceEnter(Sender: TObject);
    procedure EnterSumClick(Sender: TObject);
    procedure cbSizeChange(Sender: TObject);
    procedure cbSizeExit(Sender: TObject);
    procedure edKolExit(Sender: TObject);
    procedure cbTipChange(Sender: TObject);
    procedure cbMatChange(Sender: TObject);
    procedure cbFirmChange(Sender: TObject);
    procedure edArtChange(Sender: TObject);
    procedure edOpisChange(Sender: TObject);
  private
    { Private declarations }
    procedure ShowOpis;
    procedure HideOpis;
    procedure ShowScan;
    procedure HideScan;
    procedure ShowCod;
    procedure HideCod;
    procedure Retry;
    procedure FillCartSale;
    procedure FillSaleTovar;
{    function CheckTovarSize:boolean; }
  public
    { Public declarations }
    cp:tChequePos;
  end;

var
  ChequePosition: TChequePosition;
  Zakup       : integer=0;
  SaleMaxCount: integer=0;
  SalePercent : integer=0;
  SaleSize    : integer=0;
  SaleTovar   : integer=0;

implementation

{$R *.dfm}

var
  AfterFresh:TWinControl=nil;
  wayCartCod:boolean=false;
  wayTovarCod:boolean=false;
  
procedure TChequePosition.ShowScan;
  begin
    Animate1.Show;
    Animate1.Reset;
    Animate1.Active:=true;
    {run scan mode}
  end;

procedure TChequePosition.HideScan;
  begin
    {stop scan mode}
    Animate1.Stop;
    Animate1.Active:=false;
    Animate1.Hide;
  end;

procedure TChequePosition.ShowCod;
  begin
    edCart.Enabled:=true;
    edTovar.Enabled:=true;
    label6.Enabled:=true;
    label7.Enabled:=true;
    label8.Enabled:=true;
    cbSize.Enabled:=true;
    cbSize.Color:=clAqua;
    edCart.SetFocus;
    if cp.SaleCart>0 then
      begin
        edCart.Text:=inttostr(cp.SaleCart);
        FillCartSale
      end
     else
      begin
        edCart.Text:='';
        if SaleTovar>0 then FillSaleTovar
         else edTovar.Text:='';
      end
  end;

procedure TChequePosition.HideCod;
  begin
    edCart.Enabled:=false;
    edTovar.Enabled:=false;
    label6.Enabled:=false;
    label7.Enabled:=false;
    label8.Enabled:=false;
    cbSize.Enabled:=false;
    cbSize.Color:=clGray;
    edCart.Text:='';
    edTovar.Text:='';
  end;

procedure TChequePosition.ShowOpis;
  begin
    cbTip.Enabled:=true;
    cbMat.Enabled:=true;
    cbFirm.Enabled:=true;
    edArt.Enabled:=true;
    edOpis.Enabled:=true;
    label1.Enabled:=true;
    label2.Enabled:=true;
    label3.Enabled:=true;
    label4.Enabled:=true;
    label5.Enabled:=true;
    label8.Enabled:=true;
    cbSize.Enabled:=true;
    cbSize.Color:=clMoneyGreen;
    cbTip.SetFocus;
    if SaleTovar>0 then FillSaleTovar
     else edTovar.Text:='';
  end;

procedure TChequePosition.HideOpis;
  begin
    cbTip.Enabled:=false;
    cbMat.Enabled:=false;
    cbFirm.Enabled:=false;
    edArt.Enabled:=false;
    edOpis.Enabled:=false;
    label1.Enabled:=false;
    label2.Enabled:=false;
    label3.Enabled:=false;
    label4.Enabled:=false;
    label5.Enabled:=false;
    label8.Enabled:=false;
    cbSize.Enabled:=false;
    cbSize.Color:=clGray;
  end;

procedure TChequePosition.rgClick(Sender: TObject);
begin
  case rg.ItemIndex of
    0 : begin
          HideCod;
          HideOpis;
          ShowScan;
        end;
    1 : begin
          HideScan;
          HideOpis;
          ShowCod;
        end;
    2 : begin
          HideScan;
          HideCod;
          ShowOpis;
        end
  end;
end;

procedure TChequePosition.Retry;
begin
  rgClick(Self);
    case rg.ItemIndex of
      0:;
      1:edCart.SetFocus;
      2:cbTip.SetFocus;
    end
end;

procedure TChequePosition.edKolEnter(Sender: TObject);
begin
  if SaleTovar=0 then
    begin
      if rg.ItemIndex=1 then
        cbSize.SetFocus
       else
        edCart.SetFocus
    end
   else
    if SaleMaxCount=0 then
      begin
        ShowMessage('??? ?????? ???');
        Retry
      end
     else
      if SaleSize=0 then
        edKol.Text:=inttostr(SaleMaxCount)
       else
        if edKol.Text='' then edKol.Text:='1';
end;

procedure TchequePosition.edTovarEnter(Sender: TObject);
begin
  if wayCartCod then
    begin
      edKol.Enabled:=true;
      edKol.SetFocus;
      wayCartCod:=false;
    end  
end;

procedure TChequePosition.FillSaleTovar;
var
  i:integer;
begin
  if SaleTovar>0 then
    with T[SaleTovar].state do
      begin
        i:=SaleTovar;
        edTovar.Text:=inttostr(SaleTovar);
        cbTip.Text:=Lstat[Tip][rec.tip].rec.pos.nam;
        cbMat.Text:=Lstat[Mat][rec.mat].rec.pos.nam;
        cbFirm.Text:=Lstat[Firm][rec.firm].rec.pos.nam;
        edArt.Text:=rec.art;
        edOpis.Text:=rec.opis;
        SaleTovar:=i;
      end
   else
    begin
      ShowMessage('??? ?????? ?0');
      if rg.ItemIndex=2 then cbTip.SetFocus;
    end;  
end;

{procedure TChequePosition.rbCodKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then edCart.SetFocus;
end;
 }
procedure TChequePosition.FillCartSale;
begin
    with C[cp.SaleCart].state.rec do
      begin
        SaleTovar:=base.tov;
        SaleSize:=base.siz;
        SaleMaxCount:=ost;
        FillSaleTovar;
        cbSize.ItemIndex:=SaleSize-1;
       // cbSize.Text:=Lstat[Size][SaleSize].rec.pos.nam;
        if (ost>0) then
          begin
            edKol.Enabled:=true;
            edKol.SetFocus;
          end
         else
          begin
            ShowMessage('?????? ????????');
            edCart.SetFocus
          end;
      end
end;

procedure TChequePosition.edCartKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#27)then
    if (edCart.Text='') then
      begin
        ModalResult:=mrCancel;
        exit
      end
     else
      edCart.Text:='';
  if noZifrFiltr(key) then exit;
  if key=#13 then
    begin
      wayCartCod:=true;
      edTovar.SetFocus;
    end;
end;

procedure TChequePosition.edTovarKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#27)then
    if (edTovar.Text='') then
      begin
        edCart.SetFocus;
        exit
      end
     else
      edTovar.Text:='';
  if noZifrFiltr(key) then exit;
  if key=#13 then
    if edTovar.Text='' then
      edCart.SetFocus
     else
      cbSize.SetFocus;
end;

procedure TChequePosition.cbSizeKeyPress(Sender: TObject; var Key: Char);
var
  nn,ic,i1,i2,i:integer;
 procedure AddSelCart(ss:integer);
  begin
    with C[ss].state.rec do
      if ost>0 then
        begin
          inc(SaleMaxCount,ost);
          inc(Zakup,ost*base.price);
          SelCart.add(ss);
        end;
  end;
 procedure FindSelCart(salt,siz:integer);
  begin
    i1:=TNum[salt].ctrl.Nn0;
    i2:=LNum[Size][siz].ctrl.Nn0;
    repeat
      ic:=FindMatch2Int(TNum[salt],LNum[Size][siz],i1,i2);
      if ic<>0 then AddSelCart(ic);
    until ic=0;
  end;
 procedure incMax(siz:integer);
  begin
    repeat
      nn:=FindMatch2Int(TNum[SaleTovar],LNum[Size][siz],i1,i2);
      if nn>0 then
        with C[nn].state.rec do
          begin
            inc(SaleMaxCount,ost);
            inc(Zakup,ost*base.price)
          end;
    until nn=0;
  end;
begin
  if Key=#27 then
    case rg.ItemIndex of
      0 : exit;
      1 : edTovar.SetFocus;
      2 : edOpis.SetFocus;
    end;
  if key=#13 then
    begin
      SaleSize:=GetCBlist(cbSize);
      RefreshArr(Cart);
      SaleMaxCount:=0;
      Zakup:=0;
      case rg.ItemIndex of
        0 : ;
        1 : begin
              if cp.SaleCart=0 then
                begin
                  SelCart.clear;
                  if SaleSize=-1 then
                    with TNum[SaleTovar] do
                      for i:=ctrl.Nn0 to ctrl.NN-1 do
                        AddSelCart(nums[i])
                   else
                    if SaleSize>0 then
                      FindSelCart(SaleTovar,SaleSize)
                     else {=0}
                      begin
                        i:=1;
                        repeat
                          nn:=FindMatchList(Size,i,cbSize.Text);
                          if nn<>0 then
                            begin
                              FindSelCart(SaleTovar,nn);
                              i:=nn+1;
                            end;
                        until nn=0;
                      end;
                end;
              if SaleMaxCount>0 then
                begin
                  if SelCart.NN=1 then
                    begin
                      cp.SaleCart:=SelCart.selca[0];
                      FillCartSale
                    end
                   else
                    begin
                      if SelCart.ShowModal=mrOk then
                        begin
                          cp.SaleCart:=SelCart.selca[SelCart.sg.Row-1];
                          with C[cp.SaleCart].state.rec do
                            begin
                              SaleMaxCount:=ost;
                              Zakup:=base.price;
                            end;
                          FillCartSale
                        end;
                    end;
                end
            end;
        2 : with SelTov do
              with SIA do
                if SaleSize=-1 then
                  begin
                    with A[Cart].info do
                      with TNum[SaleTovar] do
                        for ic:=0 to ctrl.NN-1 do
                          if nums[ic]>=First{CART} then
                            with C[nums[ic]].state.rec do
                              begin
                                inc(SaleMaxCount,ost);
                                inc(Zakup,base.price*ost)
                              end;
                  end
                 else
                  begin
                    i1:=TNum[SaleTovar].ctrl.Nn0;
                    if SaleSize=0 then
                     begin
                       ic:=FindMatchList(Size,1,cbSize.Text);
                       while ic>0 do
                         begin
                           i2:=LNum[Size][ic].ctrl.Nn0;
                           incMax(ic);
                           ic:=FindMatchList(Size,ic+1,cbSize.Text)
                         end
                     end
                    else
                     begin
                       i2:=LNum[Size][SaleSize].ctrl.Nn0;
                       incMax(SaleSize)
                     end;
                  end
      end;
      if SaleMaxCount>0 then
        begin
          edKol.Enabled:=true;
          edPrice.Enabled:=true;
          EnterSum.Enabled:=true;
          edKol.SetFocus;
        end
       else
        ShowMessage('??? ?????????? ??? ??? ??????');
    end;
end;

procedure TChequePosition.FreshButClick(Sender: TObject);
begin
  if RefreshList(Tip) then LoadCB(cbTip,Tip);
  if RefreshList(Mat) then LoadCB(cbMat,Mat);
  if RefreshList(Firm) then LoadCB(cbFirm,Firm);
  if RefreshList(Size) then LoadCB(cbSize,Size);
  RefreshArr(Tovar);
  RefreshArr(Cart);
  if AfterFresh<>nil then
    begin
      AfterFresh.SetFocus;
      AfterFresh:=nil;
    end;
end;

procedure TChequePosition.cbTipKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then
    if cbTip.Text='' then
      ModalResult:=mrCancel
     else
      cbTip.ItemIndex:=-1;
  if key=#13 then cbMat.SetFocus
end;

procedure TChequePosition.cbMatKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then cbTip.SetFocus;
  if (key=#13) then cbFirm.SetFocus
end;

procedure TChequePosition.cbFirmKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then cbMat.SetFocus;
  if (key=#13) then edArt.SetFocus
end;

procedure TChequePosition.edArtKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then cbFirm.SetFocus;
  if (key=#13) then edOpis.SetFocus
end;

procedure TChequePosition.edOpisKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then edArt.SetFocus;
  if (key=#13) then cbSize.SetFocus;
end;

procedure TChequePosition.edKolKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then
    if edKol.Text='' then
      cbSize.SetFocus
     else
      edKol.Text:='';
  if noZifrFiltr(key) then exit;
  if key=#13 then
    begin
      cp.SaleCount:=StrToIntDef(edKol.Text,0);
      if cp.SaleCount>0 then
        begin
          RefreshArr(Cart);
          if cp.SaleCart>0 then SaleMaxCount:=C[cp.SaleCart].state.rec.ost;
          if (SaleSize=0)and (cp.SaleCount<>SaleMaxCount)then
            edKol.Text:=inttostr(SaleMaxCount)
           else
              if cp.SaleCount>SaleMaxCount then
                begin
                  edKol.Text:=inttostr(SaleMaxCount);
                  edKol.SelectAll;
                end
               else
                begin
                  edPrice.Enabled:=true;
                  EnterSum.Enabled:=true;
                  edPrice.SetFocus;
                end
        end
       else
        edKol.SelectAll;
    end;
end;

procedure TChequePosition.edPriceKeyPress(Sender: TObject; var Key: Char);
begin
  if noZifrFiltr(key) then exit;
  if key=#27 then
    if edPrice.Text='' then
      edKol.SetFocus
     else
      edPrice.Text:='';
  if key=#13 then
    if edPrice.Text<>'' then
      begin
        btNext.Enabled:=true;
        btNext.SetFocus;
      end
  {  begin
      cp.SalePrice:=StrTointDef(edPrice.Text,-1);
      if cp.SalePrice>0 then
        begin
          btNext.Enabled:=true;
          btNext.SetFocus;
        end
       else
        edPrice.SelectAll;
    end}
end;

procedure TChequePosition.btNextClick(Sender: TObject);
begin
  ModalResult:=mrOk
end;

procedure TChequePosition.FormShow(Sender: TObject);
begin
  rg.SetFocus;
  case rg.ItemIndex of
    0 : ;
    1 : edCart.SetFocus;
    2 : cbTip.SetFocus;
  end;
end;

procedure TChequePosition.rgEnter(Sender: TObject);
begin
{  RefreshArr(Tovar);}
  edKol.Text:='';
  edPrice.Text:='';
  edKol.Enabled:=false;
  edPrice.Enabled:=false;
  EnterSum.Enabled:=false;
end;

procedure TChequePosition.cbSizeEnter(Sender: TObject);
var
  ti,iti,ma,ima,fi,ifi,tov :integer;
begin
  case rg.ItemIndex of
    0 : ;
    1 :
        {if wayCartCod then
          begin
            FillCartSale;
            if not edKol.Enabled then
              edCart.SetFocus;
            wayCartCod:=false;
          end};
    2 :if SaleTovar=0 then
        if (rg.ItemIndex=2)and(cbTip.Text='')and(cbMat.Text='')and(cbFirm.Text='')and
           (edArt.Text='')and(edOpis.Text='') then
          begin
            showmessage('?? ???? ???-??????');
            cbTip.SetFocus;
          end
         else
          begin
            SelTov.clear;
            RefreshArr(Tovar);
            ti:=GetCBlist(cbTip);
            ma:=GetCBlist(cbMat);
            fi:=GetCBlist(cbFirm);
            if ti=0 then iti:=FindMatchList(Tip,1,cbTip.Text)
             else iti:=ti;
            while iti<>0 do
              begin
                if ma=0 then ima:=FindMatchList(Mat,1,cbMat.Text)
                 else ima:=ma;
                while ima<>0 do
                  begin
                    if fi=0 then ifi:=FindMatchList(Firm,1,cbFirm.Text)
                     else ifi:=fi;
                    while ifi<>0 do
                      begin
                        tov:=0;
                        repeat
                          tov:=FindMatchTovar(tov+1,iti,ima,ifi,edArt.Text,edOpis.Text);
                          if tov>0 then SelTov.add(tov);
                        until tov=0;
                        if fi=0 then ifi:=FindMatchList(Firm,ifi+1,cbFirm.Text)
                         else ifi:=0;
                      end;
                    if ma=0 then ima:=FindMatchList(Mat,ima+1,cbMat.Text)
                     else ima:=0;
                  end;
                if ti=0 then iti:=FindMatchList(Tip,iti+1,cbTip.Text)
                 else iti:=0;
              end;
            with SelTov do
              with SIA do
                if N=0 then
                  begin
                    ShowMessage('??? ??????');
                    cbTip.SetFocus;
                  end
                 else
                  begin
                    if N=1 then
                      SaleTovar:=STA[0]
                     else
                      if SelTov.ShowModal=mrOk then
                        SaleTovar:=strtoint(TG.cells[1,TG.Row])
                       else
                        SaleTovar:=0;
                    FillSaleTovar;
                  end
          end;
  end;
end;
{       else
        begin
          if SelTov.ShowModal=mrOk then
            begin
              edTovar.Text:=SelTov.TG.cells[1,SelTov.TG.Row];
              SaleTovar:=StrToInt(edTovar.Text);
              FillSaleTovar;
              exit
            end;
          cbTip.SetFocus;
          SaleTovar:=0;
        end;
    end
else
    if SaleTovar=0 then
        if (edCart.Text='') then
          begin
            SaleCart:=0;
            if edTovar.Text='' then
              edCart.SetFocus
             else
              begin
                SaleTovar:=StrToIntDef(edTovar.Text,0);
                if (SaleTovar<1)or(SaleTovar>A[Tovar].N) then
                  edTovar.SetFocus;
              end
          end
         else
          begin
            SaleCart:=StrToIntDef(edCart.Text,0);
            if SaleCart>0 then
              begin
                RefreshArr(Cart);
                if SaleCart>A[Cart].N then
                  edCart.SetFocus
                 else
                  FillCartSale;
              end
             else
              edCart.SetFocus
          end
end;

function TChequePosition.CheckTovarSize:boolean;
var
  i,j,xx,nn,ss:integer;
begin
  RefreshArr(Cart);
  setlength(SCarts,0);
  SaleMaxCount:=0;
  if SaleTovar<>0 then
    nn:=SelectSaleCart(SaleTovar)
   else
    with SelTov.SIA do
      begin
        i:=0;
        nn:=0;
        repeat
          ss:=SelectSaleCart(STA[i]);
          inc(nn,ss);
    {      if ss=0 then
            DelInt(i)
           else
            inc(i);
        until i>=N;
      end;
  Result:=nn>0;
  if nn=0 then exit;
  if nn=1 then
    begin
      cp.SaleCart:=SCarts[0];
      ss:=C[SCarts[0]].state.rec.base.siz-1;
      cbSize.ItemIndex:=ss;
      if SaleSize<>0 then
        begin
          cbSize.SetFocus;
          cbSize.SelectAll;
        end;
      SaleSize:=ss+1;
      if SaleTovar=0 then
        begin
          SaleTovar:=C[Scarts[0]].state.rec.base.tov;
          edTovar.Text:=inttostr(SaleTovar);
        end;
      exit
    end;
  if (SaleSize=0)and(nn>1) then
    begin
      ss:=C[Scarts[0]].state.rec.base.siz;
      j:=-1;
      for i:=1 to nn-1 do
        if ss<>C[SCarts[i]].state.rec.base.siz then
          begin
            j:=i;
            break
          end;
      if j=-1 then
        begin
          SaleSize:=ss;
          cbSize.ItemIndex:=ss-1;
        end;
    end;
  if (SaleTovar=0) then
    with SelTov.SIA do
      if N=1 then
        SaleTovar:=STA[0]
       else
        begin
          {sort tovar by tip
          for i:=0 to N-2 do
            begin
              ss:=i+1;
              for j:=i+2 to N-1 do
                if T[STA[j]].state.rec.tip<T[STA[ss]].state.rec.tip then
                  ss:=j;
              if T[STA[i]].state.rec.tip>T[STA[ss]].state.rec.tip then
                begin
                  xx:=STA[i];
                  STA[i]:=STA[ss];
                  STA[ss]:=xx;
                end;
            end;
          {fill table
          SelTov.TG.RowCount:=N+1;
          for i:=1 to N do
            with T[STA[i]].state do
              with SelTov.TG do
                begin
                  Cells[0,i]:=inttostr(i);
                  Cells[1,i]:=inttostr(STA[i]);
                  Cells[2,i]:=Lstat[Tip][rec.tip].rec.pos.nam;
                  Cells[3,i]:=Lstat[Mat][rec.mat].rec.pos.nam;
                  Cells[4,i]:=Lstat[Firm][rec.firm].rec.pos.nam;
                  Cells[5,i]:=rec.art;
                  Cells[6,i]:=rec.opis;
                end;
          if SelTov.ShowModal=mrOk then  {select one tovar
            begin
              SaleTovar:=STA[SelTov.TG.Row-1];
              i:=0;
              while i<nn do
                with C[SCarts[i]].state.rec do
                  if base.tov<>SaleTovar then
                    begin
                      dec(SaleMaxCount,ost);
                      if i<>(nn-1) then
                        Scarts[i]:=Scarts[nn-1];
                      dec(nn)
                    end
                   else
                    inc(i);
              setlength(SCarts,nn);
              if nn=1 then
                begin
                  cp.SaleCart:=SCarts[0];
                  SaleSize:=C[SCarts[0]].state.rec.base.siz;
                end
            end
           else
            begin
              Retry;
              Result:=false;
              exit
            end;
        end;
end;
}
procedure TChequePosition.btNextEnter(Sender: TObject);
begin
  if (SaleMaxCount<=0)or(SaleTovar<=0)or(cp.SalePrice<=0)then Retry;
  if cp.SaleCount<1 then
    begin
      edKol.SetFocus;
      exit
    end;
  if (cp.SaleCount>SaleMaxCount)or((SaleSize=0)and(SaleMaxCount<>cp.SaleCount))then
    begin
      edKol.Text:=inttostr(SaleMaxCount);
      edKol.SetFocus;
      exit
    end;
  if EnterSum.Checked then
    begin
      cp.SaleSum:=cp.SalePrice;
      if (cp.SaleSum mod cp.SaleCount)<>0 then
        begin
          showmessage('??? ?? ??????????? ??? ???????');
          edKol.SetFocus;
          exit
        end;
      {divinto}
      cp.SalePrice:=cp.SaleSum div cp.SaleCount;
    end
   else
    begin
      cp.SaleSum:=cp.SaleCount*cp.SalePrice;
      if (cp.SaleSum<=Zakup) then
        begin
          ShowMessage('????? ??????');
          edPrice.SetFocus;
          exit
        end
    end;
  if cp.SaleCart>0 then
    with C[cp.SaleCart].state.rec do
      begin
        if ost<cp.SaleCount then
          begin
            edKol.Text:=inttostr(ost);
            edKol.SetFocus;
            exit;
          end;
        if base.price>cp.SalePrice then
          begin
            edPrice.SelectAll;
            edPrice.SetFocus;
            exit
          end;
      end
   else
    begin
{      nn:=length(SCarts);
      if nn=0 then
        begin
          Retry;
          exit
        end;
      SortInt(Scarts);
      su:=0;
      kol:=0;
      SaleCartCount:=0;
      for i:=0 to nn-1 do
        with C[Scarts[i]].state.rec do
          begin
            inc(kol,ost);
            inc(SaleCartCount);
            if kol>cp.SaleCount then
              begin
                inc(su,(cp.SaleCount+ost-kol)*base.price);
                break
              end
             else
              inc(su,ost*base.price);
          end;
      if kol<cp.SaleCount then
        begin
          SaleMaxCount:=kol;
          edKol.Text:=inttostr(kol);
          edKol.SetFocus;
          exit
        end;
      if su>SaleSum then
        begin
          edPrice.SetFocus;
          exit
        end
       else
        if SaleSum=su then
          begin
            if MessageDLg('???? ???????????',mtConfirmation,[mbyes,mbno],0)=mrNo then
              Retry
             else
              SalePercent:=100;
          end
         else
          SalePercent:=(100*SaleSum)div su;
}    end;
end;

procedure TChequePosition.btNextExit(Sender: TObject);
begin
  btNext.Enabled:=false;
end;

procedure TChequePosition.edCartExit(Sender: TObject);
begin
//  if ChequePosition.ActiveControl=rg as TWinControl then exit;
  cp.SaleCart:=StrToIntDef(edCart.Text,0);
  if ChequePosition.ActiveControl=FreshBut as TwinControl{FreshBut} then
    begin
      AfterFresh:=edCart;
      exit;
    end;
  if edCart.Text='' then
    begin
      if (ChequePosition.ActiveControl<>edTovar as TwinControl)and
         (ChequePosition.ActiveControl<>rg as TwinControl)and
         (ChequePosition.ActiveControl<>FreshBut as TwinControl) then
        edCart.SetFocus;
      wayCartCod:=false;
    end
   else
    if CheckArrRange(Cart,cp.SaleCart) then
      FillCartSale
     else
      begin
        ShowMessage('???????? ????? ????????');
        wayCartCod:=false;
        edCart.SetFocus;
      end;
end;

procedure TChequePosition.edTovarExit(Sender: TObject);
begin
//  if ChequePosition.ActiveControl=rg as TWinControl then exit;
  SaleTovar:=StrToIntDef(edTovar.Text,0);
  if ChequePosition.ActiveControl=FreshBut as TWinControl  then
    begin
      AfterFresh:=edTovar;
      exit;
    end;
  if edTovar.Text='' then
    begin
      if cp.SaleCart<>0 then
        begin
          SaleTovar:=C[cp.SaleCart].state.rec.base.tov;
          FillSaleTovar;
          exit
        end;
      if (ChequePosition.ActiveControl<>edCart as TwinControl)and
         (ChequePosition.ActiveControl<>rg as TwinControl)and
         (ChequePosition.ActiveControl<>FreshBut as TwinControl) then
        edTovar.SetFocus;
      exit
    end
   else
    if (cp.SaleCart>0) and (C[cp.SaleCart].state.rec.base.tov<>SaleTovar) then
      SaleTovar:=C[cp.SaleCart].state.rec.base.tov;
  if CheckArrRange(Tovar,SaleTovar) then
    FillSaleTovar
   else
    begin
      ShowMessage('???????? ????? ??????');
      edCart.SetFocus
    end
end;

procedure TChequePosition.edPriceExit(Sender: TObject);
begin
  cp.SalePrice:=StrToIntDef(edPrice.Text,-1);
  if cp.SalePrice<=0 then edPrice.SetFocus;
end;

procedure TChequePosition.edPriceEnter(Sender: TObject);
begin
  if (SaleMaxCount<=0)or(SaleTovar<=0)then Retry;
end;

procedure TChequePosition.EnterSumClick(Sender: TObject);
begin
  if EnterSum.Checked then
    edPrice.EditLabel.Caption:='?????'
   else
    edPrice.EditLabel.Caption:='????';
  edPrice.SetFocus;
end;

procedure TChequePosition.cbSizeChange(Sender: TObject);
begin
  case rg.ItemIndex of
    0 : ;
    1 : if cp.SaleCart<>0 then
          begin
            edCart.Text:='';
            cp.SaleCart:=0;
          end;
    2 : ;
  end;
end;


procedure TChequePosition.cbSizeExit(Sender: TObject);
var
  ss:integer;
begin
  ss:=cbSize.ItemIndex+1;
  if (rg.ItemIndex=1)and(cp.SaleCart>0)and(ss<>SaleSize) then
    cbSize.SetFocus
   else
    SaleSize:=ss;
  cbSize.Text:=cbSize.Items[SaleSize-1];
end;

procedure TChequePosition.edKolExit(Sender: TObject);
begin
  if ChequePosition.ActiveControl<>edPrice as TWinControl then
    begin
      edKol.Enabled:=false;
      edPrice.Enabled:=false;
      EnterSum.Enabled:=false;
    end
end;

procedure TChequePosition.cbTipChange(Sender: TObject);
begin
  SaleTovar:=0;
end;

procedure TChequePosition.cbMatChange(Sender: TObject);
begin
  SaleTovar:=0;
end;

procedure TChequePosition.cbFirmChange(Sender: TObject);
begin
  SaleTovar:=0;
end;

procedure TChequePosition.edArtChange(Sender: TObject);
begin
  SaleTovar:=0;
end;

procedure TChequePosition.edOpisChange(Sender: TObject);
begin
  SaleTovar:=0;
end;

end.
