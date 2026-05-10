unit PasswordService;

interface

uses System.RegularExpressions, System.SysUtils,
     System.Generics.Collections,
     Winapi.Windows, Vcl.Dialogs,
     Vcl.ExtCtrls, BCrypt, Crypto, FileSystem, SessionManager;

type
    TUserRecord = record
    ID: Integer;
    Login: String[50];
    PasswordHash: String[60];
    KdfSalt: array[0..15] of Byte;
  end;

function IsUserExists(const Login: string): boolean;
function CheckUserCredentials(const UsersLogin, Password: string): boolean;
procedure UserRegistration(const UsersLogin, UsersPassword: string);
function ValidateRegistration(const password1, password2, login: string): string;
function ValidateAuthorization(const password, login: string): string;

implementation


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
      Exit(False);

    while not eof(UsersFile) do
      begin
        Read(UsersFile, User);
        with User do
          begin
            UsersList.Add(Login);
          end;
      end;

    if UsersList.Contains(Login) then
      Exit(True)
    else
      Exit(False);

  finally
    UsersList.Free;
    if FileOpened then
      CloseFile(UsersFile);
  end;
end;


function CheckUserCredentials(const UsersLogin, Password: string): boolean;
var
  passwordRehashNeeded: Boolean;
  FilePath: string;
  UsersFile: file of TUserRecord;
  User: TUserRecord;
  Key: TBytes;
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
                if passwordRehashNeeded then
                  begin
                    User.PasswordHash := TBCrypt.HashPassword(Password);

                    Seek(UsersFile, FilePos(UsersFile) - 1);
                    Write(UsersFile, User);
                  end;

                DeriveMasterKey(Password, User.KdfSalt, Key);
                TSessionManager.Instance.LogIn(Key);

                FillChar(Key[0], Length(Key), 0);
                SetLength(Key, 0);

                Exit(True);
              end;

            Exit(False);
          end;
      end;
  finally
    CloseFile(UsersFile);
  end;
end;


procedure UserRegistration(const UsersLogin, UsersPassword: string);
var
  UsersFile: file of TUserRecord;
  User: TUserRecord;
  FilePath: string;
  Salt, Key: TBytes;
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

    DeriveMasterKey(UsersPassword, User.KdfSalt, Key);
    TSessionManager.Instance.LogIn(Key);

    FillChar(Key[0], Length(Key), 0);
    SetLength(Key, 0);

    Write(UsersFile, User);
  finally
    if FileOpened then
      CloseFile(UsersFile);
  end;
end;


function ValidateRegistration(const password1, password2, login: string): string;
begin
  if ((password1 = '') or (password2 = '') or (login = '')) then
    Exit('Заполните все поля');

  if Length(login) < 5 then
    Exit('Логин должен быть не менее 5 символов');

  if IsUserExists(login) then
    Exit('Пользователь с таким логином уже существует');

  if password1 <> password2 then
    Exit('Пароли должны совпадать');

  if not TRegEx.IsMatch(password1, '^.{16,}$') then
    Exit('Пароль должен быть не менее 16 символов');

  if password1 = login then
    Exit('Пароль не должен совпадать с логином');

  if not TRegEx.IsMatch(password1, '[A-Z]') then
    Exit('Добавьте хотя бы одну заглавную букву');

  if not TRegEx.IsMatch(password1, '[a-z]') then
    Exit('Добавьте хотя бы одну строчную букву');

  if not TRegEx.IsMatch(password1, '\d') then
    Exit('Добавьте хотя бы одну цифру');

  if not TRegEx.IsMatch(password1, '[!@#$%^&*()_+\-=]') then
    Exit('Добавьте хотя бы один специальный символ');

  Result := '';
end;


function ValidateAuthorization(const password, login: string): string;
var FilePath: string;
begin
  FilePath := CreateDirectory();

  if ((password = '') or (login = '')) then
    Exit('Заполните все поля');

  if not FileExists(FilePath) then
    Exit('Профили отсутствуют. Создайте новый');

  if not CheckUserCredentials(login, password) then
    Exit('Неверный логин или пароль');

  Result := '';
end;


end.
