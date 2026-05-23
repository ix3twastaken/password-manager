unit PasswordForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, System.RegularExpressions, dmImages;

type
  TPasswdForm = class(TForm)
    LabeledEditPassword: TLabeledEdit;
    BtnShowPassword: TBitBtn;
    DoneBtn: TBitBtn;
    LinkLabel1: TLinkLabel;
    procedure BtnShowPasswordClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure LabeledEditPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure LinkLabel1Click(Sender: TObject);
  private
  public
  end;

var
  PasswdForm: TPasswdForm;

implementation

{$R *.dfm}

uses UIHelpers, TableForm, PasswordService;

procedure TPasswdForm.DoneBtnClick(Sender: TObject);
begin
  PasswdFormHide(PasswdForm, SpreadsheetForm, LabeledEditPassword);
  BtnShowPassword.Images := DM.VirtImgListPassword;

  if LabeledEditPassword.PasswordChar = #0 then
    begin
      LabeledEditPassword.PasswordChar := '*';
      BtnShowPassword.ImageName := 'show';
    end;
end;


procedure TPasswdForm.LabeledEditPasswordKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #8 then
    Exit;

  if Key = #13 then
    begin
      PasswdFormHide(PasswdForm, SpreadsheetForm, LabeledEditPassword);
      BtnShowPassword.Images := DM.VirtImgListPassword;

      if LabeledEditPassword.PasswordChar = #0 then
        begin
          LabeledEditPassword.PasswordChar := '*';
          BtnShowPassword.ImageName := 'show';
        end;

      Exit;
    end;

  if not CharInSet(Key, ['A'..'Z', 'a'..'z', '0'..'9',
    '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '-', '=']) then
    Key := #0;
end;

procedure TPasswdForm.LinkLabel1Click(Sender: TObject);
begin
  repeat
    LabeledEditPassword.Text := GeneratePassword(16);
  until TRegEx.IsMatch(LabeledEditPassword.Text,
  '^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=]).{16,}$'); // Требования к паролю
end;

procedure TPasswdForm.BtnShowPasswordClick(Sender: TObject);
begin
  ShowPassword(LabeledEditPassword, BtnShowPassword);
end;

end.
