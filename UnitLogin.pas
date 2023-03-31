unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.TabControl,
  System.Actions, FMX.ActnList, u99Permissions, FMX.MediaLibrary.Actions, FireDAC.Comp.Client, FireDAC.DApt,

  {$IFDEF ANDROID}
  FMX.Platform, FMX.VirtualKeyboard,
  {$ENDIF}

  FMX.StdActns;

type
  TFrmLogin = class(TForm)
    Layout2: TLayout;
    img_login_logo: TImage;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    RoundRect2: TRoundRect;
    edit_login: TEdit;
    Layout1: TLayout;
    RoundRect1: TRoundRect;
    edit_login_senha: TEdit;
    Layout4: TLayout;
    rect_login: TRoundRect;
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
    rect_criar_conta: TRoundRect;
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
    ActLibrary: TTakePhotoFromLibraryAction;
    ActCamera: TTakePhotoFromCameraAction;
    Timer1: TTimer;
    img_rotation: TImage;
    procedure label_login_contaClick(Sender: TObject);
    procedure label_login_tabContaClick(Sender: TObject);
    procedure rect_conta_proximoClick(Sender: TObject);
    procedure img_foto_voltarClick(Sender: TObject);
    procedure c_escolher_fotoClick(Sender: TObject);
    procedure img_escolherFoto_voltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure img_fotoClick(Sender: TObject);
    procedure img_libraryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure ActCameraDidFinishTaking(Image: TBitmap);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rect_criar_contaClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure img_rotationClick(Sender: TObject);

  private
    { Private declarations }
    permissao : T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);
    procedure AbrirFrmPrincipal;


  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM, cUsuario;

procedure TFrmLogin.AbrirFrmPrincipal;
begin
    if NOT Assigned(FrmPrincipal) then
       Application.CreateForm(TFrmPrincipal, FrmPrincipal);

       Application.MainForm := FrmPrincipal;
       FrmPrincipal.c_icone.RotationAngle := c_escolher_foto.RotationAngle;
       FrmPrincipal.Show;
       FrmLogin.Close;
end;

procedure TFrmLogin.ActCameraDidFinishTaking(Image: TBitmap);
begin
        Image.Resize(500  , 500);
        c_escolher_foto.Fill.Bitmap.Bitmap := Image;
        c_escolher_foto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
        ActFoto.Execute;
end;

procedure TFrmLogin.ActLibraryDidFinishTaking(Image: TBitmap);
begin
  Image.Resize(500  , 500);
  c_escolher_foto.Fill.Bitmap.Bitmap := Image;
  ActFoto.Execute;
end;

procedure TFrmLogin.c_escolher_fotoClick(Sender: TObject);
begin
  ActEscolherFoto.Execute;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  permissao := T99Permissions.Create;
end;

procedure TFrmLogin.FormDestroy(Sender: TObject);
begin
  permissao.DisposeOf;
end;

procedure TFrmLogin.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
  var
    FService : IFMXVirtualKeyboardService;
{$ENDIF}
begin
{$IFDEF ANDROID}
     if (Key = vkHardwareBack) then
     begin
       TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
      if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyboardState) then
          begin
          //bot�o back pressionado e teclado vis�vel...
          //(apenas fecha o teclado)
          FService.HideVirtualKeyboard;
          end
        else
          begin
            //bot�o back pressionado e teclado n�o vis�vel...
            if TabControl1.ActiveTab = TabConta then
              begin
               Key := 0;
               ActLogin.Execute;
              end

            else if TabControl1.ActiveTab = TabFoto then
              begin
               Key := 0;
               ActConta.Execute;
              end

            else if TabControl1.ActiveTab = TabEscolherFoto then
              begin
               Key := 0;
               ActFoto.Execute;
              end;
          end;
     end;
{$ENDIF}
end;

procedure TFrmLogin.FormShow(Sender: TObject);

begin
    TabControl1.ActiveTab := TabLogin;

    Timer1.Enabled := True;
end;

procedure TFrmLogin.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
    TabControl1.Margins.Bottom := 0;
end;

procedure TFrmLogin.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
    TabControl1.Margins.Bottom := 100;
end;

procedure TFrmLogin.img_escolherFoto_voltarClick(Sender: TObject);
begin
  ActFoto.Execute;
end;

procedure TFrmLogin.Timer1Timer(Sender: TObject);
var
    usuario : TUsuario;
    erro : string;
    qry : TFDQuery;
begin

    Timer1.Enabled := False;


    //valida se o usu�rio j� est� logado
    try
        usuario := TUsuario.Create(dm.conn);
        qry := TFDQuery.Create(nil);

        qry := usuario.ListarUsuario(erro);

        if qry.FieldByName('IND_LOGIN').AsString <> 'S' then
           Exit;

    finally
        qry.DisposeOf;
        usuario.DisposeOf;
    end;

    AbrirFrmPrincipal;

end;

procedure TFrmLogin.TrataErroPermissao(Sender : TObject);
begin
  ShowMessage('Voc� n�o possui permiss�o para o acesso deste recurso');
end;

procedure TFrmLogin.img_fotoClick(Sender: TObject);
begin
  permissao.Camera(ActCamera, TrataErroPermissao);
end;

procedure TFrmLogin.img_foto_voltarClick(Sender: TObject);
begin
  ActConta.Execute;
end;

procedure TFrmLogin.img_libraryClick(Sender: TObject);
begin
  permissao.PhotoLibrary(ActLibrary, TrataErroPermissao);
end;

procedure TFrmLogin.img_rotationClick(Sender: TObject);
begin
    if c_escolher_foto.RotationAngle = 270 then
       c_escolher_foto.RotationAngle := 0
    else
       c_escolher_foto.RotationAngle :=  c_escolher_foto.RotationAngle + 90;
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

procedure TFrmLogin.rect_criar_contaClick(Sender: TObject);
var
    usuario : TUsuario;
    erro : string;
begin
    try
        usuario := TUsuario.Create(dm.conn);
        usuario.NOME := edit_cad_nome.Text;
        usuario.EMAIL := edit_cad_email.Text;
        usuario.SENHA := edit_cad_senha.Text;
        usuario.IND_LOGIN := 'S';

        usuario.FOTO := c_escolher_foto.Fill.Bitmap.Bitmap;

         //Excluir usu�rio existente...
        if NOT usuario.Excluir(erro) then
            begin
                ShowMessage(erro);
                Exit;
            end;

         //cadastrar novo usu�rio...
        if NOT usuario.Inserir(erro) then
            begin
                ShowMessage(erro);
                Exit;
            end;

    finally
        usuario.DisposeOf;
    end;

    AbrirFrmPrincipal;
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
var
    usuario : TUsuario;
    erro : string;
begin
    try
        usuario := TUsuario.Create(dm.conn);
        usuario.EMAIL := edit_login.Text;
        usuario.SENHA := edit_login_senha.Text;

        if not usuario.ValidarLogin(erro) then
        begin
          ShowMessage(erro);
          Exit;
        end;

    finally
        usuario.DisposeOf;
    end;

    AbrirFrmPrincipal;
end;

end.
