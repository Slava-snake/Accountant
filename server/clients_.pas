unit clients_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls,data, Atypes;

type
  tClientRec = record
    login   : tnam;
    name    : tOpis;
    addr    : string[255];
  end;

  tOperRec =record
    login   : tnam;
    name    : tOpis;
    dolg    : tnam;
    rights  : cardinal;
  end;

  tClient = record
    client : tClientRec;
    tim    : tDatTim;
    oper   : array of tOperRec;
  end;

  TFormClient = class(TForm)
    CLlist: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CLlistKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure EditMode;
    procedure SelectMode;
  public
    { Public declarations }
    EditClient: boolean ;
  end;

var
  FormClient  : TFormClient;
  Clients     : array[1..255] of Tclient;
  fileCL      : file of tClientRec;
  ClientCount : byte;

function IsClient(var Log:tNam):byte;
procedure WriteClient(i:integer);

implementation

{$R *.dfm}

function IsClient(var Log:tNam):byte;
  var
    i:integer;
  begin
    if ClientCount>0 then
      for i:=1 to ClientCount do
        if Clients[i].client.login=Log then
          begin
            if Clients[i].tim.t64<>0 then
              WriteLog('*** try another connect')
             else
              begin
                Result:=i;
                exit
              end
          end;
    Result:=0;
  end;

procedure WriteClient(i:integer);
  begin
    seek(fileCl,i-1);
    write(fileCL,Clients[i].client);
  end;

procedure TFormClient.EditMode;
begin
  CLlist.Options:=CLlist.Options-[goRowSelect]+[goEditing];
  CLlist.EditorMode:=true;
  CLlist.Col:=0;
end;

procedure TFormClient.SelectMode;
begin
  CLlist.Options:=CLlist.Options+[goRowSelect]-[goEditing];
  CLlist.EditorMode:=false;
  EditClient:=false;
end;

procedure TFormClient.Button2Click(Sender: TObject);
begin
  FormClient.Hide;
end;

procedure TFormClient.Button1Click(Sender: TObject);
begin
  CLlist.SetFocus;
  if ClientCount>0 then
    CLlist.RowCount:=CLlist.RowCount+1;
  CLlist.Row:=CLlist.RowCount-1;
  editMode;
end;

procedure TFormClient.CLlistKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13) and CLlist.EditorMode then
    begin
      if Cllist.Col=2 then
        begin
          if CLlist.Cells[0,CLlist.Row]='' then
            begin
              CLlist.Col:=0;
              exit;
            end;
          if EditClient then
            begin
              renamefile(ClientDir+Clients[CLlist.Row].client.login,ClientDir+CLlist.Cells[0,CLlist.Row]);
              WriteClient(CLlist.Row);
            end
           else
            begin
              inc(ClientCount);
              Createdir(clientDir+CLlist.Cells[0,CLlist.Row]);
              Clients[ClientCount].client.login:=CLlist.Cells[0,CLlist.Row];
              Clients[ClientCount].client.name:=CLlist.Cells[1,CLlist.Row];
              Clients[ClientCount].client.addr:=CLlist.Cells[2,CLlist.Row];
              WriteClient(ClientCount);
            end;
          SelectMode;
          exit
        end;
      CLlist.Col:=CLlist.Col+1;
    end;
  if key=#27 then
    begin
      if Clients[CLlist.Row].client.login='' then
        CLlist.RowCount :=CLlist.RowCount-1
       else
        begin
          CLlist.Cells[0,CLlist.Row]:=Clients[CLlist.Row].client.login;
          CLlist.Cells[1,CLlist.Row]:=Clients[CLlist.Row].client.name;
          CLlist.Cells[2,CLlist.Row]:=Clients[CLlist.Row].client.addr;
        end;
      SelectMode
    end;
end;

procedure TFormClient.FormCreate(Sender: TObject);
begin
  Cllist.Cells[0,0]:='LogIn';
  Cllist.Cells[1,0]:='описание';
  Cllist.Cells[2,0]:='адрес';
end;

end.
