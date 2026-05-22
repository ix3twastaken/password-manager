unit WelcomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, dmImages, Vcl.Imaging.pngimage, UIHelpers;

type
  TFormWelcome = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StartBtn: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure StartBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  end;

var
  FormWelcome: TFormWelcome;

implementation

uses RegisterForm;

{$R *.dfm}

procedure TFormWelcome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TFormWelcome.StartBtnClick(Sender: TObject);
begin
  SwitchForms(RegistrationForm, Self);
end;

end.
