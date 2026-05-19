unit TableForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus, SessionManager, UserStorage, dmImages;

type
  TSpreadsheetForm = class(TForm)
    GroupBox1: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    SortAtoZBtn: TBitBtn;
    SortZtoABtn: TBitBtn;
    MainMenu: TMainMenu;
    MM_About: TMenuItem;
    MM_Profile: TMenuItem;
    MM_ChangePassword: TMenuItem;
    MM_Exit: TMenuItem;
    ActivityTimer: TTimer;
    DataStringGrid: TStringGrid;
    N1: TMenuItem;
    MM_SaveFile: TMenuItem;
    SaveFileTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MM_AboutClick(Sender: TObject);
    procedure ActivityTimerTimer(Sender: TObject);
    procedure MM_ExitClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure MM_SaveFileClick(Sender: TObject);
    procedure SaveFileTimerTimer(Sender: TObject);
    procedure DataStringGridSetEditText(Sender: TObject; ACol, ARow: LongInt;
      const Value: string);
    procedure FormShow(Sender: TObject);
    procedure DataStringGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DataStringGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DataStringGridSelectCell(Sender: TObject; ACol, ARow: LongInt;
      var CanSelect: Boolean);
    procedure SortAtoZBtnClick(Sender: TObject);
    procedure SortZtoABtnClick(Sender: TObject);
  private
  public
  end;

var
  SpreadsheetForm: TSpreadsheetForm;

implementation

uses UIHelpers, AuthForm, AboutForm, PasswordForm;

{$R *.dfm}

procedure TSpreadsheetForm.DataStringGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then // Enter
    begin
      if DataStringGrid.Col = 3 then
        begin
          SaveToFile(DataStringGrid);
          PasswdFormShow(PasswdForm, SpreadsheetForm, PasswdForm.LabeledEditPassword, DataStringGrid.Row);
        end;
    end;

end;

procedure TSpreadsheetForm.DataStringGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  if ssDouble in Shift then
  begin
    DataStringGrid.MouseToCell(X, Y, Col, Row);

    if (Col = 3) and (Row > 0) then
      begin
        SaveToFile(DataStringGrid);
        PasswdFormShow(PasswdForm, SpreadsheetForm, PasswdForm.LabeledEditPassword, Row);
      end;
  end;
end;


procedure TSpreadsheetForm.DataStringGridSelectCell(Sender: TObject; ACol,
  ARow: LongInt; var CanSelect: Boolean);
begin
  if ACol = 3 then
    DataStringGrid.Options := DataStringGrid.Options - [goEditing]
  else
    DataStringGrid.Options := DataStringGrid.Options + [goEditing];
end;

procedure TSpreadsheetForm.DataStringGridSetEditText(Sender: TObject; ACol,
  ARow: LongInt; const Value: string);
begin
  AutoAddRow(DataStringGrid, ARow);
end;


procedure TSpreadsheetForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveToFile(DataStringGrid);
  Application.Terminate;
end;


procedure TSpreadsheetForm.FormCreate(Sender: TObject);
begin
  ClearGrid(DataStringGrid);
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


procedure TSpreadsheetForm.FormShow(Sender: TObject);
begin
  ClearGrid(DataStringGrid);
  SetRowAndColumnNames(DataStringGrid);
  CalcColWidths(DataStringGrid, SpreadsheetForm);
end;

procedure TSpreadsheetForm.MM_AboutClick(Sender: TObject);
begin
  FormAbout.Show;
  FormAbout.ShowInTaskBar := True;
end;


procedure TSpreadsheetForm.MM_ExitClick(Sender: TObject);
begin
  SaveToFile(DataStringGrid);
  TSessionManager.Instance.LogOut;
  SwitchForms(AuthorizationForm, SpreadsheetForm);
  ActivityTimer.Enabled := False;
  SaveFileTimer.Enabled := False;
  ShowError('', AuthorizationForm.ErrorsLabel);
end;


procedure TSpreadsheetForm.MM_SaveFileClick(Sender: TObject);
begin
  SaveToFile(DataStringGrid);
end;


procedure TSpreadsheetForm.SaveFileTimerTimer(Sender: TObject);
begin
  SaveToFile(DataStringGrid);
end;


procedure TSpreadsheetForm.SortAtoZBtnClick(Sender: TObject);
begin
  SortGrid(DataStringGrid, False);
end;

procedure TSpreadsheetForm.SortZtoABtnClick(Sender: TObject);
begin
  SortGrid(DataStringGrid, True);
end;

procedure TSpreadsheetForm.ActivityTimerTimer(Sender: TObject);
begin
  if not TSessionManager.Instance.IsSessionActive then
    begin
      if FormAbout.Visible then
        FormAbout.Hide;
      SaveToFile(DataStringGrid);
      ActivityTimer.Enabled := False;
      SaveFileTimer.Enabled := False;
      TSessionManager.Instance.LogOut;
      ShowError('Ваша сессия истекла', AuthorizationForm.ErrorsLabel);
      SwitchForms(AuthorizationForm, SpreadsheetForm);
    end;
end;



end.
