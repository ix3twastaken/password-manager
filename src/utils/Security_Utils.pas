unit Security_Utils;

interface

uses System.RegularExpressions, System.SysUtils, System.IOUtils,
     Winapi.Windows, Vcl.Dialogs,
     Vcl.ExtCtrls, Sodium, BCrypt;

type
  TUserRecord = record
    ID: Integer;
    Login: String[50];
    PasswordHash: String[72];
    KdfSalt: array[0..15] of Byte;
  end;

function ValidatePassword(const password, login: string): string;
function SystemFunction036(Buffer: Pointer; Length: ULONG): BOOL; stdcall;
function GetRandomBytes(var Buffer: TBytes): Boolean;
function GeneratePassword(const Length: Integer): string;
function GenerateSalt: TBytes;
procedure UserRegistration(const UsersLogin, UsersPassword: string);

implementation


function SystemFunction036(Buffer: Pointer; Length: ULONG): BOOL; stdcall;
  external 'advapi32.dll' name 'SystemFunction036';


function GetRandomBytes(var Buffer: TBytes): Boolean;
begin
  Result := SystemFunction036(@Buffer[0], Length(Buffer));
end;


function GeneratePassword(const Length: Integer): string;
const
  Charset = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz' +
            '123456789!@#$%^&*()_+-=';
var
  Bytes: TBytes;
  I: Integer;
begin
  SetLength(Bytes, Length);

  if not GetRandomBytes(Bytes) then
    raise Exception.Create('Failed to get secure random data');

  SetLength(Result, Length);

  for I := 0 to Length - 1 do
    Result[I + 1] := Charset[(Bytes[I] mod System.Length(Charset)) + 1];
end;


function ValidatePassword(const password, login: string): string;
begin
  if not TRegEx.IsMatch(Password, '^.{16,}$') then
    begin
      Result := 'Пароль должен быть не менее 16 символов';
      Exit;
    end;

  if password = login then
    begin
      Result := 'Пароль не должен совпадать с логином';
      Exit;
    end;

  if not TRegEx.IsMatch(Password, '[A-Z]') then
    begin
      Result := 'Добавьте хотя бы одну заглавную букву';
      Exit;
    end;

  if not TRegEx.IsMatch(Password, '[a-z]') then
    begin
      Result := 'Добавьте хотя бы одну строчную букву';
      Exit;
    end;

  if not TRegEx.IsMatch(Password, '\d') then
    begin
      Result := 'Добавьте хотя бы одну цифру';
      Exit;
    end;

  if not TRegEx.IsMatch(Password, '[!@#$%^&*()_+\-=]') then
    begin
      Result := 'Добавьте хотя бы один специальный символ';
      Exit;
    end;
  Result := '';
end;


function GenerateSalt: TBytes;
begin
  SetLength(Result, 16);
  randombytes_buf(@Result[0], Length(Result));
end;


procedure UserRegistration(const UsersLogin, UsersPassword: string);
var
  UsersFile: file of TUserRecord;
  User: TUserRecord;
  FilePath: string;
  Salt: TBytes;
begin
  try
    FilePath := TPath.GetHomePath + '\users.dat';
    AssignFile(UsersFile, FilePath);

    if FileExists(FilePath) then
      Reset(UsersFile)
    else
      Rewrite(UsersFile);

    FillChar(User, SizeOf(User), 0);

    Seek(UsersFile, FileSize(UsersFile));
    Salt := GenerateSalt;

    with User do
      begin
        if FileSize(UsersFile) = 0 then
          ID := 1
        else
          ID := FileSize(UsersFile) + 1;
        Login := ShortString(UsersLogin);
        PasswordHash := TBCrypt.HashPassword(UTF8String(UsersPassword));
        Move(Salt[0], User.KdfSalt[0], 16);
      end;

    Write(UsersFile, User);
  finally
    CloseFile(UsersFile);
  end;
end;

end.
