unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Ani,
  Firedac.Comp.Client, FireDAC.DApt, Data.DB;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_menu: TImage;
    Circle1: TCircle;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Layout6: TLayout;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Rectangle1: TRectangle;
    Image4: TImage;
    Rectangle2: TRectangle;
    Layout7: TLayout;
    Label8: TLabel;
    lbl_todos_lanc: TLabel;
    lv_lancamento: TListView;
    img_categoria: TImage;
    StyleBook1: TStyleBook;
    rect_menu: TRectangle;
    layout_principal: TLayout;
    AnimationMenu: TFloatAnimation;
    img_fechar_menu: TImage;
    layout_menu_cat: TLayout;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lbl_todos_lancClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_menuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AnimationMenuFinish(Sender: TObject);
    procedure AnimationMenuProcess(Sender: TObject);
    procedure img_fechar_menuClick(Sender: TObject);
    procedure layout_menu_catClick(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure ListarUltimosLancamentos;

    { Private declarations }
  public
    { Public declarations }

    procedure SetupLancamento(lv : TListView; Item: TListViewItem);
    procedure SetupCategoria(lv: TListView; Item: TListViewItem);

    procedure AddLancamento( listview : TListView;
                             id_lancamento, descricao, categoria: string;
                             valor: double;
                             dt: TDateTime;
                             foto: TStream);

    procedure AddCategoria( listview: TListView;
                            id_categoria,
                            categoria: string;
                            foto: TStream);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitLancamentos, UnitCategorias, cLancamento, UnitDM, UnitLancamentosCad;

//***************** UNIT DE FUN��ES GLOBAIS *********************************

procedure TFrmPrincipal.AddLancamento( listview : TListView;
                                       id_lancamento, descricao, categoria : string;
                                       valor: double;
                                       dt: TDateTime;
                                       foto: TStream);
  var
    bmp : TBitmap;
begin
    with listview.Items.Add do
    begin

        TagString := id_lancamento;

        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtValor')).Text := FormatFloat('#,##0.00', valor);
        TListItemText(Objects.FindDrawable('TxtData')).Text := FormatDateTime('dd/mm', dt);

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := True;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := bmp;


            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := True;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := bmp;

        end;
    end;
end;

procedure TFrmPrincipal.AnimationMenuFinish(Sender: TObject);
begin
    img_menu.Visible := AnimationMenu.Inverse;
    layout_principal.Enabled := AnimationMenu.Inverse;
    AnimationMenu.Inverse := NOT animationmenu.Inverse;
end;

procedure TFrmPrincipal.AnimationMenuProcess(Sender: TObject);
begin
    layout_principal.Margins.Right := -260 - rect_menu.Margins.Left;
end;

procedure TFrmPrincipal.AddCategoria( listview : TListView;
                                      id_categoria,
                                      categoria : string;
                                      foto: TStream);
  var
    bmp : TBitmap;
begin
    with listview.Items.Add do
    begin
      //TagString pertence a FMX.ListView.Types ... (property TagString: string read FTagString write FTagString;)
      //e recebe a Tag do item da lista.
        TagString := id_categoria;
        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := True;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := bmp;
        end;
    end;
end;


procedure TFrmPrincipal.SetupLancamento(lv : TListView; Item : TListViewItem);
begin
   Item.Objects.FindDrawable('TxtDescricao').Width :=
   lv.Width - Item.Objects.FindDrawable('TxtDescricao').PlaceOffset.X - 100;
end;

procedure TFrmPrincipal.SetupCategoria(lv : TListView; Item : TListViewItem);
begin
   Item.Objects.FindDrawable('TxtCategoria').Width :=
   lv.Width - Item.Objects.FindDrawable('TxtCategoria').PlaceOffset.X - 100;
end;


//***************************************************************************
procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin

    if Assigned(Frmlancamentos) then
       begin
         Frmlancamentos.DisposeOf;
         Frmlancamentos := nil;
       end;

end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    rect_menu.Margins.Left := -260;
    rect_menu.Align := TAlignLayout.Left;
    rect_menu.Visible := True;
end;

procedure TFrmPrincipal.ListarUltimosLancamentos;
var
    foto : TStream;
    lanc : TLancamento;
    qry : TFDQuery;
    erro : string;
begin

    try
        lv_lancamento.Items.clear;
        lanc := TLancamento.Create(dm.conn);
        qry := lanc.ListarLancamento(0, erro);

        if  erro <> '' then
        begin
            MessageDlg(erro, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbNo], 0);
            Exit;
        end;

        while NOT qry.Eof do
        begin

         if qry.FieldByName('ICONE').AsString <> '' then
            foto := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
         else
            foto := nil;

            AddLancamento( lv_lancamento,
                           qry.FieldByName('ID_LANCAMENTO').AsString,
                           qry.FieldByName('DESCRICAO').AsString,
                           qry.FieldByName('DESCRICAO_CATEGORIA').AsString,
                           qry.FieldByName('VALOR').AsFloat,
                           qry.FieldByName('DATA').AsDateTime,
                           foto );
            qry.Next;
            foto.DisposeOf;
        end;

    finally
        lanc.DisposeOf;
    end;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarUltimosLancamentos;
end;

procedure TFrmPrincipal.Image4Click(Sender: TObject);
begin
if NOT Assigned(FrmLancamentosCad) then
           Application.CreateForm(TFrmLancamentosCad, FrmLancamentosCad);

           FrmLancamentosCad.modo := 'I';

           FrmLancamentosCad.ShowModal(procedure(ModalResult: TModalResult)
                  begin
                      ListarUltimosLancamentos;
                  end);
end;

procedure TFrmPrincipal.img_fechar_menuClick(Sender: TObject);
begin
    AnimationMenu.Start;
end;

procedure TFrmPrincipal.img_menuClick(Sender: TObject);
begin

    AnimationMenu.Start;

end;

procedure TFrmPrincipal.layout_menu_catClick(Sender: TObject);
begin

    AnimationMenu.Start;

    if NOT Assigned(FrmCategorias) then
           Application.CreateForm(TFrmCategorias, FrmCategorias);
           FrmCategorias.Show;
end;

procedure TFrmPrincipal.lbl_todos_lancClick(Sender: TObject);
begin
    if NOT Assigned(FrmLancamentos) then
           Application.CreateForm(TFrmLancamentos, FrmLancamentos);
           FrmLancamentos.show;
end;

procedure TFrmPrincipal.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmLancamentosCad) then
           Application.CreateForm(TFrmLancamentosCad, FrmLancamentosCad);

          FrmLancamentosCad.modo := 'A';
          FrmLancamentosCad.id_lanc := AItem.TagString.ToInteger();

    FrmLancamentosCad.ShowModal( procedure( ModalResult : TModalResult )
                                   begin
                                      ListarUltimosLancamentos;
                                   end);
end;

procedure TFrmPrincipal.lv_lancamentoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
 // var
 //   i : integer;
begin
  {  if lv_lancamento.Items.Count > 0 then

        if lv_lancamento.GetItemRect(lv_lancamento.items.Count - 2).Bottom <= lv_lancamento.Height then

            for i := lv_lancamento.items.Count + 1 to lv_lancamento.items.Count + 10 do

                AddLancamento(Self.lv_lancamento ,'0000' + IntToStr(i), 'Produto ' + IntToStr(i), 'Categoria ' + IntToStr(i), -50 , date, nil);
   }
end;

procedure TFrmPrincipal.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    SetupLancamento(FrmPrincipal.lv_lancamento, AItem);
end;

end.
