unit UIHelpers;

interface

uses System.SysUtils, Vcl.Graphics,  Vcl.Forms, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls,
     Vcl.Buttons, dmImages, WinApi.Windows;

procedure ShowPassword(Password: TLabeledEdit; Btn: TBitBtn);
procedure CalcColWidths(Grid: TStringGrid; Form: TForm);
procedure SwitchForms(FormToShow: TForm; FormToHide: TForm);
procedure ShowError(const ErrorMsg: string; ErrLabel: TLabel);
procedure ClearLabeledEdits(const Labeles: array of TLabeledEdit);
procedure SetRowAndColumnNames(Grid: TStringGrid);
procedure AutoAddRow(Form: TForm; Grid: TStringGrid; CurrentRow: LongInt);
procedure ClearGrid(Grid: TStringGrid);
procedure PasswdFormShow(PasswdForm: TForm; ParentForm: TForm; LabeledEditPasswd: TLabeledEdit; CurrentRow: LongInt);
procedure PasswdFormHide(PasswdForm: TForm; ParentForm: TForm; LabeledEditPasswd: TLabeledEdit);

implementation

uses UserStorage;

var Row: LongInt = 1;

procedure ShowError(const ErrorMsg: string; ErrLabel: TLabel);
begin
  ErrLabel.Caption := ErrorMsg;
  ErrLabel.Visible := True;
  ErrLabel.Left := (ErrLabel.Parent.Width - ErrLabel.Width) div 2;
end;


procedure ShowPassword(Password: TLabeledEdit; Btn: TBitBtn);
begin
  Btn.Images := DM.VirtImgListPassword;

  if Password.PasswordChar = #0 then
  begin
    Password.PasswordChar := '*';
    Btn.ImageName := 'show';
  end
  else
  begin
    Password.PasswordChar := #0;
    Btn.ImageName := 'hide';
  end;
end;


function IsVerticalScrollVisible(Grid: TStringGrid): Boolean;
var
  Info: TScrollInfo;
begin
  Info.cbSize := SizeOf(Info);
  Info.fMask := SIF_ALL;

  GetScrollInfo(Grid.Handle, SB_VERT, Info);

  Result := Info.nMax > Integer(Info.nPage);
end;


procedure CalcColWidths(Grid: TStringGrid; Form: TForm);
const
  FirstCol = 24;
var
  AvailableWidth: Integer;
  ScrollWidth: Integer;
  ResizableCols: Integer;
  ColWidth: Integer;
  Remainder: Integer;
begin
  Grid.ColWidths[0] := FirstCol;

  Grid.Width := Form.ClientWidth;
  Grid.Height := Form.ClientHeight - 80;

  if IsVerticalScrollVisible(Grid) then
    ScrollWidth := GetSystemMetrics(SM_CXVSCROLL) - 17
  else
    ScrollWidth := 0;

  ResizableCols := Grid.ColCount - 1;

  AvailableWidth :=
    Grid.ClientWidth
    - FirstCol
    - ScrollWidth
    - (ResizableCols * Grid.GridLineWidth)
    - 1;

  ColWidth := AvailableWidth div ResizableCols;
  Remainder := AvailableWidth mod ResizableCols;

  for var i := 1 to ResizableCols do
    Grid.ColWidths[I] := ColWidth;

  Grid.ColWidths[ResizableCols] :=
    Grid.ColWidths[ResizableCols] + Remainder;
end;

procedure SwitchForms(FormToShow: TForm; FormToHide: TForm);
begin
  FormToHide.Hide;
  FormToShow.ShowInTaskBar := True;
  FormToShow.Show;
  FormToShow.SetFocus;
end;


procedure ClearLabeledEdits(const Labeles: array of TLabeledEdit);
var Lbl: TLabeledEdit;
begin
  for Lbl in Labeles do
    Lbl.Clear;
end;


procedure SetRowAndColumnNames(Grid: TStringGrid);
begin
  Grid.Cells[1, 0] := 'Название сервиса';
  Grid.Cells[2, 0] := 'Логин';
  Grid.Cells[3, 0] := 'Пароль';
  Grid.Cells[4, 0] := 'Примечание';

  for var i := 1 to Grid.RowCount - 1 do
    begin
      Grid.Cells[0, i] := IntToStr(i);
      Grid.Cells[3, i] := '********';
    end;
end;


procedure AutoAddRow(Form: TForm; Grid: TStringGrid; CurrentRow: LongInt);
begin
  if CurrentRow = Grid.Rowcount - 1 then
    begin
      Grid.RowCount := Grid.RowCount + 1;
      Grid.Cells[3, CurrentRow] := '********';
      SetRowAndColumnNames(Grid);
      CalcColWidths(Grid, Form);
    end;
end;


procedure ClearGrid(Grid: TStringGrid);
begin
  for var i := 1 to Grid.RowCount - 1 do
    Grid.Rows[i].Clear;
  Grid.RowCount := 2;
end;


procedure PasswdFormShow(PasswdForm: TForm; ParentForm: TForm; LabeledEditPasswd: TLabeledEdit; CurrentRow: LongInt);
begin
  Row := CurrentRow;
  ParentForm.Enabled := False;
  PasswdForm.Show;
  GetPasswdFromFile(LabeledEditPasswd, CurrentRow);
end;


procedure PasswdFormHide(PasswdForm: TForm; ParentForm: TForm; LabeledEditPasswd: TLabeledEdit);
begin
  if LabeledEditPasswd.Text = '' then
    begin
      PasswdForm.Hide;
      ParentForm.Enabled := True;
      ParentForm.SetFocus;
    end
  else
    begin
      SavePasswdToFile(LabeledEditPasswd, Row);
      LabeledEditPasswd.Text := '';
      PasswdForm.Hide;
      ParentForm.Enabled := True;
      ParentForm.SetFocus;
    end;
end;
end.
