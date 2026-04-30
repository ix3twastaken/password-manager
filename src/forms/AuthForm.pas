unit AuthForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.RegularExpressions, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.Buttons;

type
  TAuthorizationForm = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    LabeledEditLogin: TLabeledEdit;
    LabeledEditPassword: TLabeledEdit;
    Button2: TButton;
    LinkLabel1: TLinkLabel;
    BtnShowPassword: TBitBtn;
    procedure LinkLabel1Click(Sender: TObject);
    procedure BtnShowPasswordClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LabeledEditLoginKeyPress(Sender: TObject; var Key: Char);
    procedure LabeledEditPasswordKeyPress(Sender: TObject; var Key: Char);
  private
  public
  end;

var
  AuthorizationForm: TAuthorizationForm;

implementation

uses RegistrForm, UI_Utils, TableForm;

{$R *.dfm}

procedure TAuthorizationForm.BtnShowPasswordClick(Sender: TObject);
begin
  ShowPassword(LabeledEditPassword, BtnShowPassword);
end;


procedure TAuthorizationForm.Button2Click(Sender: TObject);
begin
  SwitchForms(SpreadsheetForm, AuthorizationForm);
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


procedure TAuthorizationForm.LinkLabel1Click(Sender: TObject);
begin
  SwitchForms(RegistrationForm, AuthorizationForm);
end;
end.
