program BDclient;

uses
  Forms,
  login_ in 'login_.pas' {Login},
  BDconnect in 'BDconnect.pas' {c1},
  TovarSel in 'TovarSel.pas' {TovarSelect},
  client in 'client.pas' {Form1},
  PrihNak in 'PrihNak.pas' {PrihNakl},
  CatSel in 'CatSel.pas' {catselect},
  goh in 'goh.pas' {goods},
  Atypes in 'E:\work\accountant\Atypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tc1, c1);
  Application.CreateForm(TPrihNakl, PrihNakl);
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TTovarSelect, TovarSelect);
  Application.CreateForm(Tcatselect, catselect);
  Application.CreateForm(Tgoods, goods);
  Application.Run;
end.
