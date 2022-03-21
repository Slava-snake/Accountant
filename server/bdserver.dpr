program bdserver;

uses
  Forms,
  clients_ in 'clients_.pas' {FormClient},
  data in 'data.pas',
  nums in 'nums.pas',
  arrs in 'arrs.pas',
  lists in 'lists.pas',
  cats in 'cats.pas',
  kass in 'kass.pas', 
  server in 'server.pas' {Form1} ,
  Atypes in 'E:\work\accountant\Atypes.pas';
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormClient, FormClient);
  Application.Run;
end.

