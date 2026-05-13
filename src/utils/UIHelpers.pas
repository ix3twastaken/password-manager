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
procedure AutoAddRow(Grid: TStringGrid; CurrentRow: LongInt);
procedure ClearGrid(Grid: TStringGrid);

implementation


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


procedure CalcColWidths(Grid: TStringGrid; Form: TForm);
const FirstCol = 24;
var WindowWidth, WindowHeight, ColumnCount: integer;
begin
  Grid.ColWidths[0] := FirstCol;
  WindowWidth := Form.ClientWidth;
  WindowHeight := Form.ClientHeight;
  ColumnCount := Grid.ColCount - 1;
  Grid.Width := WindowWidth;
  Grid.Height := WindowHeight - 105; //105 - высота GroupBox над Grid

  for var i := 1 to ColumnCount do
    Grid.ColWidths[i] := ((WindowWidth - FirstCol) div ColumnCount)-2;
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
    Grid.Cells[0, i] := IntToStr(i);
end;


procedure AutoAddRow(Grid: TStringGrid; CurrentRow: LongInt);
begin
  if CurrentRow = Grid.Rowcount - 1 then
    begin
      Grid.RowCount := Grid.RowCount + 1;
      Grid.Cells[3, CurrentRow] := '********';
      SetRowAndColumnNames(Grid);
    end;
end;


procedure ClearGrid(Grid: TStringGrid);
begin
  for var i := 1 to Grid.RowCount - 1 do
    Grid.Rows[i].Clear;
  Grid.RowCount := 5;
end;
end.
