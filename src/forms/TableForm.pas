unit TableForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus, SessionManager;

type
  TSpreadsheetForm = class(TForm)
    DataStringGrid: TStringGrid;
    GroupBox1: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    SortAtoZBtn: TBitBtn;
    SortZtoABtn: TBitBtn;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    ActivityTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
    procedure ActivityTimerTimer(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
  public
  end;

var
  SpreadsheetForm: TSpreadsheetForm;

implementation

uses UIHelpers, AuthForm, AboutForm;

{$R *.dfm}

procedure TSpreadsheetForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;


procedure TSpreadsheetForm.FormCreate(Sender: TObject);
begin
  SetRowAndColumnNames(DataStringGrid);
  CalcColWidths(DataStringGrid, SpreadsheetForm);
end;


procedure TSpreadsheetForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TSessionManager.Instance.UpdateActivity;
end;


procedure TSpreadsheetForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  TSessionManager.Instance.UpdateActivity;
end;


procedure TSpreadsheetForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TSessionManager.Instance.UpdateActivity;
end;


procedure TSpreadsheetForm.FormResize(Sender: TObject);
begin
  CalcColWidths(DataStringGrid, SpreadsheetForm);
end;


procedure TSpreadsheetForm.N1Click(Sender: TObject);
begin
  FormAbout.Show;
  FormAbout.ShowInTaskBar := True;
end;


procedure TSpreadsheetForm.N5Click(Sender: TObject);
begin
  TSessionManager.Instance.LogOut;
  SwitchForms(AuthorizationForm, SpreadsheetForm);
  ActivityTimer.Enabled := False;
end;


procedure TSpreadsheetForm.ActivityTimerTimer(Sender: TObject);
begin

  if not TSessionManager.Instance.IsSessionActive then
    begin
      if FormAbout.Visible then
        FormAbout.Hide;
      ActivityTimer.Enabled := False;
      TSessionManager.Instance.LogOut;
      ShowError('Ваша сессия истекла', AuthorizationForm.ErrorsLabel);
      SwitchForms(AuthorizationForm, SpreadsheetForm);
    end;

end;
end.
