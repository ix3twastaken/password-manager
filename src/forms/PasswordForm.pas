unit PasswordForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls;

type
  TPasswdForm = class(TForm)
    LabeledEditPassword: TLabeledEdit;
    BtnShowPassword: TBitBtn;
    DoneBtn: TBitBtn;
    procedure BtnShowPasswordClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
end;

procedure TPasswdForm.BtnShowPasswordClick(Sender: TObject);
begin
  ShowPassword(LabeledEditPassword, BtnShowPassword);
end;

procedure TPasswdForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PasswdFormHide(PasswdForm, SpreadsheetForm, LabeledEditPassword);
end;

end.
