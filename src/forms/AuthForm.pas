unit AuthForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.RegularExpressions, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.Buttons, dmImages, SessionManager, UserStorage, FileSystem, WelcomeForm;

type
  TAuthorizationForm = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    LabeledEditLogin: TLabeledEdit;
    LabeledEditPassword: TLabeledEdit;
    Button2: TButton;
    LinkLabelRegister: TLinkLabel;
    BtnShowPassword: TBitBtn;
    ErrorsLabel: TLabel;
    procedure LinkLabelRegisterClick(Sender: TObject);
    procedure BtnShowPasswordClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LabeledEditLoginKeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEditPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  AuthorizationForm: TAuthorizationForm;

implementation

uses RegisterForm, UIHelpers, TableForm, PasswordService, Crypto;

{$R *.dfm}

procedure TAuthorizationForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and not WS_VISIBLE;
end;


procedure TAuthorizationForm.BtnShowPasswordClick(Sender: TObject);
begin
  ShowPassword(LabeledEditPassword, BtnShowPassword);
end;


procedure TAuthorizationForm.Button2Click(Sender: TObject);
var ErrorMessage: string;
begin
  ErrorMessage := ValidateAuthorization(LabeledEditPassword.Text,
                                        LabeledEditLogin.Text);
  if ErrorMessage <> '' then
    begin
      ShowError(ErrorMessage, ErrorsLabel);
      Exit;
    end
  else
    SwitchForms(SpreadsheetForm, AuthorizationForm);
    ClearLabeledEdits([LabeledEditLogin, LabeledEditPassword]);
    LoadFromFile(SpreadsheetForm.DataStringGrid);
    CalcColWidths(SpreadsheetForm.DataStringGrid, SpreadsheetForm);
    SpreadsheetForm.ActivityTimer.Enabled := True;
    SpreadsheetForm.SaveFileTimer.Enabled := True;
end;


procedure TAuthorizationForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TAuthorizationForm.FormCreate(Sender: TObject);
var Path: string;
begin
  Self.Hide;
  Path := CreateDirectory('users.dat');
  if FileExists(Path) then
    begin
      Self.Show;
      Self.ShowInTaskBar := True;
    end
  else
    FormWelcome.Show;
end;

procedure TAuthorizationForm.FormDestroy(Sender: TObject);
begin
  TSessionManager.Instance.Free;
end;

procedure TAuthorizationForm.LabeledEditLoginKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #8 then
    Exit;

  if not TRegEx.IsMatch(Key, '^[a-zA-Z0-9_]*$') then
    Key := #0;
end;


procedure TAuthorizationForm.LabeledEditPasswordKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #8 then
    Exit;

  if not TRegEx.IsMatch(Key, '^[a-zA-Z0-9!@#$%^&*()_+\-=]*$') then
    Key := #0;
end;


procedure TAuthorizationForm.LinkLabelRegisterClick(Sender: TObject);
begin
  SwitchForms(RegistrationForm, AuthorizationForm);
end;
end.
