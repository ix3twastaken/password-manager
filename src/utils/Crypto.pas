unit Crypto;

interface

uses System.RegularExpressions, System.SysUtils, System.IOUtils,
     Winapi.Windows, Vcl.Dialogs,
     Vcl.ExtCtrls, Sodium, BCrypt;


procedure DeriveMasterKey(const Password: AnsiString; const Salt: array of Byte; out Key: TBytes);
function SystemFunction036(Buffer: Pointer; Length: ULONG): BOOL; stdcall;
function GetRandomBytes(var Buffer: TBytes): Boolean;
function GeneratePassword(const Length: Integer): string;
function GenerateSalt: TBytes;
function GenerateNonce: TBytes;
procedure SecureZero(var Data: TBytes);
function Encrypt(
  const PlainText: TBytes;
  const Key: TBytes;
  const AAD: TBytes = nil
): TBytes;

function Decrypt(
  const Data: TBytes;
  const Key: TBytes;
  const AAD: TBytes = nil
): TBytes;

const
  NONCE_SIZE = crypto_aead_xchacha20poly1305_ietf_NPUBBYTES;

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


function GenerateNonce: TBytes;
begin
  SetLength(Result, NONCE_SIZE);
  randombytes_buf(@Result[0], NONCE_SIZE);
end;


procedure SecureZero(var Data: TBytes);
begin
  if Length(Data) > 0 then
    FillChar(Data[0], Length(Data), 0);
end;


function Encrypt(
  const PlainText: TBytes;
  const Key: TBytes;
  const AAD: TBytes
): TBytes;
var
  Nonce, Cipher: TBytes;
  CipherLen: UInt64;
  adPtr: PByte;
  Offset: Integer;
begin
  if Length(Key) <> crypto_aead_xchacha20poly1305_ietf_KEYBYTES then
    raise Exception.Create('Invalid key size');

  if Length(PlainText) = 0 then
    raise Exception.Create('Empty plaintext');

  Nonce := GenerateNonce;

  if Length(AAD) > 0 then
    adPtr := @AAD[0]
  else
    adPtr := nil;

  SetLength(Cipher, Length(PlainText) +
    crypto_aead_xchacha20poly1305_ietf_ABYTES);

  if crypto_aead_xchacha20poly1305_ietf_encrypt(
    @Cipher[0],
    @CipherLen,
    @PlainText[0],
    Length(PlainText),
    adPtr,
    Length(AAD),
    nil,
    @Nonce[0],
    @Key[0]
  ) <> 0 then
    raise Exception.Create('Encryption failed');

  SetLength(Cipher, CipherLen);

  SetLength(Result, NONCE_SIZE + Length(Cipher));

  Offset := 0;

  Move(Nonce[0], Result[Offset], NONCE_SIZE);
  Inc(Offset, NONCE_SIZE);

  Move(Cipher[0], Result[Offset], Length(Cipher));
end;


function Decrypt(
  const Data: TBytes;
  const Key: TBytes;
  const AAD: TBytes
): TBytes;
var
  Nonce, Cipher: TBytes;
  PlainLen: UInt64;
  adPtr: PByte;
  Offset: Integer;
begin
  if Length(Key) <> crypto_aead_xchacha20poly1305_ietf_KEYBYTES then
    raise Exception.Create('Invalid key size');

  if Length(Data) < NONCE_SIZE then
    raise Exception.Create('Invalid data');

  Offset := 0;

  SetLength(Nonce, NONCE_SIZE);
  Move(Data[Offset], Nonce[0], NONCE_SIZE);
  Inc(Offset, NONCE_SIZE);

  SetLength(Cipher, Length(Data) - Offset);
  Move(Data[Offset], Cipher[0], Length(Cipher));

  if Length(AAD) > 0 then
    adPtr := @AAD[0]
  else
    adPtr := nil;

  SetLength(Result, Length(Cipher));

  if crypto_aead_xchacha20poly1305_ietf_decrypt(
    @Result[0],
    @PlainLen,
    nil,
    @Cipher[0],
    Length(Cipher),
    adPtr,
    Length(AAD),
    @Nonce[0],
    @Key[0]
  ) <> 0 then
    raise Exception.Create('Decryption failed (corrupted or wrong key)');

  SetLength(Result, PlainLen);
end;

end.
