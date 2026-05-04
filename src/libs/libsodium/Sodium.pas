unit Sodium;

interface

uses
  System.SysUtils;

procedure randombytes_buf(buf: Pointer; size: NativeUInt); cdecl;
  external 'libsodium.dll';

function sodium_init: Integer; cdecl;
  external 'libsodium.dll';

implementation

end.
