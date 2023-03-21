unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.TabControl,
  System.Actions, FMX.ActnList;

type
  TFrmLogin = class(TForm)
    Layout2: TLayout;
    img_login_logo: TImage;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    RoundRect2: TRoundRect;
    Edit1: TEdit;
    Layout1: TLayout;
    RoundRect1: TRoundRect;
    edit_login_senha: TEdit;
    Layout4: TLayout;
    RoundRect3: TRoundRect;
    Label1: TLabel;
    TabControl1: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    Layout5: TLayout;
    Image1: TImage;
    Layout6: TLayout;
    RoundRect4: TRoundRect;
    edit_cad_nome: TEdit;
    Layout7: TLayout;
    RoundRect5: TRoundRect;
    edit_cad_senha: TEdit;
    Layout8: TLayout;
    rect_conta_proximo: TRoundRect;
    label_proximo: TLabel;
    Layout9: TLayout;
    RoundRect7: TRoundRect;
    edit_cad_email: TEdit;
    TabFoto: TTabItem;
    Layout10: TLayout;
    c_escolher_foto: TCircle;
    Layout11: TLayout;
    RoundRect8: TRoundRect;
    Label3: TLabel;
    TabEscolherFoto: TTabItem;
    Layout12: TLayout;
    Label4: TLabel;
    img_foto: TImage;
    img_library: TImage;
    Layout13: TLayout;
    img_escolherFoto_voltar: TImage;
    Layout14: TLayout;
    img_foto_voltar: TImage;
    Layout15: TLayout;
    Layout16: TLayout;
    label_login_tab: TLabel;
    label_login_conta: TLabel;
    Rectangle1: TRectangle;
    ActionList1: TActionList;
    ActEscolherFoto: TChangeTabAction;
    ActFoto: TChangeTabAction;
    ActLogin: TChangeTabAction;
    ActConta: TChangeTabAction;
    Layout17: TLayout;
    Layout18: TLayout;
    label_login_tabConta: TLabel;
    Label6: TLabel;
    Rectangle2: TRectangle;
    procedure label_login_contaClick(Sender: TObject);
    procedure label_login_tabContaClick(Sender: TObject);
    procedure rect_conta_proximoClick(Sender: TObject);
    procedure img_foto_voltarClick(Sender: TObject);
    procedure c_escolher_fotoClick(Sender: TObject);
    procedure img_escolherFoto_voltarClick(Sender: TObject);



  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}


procedure TFrmLogin.c_escolher_fotoClick(Sender: TObject);
begin
  ActEscolherFoto.Execute;
end;

procedure TFrmLogin.img_escolherFoto_voltarClick(Sender: TObject);
begin
  ActFoto.Execute;
end;

procedure TFrmLogin.img_foto_voltarClick(Sender: TObject);
begin
  ActConta.Execute;
end;

procedure TFrmLogin.label_login_contaClick(Sender: TObject);
begin
  ActConta.Execute;
end;

procedure TFrmLogin.label_login_tabContaClick(Sender: TObject);
begin
  ActLogin.Execute;
end;

procedure TFrmLogin.rect_conta_proximoClick(Sender: TObject);
begin
  ActFoto.Execute;
end;

end.