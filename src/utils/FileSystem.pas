unit FileSystem;

interface

uses System.SysUtils, System.IOUtils, UserTypes;


function CreateDirectory(FileName: string): string;
procedure CreateDataFile(UserID: integer);


implementation

function CreateDirectory(FileName: string): string;
begin
  Result := TPath.GetHomePath;
  if not DirectoryExists(Result + '\Password Manager') then
    begin
      CreateDir(Result + '\Password Manager');
      Result := Result + '\Password Manager\' + FileName;
    end
  else
    begin
      Result := Result + '\Password Manager\' + FileName;
    end;
end;


procedure CreateDataFile(UserID: integer);
var Path: string;
    DataFile: file of TUserDataRecord;
    Data: TUserDataRecord;
begin
  try
    Path := CreateDirectory('data_' + IntToStr(UserID) + '.dat');
    Assign(DataFile, Path);
    Rewrite(DataFile);
  finally
    CloseFile(DataFile);
  end;
end;

end.
