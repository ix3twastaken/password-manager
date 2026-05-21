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
    procedure BtnShowPasswordClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure LabeledEditPasswordKeyPress(Sender: TObject; var Key: Char);
  private
  public
  end;

var
  PasswdForm: TPasswdForm;

implementation

{$R *.dfm}

uses UIHelpers, TableForm;

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

  if not CharInSet(Key, ['A'..'Z', 'a'..'z', '0'..'9',
    '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '-', '=']) then
    Key := #0;
end;

procedure TPasswdForm.BtnShowPasswordClick(Sender: TObject);
begin
  ShowPassword(LabeledEditPassword, BtnShowPassword);
end;

end.
