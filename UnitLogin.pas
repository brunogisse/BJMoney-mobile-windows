unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.TabControl,
  System.Actions, FMX.ActnList, u99Permissions, FMX.MediaLibrary.Actions,

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
    rect_login: TRoundRect;
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
    procedure RoundRect3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    permissao : T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);


  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;


procedure TFrmLogin.ActCameraDidFinishTaking(Image: TBitmap);
begin
  c_escolher_foto.Fill.Bitmap.Bitmap := Image;
  ActFoto.Execute;
end;

procedure TFrmLogin.ActLibraryDidFinishTaking(Image: TBitmap);
begin
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
          if (FService = nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyboardState) then
              begin
              //bot�o back pressionado e teclado vis�vel...
              //(apenas fecha o teclado)
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
end;

procedure TFrmLogin.img_escolherFoto_voltarClick(Sender: TObject);
begin
  ActFoto.Execute;
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

procedure TFrmLogin.RoundRect3Click(Sender: TObject);
begin
     if NOT Assigned(FrmPrincipal) then
       Application.CreateForm(TFrmPrincipal, FrmPrincipal);

       Application.MainForm := FrmPrincipal;
       FrmPrincipal.Show;
       FrmLogin.Close;
end;

end.
