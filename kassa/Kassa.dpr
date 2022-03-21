program Kassa;

uses
  Forms,
  Atypes in '..\atypes.pas',
  login_ in 'login_.pas' {ConServ},
  KassaBD in 'KassaBD.pas',
  SelectTovar in 'SelectTovar.pas',
  CheqPos in 'CheqPos.pas' {ChequePosition},
  KASSAinterface in 'KASSAinterface.pas' {Form1},
  SelectCart in 'SelectCart.pas' {SelCart};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TConServ, ConServ);
  Application.CreateForm(TChequePosition, ChequePosition);
  Application.CreateForm(TSelTov, SelTov);
  Application.CreateForm(TSelCart, SelCart);
  Application.Run;
end.
