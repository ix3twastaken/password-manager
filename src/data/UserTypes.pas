unit UserTypes;

interface

type
  TUserDataRecord = packed record
    ID: integer;
    ServiceName: string[255];
    Login: string[255];
    Password: string[255];
    Note: string[255];
  end;

  TUserRecord = packed record
    ID: Integer;
    Login: String[50];
    PasswordHash: String[60];
    KdfSalt: array[0..15] of Byte;
  end;

implementation

end.
