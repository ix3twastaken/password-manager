object RegistrationForm: TRegistrationForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsSingle
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1087#1088#1086#1092#1080#1083#1103
  ClientHeight = 330
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 15
  object Label1: TLabel
    AlignWithMargins = True
    Left = 136
    Top = 10
    Width = 326
    Height = 38
    Margins.Top = 10
    Margins.Bottom = 0
    Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1087#1088#1086#1092#1080#1083#1103
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Georgia'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 20
    Top = 106
    Width = 285
    Height = 139
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    AutoSize = False
    Caption = 
      '   '#8226' '#1053#1077' '#1084#1077#1085#1077#1077' 16 '#1089#1080#1084#1074#1086#1083#1086#1074';'#13#10'   '#8226' '#1047#1072#1075#1083#1072#1074#1085#1099#1077' '#1073#1091#1082#1074#1099' (A'#8211'Z);'#13#10'   '#8226' '#1057#1090 +
      #1088#1086#1095#1085#1099#1077' '#1073#1091#1082#1074#1099' (a'#8211'z);'#13#10'   '#8226' '#1062#1080#1092#1088#1099' (0'#8211'9);'#13#10'   '#8226' '#1057#1087#1077#1094#1080#1072#1083#1100#1085#1099#1077' '#1089#1080#1084#1074#1086#1083#1099 +
      ' (!, @, #, '#13#10'      $, %, ^, &&, *, (), _, +, -, =).'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label3: TLabel
    Left = 15
    Top = 69
    Width = 214
    Height = 23
    Caption = #1058#1088#1077#1073#1086#1074#1072#1085#1080#1103' '#1082' '#1087#1072#1088#1086#1083#1102':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 310
    Top = 69
    Width = 273
    Height = 241
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    TabOrder = 0
    object ErrorsLabel: TLabel
      Left = 108
      Top = 166
      Width = 56
      Height = 16
      Caption = 'ErrorsLabel'
      Color = clRed
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Century Gothic'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
      StyleElements = []
    end
    object LabeledEditLogin: TLabeledEdit
      Left = 41
      Top = 40
      Width = 191
      Height = 25
      EditLabel.Width = 39
      EditLabel.Height = 17
      EditLabel.Caption = #1051#1086#1075#1080#1085
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
      MaxLength = 50
      ParentFont = False
      TabOrder = 0
      Text = ''
      OnKeyPress = LabeledEditLoginKeyPress
    end
    object LabeledEditPassword1: TLabeledEdit
      Left = 41
      Top = 88
      Width = 185
      Height = 25
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
      TabOrder = 1
      Text = ''
      OnKeyPress = LabeledEditPassword1KeyPress
    end
    object LabeledEditPassword2: TLabeledEdit
      Left = 41
      Top = 136
      Width = 185
      Height = 25
      EditLabel.Width = 120
      EditLabel.Height = 17
      EditLabel.Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1077' '#1087#1072#1088#1086#1083#1100
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
      TabOrder = 2
      Text = ''
      OnKeyPress = LabeledEditPassword1KeyPress
    end
    object CreateProfileBtn: TButton
      Left = 92
      Top = 188
      Width = 89
      Height = 33
      Cursor = crHandPoint
      Caption = #1057#1086#1079#1076#1072#1090#1100
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Century Gothic'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CreateProfileBtnClick
    end
    object BtnShowPassword2: TBitBtn
      Left = 208
      Top = 136
      Width = 25
      Height = 25
      Cursor = crHandPoint
      ImageIndex = 1
      ImageName = 'show'
      Images = DM.VirtImgListPassword
      TabOrder = 4
      OnClick = BtnShowPassword1Click
    end
    object BtnShowPassword1: TBitBtn
      Left = 208
      Top = 88
      Width = 25
      Height = 25
      Cursor = crHandPoint
      ImageIndex = 1
      ImageName = 'show'
      Images = DM.VirtImgListPassword
      TabOrder = 5
      OnClick = BtnShowPassword1Click
    end
  end
  object GeneratePasswordBtn: TButton
    Left = 8
    Top = 252
    Width = 285
    Height = 41
    Cursor = crHandPoint
    Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1081' '#1087#1072#1088#1086#1083#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = GeneratePasswordBtnClick
  end
  object BackToAuthBtn: TBitBtn
    Left = 8
    Top = 8
    Width = 25
    Height = 25
    Cursor = crHandPoint
    ImageIndex = 0
    ImageName = 'left_arrow'
    Images = DM.VirtImgListOther
    TabOrder = 2
    OnClick = BackToAuthBtnClick
  end
end
