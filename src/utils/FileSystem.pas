unit FileSystem;

interface

uses System.SysUtils, System.IOUtils;

function CreateDirectory: string;

implementation

function CreateDirectory: string;
begin
  Result := TPath.GetHomePath;
  if not DirectoryExists(Result + '\Password Manager') then
    begin
      CreateDir(Result + '\Password Manager');
      Result := Result + '\Password Manager\users.dat';
    end
  else
    begin
      Result := Result + '\Password Manager\users.dat';
    end;
end;

end.
