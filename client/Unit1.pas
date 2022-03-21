unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

const
  ServerPort = 8888;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1  : TForm1;
  SIP    : string;
  Sport  : integer;
  Nserver: integer;
  BDname : string;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
  var
    f:textfile;
    s:string;
    b:byte;
begin
  assignfile(f,'server.cnt');
  reset(f);
  readln(f,s);
  b:=pos(':',s);
  SIP:=copy(s,1,b-1);
  Sport:=strtoint(copy(s,b+1,length(s)-b));
  readln(f,s);
  b:=pos('-',s);
  Nserver:=strtoint(copy(s,1,b-1));
  BDname:=copy(s,b+1,length(s)-b);
  closefile(f);
end;

end.
