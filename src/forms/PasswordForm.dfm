object PasswdForm: TPasswdForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1072#1088#1086#1083#1100
  ClientHeight = 140
  ClientWidth = 240
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 15
  object LabeledEditPassword: TLabeledEdit
    AlignWithMargins = True
    Left = 25
    Top = 45
    Width = 168
    Height = 25
    Margins.Left = 25
    Margins.Top = 45
    Margins.Right = 25
    Margins.Bottom = 25
    EditLabel.Width = 49
    EditLabel.Height = 17
    EditLabel.Caption = #1055#1072#1088#1086#1083#1100
    EditLabel.Font.Charset = ANSI_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -13
    EditLabel.Font.Name = 'Century Gothic'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Century Gothic'
    Font.Style = []
    MaxLength = 72
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 0
    Text = ''
  end
  object BtnShowPassword: TBitBtn
    AlignWithMargins = True
    Left = 190
    Top = 45
    Width = 25
    Height = 25
    Cursor = crHandPoint
    Margins.Left = 25
    Margins.Top = 45
    Margins.Right = 25
    Margins.Bottom = 25
    ImageIndex = 1
    ImageName = 'show'
    Images = DM.VirtImgListPassword
    TabOrder = 1
    OnClick = BtnShowPasswordClick
  end
  object DoneBtn: TBitBtn
    AlignWithMargins = True
    Left = 82
    Top = 95
    Width = 75
    Height = 30
    Margins.Left = 15
    Margins.Top = 15
    Margins.Right = 15
    Margins.Bottom = 15
    Caption = #1043#1086#1090#1086#1074#1086
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = DoneBtnClick
  end
end
