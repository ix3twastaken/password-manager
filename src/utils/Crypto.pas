unit Crypto;

interface

uses System.RegularExpressions, System.SysUtils, System.IOUtils,
     Winapi.Windows, Vcl.Dialogs,
     Vcl.ExtCtrls, Sodium, BCrypt;

type
  TUserRecord = record
    ID: Integer;
    Login: String[50];
    PasswordHash: String[60];
    KdfSalt: array[0..15] of Byte;
  end;


procedure DeriveMasterKey(const Password: AnsiString; const Salt: array of Byte; out Key: TBytes);
function SystemFunction036(Buffer: Pointer; Length: ULONG): BOOL; stdcall;
function GetRandomBytes(var Buffer: TBytes): Boolean;
function GeneratePassword(const Length: Integer): string;
function GenerateSalt: TBytes;


implementation


procedure DeriveMasterKey(const Password: AnsiString; const Salt: array of Byte; out Key: TBytes);
begin
  SetLength(Key, 32); // 256-bit ключ

  if crypto_pwhash(
    @Key[0], Length(Key),
    PAnsiChar(Password), Length(Password),
    @Salt[0],
    3,                // opslimit
    64 * 1024 * 1024, // memlimit
    2 // crypto_pwhash_ALG_ARGON2ID13
  ) <> 0 then
    raise Exception.Create('Argon2 failed');
end;


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


function GenerateSalt: TBytes;
begin
  SetLength(Result, 16);
  randombytes_buf(@Result[0], Length(Result));
end;

end.
