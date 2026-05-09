unit Sodium;

interface

uses
  System.SysUtils;

procedure randombytes_buf(buf: Pointer; size: NativeUInt); cdecl;
  external 'libsodium.dll';

function sodium_init: Integer; cdecl;
  external 'libsodium.dll';

function crypto_pwhash(outbuf: PByte; outlen: UInt64;
  passwd: PAnsiChar; passwdlen: UInt64;
  salt: PByte;
  opslimit: UInt64; memlimit: NativeUInt;
  alg: Integer): Integer; cdecl;
  external 'libsodium.dll';

implementation

end.
