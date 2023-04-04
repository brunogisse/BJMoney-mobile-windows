unit UnitLancamentosCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  FMX.DateTimeCtrls, FMX.ListBox, FireDAC.Comp.Client, FireDAC.DApt, FMX.DialogService;

type
  TFrmLancamentosCad = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    img_save: TImage;
    Layout2: TLayout;
    Label2: TLabel;
    edt_descricao: TEdit;
    Line1: TLine;
    Layout3: TLayout;
    Label3: TLabel;
    Line2: TLine;
    Layout4: TLayout;
    Label4: TLabel;
    Line3: TLine;
    Layout5: TLayout;
    Label5: TLabel;
    edt_valor: TEdit;
    Line4: TLine;
    dt_lancamento: TDateEdit;
    img_hoje: TImage;
    img_ontem: TImage;
    rect_delete: TRectangle;
    img_delete: TImage;
    img_tipo_lancamento: TImage;
    img_despesa: TImage;
    img_receita: TImage;
    lbl_categoria: TLabel;
    Image1: TImage;
    procedure img_voltarClick(Sender: TObject);
    procedure img_tipo_lancamentoClick(Sender: TObject);
    procedure img_hojeClick(Sender: TObject);
    procedure img_ontemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure img_saveClick(Sender: TObject);
    procedure edt_valorTyping(Sender: TObject);
    procedure img_deleteClick(Sender: TObject);
    procedure lbl_categoriaClick(Sender: TObject);
    procedure img_hojeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_hojeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_ontemMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_ontemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_saveMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_saveMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_deleteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_deleteMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    procedure ComboCategoria;
    function TrataValor(str: string): double;
    { Private declarations }
  public
    { Public declarations }

    modo : string;
    id_lanc : Integer;

  end;

var
  FrmLancamentosCad: TFrmLancamentosCad;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitCategorias, UnitDM, cCategoria, cLancamento, uFormat,
  UnitComboCategoria;

procedure TFrmLancamentosCad.ComboCategoria;
var
    categoria : TCategoria;
    erro      : string;
    qry       : TFDQuery;
begin
    {try
        cmb_categoria.Items.Clear;
        categoria := TCategoria.Create(dm.conn); //categoria � um objeto instanciado da classe TCategoria.
        qry := categoria.ListarCategoria(erro);

        if erro <> '' then
        begin
            //MessageDlg(erro, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
            ShowMessage(erro);
            Exit;
        end;

        while NOT qry.Eof do
        begin
            cmb_categoria
                  .Items
                  .AddObject(qry.FieldByName('DESCRICAO').AsString,
                             TObject(qry.FieldByName('ID_CATEGORIA').AsInteger));

            qry.Next;
        end;

    finally
        categoria.DisposeOf;
        qry.DisposeOf;
    end;   }
end;

procedure TFrmLancamentosCad.edt_valorTyping(Sender: TObject);
begin
    Formatar(edt_valor, TFormato.Valor);
end;

procedure TFrmLancamentosCad.FormShow(Sender: TObject);
var
    lancamento : TLancamento;
    qry        : TFDQuery;
    erro       : string;
begin
    ComboCategoria;

    if modo = 'I' then
    begin
        edt_descricao.Text := '';
        dt_lancamento.Date := Date;
        edt_valor.Text := '';
        img_tipo_lancamento.Bitmap := img_despesa.Bitmap;
        img_tipo_lancamento.Tag := -1;
        rect_delete.Visible := False;
        lbl_categoria.Text := '';
        lbl_categoria.Tag := 0;
    end
    else
    begin
        try
            lancamento := TLancamento.Create(dm.conn);
            lancamento.ID_LANCAMENTO := id_lanc;
            qry := lancamento.ListarLancamento(0, 0, erro);

            if qry.RecordCount = 0 then
            begin
              {$IFDEF MSWINDOWS}
               MessageDlg('Lan�amento n�o encontrado', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
              {$ELSE}
               ShowMessage('Lan�amento n�o encontrado');
              {$ENDIF}
               Exit;
            end;

            edt_descricao.Text := qry.FieldByName('DESCRICAO').AsString;
            dt_lancamento.Date := qry.FieldByName('data').AsDateTime;

            if qry.FieldByName('VALOR').AsFloat < 0 then  //despesa...
            begin
               edt_valor.Text     := FormatFloat('#,##0.00', qry.FieldByName('VALOR').AsFloat * -1);
               img_tipo_lancamento.Bitmap := img_despesa.Bitmap;
               img_tipo_lancamento.Tag := -1;
            end
          else
            begin
               edt_valor.Text     := FormatFloat('#,##0.00', qry.FieldByName('VALOR').AsFloat);
               img_tipo_lancamento.Bitmap := img_receita.Bitmap;
               img_tipo_lancamento.Tag := 1;
            end;

         //   cmb_categoria.ItemIndex := cmb_categoria.Items.IndexOf(qry.FieldByName('DESCRICAO_CATEGORIA').AsString);
            lbl_categoria.Text := qry.FieldByName('DESCRICAO_CATEGORIA').AsString;
            lbl_categoria.Tag := qry.FieldByName('ID_CATEGORIA').AsInteger;
            rect_delete.Visible := True;

        finally
            lancamento.DisposeOf;
            qry.DisposeOf;
        end;
    end;
end;

procedure TFrmLancamentosCad.img_deleteClick(Sender: TObject);
var
    lancamento  : TLancamento;
    erro : string;
begin
    TDialogService.MessageDialog( 'Confirma a esclus�o do lan�amento ?' ,
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
              lancamento := TLancamento.Create(dm.conn);
              lancamento.ID_LANCAMENTO := id_lanc;

              if NOT lancamento.Excluir(erro) then
              begin
                  ShowMessage(erro);
                  Exit;
              end;

              Close;

            finally
                lancamento.DisposeOf;
            end;
        end;
    end);

end;

procedure TFrmLancamentosCad.img_deleteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmLancamentosCad.img_deleteMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentosCad.img_hojeClick(Sender: TObject);
begin
    dt_lancamento.Date := date;
end;

procedure TFrmLancamentosCad.img_hojeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmLancamentosCad.img_hojeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentosCad.img_ontemClick(Sender: TObject);
begin
    dt_lancamento.Date := Date - 1;
end;

procedure TFrmLancamentosCad.img_ontemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmLancamentosCad.img_ontemMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

function TFrmLancamentosCad.TrataValor(str : string) : double ;
begin
    //exemplo... recebe 1.250,75
    str := StringReplace(str, '.', '', [rfReplaceAll]); // 1250,75...
    str := StringReplace(str, ',', '', [rfReplaceAll]); // 125075...

    try
        Result := StrToFloat(str) / 100;
    except
        Result := 0;
    end;
end;

procedure TFrmLancamentosCad.img_saveClick(Sender: TObject);
var
    lancamento : TLancamento;
    erro       : string;
begin
    try
        lancamento := TLancamento.Create(dm.conn);
        lancamento.DESCRICAO := edt_descricao.Text;
        lancamento.VALOR := TrataValor(edt_valor.Text) * img_tipo_lancamento.Tag;

        //lancamento.ID_CATEGORIA := Integer(cmb_categoria.Items.Objects[cmb_categoria.ItemIndex]);

        lancamento.ID_CATEGORIA := lbl_categoria.Tag;
        lancamento.DATA_LANCAMENTO := dt_lancamento.Date;

        if modo = 'I' then
            lancamento.inserir(erro)
        else
        begin
            lancamento.ID_LANCAMENTO := id_lanc;
            lancamento.Alterar(erro);
        end;

        if erro <> '' then
        begin
            ShowMessage(erro);
            Exit;
        end;

       Close;
    finally
        lancamento.DisposeOf;
    end;
end;

procedure TFrmLancamentosCad.img_saveMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmLancamentosCad.img_saveMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentosCad.img_tipo_lancamentoClick(Sender: TObject);
begin
    case img_tipo_lancamento.Tag of
       1:
          begin
              img_tipo_lancamento.Bitmap := img_despesa.Bitmap;
              img_tipo_lancamento.Tag := -1;
          end;
       -1:
          begin
              img_tipo_lancamento.Bitmap := img_receita.Bitmap;
              img_tipo_lancamento.Tag := 1;
          end;
    end;
end;

procedure TFrmLancamentosCad.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmLancamentosCad.lbl_categoriaClick(Sender: TObject);
begin
    //Abre listagem das categorias...

    if not Assigned( FrmComboCategoria ) then
        application.CreateForm( TFrmComboCategoria, FrmComboCategoria );

    FrmComboCategoria.ShowModal( procedure ( ModalResult : TModalResult )
    begin
        if FrmComboCategoria.idCategoriaSelecao > 0 then
        begin
            lbl_categoria.Text := FrmComboCategoria.CategoriaSelecao;
            lbl_categoria.Tag  := FrmComboCategoria.IdcategoriaSelecao;
        end;

    end);

end;

end.
