unit SessionManager;

interface

uses System.SysUtils, System.DateUtils, Vcl.Dialogs;

type
  TSessionState = class
    private
      FIsUnlocked: boolean;
      FLastActivity: TDateTime;
      FEncryptionKey: TBytes;
      FUserID: integer;
    public
      constructor Create;
      destructor Destroy; override;

      procedure ClearKey;
      procedure SetKey(const AKey: TBytes);

      property IsUnlocked: Boolean read FIsUnlocked write FIsUnlocked;
      property LastActivity: TDateTime read FLastActivity write FLastActivity;
      property UserID: integer read FUserID write FUserID;
  End;

  TSessionManager = class
    private
      class var FInstance: TSessionManager;

      FSession: TSessionState;
      FTimeOutMinutes: integer;
      constructor Create;
    public
      destructor Destroy; override;

      class function Instance: TSessionManager;

      procedure LogIn(const Key: TBytes; const ID: integer);
      procedure LogOut;

      function IsSessionActive: boolean;
      function GetUserID: integer;
      procedure UpdateActivity;

  end;


implementation

// TSessionState implementation

constructor TSessionState.Create;
begin
  inherited;
  FIsUnlocked := False;
  FLastActivity := 0;
  FEncryptionKey := nil;
  FUserID := -1;
  SetLength(FEncryptionKey, 0);
end;


destructor TSessionState.Destroy;
begin
  ClearKey;
  inherited;
end;

procedure TSessionState.SetKey(const AKey: TBytes);
begin
  ClearKey;
  FEncryptionKey := Copy(AKey);
end;


procedure TSessionState.ClearKey;
var
  i: integer;
begin
  for i := 0 to Length(FEncryptionKey) - 1 do
    FEncryptionKey[i] := 0;

  SetLength(FEncryptionKey, 0);
end;

// End of TSessionState implementation



// TSessionManager implementation

constructor TSessionManager.Create;
begin
  inherited;
  FSession := TSessionState.Create;
  FTimeOutMinutes := 10;
end;


destructor TSessionManager.Destroy;
begin
  FSession.Free;
  inherited;
end;


procedure TSessionManager.LogIn(const Key: TBytes; const ID: integer);
begin
  FSession.SetKey(Key);
  FSession.IsUnlocked := True;
  FSession.LastActivity := Now;
  FSession.UserId := ID;
end;


procedure TSessionManager.LogOut;
begin
  FSession.ClearKey;
  FSession.IsUnlocked := False;
  FSession.UserID := -1;
end;


function TSessionManager.IsSessionActive: Boolean;
begin
  Result := FSession.IsUnlocked and
            (SecondsBetween(Now, FSession.LastActivity) < FTimeOutMinutes * 60);

  if not Result then
    LogOut;
end;


procedure TSessionManager.UpdateActivity;
begin
  FSession.LastActivity := Now;
end;


function TSessionManager.GetUserID: integer;
begin
  Result := FSession.UserID;
end;


class function TSessionManager.Instance: TSessionManager;
begin
  if FInstance = nil then
    FInstance := TSessionManager.Create;

  Result := FInstance;
end;

// End of TSessionManager implementation

end.
