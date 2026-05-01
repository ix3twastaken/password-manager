unit RegistrForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.RegularExpressions, Vcl.Graphics, Vcl.Controls,
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

uses AuthForm, UI_Utils, Security_Utils;

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
  ErrorMessage := ValidatePassword(LabeledEditPassword1.Text,
                                   LabeledEditLogin.Text);

  if ((LabeledEditLogin.Text = '') or
     (LabeledEditPassword1.Text = '') or
     (LabeledEditPassword2.Text = '')) then
    begin
      ShowError('Заполните все поля', ErrorsLabel);
      Exit;
    end;

  if Length(LabeledEditLogin.Text) < 5 then
    begin
      ShowError('Логин должен быть не менее 5 символов', ErrorsLabel);
      Exit;
    end;

  if LabeledEditPassword1.Text <> LabeledEditPassword2.Text then
    begin
      ShowError('Пароли должны совпадать', ErrorsLabel);
      Exit;
    end;

  if ErrorMessage <> '' then
    begin
      ShowError(ErrorMessage, ErrorsLabel);
      Exit;
    end
  else
    ErrorsLabel.Visible := False;
    //хэширование и сохранение в файл


end;


procedure TRegistrationForm.GeneratePasswordBtnClick(Sender: TObject);
begin
  repeat
    LabeledEditPassword1.Text := GeneratePassword(16);
  until ValidatePassword(LabeledEditPassword1.Text,
                         LabeledEditLogin.Text) = '';
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
