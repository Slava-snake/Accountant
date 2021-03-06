unit CatSel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BDconnect, Menus, Atypes;

type
  TMyTreeView = class(TTreeView)
  published
    property OnCancelEdit;
    property OnKeyPress;
  end;
  Tcatselect = class(TForm)
    TreeTip: TTreeView;
    CatGroup: TRadioGroup;
    TreeMat: TTreeView;
    TreeFirm: TTreeView;
    TreeSize: TTreeView;
    TreeAgent: TTreeView;
    CatMenu: TPopupMenu;
    CatAddNode: TMenuItem;
    CatAddLeaf: TMenuItem;
    N1: TMenuItem;
    LastChange: TLabel;
    procedure CatGroupClick(Sender: TObject);
    procedure CatAddNodeClick(Sender: TObject);
    procedure tvCancelEdit(Sender: TObject; Node: TTreeNode);
    procedure TVEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure CatAddLeafClick(Sender: TObject);
    procedure TVEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TVExit(Sender: TObject);
    procedure TvCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure RenameItem(Sender: TObject);
    procedure TVkeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    caMode:integer;
    procedure FreshChange(ca:integer);
    procedure TreeWay(uz:integer);
  public
    { Public declarations }
    TreeCat:array[Tip..Agent]of tMyTreeView;
    TV : TmyTreeView;
    function ParentNode(no:integer):TTreeNode;
    function Add2node(no:integer):TTreeNode;
    procedure SetCat(ca:integer);
    procedure SetCatMode(mo:integer);
    procedure SelectChildren(node:TTreeNode);
  end;

var
  catselect: Tcatselect;
  popmen   : tPopupMenu;

 function SelectNode(ca:integer; const CanModify:boolean=false):integer;
 {function MultiSelect(ca:integer):integer;}

implementation

{$R *.dfm}
procedure Tcatselect.SetCatMode(mo:integer);
begin
  case mo of
    {view only}        0:begin
                           CatGroup.Enabled:=true;
                           PopMen:=nil;
                           TV.ReadOnly:=true;
                           TV.MultiSelect:=false;
                           caMode:=-1;
                         end;
    {select only}      1:begin
                           CatGroup.Enabled:=false;
                           PopMen:=nil;
                           TV.ReadOnly:=true;
                           TV.MultiSelect:=false;
                           caMode:=-1;
                         end;
    {edit&select group}2:begin
                           CatGroup.Enabled:=false;
                           PopMen:=CatMenu;
                           TV.ReadOnly:=false;
                           TV.MultiSelect:=false;
                           caMode:=0;
                         end;
    {full edit}        3:begin
                           CatGroup.Enabled:=true;
                           PopMen:=CatMenu;
                           TV.ReadOnly:=false;
                           TV.MultiSelect:=false;
                           caMode:=0;
                         end;
    {Multiselect}      4:begin
                           CatGroup.Enabled:=false;
                           PopMen:=nil;
                           TV.ReadOnly:=true;
                           TV.MultiSelect:=true;
                           caMode:=4;
                         end
  end;
end;

  function tCatselect.ParentNode(no:integer):TTreeNode;
    begin
      with Cstat[Catgroup.ItemIndex][no] do
        begin
          if ViewNodeC=nil then
            viewnodeC:=Add2node(no);
          Result:=ViewnodeC;
        end;
    end;

  function tCatSelect.Add2node(no:integer):TTreeNode;
    begin
      with Cstat[CatGroup.ItemIndex][no] do
        begin
          if no=1 then
            ViewnodeC:=Tv.Items.AddChild(nil,rec.pos.nam)
           else
            viewnodeC:=TV.Items.AddChild(ParentNode(rec.pos.node),rec.pos.nam);
          viewnodeC.Data:=pointer(no);
          Result:=viewnodeC;
        end;
    end;

procedure tCatSelect.TreeWay(uz:integer);
 var
   i:integer;
begin
  with Cstat[catGroup.ItemIndex][uz] do
    if (viewnodeC=nil) then
      Add2Node(uz)
     else
      begin
        if prNam in prop then
          viewnodeC.Text:=rec.pos.nam;
        if prNode in prop then
          viewnodeC.MoveTo(ParentNode(rec.pos.node),naAddChild);
        prop:=[];
      end;
  with CatNNum[CatGroup.ItemIndex][uz] do
    for i:=0 to ctrl.NN-1  do TreeWay(nums[i]);
  with CatLnum[CatGroup.ItemIndex][uz] do
    begin
      for i:=0 to ctrl.NN-1 do
        with Lstat[CatGroup.ItemIndex][nums[i]] do
          if viewnodeL=nil then
            begin
              viewnodeL:=TV.Items.AddChild(ParentNode(rec.pos.node),rec.pos.nam);
              viewnodeL.Data:=pointer(-nums[i]);
             end
            else
             begin
               if prNam in prop then
                 viewnodeL.Text:=rec.pos.nam;
               if prNode in prop then
                 viewnodeL.MoveTo(ParentNode(rec.pos.node),naAddChild);
               prop:=[];
             end;
    end;
end;

procedure Tcatselect.FreshChange(ca:integer);
var
  ti:tDatTim;
begin
  ti.t64:=Cat[ca].info.changed.t64;
  if ti.t64<L[ca].info.changed.t64 then ti:=L[ca].info.changed;
  if ti.t64<>0 then LastChange.Caption:=DatTimTostr(ti)
   else LastChange.Caption:='';
end;

procedure Tcatselect.SetCat(ca:integer);
begin
  if CatGroup.ItemIndex<>ca then
    CatGroup.ItemIndex:=ca;
  TV:=TreeCat[ca];
  Tv.PopupMenu:=popmen;
  tv.BringToFront;
  ActiveControl:=tv;
  RefreshCat(ca);
  RefreshList(ca);
  FreshChange(ca);
  if Cat[ca].info.N>0 then
    TreeWay(1);
end;

function SelectNode(ca:integer; const CanModify:boolean=false):integer;
begin
  with catselect do
    begin
      if CanModify then
        SetCatMode(2)
       else
        SetCatMode(1);
      SetCat(ca);
      showmodal;
      if ModalResult=mrOk then
        Result:=integer(tv.Selected.Data)
       else
        Result:=0;
    end;
end;

procedure Tcatselect.CatGroupClick(Sender: TObject);
begin
  SetCat(CatGroup.ItemIndex);
end;

procedure Tcatselect.CatAddNodeClick(Sender: TObject);
  var
    nov:TTreeNode;
    nod:integer;
begin
  if TV.Items.Count=0 then
    begin
      nod:=AddCat(CatGroup.ItemIndex,0,'???');
      if nod<>0 then
        begin
          nov:=TV.Items.AddChildFirst(nil,'???');
          nov.Data:=pointer(nod);
          with Cstat[CatGroup.ItemIndex][nod] do
            begin
              viewnodeC:=nov;
              prop:=[];
            end;
          TV.Selected:=nov;
        end;
      exit
    end;
  if (TV.Selected<>nil)and(integer(TV.Selected.Data)>0) then
    begin
      tv.Font.Style:=[fsBold,fsItalic];
      nov:=TV.Items.AddChild(TV.Selected,'*****');
      nov.Selected:=true;
      caMode:=1;
      nov.EditText
    end;
end;

procedure Tcatselect.TVEdited(Sender: TObject; Node: TTreeNode; var S: String);
var
  num:integer;
begin
  if (caMode<0)or(node.AbsoluteIndex=0) then {root}
    begin
      S:=node.Text;
      exit
    end;
  case caMode of
     3 : begin
           num:=integer(node.Data);
           if num>0 then
             begin
               if not RenameCat(CatGroup.ItemIndex,num,S) then
                 S:=node.Text
                else
                 Cstat[CatGroup.ItemIndex][num].prop:=[];
             end
           else
             if not RenameList(CatGroup.ItemIndex,-num,S) then
               S:=node.Text
              else
               Lstat[CatGroup.ItemIndex][-num].prop:=[];
         end;
     1 : begin
           num:=AddCat(CatGroup.ItemIndex,integer(node.Parent.Data),S);
           if num<>0 then
             begin
               node.Data:=pointer(num);
               with Cstat[CatGroup.ItemIndex][num] do
                 begin
                   viewnodeC:=Node;
                   prop:=[];
                   Node.Selected:=true;
                 end
             end
            else node.Delete;
         end;
     2 : begin
           num:=AddList(CatGroup.ItemIndex,integer(node.Parent.Data),S);
           if num<>0 then
             begin
               node.Data:=pointer(-num);
               with Lstat[CatGroup.ItemIndex][num] do
                 begin
                   viewnodeL:=node;
                   prop:=[];
                   node.Parent.Selected:=true;
                 end
             end
            else node.Delete;
         end;
   else
    exit
  end;
  caMode:=0;
  FreshChange(CatGroup.ItemIndex);
  if rfrC>0 then
    begin
      treeWay(1);
      rfrC:=0;
      rfrL:=0;
    end;
end;

procedure Tcatselect.CatAddLeafClick(Sender: TObject);
var
  no:integer;
  nod:TTreeNode;
begin
  if TV.Selected=nil then exit;
  no:=integer(TV.Selected.Data);
  if no<0 then exit;
  if CatGroup.Enabled then {add list}
    begin
      tv.Font.Style:=[fsUnderline];
      nod:=TV.Items.AddChild(TV.Selected,'***');
      nod.Selected:=true;
      caMode:=2;
      nod.EditText;
    end
   else    {select}
    begin
      modalResult:=mrOk;
    end;
end;

procedure Tcatselect.TVEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
begin
  if (caMode<=0)or(node.AbsoluteIndex=0) then
    begin
      AllowEdit:=false;
      exit
    end;
end;

procedure Tcatselect.FormCreate(Sender: TObject);
var
  i:integer;
begin
  ActiveControl:=tv;
  for i:=Tip to Agent do
    begin
      TreeCat[i]:=tMyTreeView.Create(CatSelect);
      with TreeCat[i] do
        begin
          Parent:=CatSelect;
          OnCancelEdit:=TVCancelEdit;
          OnKeypress:=TVkeyPress;
          OnExit:=TVExit;
          OnCustomDrawItem:=TvCustomDrawItem;
          OnEdited:=TVedited;
          OnEditing:=TVEditing;
          Anchors:=[akLeft,akTop,akRight,akBottom];
          Left:=0;
          Top:=0;
          Width:=513;
          Height:=321;
        end;
    end;
  tv:=TreeCat[Tip];
end;

procedure Tcatselect.tvCancelEdit(Sender: TObject; Node: TTreeNode);
begin
  if node.Data=nil then node.Delete;
end;

procedure Tcatselect.TVExit(Sender: TObject);
 var
   S:string;
   nn:integer;
   cha:boolean;
begin
  if (caMode<=0)or(TV.Selected=nil) then exit;
  cha:=true;
  with TV.Selected do
    if (caMode=3) then
      begin
        nn:=integer(Data);
        if nn=0 then
          begin
            delete;
            exit
          end;
        if nn>0 then
          begin
            if Cstat[CatGroup.ItemIndex][nn].rec.pos.nam=Text then cha:=false;
          end
         else
          if Lstat[CatGroup.ItemIndex][-nn].rec.pos.nam=Text then cha:=false;
      end;
  if cha then
    begin
      S:=Text;
      TVEdited(Sender,TV.selected,S);
    end;
end;

procedure Tcatselect.TvCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  with TV.Canvas.Font do
    if (integer(node.Data)>0) then
      Style:=[fsBold,fsItalic]
     else
      Style:=[fsUnderline];
  DefaultDraw:=true;
end;

procedure Tcatselect.RenameItem(Sender: TObject);
begin
  if (TV.Selected<>nil)and(TV.Selected.AbsoluteIndex<>0) then
    with TV.Font do
      begin
        if integer(TV.Selected.Data)>0 then
          Style:=[fsBold,fsItalic]
         else
          Style:=[fsUnderline];
        caMode:=3;
        TV.Selected.EditText;
      end
end;

procedure Tcatselect.SelectChildren(node:TTreeNode);
var
  i:integer;
begin
  for i:=0 to node.Count-1 do
    if integer(node.Item[i].Data)>0 then
      SelectChildren(node.Item[i])
     else
      TV.Select(node.Item[i],[ssCtrl]);
end;

procedure Tcatselect.TVkeyPress(Sender: TObject; var Key: Char);
begin
  if (caMode=4) then
    case key of
      #13: if TV.Selected<>nil then
             begin
               if (integer(TV.Selected.Data)>0) then
                 begin
                   TV.Deselect(TV.Selected);
                   SelectChildren(TV.Selected);
                 end;
               ModalResult:=mrOk;
             end;
      #27: ModalResult:=mrCancel;
    end;
end;
{
procedure Tcatselect.TVkeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (caMode=4) then
    case key of
      13: if TV.Selected<>nil then ModalResult:=mrOk;
      27: ModalResult:=mrCancel;
    end;
end;

procedure Tcatselect.TVkeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (caMode=4) then
    case key of
      13: if TV.Selected<>nil then ModalResult:=mrOk;
      27: ModalResult:=mrCancel;
    end;
end;
       }
end.
