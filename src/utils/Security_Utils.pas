unit Security_Utils;

interface

uses System.RegularExpressions, System.SysUtils, Winapi.Windows, Vcl.Dialogs;

function ValidatePassword(const password, login: string): string;
function SystemFunction036(Buffer: Pointer; Length: ULONG): BOOL; stdcall;
function GetRandomBytes(var Buffer: TBytes): Boolean;
function GeneratePassword(const Length: Integer): string;

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

end.
