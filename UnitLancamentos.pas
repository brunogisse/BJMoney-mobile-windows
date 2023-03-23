unit UnitLancamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmLancamentos = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Layout2: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label2: TLabel;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    img_add: TImage;
    lv_lancamento: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_addClick(Sender: TObject);
  private
    procedure EditarLancamento(id_lancamento: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancamentos: TFrmLancamentos;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitLancamentosCad;

procedure TFrmLancamentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   // Action := TCloseAction.caFree;
  //  FrmLancamentos := nil;   .... estamos fechando no formulário principal
end;

procedure TFrmLancamentos.FormShow(Sender: TObject);
  var
    foto : TStream;
    i : integer;
begin
    foto := TMemoryStream.Create;
    FrmPrincipal.img_categoria.Bitmap.SaveToStream(foto);
    foto.Position := 0;

    for i := 1 to 10 do
        FrmPrincipal
        .AddLancamento( Self.lv_lancamento,
                       '00001',
                       'Compra de passagem Compra de passagem Compra de passagem ',
                       'Transporte',
                       -45,
                       date,
                       foto );

    foto.DisposeOf;

end;

procedure TFrmLancamentos.img_addClick(Sender: TObject);
begin
    EditarLancamento('');
end;

procedure TFrmLancamentos.img_voltarClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmLancamentos.EditarLancamento(id_lancamento : string);
begin
    if NOT Assigned(FrmLancamentosCad) then
           Application.CreateForm(TFrmLancamentosCad, FrmLancamentosCad);
           FrmLancamentosCad.show;
end;

procedure TFrmLancamentos.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    EditarLancamento('');
end;

procedure TFrmLancamentos.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmPrincipal.SetupLancamento(Self.lv_lancamento, AItem);
end;

end.
