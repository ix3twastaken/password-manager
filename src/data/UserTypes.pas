unit UserTypes;

interface

uses System.SysUtils;

const
  MAX_PASSWORD_SIZE = 512;

type
  TUserDataRecord = packed record
    Key: integer;
    UserID: integer;
    ServiceName: string[255];
    Login: string[255];
    PasswordSize: UInt16;
    Password: array[0..MAX_PASSWORD_SIZE - 1] of Byte;
    Note: string[255];
  end;

  TUserRecord = packed record
    ID: Integer;
    Login: String[50];
    PasswordHash: String[60];
    KdfSalt: array[0..15] of Byte;
  end;

  TIndexedRecord = record
    Rec: TUserDataRecord;
    OriginalIndex: Integer;
  end;

implementation

end.
