unit UnitLancamentosResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.DateTimeCtrls, FMX.ListBox, FireDAC.Comp.Client, FireDAC.DApt,
  Data.DB, FMX.DialogService, DateUtils;

type
  TFrmLancamentosResumo = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    Image3: TImage;
    lbl_mes: TLabel;
    lv_resumo: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_voltarClick(Sender: TObject);
    procedure img_voltarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_voltarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private

    procedure MontarResumo;
    procedure AddCategoria( listview: TListView;
                            categoria: string;
                            valor : double;
                            foto: TStream);

    { Private declarations }
  public
    { Public declarations }

    dt_filtro : TDate;

  end;

var
  FrmLancamentosResumo: TFrmLancamentosResumo;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM, cLancamento;

procedure TFrmLancamentosResumo.AddCategoria( listview : TListView;
                                      categoria : string;
                                      valor : double;
                                      foto: TStream);
var
    bmp : TBitmap;
begin
    with listview.Items.Add do
    begin

        if valor < 0 then
           TListItemText(Objects.FindDrawable('TxtValor')).TextColor := $FFFF5733
        else
           TListItemText(Objects.FindDrawable('TxtValor')).TextColor := $FF5863CD;

        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtValor')).Text := FormatFloat('#,##0.00', valor);

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := True;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := bmp;
        end;
    end;
end;


procedure TFrmLancamentosResumo.MontarResumo;
var
    lancamento   : TLancamento;
    qry          : TFDQuery;
    erro         : string;
    icone        : TStream;
begin
   try
      lv_resumo.Items.Clear;

      lancamento := TLancamento.Create(dm.conn);
      lancamento.DATA_DE  := FormatDateTime('YYYY-MM-DD', StartOfTheMonth(dt_filtro));
      lancamento.DATA_ATE := FormatDateTime('YYYY-MM-DD', EndOfTheMonth(dt_filtro));
      qry := lancamento.ListarResumo(0, erro);

     while not qry.Eof do
      begin
        if qry.FieldByName('ICONE').AsString <> '' then
           icone := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
        else
           icone := nil;
           FrmLancamentosResumo.AddCategoria( FrmLancamentosResumo.lv_resumo,
                                              qry.FieldByName('DESCRICAO').AsString,
                                              qry.FieldByName('VALOR').AsFloat,
                                              icone );
       if icone <> nil then
          icone.DisposeOf;

          qry.Next;
      end;

   finally
        qry.DisposeOf;
        lancamento.DisposeOf;
   end;
end;


procedure TFrmLancamentosResumo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLancamentosResumo := nil;
end;

procedure TFrmLancamentosResumo.FormShow(Sender: TObject);
begin
    MontarResumo;
end;

procedure TFrmLancamentosResumo.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmLancamentosResumo.img_voltarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 0.4;
end;

procedure TFrmLancamentosResumo.img_voltarMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    TImage(Sender).Opacity := 1;
end;

end.
