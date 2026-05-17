unit Sodium;

interface

uses
  System.SysUtils;

const
  crypto_aead_xchacha20poly1305_ietf_KEYBYTES = 32;
  crypto_aead_xchacha20poly1305_ietf_NPUBBYTES = 24;
  crypto_aead_xchacha20poly1305_ietf_ABYTES = 16;

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

function crypto_aead_xchacha20poly1305_ietf_encrypt(
  c: PByte;
  clen_p: PUInt64;
  m: PByte;
  mlen: UInt64;
  ad: PByte;
  adlen: UInt64;
  nsec: PByte;
  npub: PByte;
  k: PByte
): Integer; cdecl;
  external 'libsodium.dll';

function crypto_aead_xchacha20poly1305_ietf_decrypt(
  m: PByte;
  mlen_p: PUInt64;
  nsec: PByte;
  c: PByte;
  clen: UInt64;
  ad: PByte;
  adlen: UInt64;
  npub: PByte;
  k: PByte
): Integer; cdecl;
  external 'libsodium.dll';

implementation

end.
