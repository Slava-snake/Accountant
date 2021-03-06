unit login_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
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
  Login: TLogin;
  UserName,Password:string;

implementation

{$R *.dfm}

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
