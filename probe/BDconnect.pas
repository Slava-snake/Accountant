unit BDconnect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  StdCtrls;

const
  ServerPort = 8888;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    conn: TButton;
    Save: TButton;
    Cancel: TButton;
    Label1: TLabel;
    C1: TIdTCPClient;
    Edit3: TEdit;
    Label2: TLabel;
    procedure connClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    nam  :string;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.connClick(Sender: TObject);
var
  cur:tCursor;
begin
  c1.Host:=edit1.Text;
  c1.Port:=ServerPort+strtoint(edit2.Text);
  cur:=form2.Cursor;
  form2.Cursor:=crHourGlass;
  try
    c1.Connect(2000);
  finally
    form2.Cursor:=cur;
  end;
  if c1.Connected then
    begin
      label1.Caption:=c1.ReadLn;
      c1.WriteLn(Edit3.Text);
      save.SetFocus;
      c1.Disconnect
    end
   else
    label1.Caption:=''
end;

procedure TForm2.SaveClick(Sender: TObject);
begin
  if edit3.Text<>'' then
    form2.ModalResult:=mrOk
   else Edit3.SetFocus;
end;

procedure TForm2.CancelClick(Sender: TObject);
begin
  form2.ModalResult:=mrCancel;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then Edit2.SetFocus
end;

procedure TForm2.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then conn.SetFocus;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
  edit3.SetFocus;
end;

procedure TForm2.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13) and (text<>'') then edit1.SetFocus;
end;

end.
