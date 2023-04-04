unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Ani,
  Firedac.Comp.Client, FireDAC.DApt, Data.DB, System.DateUtils;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_menu: TImage;
    c_icone: TCircle;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    lbl_saldo: TLabel;
    Label3: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image2: TImage;
    lbl_receitas: TLabel;
    Layout6: TLayout;
    Image3: TImage;
    lbl_despesas: TLabel;
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
    layout_menu_logoff: TLayout;
    Label10: TLabel;
    img_saldo_visivel: TImage;
    label5: TLabel;
    img_closed_eye: TImage;
    img_open_eye: TImage;
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
    procedure layout_menu_logoffClick(Sender: TObject);
    procedure img_saldo_visivelClick(Sender: TObject);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure lbl_todos_lancMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure lbl_todos_lancMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Label9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Label9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Label10MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Label10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_fechar_menuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_fechar_menuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_menuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_menuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private

    procedure ListarUltimosLancamentos(limit : integer; offset : Integer; condicao : string);
    procedure Dashboard;
    procedure CarregarIcone;
    procedure VisibilidadeSaldo;

    { Private declarations }
  public
    { Public declarations }

    PosicaoFoto : Integer;

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

uses UnitLancamentos, UnitCategorias, cLancamento, UnitDM, UnitLancamentosCad,
  cUsuario, UnitLogin;

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

      {  if valor < 0 then
           TListItemText(Objects.FindDrawable('TxtValor')).TextColor := $FFFF5733
        else
           TListItemText(Objects.FindDrawable('TxtValor')).TextColor := $FF5863CD;
      }
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

procedure TFrmPrincipal.CarregarIcone;
var
    usuario : TUsuario;
    qry     : TFDQuery;
    erro    : string;
    foto    : TStream;
begin
    try
        usuario := TUsuario.Create(dm.conn);
        qry     := usuario.ListarUsuario(erro);

        if qry.FieldByName('FOTO').AsString <> '' then
            foto := qry.CreateBlobStream(qry.FieldByName('FOTO'), TBlobStreamMode.bmRead)
           else
            foto := nil;

        if foto <> nil then
        begin
           c_icone.Fill.Bitmap.Bitmap.LoadFromStream(foto);
           foto.DisposeOf;
        end;

    finally
        usuario.DisposeOf;
        qry.DisposeOf;
    end;

end;

procedure TFrmPrincipal.Dashboard;
var
    lancamento : TLancamento;
    qry        : TFDQuery;
    erro       : string;

    vl_receita,
    vl_despesa : double;
begin
    try
        lancamento := TLancamento.Create(dm.conn);
        lancamento.DATA_DE  := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(Date));
        lancamento.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(Date));
        qry := lancamento.ListarLancamento(0, 0, erro);

        if erro <> '' then
        begin
            ShowMessage(erro);
            Exit;
        end;

        vl_receita := 0;
        vl_despesa := 0;

        while not qry.Eof do
        begin
            if qry.FieldByName('VALOR').AsFloat > 0 then
                vl_receita := vl_receita + qry.FieldByName('VALOR').AsFloat
               else
                vl_despesa := vl_despesa + qry.FieldByName('VALOR').AsFloat;

            qry.Next;
        end;

        lbl_receitas.Text := FormatFloat('#,##0.00', vl_receita);
        lbl_despesas.Text := FormatFloat('#,##0.00', vl_despesa);
        lbl_saldo.Text := FormatFloat('#,##0.00', vl_receita + vl_despesa);

    finally
        qry.DisposeOf;
        lancamento.DisposeOf;
    end;

end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin

    if Assigned(Frmlancamentos) then
       begin
         Frmlancamentos.DisposeOf;
         Frmlancamentos := nil;
       end;

    Action := TCloseAction.caFree;
    FrmPrincipal := nil;

end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    rect_menu.Margins.Left := -260;
    rect_menu.Align := TAlignLayout.Left;
    rect_menu.Visible := True;
end;

procedure TFrmPrincipal.lv_lancamentoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    //rolagem infinita...

    if lv_lancamento.Items.Count > 0 then
     if lv_lancamento.GetItemRect(lv_lancamento.items.Count - 2).Bottom <= lv_lancamento.Height then
        ListarUltimosLancamentos(10, lv_lancamento.items.Count, 'rolagem');

end;

procedure TFrmPrincipal.ListarUltimosLancamentos(limit : integer; offset : Integer; condicao : string);
var
    foto : TStream;
    lanc : TLancamento;
    qry : TFDQuery;
    erro : string;
begin

    try
        if condicao <> 'rolagem' then
           lv_lancamento.Items.clear;
           lanc := TLancamento.Create(dm.conn);

        qry := lanc.ListarLancamento(limit, offset, erro);

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

    Dashboard;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarUltimosLancamentos(10, 0, '');
    CarregarIcone;
    VisibilidadeSaldo;
end;

procedure TFrmPrincipal.Image4Click(Sender: TObject);
begin
if NOT Assigned(FrmLancamentosCad) then
           Application.CreateForm(TFrmLancamentosCad, FrmLancamentosCad);

           FrmLancamentosCad.modo := 'I';

           FrmLancamentosCad.ShowModal(procedure(ModalResult: TModalResult)
                  begin
                      ListarUltimosLancamentos(10, 0, '');
                  end);
end;

procedure TFrmPrincipal.Image4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    //
    image4.Opacity := 0.5;
end;

procedure TFrmPrincipal.Image4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    image4.Opacity := 1;
end;

procedure TFrmPrincipal.VisibilidadeSaldo;
begin
    lbl_receitas.Visible := not lbl_receitas.Visible;
    lbl_despesas.Visible := not lbl_despesas.Visible;
    lbl_saldo.Visible := not lbl_saldo.Visible;

    if img_saldo_visivel.Tag = 1 then
      begin
        img_saldo_visivel.Bitmap := img_closed_eye.Bitmap;
        img_saldo_visivel.Tag := 0;
      end
    else
      begin
        img_saldo_visivel.Bitmap := img_open_eye.Bitmap;
        img_saldo_visivel.Tag := 1;
      end;
end;

procedure TFrmPrincipal.img_saldo_visivelClick(Sender: TObject);
begin
    VisibilidadeSaldo;
end;

procedure TFrmPrincipal.Label10MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.5;
end;

procedure TFrmPrincipal.Label10MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmPrincipal.Label9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.5;
end;

procedure TFrmPrincipal.Label9MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmPrincipal.img_fechar_menuClick(Sender: TObject);
begin
    AnimationMenu.Start;
end;

procedure TFrmPrincipal.img_fechar_menuMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.5;
end;

procedure TFrmPrincipal.img_fechar_menuMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmPrincipal.img_menuClick(Sender: TObject);
begin

    AnimationMenu.Start;

end;

procedure TFrmPrincipal.img_menuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmPrincipal.img_menuMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmPrincipal.layout_menu_catClick(Sender: TObject);
begin

    AnimationMenu.Start;

    if NOT Assigned(FrmCategorias) then
           Application.CreateForm(TFrmCategorias, FrmCategorias);
           FrmCategorias.Show;
end;

procedure TFrmPrincipal.layout_menu_logoffClick(Sender: TObject);
var
    usuario : TUsuario;
    erro : string;
begin
    try
        usuario := TUsuario.Create(dm.conn);

        if not usuario.LogOut(erro) then
        begin
          ShowMessage(erro);
          Exit;
        end;

    finally
        usuario.DisposeOf;
    end;

    if NOT Assigned( FrmLogin ) then
       Application.CreateForm(TFrmLogin, FrmLogin);

       Application.MainForm := FrmLogin;
       FrmLogin.Show;
       FrmPrincipal.Close;

end;

procedure TFrmPrincipal.lbl_todos_lancClick(Sender: TObject);
begin
    if NOT Assigned(FrmLancamentos) then
           Application.CreateForm(TFrmLancamentos, FrmLancamentos);
           FrmLancamentos.ShowModal( procedure( ModalResult : TModalResult )
                                   begin
                                      ListarUltimosLancamentos(10, 0, '');
                                   end);
end;

procedure TFrmPrincipal.lbl_todos_lancMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.2;
end;

procedure TFrmPrincipal.lbl_todos_lancMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.7;
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
                                      ListarUltimosLancamentos(10, 0, '');
                                   end);
end;


procedure TFrmPrincipal.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    SetupLancamento(FrmPrincipal.lv_lancamento, AItem);
end;

end.
