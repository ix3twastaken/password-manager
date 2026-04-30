program PasswordManager;

uses
  Vcl.Forms,
  AuthForm in '../forms/AuthForm.pas' {AuthorizationForm},
  Vcl.Themes,
  Vcl.Styles,
  RegistrForm in '../forms/RegistrForm.pas' {RegistrationForm},
  UI_Utils in '../utils/UI_Utils.pas',
  TableForm in '../forms/TableForm.pas' {SpreadsheetForm},
  AboutForm in '../forms/AboutForm.pas' {FormAbout},
  Security_Utils in '../utils/Security_Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Modern Light');
  Application.CreateForm(TAuthorizationForm, AuthorizationForm);
  Application.CreateForm(TRegistrationForm, RegistrationForm);
  Application.CreateForm(TSpreadsheetForm, SpreadsheetForm);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.Run;
end.
