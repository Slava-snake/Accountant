unit client;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  StdCtrls, Sockets, FileCtrl, Grids, ComCtrls{, BDconnect};

const
  ServerPort = 8888;

  BDfile    = 'bd.cnt';
  OperFile  = 'BDclient.cnt';

  rashodFile= 'rashod.cnt';
  prihodFile= 'prihod.cnt';
  cartFile  = 'carts.cnt';
  numFile   = 'nums.cnt';
  tovarFile = 'tovar.cnt';
  listsFile = 'lists.cnt';
  tipFile   = 'type.cnt';
  matFile   = 'material.cnt';
  firmFile  = 'firm.cnt';
  sizeFile  = 'size.cnt';
  agentFile = 'agent.cnt';
  groupFile = 'group.cnt';

  agentDir = 'Agents';
  firmDir  = 'Firms';
  tipDir   = 'Types';
  matDir   = 'Material';
  sizeDir  = 'Sizes';
  prihDir  = 'Prihod';
  rashDir  = 'Rashod';
  tradeDir = 'Trade';
  tovarDir = 'Tovars';

  user = 'resu';
  pass = 'ssap';

type
  tNam  = string[31];            {32}
  tArt  = string[11];            {12}
  tOpis = string[47];            {48}
  tTim  = string[8]; {00:00:00}  {9}
  tDat  = string[10];{0000.00.00}{11}
  tFileNam = string[12];{filename.ext} {13}
  tArrCar = array of cardinal;
  tOperRec =record
      login   : tnam;
      name    : tOpis;
      dolg    : tnam;
      rights  : cardinal;
    end;
  tuser  = array[0..255]of byte;

  TForm1 = class(TForm)
    TCPc: TIdTCPClient;
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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TCPcConnected(Sender: TObject);
    procedure TCPcDisconnected(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function EditConnect:boolean;
    procedure PcreatClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1      : TForm1;
  ii:integer;
  Nserver    : integer = 0;
  OnLine     : boolean = false;
  Oper       : byte =255;
  wc,CLname,BDdir,BDname : string ;
  BDtime,delta: tDateTime;
{  A       : array [low(arr)..high(arr)] of tArr;
  T       : array of tTov;
  C       : array of tCart;
  P       : array of tPrih;
  R       : array of tRash;
  L       : array [low(list)..high(list)] of tList;
  listfile: array [low(list)..high(list)] of tFileNam=(tipFile,matFile,firmFile,sizeFile,agentFile);
}
implementation

uses BDconnect,PrihNak, login_;


{$R *.dfm}

function TForm1.EditConnect:boolean;
var
  f:textfile;
  s:string;
begin
  form2.label1.Caption:=BDname;
  form2.Edit1.Text:=TCPc.Host;
  form2.Edit2.Text:=inttostr(TCPc.Port);
  form2.Edit3.Text:=CLname;
  if form2.ShowModal=mrOk then
    begin
      while not SelectDirectory(BDdir,[sdAllowCreate, sdPerformCreate, sdPrompt],0) do;
      assignfile(f,wc+'\'+BDfile);
      rewrite(f);
      s:=form2.Edit3.Text; {client}
      writeln(f,s);
      s:=form2.Edit1.Text; {host}
      writeln(f,s);
      s:=form2.Edit2.Text; {port}
      writeln(f,s);
      s:=form2.Label1.Caption; {BDname}
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
  PG.Cells[0,0]:='дата';
  PG.Cells[1,0]:='номер';
  PG.Cells[2,0]:='сумма';
  PG.Cells[3,0]:='поставщик';
end;

procedure CodeUser(var n:tUser; var us,pa:string);
  var
    i,lu,lp:integer;
  begin
    lu:=length(us);
    lp:=length(pa);
    for i:=0 to 254 do
      n[i]:=ord(user[(i div 2) mod 4+1])xor ord(us[(i div 2)mod lu+1])
            xor ord(pass[(i div 2) mod 4+1])xor ord(pa[(i div 2)mod lp+1]);
  end;


function AddOper(var us,pa:string):byte;
  var
    f: file of tUser;
    n: tUser;
  begin
    assignfile(f,OperFile);
    reset(f);
    result:=filesize(f);
    seek(f,result);
    CodeUser(n,us,pa);
    write(f,n);
    closefile(f);
  end;

function SelectOper(var us,pa:string):byte;
  var
    f: file of tUser;
    n,z: tUser;
    i:integer;
    match:boolean;
  begin
    assignfile(f,OperFile);
    reset(f);
    result:=255;
    CodeUser(z,us,pa);
    while not eof(f) do
      begin
        read(f,n);
        match:=true;
        for i:=0 to 255 do
          if n[i]<>z[i] then
            begin
              match:=false;
              break;
            end;
        if match then
          begin
            Result:=filepos(f)-1;
            break
          end;
      end;
    closefile(f);
  end;

procedure TForm1.FormActivate(Sender: TObject);
  var
    ft:textfile;
    f :file of byte;
    s:string;
begin
  if Oper=255 then
    begin
      if Login.ShowModal=mrCancel then exit;
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
      if not EditConnect then
        exit
    end
   else
    closefile(f);
  if TCPc.Connected then exit;
  assignfile(ft,BDfile);
  reset(ft);
  readln(ft,CLname);            {client}
  form1.Caption:=CLname+' -> ';
  readln(ft,s);                 {host}
  TCPc.Host:=s;
  readln(ft,s);                 {port}
  Nserver:=strtoint(s);
  TCPc.Port:=Nserver+Serverport;
  readln(ft,BDname);             {BDname}
  readln(ft,BDdir);              {BDdir}
  closefile(ft);
  form1.Caption:=CLname;
  TCPc.Connect(1000);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TCPc.Disconnect;
end;

procedure TForm1.TCPcConnected(Sender: TObject);
var
  s:string;
begin
  s:=TCPc.ReadLn;
  TCPc.WriteLn(CLname);
  if (Oper=255) and (Login.ShowModal<>mrOk) then
    begin
      TCPc.Disconnect;
      exit
    end;
  TCPc.WriteSmallInt(Oper);
  TCPc.WriteLn(username);
  if BDname=s then
    begin
      form1.Caption:=form1.Caption+' -> '+'['+inttostr(Nserver)+'] - '+BDname;
      TCPc.WriteLn('T');
      delta:=Now;
      TCPc.Readbuffer(BDtime,8);
      delta:=BDtime-delta;
      button1.Font.Color:=clGreen;
      button1.Caption:='+';
      Online:=true;
      StatusBar1.Color:=clGreen;
      StatusBar1.SimpleText:=UserName;
{  ********** synchronize ************  }
    end
   else
    begin
      showmessage('Error BD');
      TCPc.Disconnect;
    end;
end;

procedure TForm1.TCPcDisconnected(Sender: TObject);
begin
  button1.Font.Color:=clRed;
  button1.Caption:='O';
  StatusBar1.Color:=clMaroon;
  StatusBar1.SimpleText:='';
 { UserName:=''; }
  Form1.Caption:=CLname;
end;

function IntToArt(n:integer):tArt;
  begin
    Result:=format('%9.9d',[n]);
  end;

procedure TForm1.PcreatClick(Sender: TObject);
var
  n:integer;
begin
  TCPc.WriteLn('AAP');
  n:=TCPc.ReadInteger;
  PrihNakl.num.Caption:=InttoArt(n);
  PrihNakl.Show;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if tcpc.Connected then
    begin
      tcpc.Disconnect;
      exit
    end;
  if not Online and ((Oper<>255)or(Login.ShowModal=mrOk)) then
    begin
      Oper:=SelectOper(UserName,Password);
      if Oper<>255 then
        begin
          tcpc.Connect;
          PageControl1.Visible:=true
        end;
    end;
end;

end.
