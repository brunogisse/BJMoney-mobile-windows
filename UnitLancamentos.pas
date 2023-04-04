unit UnitLancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  Firedac.Comp.Client, FireDAC.DApt, Data.DB, DateUtils;

type
  TFrmLancamentos = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    img_anterior: TImage;
    img_proximo: TImage;
    Image3: TImage;
    lbl_mes: TLabel;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    lbl_receitas: TLabel;
    Label5: TLabel;
    lbl_despesas: TLabel;
    Label6: TLabel;
    lbl_saldo: TLabel;
    Label8: TLabel;
    img_add: TImage;
    lv_lancamento: TListView;
    Image1: TImage;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_addClick(Sender: TObject);
    procedure img_proximoClick(Sender: TObject);
    procedure img_anteriorClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure img_anteriorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_anteriorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_proximoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_proximoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_addMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_addMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_voltarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_voltarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private

    dt_filtro : TDate;

    procedure AbrirLancamento(id_lancamento: string);
    procedure ListarLancamentos;
    procedure NavegarMes(num_mes: Integer);
    procedure NomeDoMes(dt_label_data: TDateTime);

    { Private declarations }

  public

    { Public declarations }

  end;

var
  FrmLancamentos: TFrmLancamentos;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitLancamentosCad, cLancamento, UnitDM,
  UnitLancamentosResumo;

procedure TFrmLancamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   // Action := TCloseAction.caFree;
  //  FrmLancamentos := nil;   .... estamos fechando no formul�rio principal
end;

procedure TFrmLancamentos.NomeDoMes(dt_label_data : TDateTime);
const
    mes : array[1..12] of string = ( 'Janeiro', 'Fevereiro', 'Mar�o', 'Abril',
                                        'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro',
                                          'Outubro' ,'Novembro' ,'Dezembro');
begin
    lbl_mes.Text := mes[MonthOf(dt_label_data)]
          + ' / ' + IntToStr(YearOf(dt_label_data)) ;
end;

procedure TFrmLancamentos.NavegarMes(num_mes : Integer);
begin
    dt_filtro := IncMonth(dt_filtro, num_mes);

    NomeDoMes(dt_filtro);

    ListarLancamentos;
end;

procedure TFrmLancamentos.ListarLancamentos;
  var
    foto : TStream;
    lanc : TLancamento;
    qry : TFDQuery;
    erro : string;
    vl_receita, vl_despesa : double;
begin

    try

        Self.lv_lancamento.Items.Clear;
        vl_receita := 0;
        vl_despesa := 0;

        lanc          := TLancamento.Create(dm.conn);
        lanc.DATA_DE  := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(dt_filtro));
        lanc.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(dt_filtro));
        qry           := lanc.ListarLancamento(0, 0, erro);

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

            FrmPrincipal.AddLancamento(  self.lv_lancamento,
                                         qry.FieldByName('ID_LANCAMENTO').AsString,
                                         qry.FieldByName('DESCRICAO').AsString,
                                         qry.FieldByName('DESCRICAO_CATEGORIA').AsString,
                                         qry.FieldByName('VALOR').AsFloat,
                                         qry.FieldByName('DATA').AsDateTime,
                                         foto );

            if qry.FieldByName('VALOR').AsFloat > 0 then
               vl_receita := vl_receita + qry.FieldByName('VALOR').AsFloat
            else
               vl_despesa := vl_despesa + qry.FieldByName('VALOR').AsFloat;


            qry.Next;
            foto.DisposeOf;
        end;

        lbl_receitas.Text := FormatFloat('#,##0.00', vl_receita);
        lbl_despesas.Text := FormatFloat('#,##0.00', vl_despesa);

        lbl_saldo.Text := FormatFloat('#,##0.00', vl_receita + vl_despesa);

    finally
        lanc.DisposeOf;
    end;

end;

procedure TFrmLancamentos.FormShow(Sender: TObject);
begin
    dt_filtro := Date;
    NomeDoMes(dt_filtro);
    ListarLancamentos;
end;


procedure TFrmLancamentos.Image1Click(Sender: TObject);
begin
    if not Assigned( FrmLancamentosResumo ) then
        Application.CreateForm( TFrmLancamentosResumo, FrmLancamentosResumo );

        FrmLancamentosResumo.lbl_mes.Text := FrmLancamentos.lbl_mes.Text;
        FrmLancamentosResumo.dt_filtro := FrmLancamentos.dt_filtro;
        FrmLancamentosResumo.Show;
end;

procedure TFrmLancamentos.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.5;
end;

procedure TFrmLancamentos.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentos.img_addClick(Sender: TObject);
begin
    AbrirLancamento('');
end;

procedure TFrmLancamentos.img_addMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.5;
end;

procedure TFrmLancamentos.img_addMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentos.img_anteriorClick(Sender: TObject);
begin
    NavegarMes(-1);
end;

procedure TFrmLancamentos.img_anteriorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentos.img_anteriorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.5;
end;

procedure TFrmLancamentos.img_proximoClick(Sender: TObject);
begin
    NavegarMes(1);
end;

procedure TFrmLancamentos.img_proximoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentos.img_proximoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.5;
end;

procedure TFrmLancamentos.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmLancamentos.img_voltarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmLancamentos.img_voltarMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

procedure TFrmLancamentos.AbrirLancamento(id_lancamento : string);
begin
    if NOT Assigned(FrmLancamentosCad) then
           Application.CreateForm(TFrmLancamentosCad, FrmLancamentosCad);

    if id_lancamento <> '' then
       begin
          FrmLancamentosCad.modo := 'A';
          FrmLancamentosCad.id_lanc := id_lancamento.ToInteger;
       end
    else
       begin
          FrmLancamentosCad.modo := 'I';
          FrmLancamentosCad.id_lanc := 0;
       end;

    FrmLancamentosCad.ShowModal( procedure( ModalResult : TModalResult )
                                   begin
                                      ListarLancamentos;
                                   end);
end;

procedure TFrmLancamentos.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    AbrirLancamento(AItem.TagString);
end;

procedure TFrmLancamentos.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmPrincipal.SetupLancamento(Self.lv_lancamento, AItem);
end;

end.
