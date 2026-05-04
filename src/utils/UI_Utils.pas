unit UI_Utils;

interface

uses Vcl.Graphics,  Vcl.Forms, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls,
     Vcl.Buttons, dmImages;

procedure ShowPassword(Password: TLabeledEdit; Btn: TBitBtn);
procedure CalcColWidths(Grid: TStringGrid; Form: TForm);
procedure SwitchForms(FormToShow: TForm; FormToHide: TForm);
procedure ShowError(const ErrorMsg: string; ErrLabel: TLabel);
procedure ClearLabeledEdits(const Labeles: array of TLabeledEdit);

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
  WindowWidth := Form.Width;
  WindowHeight := Form.Height;
  ColumnCount := Grid.ColCount - 1;
  Grid.Width := WindowWidth;
  Grid.Height := WindowHeight - 105; //105 - высота GroupBox над Grid

  for var i := 1 to ColumnCount do
      Grid.ColWidths[i] := ((WindowWidth - FirstCol) div ColumnCount)-4;
end;


procedure SwitchForms(FormToShow: TForm; FormToHide: TForm);
begin
  FormToHide.Visible := False;
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
end.
