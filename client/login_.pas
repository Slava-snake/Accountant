
unit login_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

const
  user1 = 'resu';
  pass1 = 'ssap';
  OperFile  = 'BDclient.cnt';

type
  tuser  = array[0..255]of byte;

  TLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    LogEdit: TEdit;
    PasEdit: TEdit;
    ButEnter: TButton;
    ButCancel: TButton;
    procedure LogEditKeyPress(Sender: TObject; var Key: Char);
    procedure PasEditKeyPress(Sender: TObject; var Key: Char);
    procedure ButCancelClick(Sender: TObject);
    procedure ButEnterClick(Sender: TObject);
    procedure PasEditEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Login    : TLogin;
  UserName : string='slava';
  Password : string='snake';
  Operator : byte =255;

procedure CodeUser(var n:tUser; var us,pa:string);
function AddOper(var us,pa:string):byte;
function SelectOper(var us,pa:string):byte;

implementation

{$R *.dfm}

procedure CodeUser(var n:tUser; var us,pa:string);
  var
    i,lu,lp:integer;
  begin
    lu:=length(us);
    lp:=length(pa);
    for i:=0 to 254 do
      n[i]:=ord(user1[(i div 2) mod 4+1])xor ord(us[(i div 2)mod lu+1])
            xor ord(pass1[(i div 2) mod 4+1])xor ord(pa[(i div 2)mod lp+1]);
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

procedure TLogin.LogEditKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then PasEdit.SetFocus;
  if Key=#27 then Login.ModalResult:=mrCancel;
end;

procedure TLogin.PasEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then ButEnter.SetFocus;
  if Key=#27 then Login.ModalResult:=mrCancel;
  if (Key=#8)and(length(password)>0) then
    setlength(password,length(password)-1);
  if (Key>=#32)and(Key<=#255) then
    begin
      Password:=Password+key;
      key:='*';
    end;
end;

procedure TLogin.ButCancelClick(Sender: TObject);
begin
  Login.ModalResult:=mrCancel;
end;

procedure TLogin.ButEnterClick(Sender: TObject);
begin
  if LogEdit.Text='' then
    begin
      LogEdit.SetFocus;
      exit;
    end;
  if PasEdit.Text='' then
    begin
      PasEdit.SetFocus;
      exit;
    end;
  LogEdit.SetFocus;
  username:=LogEdit.Text;
  Login.ModalResult:=mrOk;
end;

procedure TLogin.PasEditEnter(Sender: TObject);
begin
  PasEdit.Text:='';
  PassWord:='';
end;

end.
