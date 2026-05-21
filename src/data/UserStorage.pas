unit UserStorage;

interface

uses System.SysUtils, System.IOUtils, System.Generics.Collections, System.UITypes, 
     System.Generics.Defaults, System.StrUtils, UserTypes, Vcl.Grids,
     SessionManager, FileSystem, Vcl.Dialogs, UIHelpers, Vcl.ExtCtrls, Crypto;

procedure SaveToFile(Grid: TStringGrid);
procedure LoadFromFile(Grid: TStringGrid);
procedure GetPasswdFromFile(LabeledEditPasswd: TLabeledEdit; Row: integer);
procedure SavePasswdToFile(LabeledEditPasswd: TLabeledEdit; Row: integer);
procedure SetPassword(var Rec: TUserDataRecord; const Data: TBytes);
function GetPassword(const Rec: TUserDataRecord): TBytes;
function CompareStrings(const S1, S2: string; Desc: boolean): Integer;
function CompareRecords(
  const L, R: TIndexedRecord;
  SortColumn: integer;
  Desc: boolean
): Integer;
procedure SortTList(
  {out}List: TList<TUserDataRecord>;
  SortColumn: integer;
  Desc: boolean
);
procedure FileToTList(out List: TList<TUserDataRecord>);
procedure TListToFile(List: TList<TUserDataRecord>);
procedure SortGrid(Grid: TStringGrid; Desc: Boolean);
procedure DoSearch(SearchGrid, Grid: TStringGrid; const Text: ShortString);


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

        Data.Key := StrToInt(Grid.Cells[0, Row]);
        Data.UserID := UserID;
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
    if Length(PasswdData) >= NONCE_SIZE then
      begin
        PasswdData := TSessionManager.Instance.DecryptData(PasswdData);
        LabeledEditPasswd.Text := StringOf(PasswdData);
      end
    else
      Exit;

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


function CompareStrings(const S1, S2: string; Desc: boolean): Integer;
var
  IsEmpty1, IsEmpty2: Boolean;
begin
  IsEmpty1 := S1.Trim.IsEmpty;
  IsEmpty2 := S2.Trim.IsEmpty;

  if IsEmpty1 and IsEmpty2 then
    Exit(0);

  if IsEmpty1 then
    Exit(1);

  if IsEmpty2 then
    Exit(-1);

  Result := CompareText(S1, S2);

  if Desc then
    Result := -Result;
end;


function CompareRecords(
  const L, R: TIndexedRecord;
  SortColumn: integer;
  Desc: Boolean
): Integer;
begin
  case SortColumn of
    1: Result := CompareStrings(L.Rec.ServiceName, R.Rec.ServiceName, Desc);
    2: Result := CompareStrings(L.Rec.Login, R.Rec.Login, Desc);
    4: Result := CompareStrings(L.Rec.Note, R.Rec.Note, Desc);
  else
    Result := 0;
  end;

  if Result = 0 then
    Result := L.OriginalIndex - R.OriginalIndex;

end;


procedure SortTList(
  List: TList<TUserDataRecord>;
  SortColumn: Integer;
  Desc: Boolean
);
var
  TempList: TList<TIndexedRecord>;
  i: Integer;
  Temp: TIndexedRecord;
begin
  TempList := TList<TIndexedRecord>.Create;
  try
    for i := 0 to List.Count - 1 do
      begin
        Temp.Rec := List[i];
        Temp.OriginalIndex := i;
        TempList.Add(Temp);
      end;

    TempList.Sort(
      TComparer<TIndexedRecord>.Construct(
        function(const L, R: TIndexedRecord): Integer
        begin
          Result := CompareRecords(L, R, SortColumn, Desc);
        end
      )
    );

    for i := 0 to TempList.Count - 1 do
      List[I] := TempList[i].Rec;

  finally
    TempList.Free;
  end;
end;

procedure FileToTList(out List: TList<TUserDataRecord>);
var
  DataFile: file of TUserDataRecord;
  Data: TUserDataRecord;
  Path: string;
begin
  List := TList<TUserDataRecord>.Create;
  Path := CreateDirectory('data_' + IntToStr(TSessionManager.Instance.GetUserID) + '.dat');

  if not FileExists(Path) then
    begin
      MessageDlg('Файл не существует', mtError, [mbOK], 0);
      Exit;
    end;

  AssignFile(DataFile, Path);
  Reset(DataFile);

  try
    while not eof(DataFile) do
      begin
        Read(DataFile, Data);
        List.Add(Data);
      end;
  finally
    CloseFile(DataFile);
  end;
end;


procedure TListToFile(List: TList<TUserDataRecord>);
var
  DataFile: file of TUserDataRecord;
  Data: TUserDataRecord;
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
    for var i := 0 to List.Count - 1 do
      begin
        Data := List[i];
        Write(DataFile, Data);
      end;
  finally
    List.Free;
    CloseFile(DataFile);
  end;
end;


procedure SortGrid(Grid: TStringGrid; Desc: Boolean);
var List: TList<TUserDataRecord>;
    SortColumn: Integer;
begin
  SortColumn := Grid.Col;

  if SortColumn = 3 then
    Exit;

  SaveToFile(Grid); //сохранение таблицы в файл
  FileToTList(List); //перенос данных из файла в TList<TUserDataRecord>
  SortTList(List, SortColumn, Desc); //вызов процедуры сортировки
  TListToFile(List); //сохранение TList<TUserDataRecord> в файл
  LoadFromFile(Grid); //загрузка из файла
end;


procedure DoSearch(SearchGrid, Grid: TStringGrid; const Text: ShortString);
var List: TList<TUserDataRecord>;
    Row, FoundCount: integer;
begin
  FoundCount := 1;
  if Text = '' then
    begin
      Grid.Enabled := True;
      SearchGrid.Enabled := False;
      SearchGrid.SendToBack;
      ClearGrid(SearchGrid);
      Exit;
    end
  else
    begin
      Grid.Enabled := False;
      SearchGrid.Enabled := True;
      SearchGrid.BringToFront;
      Row := 1;

      FileToTList(List);
      ClearGrid(SearchGrid);
      for var i := 0 to List.Count - 1 do
        begin
          if (ContainsText(List[i].ServiceName, Text) or
              ContainsText(List[i].Login, Text) or
              ContainsText(List[i].Note, Text)) then
            begin
              SearchGrid.Cells[0, Row] := IntToStr(List[i].Key);
              SearchGrid.Cells[1, Row] := List[i].ServiceName;
              SearchGrid.Cells[2, Row] := List[i].Login;
              SearchGrid.Cells[3, Row] := '********';
              SearchGrid.Cells[4, Row] := List[i].Note;
              Inc(FoundCount);
              Inc(Row);
            end;
        end;
      SearchGrid.RowCount := FoundCount;
      Exit;
    end;
  SearchGrid.RowCount := FoundCount + 1; // если ничего не найдено
end;
end.
