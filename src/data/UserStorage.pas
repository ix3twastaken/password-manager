unit UserStorage;

interface

uses System.SysUtils, System.IOUtils, System.Generics.Collections, System.UITypes, 
     UserTypes, Vcl.Grids, SessionManager, FileSystem, Vcl.Dialogs, UIHelpers,
     Vcl.ExtCtrls, Crypto;

procedure SaveToFile(Grid: TStringGrid);
procedure LoadFromFile(Grid: TStringGrid);
procedure GetPasswdFromFile(LabeledEditPasswd: TLabeledEdit; Row: integer);
procedure SavePasswdToFile(LabeledEditPasswd: TLabeledEdit; Row: integer);
procedure SetPassword(var Rec: TUserDataRecord; const Data: TBytes);
function GetPassword(const Rec: TUserDataRecord): TBytes;

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
        if Row - 1 < FileSize(DataFile) then
          begin
            Seek(DataFile, Row - 1);
            Read(DataFile, Data);
          end
        else
          begin
            FillChar(Data, SizeOf(Data), 0);
          end;

        Data.ID := UserID;
        Data.ServiceName := Grid.Cells[1, Row];
        Data.Login := Grid.Cells[2, Row];
        Data.Note := Grid.Cells[4, Row];

        Seek(DataFile, Row - 1);
        Write(DataFile, Data);
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


procedure GetPasswdFromFile(LabeledEditPasswd: TLabeledEdit; Row: integer);
var
  DataFile: file of TUserDataRecord;
  Data: TUserDataRecord;
  Path: string;
  PasswdData: TBytes;
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
    Seek(DataFile, Row-1);
    Read(DataFile, Data);

    PasswdData := GetPassword(Data);
    PasswdData := TSessionManager.Instance.DecryptData(PasswdData);
    LabeledEditPasswd.Text := StringOf(PasswdData);

  finally
    CloseFile(DataFile);
  end;
end;


procedure SavePasswdToFile(LabeledEditPasswd: TLabeledEdit; Row: integer);
var
  DataFile: file of TUserDataRecord;
  Data: TUserDataRecord;
  Path: string;
  PasswdData: TBytes;
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
    Seek(DataFile, Row-1);
    Read(DataFile, Data);

    PasswdData := BytesOf(LabeledEditPasswd.Text);
    PasswdData := TSessionManager.Instance.EncryptData(PasswdData);

    SetPassword(Data, PasswdData);

    Seek(DataFile, Row-1);
    Write(DataFile, Data);
  finally
    CloseFile(DataFile);
  end;
end;


procedure SetPassword(var Rec: TUserDataRecord; const Data: TBytes);
begin
  if Length(Data) > MAX_PASSWORD_SIZE then
    raise Exception.Create('Password too large');

  Rec.PasswordSize := Length(Data);

  if Length(Data) > 0 then
    Move(Data[0], Rec.Password[0], Length(Data));
end;


function GetPassword(const Rec: TUserDataRecord): TBytes;
begin
  SetLength(Result, Rec.PasswordSize);

  if Rec.PasswordSize > 0 then
    Move(Rec.Password[0], Result[0], Rec.PasswordSize);
end;
end.
