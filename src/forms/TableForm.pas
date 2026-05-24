unit TableForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus, SessionManager, UserStorage, dmImages;

type
  TSpreadsheetForm = class(TForm)
    GroupBox1: TGroupBox;
    SortAtoZBtn: TBitBtn;
    SortZtoABtn: TBitBtn;
    MainMenu: TMainMenu;
    MM_About: TMenuItem;
    MM_Profile: TMenuItem;
    MM_Exit: TMenuItem;
    ActivityTimer: TTimer;
    DataStringGrid: TStringGrid;
    N1: TMenuItem;
    MM_SaveFile: TMenuItem;
    SaveFileTimer: TTimer;
    SearchEdit: TButtonedEdit;
    SearchGrid: TStringGrid;
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
    procedure SearchEditChange(Sender: TObject);
    procedure SearchGridSelectCell(Sender: TObject; ACol, ARow: LongInt;
      var CanSelect: Boolean);
    procedure SearchGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SearchEditRightButtonClick(Sender: TObject);
    procedure SearchGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchGridSetEditText(Sender: TObject; ACol, ARow: LongInt;
      const Value: string);
  private
     procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
  end;

var
  SpreadsheetForm: TSpreadsheetForm;

implementation

uses UIHelpers, AuthForm, AboutForm, PasswordForm;

{$R *.dfm}

procedure TSpreadsheetForm.WMSysCommand(var Msg: TWMSysCommand);
begin
  inherited;

  if (Msg.CmdType = SC_RESTORE) or (Msg.CmdType = SC_MAXIMIZE) then
  begin
    Self.Realign;
    SearchEdit.Invalidate;
  end;
end;


procedure TSpreadsheetForm.SearchEditChange(Sender: TObject);
begin
  SaveToFile(DataStringGrid);
  DoSearch(SearchGrid, DataStringGrid, SearchEdit.Text);
end;

procedure TSpreadsheetForm.SearchEditRightButtonClick(Sender: TObject);
begin
  SearchEdit.Text := '';
end;

procedure TSpreadsheetForm.SearchGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Row: integer;
begin
  Row := SearchGrid.Row;
  if (Key = VK_RETURN) then // Enter
    begin
      if SearchGrid.Col = 3 then
        begin
          SaveToFile(DataStringGrid);
          PasswdFormShow(PasswdForm, SpreadsheetForm, PasswdForm.LabeledEditPassword, StrToInt(SearchGrid.Cells[0, Row]));
        end;
    end;
end;

procedure TSpreadsheetForm.SearchGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  if Button = mbLeft then
    begin
      SearchGrid.MouseToCell(X, Y, Col, Row);
      Row := SearchGrid.Row;
      if (Col = 3) and (Row > 0) then
        begin
          SaveToFile(DataStringGrid);
          PasswdFormShow(PasswdForm, SpreadsheetForm, PasswdForm.LabeledEditPassword, StrToInt(SearchGrid.Cells[0, Row]));
        end;
    end;
end;

procedure TSpreadsheetForm.SearchGridSelectCell(Sender: TObject; ACol,
  ARow: LongInt; var CanSelect: Boolean);
begin
  if ACol = 3 then
    SearchGrid.Options := SearchGrid.Options - [goEditing]
  else
    SearchGrid.Options := SearchGrid.Options + [goEditing];
end;

procedure TSpreadsheetForm.SearchGridSetEditText(Sender: TObject; ACol,
  ARow: LongInt; const Value: string);
var Row: integer;
begin
  TryStrToInt(SearchGrid.Cells[0, ARow], Row);
  UpdateSearchRow(SearchGrid, DataStringGrid, Row, ARow);
end;

procedure TSpreadsheetForm.DataStringGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Row: integer;
begin
  Row := DataStringGrid.Row;
  if (Key = VK_RETURN) then // Enter
    begin
      if DataStringGrid.Col = 3 then
        begin
          SaveToFile(DataStringGrid);
          PasswdFormShow(PasswdForm, SpreadsheetForm, PasswdForm.LabeledEditPassword, StrToInt(DataStringGrid.Cells[0, Row]));
        end;
    end;
end;

procedure TSpreadsheetForm.DataStringGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  if Button = mbLeft then
    begin
      DataStringGrid.MouseToCell(X, Y, Col, Row);
      Row := DataStringGrid.Row;
      if (Col = 3) and (Row > 0) then
        begin
          SaveToFile(DataStringGrid);
          PasswdFormShow(PasswdForm, SpreadsheetForm, PasswdForm.LabeledEditPassword, StrToInt(DataStringGrid.Cells[0, Row]));
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
  AutoAddRow(Self, DataStringGrid, ARow);
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
  SetRowAndColumnNames(SearchGrid);
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
  CalcColWidths(SearchGrid, SpreadsheetForm);
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
  SearchEdit.Text := '';
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
