program BDclient;

uses
  Forms,
  client in 'client.pas' {Form1},
  BDconnect in 'BDconnect.pas' {Form2},
  PrihNak in 'PrihNak.pas' {Form3},
  login_ in 'login_.pas' {Login};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, PrihNakl);
  Application.CreateForm(TLogin, Login);
  Application.Run;
end.
