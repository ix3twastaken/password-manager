unit TableForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus;

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
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
  private
  public
  end;

var
  SpreadsheetForm: TSpreadsheetForm;

implementation

uses UI_Utils, AuthForm, AboutForm;

{$R *.dfm}

procedure TSpreadsheetForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TSpreadsheetForm.FormCreate(Sender: TObject);
begin
  DataStringGrid.Cells[1, 0] := 'Название сервиса';
  DataStringGrid.Cells[2, 0] := 'Логин';
  DataStringGrid.Cells[3, 0] := 'Пароль';
  DataStringGrid.Cells[4, 0] := 'Примечание';

  for var i := 1 to DataStringGrid.RowCount - 1 do
      DataStringGrid.Cells[0, i] := IntToStr(i);

  CalcColWidths(DataStringGrid, SpreadsheetForm);
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

end.
