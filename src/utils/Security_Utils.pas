unit Security_Utils;

interface

uses System.RegularExpressions, System.SysUtils, System.IOUtils,
     System.Generics.Collections,
     Winapi.Windows, Vcl.Dialogs,
     Vcl.ExtCtrls, Sodium, BCrypt;

type
  TUserRecord = record
    ID: Integer;
    Login: String[50];
    PasswordHash: String[60];
    KdfSalt: array[0..15] of Byte;
  end;

function ValidateRegistration(const password1, password2, login: string): string;
function ValidateAuthorization(const password, login: string): string;
function SystemFunction036(Buffer: Pointer; Length: ULONG): BOOL; stdcall;
function GetRandomBytes(var Buffer: TBytes): Boolean;
function IsUserExists(const Login: string): boolean;
function GeneratePassword(const Length: Integer): string;
function GenerateSalt: TBytes;
function CreateDirectory: string;
function CheckUserCredentials(const UsersLogin, Password: string): boolean;
procedure UserRegistration(const UsersLogin, UsersPassword: string);


implementation


function SystemFunction036(Buffer: Pointer; Length: ULONG): BOOL; stdcall;
  external 'advapi32.dll' name 'SystemFunction036';


function GetRandomBytes(var Buffer: TBytes): Boolean;
begin
  Result := SystemFunction036(@Buffer[0], Length(Buffer));
end;


function IsUserExists(const Login: string): boolean;
var
  UsersFile: file of TUserRecord;
  User: TUserRecord;
  FilePath: string;
  UsersList: TList<string>;
  FileOpened: boolean;
begin
  FileOpened := False;
  UsersList := TList<string>.Create;
  try
    FilePath := CreateDirectory();
    AssignFile(UsersFile, FilePath);

    if FileExists(FilePath) then
      begin
        Reset(UsersFile);
        FileOpened := True;
      end
    else
      begin
        Result := False;
        Exit;
      end;

    while not eof(UsersFile) do
      begin
        Read(UsersFile, User);
        with User do
          begin
            UsersList.Add(Login);
          end;
      end;

    if UsersList.Contains(Login) then
      Result := True
    else
      Result := False;

  finally
    UsersList.Free;
    if FileOpened then
      CloseFile(UsersFile);
  end;
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


function ValidateRegistration(const password1, password2, login: string): string;
begin
  if ((password1 = '') or (password2 = '') or (login = '')) then
    begin
      Result := 'Заполните все поля';
      Exit;
    end;

  if Length(login) < 5 then
    begin
      Result := 'Логин должен быть не менее 5 символов';
      Exit;
    end;

  if IsUserExists(login) then
    begin
      Result := 'Пользователь с таким логином уже существует';
      Exit;
    end;

  if password1 <> password2 then
    begin
      Result := 'Пароли должны совпадать';
      Exit;
    end;

  if not TRegEx.IsMatch(password1, '^.{16,}$') then
    begin
      Result := 'Пароль должен быть не менее 16 символов';
      Exit;
    end;

  if password1 = login then
    begin
      Result := 'Пароль не должен совпадать с логином';
      Exit;
    end;

  if not TRegEx.IsMatch(password1, '[A-Z]') then
    begin
      Result := 'Добавьте хотя бы одну заглавную букву';
      Exit;
    end;

  if not TRegEx.IsMatch(password1, '[a-z]') then
    begin
      Result := 'Добавьте хотя бы одну строчную букву';
      Exit;
    end;

  if not TRegEx.IsMatch(password1, '\d') then
    begin
      Result := 'Добавьте хотя бы одну цифру';
      Exit;
    end;

  if not TRegEx.IsMatch(password1, '[!@#$%^&*()_+\-=]') then
    begin
      Result := 'Добавьте хотя бы один специальный символ';
      Exit;
    end;

  Result := '';
end;


function CheckUserCredentials(const UsersLogin, Password: string): boolean;
var
  passwordRehashNeeded: Boolean;
  FilePath: string;
  UsersFile: file of TUserRecord;
  User: TUserRecord;
begin
  Result := False;

  FilePath := CreateDirectory();
  if not FileExists(FilePath) then
    Exit(False);

  AssignFile(UsersFile, FilePath);
  Reset(UsersFile);
  try
    while not EOF(UsersFile) do
    begin
      Read(UsersFile, User);

      if User.Login = UsersLogin then
      begin

        if TBCrypt.CheckPassword(Password, User.PasswordHash, passwordRehashNeeded) then
        begin
          Result := True;

          if passwordRehashNeeded then
          begin
            User.PasswordHash := TBCrypt.HashPassword(Password);

            Seek(UsersFile, FilePos(UsersFile) - 1);
            Write(UsersFile, User);
          end;

          Exit(True);
        end;

        Exit(False);
      end;
    end;

    Result := False;
  finally
    CloseFile(UsersFile);
  end;
end;


function ValidateAuthorization(const password, login: string): string;
var FilePath: string;
begin
  FilePath := CreateDirectory();

  if ((password = '') or (login = '')) then
    begin
      Result := 'Заполните все поля';
      Exit;
    end;

  if not FileExists(FilePath) then
    begin
      Result := 'Профили отсутствуют. Создайте новый';;
      Exit;
    end;

  if not CheckUserCredentials(login, password) then
    begin
      Result := 'Неверный логин или пароль';
      Exit;
    end;

  Result := '';
end;


function GenerateSalt: TBytes;
begin
  SetLength(Result, 16);
  randombytes_buf(@Result[0], Length(Result));
end;


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


procedure UserRegistration(const UsersLogin, UsersPassword: string);
var
  UsersFile: file of TUserRecord;
  User: TUserRecord;
  FilePath: string;
  Salt: TBytes;
  FileOpened: boolean;
begin
  FileOpened := False;
  try
    FilePath := CreateDirectory();
    AssignFile(UsersFile, FilePath);

    if FileExists(FilePath) then
      begin
        FileOpened := True;
        Reset(UsersFile);
      end
    else
      begin
        Rewrite(UsersFile);
        FileOpened := True;
      end;

    FillChar(User, SizeOf(User), 0);

    Seek(UsersFile, FileSize(UsersFile));
    Salt := GenerateSalt;

    with User do
      begin
        if FileSize(UsersFile) = 0 then
          ID := 1
        else
          ID := FileSize(UsersFile) + 1;
        Login := UsersLogin;
        PasswordHash := TBCrypt.HashPassword(UsersPassword);
        Move(Salt[0], User.KdfSalt[0], 16);
      end;

    Write(UsersFile, User);
  finally
    if FileOpened then
      CloseFile(UsersFile);
  end;
end;

end.
