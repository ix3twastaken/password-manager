unit UserStorage;

interface

uses System.SysUtils, System.IOUtils, System.Generics.Collections, System.UITypes, 
     UserTypes, Vcl.Grids, SessionManager, FileSystem, Vcl.Dialogs, UIHelpers;

procedure SaveToFile(Grid: TStringGrid);
procedure LoadFromFile(Grid: TStringGrid);

implementation

procedure SaveToFile(Grid: TStringGrid);
var 
  DataFile: file of TUserDataRecord;
  Data: TUserDataRecord; 
  UserID, Row: integer; 
  Path: string;
begin
  UserID := TSessionManager.Instance.GetUserID;
  Path := CreateDirectory('data_' + IntToStr(UserID) + '.dat');
  
  try
    if not FileExists(Path) then
      CreateDataFile(UserID);
  
    Assign(DataFile, Path);
    Reset(DataFile);
    
    for Row := 1 to Grid.RowCount - 1 do
      begin
        Data.ID := UserID;

        if not ((Data.ServiceName = '') and 
                (Data.Login = '') and
                (Data.Note = '')) then
          begin
            Data.ServiceName := Grid.Cells[1, Row]; 
            Data.Login := Grid.Cells[2, Row];
            Data.Note := Grid.Cells[4, Row];

            Write(DataFile, Data);
          end
        else
          continue;
      end;

  finally
    CloseFile(DataFile);
  end;
end;


procedure LoadFromFile(Grid: TStringGrid);
var
  DataFile: file of TUserDataRecord;
  Data: TUserDataRecord;
  Row: Integer;
  Path: string;
begin
  Path := CreateDirectory('data_' + IntToStr(TSessionManager.Instance.GetUserID) + '.dat');

  if not FileExists(Path) then
    begin
      MessageDlg('Файл не существует', mtError, [mbOK], 0);
      Exit;
    end;

  AssignFile(DataFile, Path);
  Reset(DataFile);

  try
    Row := 1;

    Grid.RowCount := FileSize(DataFile) + 1;

    while not Eof(DataFile) do
      begin
        Read(DataFile, Data);

        Grid.Cells[1, Row] := Data.ServiceName;
        Grid.Cells[2, Row] := Data.Login;
        Grid.Cells[3, Row] := '********';
        Grid.Cells[4, Row] := Data.Note;

        Inc(Row);
      end;
    SetRowAndColumnNames(Grid);
  finally
    CloseFile(DataFile);
  end;
end;

end.
