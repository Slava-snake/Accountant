unit login_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient,Atypes;

const
  ServerPort = 8888;

type
  TConServ = class(TForm)
    c1: TIdTCPClient;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure c1Connected(Sender: TObject);
    procedure c1Disconnected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  ConServ: TConServ;
  Online : boolean=false;
  CLname,BDdir,BDname,BDnum : string ;
  BDtime,delta:tDatTim;
  CLnum : integer;
  KassOper:Smallint=0;
  KassUser:string='paymaster';

implementation

uses KASSAinterface,KassaBD;

{$R *.dfm}

procedure TConServ.c1Connected(Sender: TObject);
var
  s:string;
begin
  s:=c1.ReadLn;  {}
  c1.WriteLn(CLname);
  if (KassOper=-1) {and (Login.ShowModal<>mrOk)} then
    begin
      c1.Disconnect;
      exit
    end;
  c1.WriteSmallInt(KassOper);
  c1.WriteLn(KassUser);
  if BDname=s then
    begin
      CLnum:=c1.ReadInteger;
      qp.sl[0]:='T';
      c1.WriteBuffer(qp,sizeofqp,true);
      delta:=TimeNow;
      c1.Readbuffer(BDtime,8);
      delta.t64:=BDtime.t64-delta.t64;
      Online:=true;
      Form1.Caption:=Form1.Caption+' №'+inttostr(CLnum)+'  закрыта';       
    end
   else
    begin
      showmessage('Error BD connect');
      c1.Disconnect;
    end;

end;

procedure TConServ.c1Disconnected(Sender: TObject);
begin
  if not c1.Connected then
    OnLine:=false;
{  Form1.Caption:='Касса';     }
end;

end.
