unit UnitCategoriasCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FireDAC.Comp.Client, FireDAC.DApt, FMX.DialogService;

type
  TFrmCategoriasCad = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    img_save: TImage;
    Layout2: TLayout;
    Label2: TLabel;
    edt_descricao: TEdit;
    Line1: TLine;
    Label1: TLabel;
    lb_icone: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    img_selecao: TImage;
    rect_delete: TRectangle;
    img_delete: TImage;
    procedure img_voltarClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure img_saveClick(Sender: TObject);
    procedure img_deleteClick(Sender: TObject);
    procedure img_saveMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_saveMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_voltarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_voltarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_deleteMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_deleteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    icone_selecionado : TBitmap;
    procedure SelecionaIcone(img: Timage);
    { Private declarations }
  public
    { Public declarations }
    modo   : string; // I (Inclusão) | A (Alteração)
    id_cat : Integer;
  end;

var
  FrmCategoriasCad: TFrmCategoriasCad;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitCategorias, cCategoria, UnitDM;

procedure TFrmCategoriasCad.SelecionaIcone(img : Timage);
begin
  icone_selecionado := img.Bitmap;
  img_selecao.Parent := img.Parent;
end;

procedure TFrmCategoriasCad.FormResize(Sender: TObject);
begin
  lb_icone.Columns := Trunc(lb_icone.Width / 80);
end;

procedure TFrmCategoriasCad.FormShow(Sender: TObject);
var
    cat   : TCategoria;
    qry   : TFDQuery;
    erro  : string;
begin
    if modo = 'I' then
    begin
        rect_delete.Visible := False;
        edt_descricao.Text := '';
    end
    else
      begin
           try
              rect_delete.Visible := True;

              cat := TCategoria.Create(dm.conn);
              cat.ID_CATEGORIA := id_cat;

              qry := cat.ListarCategoria(erro);

              edt_descricao.Text := qry.FieldByName('DESCRICAO').AsString;

              img_selecao.Parent := TListBoxItem( lb_icone
                                                  .ItemByIndex(qry.FieldByName('INDICE_ICONE')
                                                  .AsInteger));


              SelecionaIcone( FrmCategoriasCad.FindComponent('Image' +
                            ( TListBoxItem(lb_icone
                             .ItemByIndex(qry.FieldByName('INDICE_ICONE')
                             .AsInteger)).Index + 1)
                             .ToString) as TImage);

          finally
              qry.DisposeOf;
              cat.DisposeOf;
          end;
      end;

end;

procedure TFrmCategoriasCad.Image1Click(Sender: TObject);
begin
    SelecionaIcone(TImage(Sender));
end;

procedure TFrmCategoriasCad.img_deleteClick(Sender: TObject);
var
    cat  : TCategoria;
    erro : string;
begin
    TDialogService.MessageDialog( 'Confirma a esclusão da categoria ?' ,
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                   TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    var
        erro: string;
    begin
        if AResult = mrYes then
        begin
           try
              cat := TCategoria.Create(dm.conn);
              cat.ID_CATEGORIA := id_cat;

              if NOT cat.Excluir(erro) then
              begin
                  ShowMessage(erro);
                  Exit;
              end;

              FrmCategorias.ListarCategorias;
              Close;

            finally
                cat.DisposeOf;
            end;
        end;
    end);

end;

procedure TFrmCategoriasCad.img_deleteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmCategoriasCad.img_deleteMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmCategoriasCad.img_saveClick(Sender: TObject);
var
    cat  : TCategoria;
    erro : string;
begin
    try
       cat := TCategoria.Create(dm.conn);
       cat.DESCRICAO := edt_descricao.Text;
       cat.ICONE := icone_selecionado;
       cat.INDICE_ICONE :=  TListBoxItem(img_selecao.Parent).Index;

       if modo = 'I' then
          cat.Inserir(erro)
       else
          begin
            cat.ID_CATEGORIA := id_cat;
            cat.Alterar(erro);
          end;


       if erro <> '' then
          begin
            ShowMessage(erro);
            Exit;
          end;

       FrmCategorias.ListarCategorias;
       Close;

    finally
       cat.DisposeOf;
    end;
end;

procedure TFrmCategoriasCad.img_saveMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmCategoriasCad.img_saveMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmCategoriasCad.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmCategoriasCad.img_voltarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmCategoriasCad.img_voltarMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

end.
