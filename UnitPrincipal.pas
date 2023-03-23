unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

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
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lbl_todos_lancClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_menuClick(Sender: TObject);
  private

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

uses UnitLancamentos, UnitCategorias;

//***************** UNIT DE FUNÇÕES GLOBAIS *********************************

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
        end;
    end;
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

procedure TFrmPrincipal.FormShow(Sender: TObject);
  var
    foto : TStream;
    i : integer;
begin
    foto := TMemoryStream.Create;
    img_categoria.Bitmap.SaveToStream(foto);
    foto.Position := 0;

    for i := 1 to 10 do
        AddLancamento( FrmPrincipal.lv_lancamento,
                       '00001',
                       'Compra de passagem Compra de passagem Compra de passagem ',
                       'Transporte',
                       -45,
                       date,
                       foto );

    foto.DisposeOf;
end;

procedure TFrmPrincipal.img_menuClick(Sender: TObject);
begin
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

procedure TFrmPrincipal.lv_lancamentoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
  var
    i : integer;
begin
    if lv_lancamento.Items.Count > 0 then

        if lv_lancamento.GetItemRect(lv_lancamento.items.Count - 2).Bottom <= lv_lancamento.Height then

            for i := lv_lancamento.items.Count + 1 to lv_lancamento.items.Count + 10 do

                AddLancamento(Self.lv_lancamento ,'0000' + IntToStr(i), 'Produto ' + IntToStr(i), 'Categoria ' + IntToStr(i), -50 , date, nil);
end;

procedure TFrmPrincipal.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    SetupLancamento(FrmPrincipal.lv_lancamento, AItem);
end;

end.
