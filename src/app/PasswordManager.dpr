program PasswordManager;

uses
  System.SysUtils,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  AuthForm in '..\forms\AuthForm.pas' {AuthorizationForm},
  RegisterForm in '..\forms\RegisterForm.pas' {RegistrationForm},
  TableForm in '..\forms\TableForm.pas' {SpreadsheetForm},
  AboutForm in '..\forms\AboutForm.pas' {FormAbout},
  Bcrypt in '..\libs\bcrypt\Bcrypt.pas',
  Sodium in '..\libs\libsodium\Sodium.pas',
  dmImages in '..\data\dmImages.pas' {DM: TDataModule},
  PasswordService in '..\core\PasswordService.pas',
  FileSystem in '..\utils\FileSystem.pas',
  Crypto in '..\utils\Crypto.pas',
  UIHelpers in '..\utils\UIHelpers.pas',
  SessionManager in '..\core\SessionManager.pas',
  UserStorage in '..\data\UserStorage.pas',
  UserTypes in '..\data\UserTypes.pas',
  PasswordForm in '..\forms\PasswordForm.pas' {PasswdForm},
  WelcomeForm in '..\forms\WelcomeForm.pas' {FormWelcome};

{$R *.res}

begin
  if sodium_init < 0 then
    raise Exception.Create('libsodium не инициализировалась');

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Modern Light');
  Application.ShowMainForm := False;
  Application.CreateForm(TFormWelcome, FormWelcome);
  Application.CreateForm(TAuthorizationForm, AuthorizationForm);
  Application.CreateForm(TRegistrationForm, RegistrationForm);
  Application.CreateForm(TSpreadsheetForm, SpreadsheetForm);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TPasswdForm, PasswdForm);
  Application.Run;
end.
