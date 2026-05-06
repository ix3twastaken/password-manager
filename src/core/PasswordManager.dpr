program PasswordManager;

uses
  Vcl.Forms,
  System.SysUtils,
  AuthForm in '..\forms\AuthForm.pas' {AuthorizationForm},
  Vcl.Themes,
  Vcl.Styles,
  UI_Utils in '..\utils\UI_Utils.pas',
  TableForm in '..\forms\TableForm.pas' {SpreadsheetForm},
  AboutForm in '..\forms\AboutForm.pas' {FormAbout},
  Security_Utils in '..\utils\Security_Utils.pas',
  dmImages in 'dmImages.pas' {DM: TDataModule},
  Bcrypt in '..\libs\bcrypt\Bcrypt.pas',
  Sodium in '..\libs\libsodium\Sodium.pas',
  RegisterForm in '..\forms\RegisterForm.pas' {RegistrationForm};

{$R *.res}

begin

  if sodium_init < 0 then
    raise Exception.Create('libsodium не инициализировалась');

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Modern Light');
  Application.CreateForm(TAuthorizationForm, AuthorizationForm);
  Application.CreateForm(TSpreadsheetForm, SpreadsheetForm);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TRegistrationForm, RegistrationForm);
  Application.Run;
end.
