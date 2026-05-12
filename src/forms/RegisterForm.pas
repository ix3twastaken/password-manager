unit RegisterForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.RegularExpressions, System.IOUtils, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.Buttons,
  dmImages;

type
  TRegistrationForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    LabeledEditLogin: TLabeledEdit;
    LabeledEditPassword1: TLabeledEdit;
    LabeledEditPassword2: TLabeledEdit;
    CreateProfileBtn: TButton;
    BtnShowPassword2: TBitBtn;
    BtnShowPassword1: TBitBtn;
    GeneratePasswordBtn: TButton;
    Label3: TLabel;
    ErrorsLabel: TLabel;
    BackToAuthBtn: TBitBtn;
    procedure BtnShowPassword1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CreateProfileBtnClick(Sender: TObject);
    procedure GeneratePasswordBtnClick(Sender: TObject);
    procedure LabeledEditLoginKeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEditPassword1KeyPress(Sender: TObject; var Key: Char);
    procedure BackToAuthBtnClick(Sender: TObject);
  private
  public
  end;


var
  RegistrationForm: TRegistrationForm;

implementation

uses AuthForm, TableForm, UIHelpers, PasswordService, Crypto;

{$R *.dfm}

procedure TRegistrationForm.BackToAuthBtnClick(Sender: TObject);
begin
  SwitchForms(AuthorizationForm, RegistrationForm);
end;


procedure TRegistrationForm.BtnShowPassword1Click(Sender: TObject);
begin
  ShowPassword(LabeledEditPassword1, BtnShowPassword1);
  ShowPassword(LabeledEditPassword2, BtnShowPassword2);
end;


procedure TRegistrationForm.CreateProfileBtnClick(Sender: TObject);
var ErrorMessage: string;
begin
  ErrorMessage := ValidateRegistration(LabeledEditPassword1.Text,
                                       LabeledEditPassword2.Text,
                                       LabeledEditLogin.Text);
  // Проверка правильно ли введены данные
  if ErrorMessage <> '' then
    begin
      ShowError(ErrorMessage, ErrorsLabel);
      Exit;
    end
  else
    // Вход в систему
    ErrorsLabel.Visible := False;
    UserRegistration(LabeledEditLogin.Text, LabeledEditPassword1.Text);
    ClearLabeledEdits([LabeledEditLogin, LabeledEditPassword1,
                                         LabeledEditPassword2]);
    if Application.MessageBox(
      'Регистрация завершена успешно!' + #13#10 +
      'Нажмите OK, чтобы начать работу.',
      'Успешная регистрация',
      MB_OK or MB_ICONINFORMATION
    ) = IDOK then
    begin
      SwitchForms(SpreadsheetForm, RegistrationForm);
      SpreadsheetForm.ActivityTimer.Enabled := True;
      SpreadsheetForm.SaveFileTimer.Enabled := True;
    end;
end;


procedure TRegistrationForm.GeneratePasswordBtnClick(Sender: TObject);
begin
  // Генерирует пароль до тех пор, пока он не будет соответствовать требованиям
  repeat
    LabeledEditPassword1.Text := GeneratePassword(16);
  until TRegEx.IsMatch(LabeledEditPassword1.Text,
  '^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=]).{16,}$'); // Требования к паролю
  LabeledEditPassword2.Text := LabeledEditPassword1.Text;
end;


procedure TRegistrationForm.LabeledEditLoginKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #8 then
    Exit;

  if not TRegEx.IsMatch(Key, '^[a-zA-Z0-9_]*$') then
    Key := #0;
end;


procedure TRegistrationForm.LabeledEditPassword1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #8 then
    Exit;

  if not TRegEx.IsMatch(Key, '^[a-zA-Z0-9!@#$%^&*()_+\-=]*$') then
    Key := #0;
end;


procedure TRegistrationForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Terminate;
end;


end.
