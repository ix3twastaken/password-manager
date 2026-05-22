object AuthorizationForm: TAuthorizationForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsSingle
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 301
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClick = BtnShowPasswordClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Label1: TLabel
    AlignWithMargins = True
    Left = 38
    Top = 10
    Width = 226
    Height = 38
    Margins.Top = 10
    Margins.Bottom = 5
    Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Georgia'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 20
    Top = 58
    Width = 251
    Height = 223
    Margins.Left = 20
    Margins.Top = 5
    Margins.Right = 20
    Margins.Bottom = 20
    TabOrder = 0
    object ErrorsLabel: TLabel
      Left = 97
      Top = 142
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
      Left = 30
      Top = 43
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
    object LabeledEditPassword: TLabeledEdit
      Left = 30
      Top = 98
      Width = 168
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
      OnKeyPress = LabeledEditPasswordKeyPress
    end
    object Button2: TButton
      Left = 81
      Top = 164
      Width = 89
      Height = 33
      Cursor = crHandPoint
      Caption = #1042#1086#1081#1090#1080
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Century Gothic'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object LinkLabel1: TLinkLabel
      Left = 116
      Top = 123
      Width = 104
      Height = 20
      Cursor = crHandPoint
      Caption = '<a style="color: rgb(0,255,0)">'#1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1092#1080#1083#1100'</a>'
      Color = clBtnFace
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Century Gothic'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      TabOrder = 3
      OnClick = LinkLabel1Click
    end
    object BtnShowPassword: TBitBtn
      Left = 195
      Top = 98
      Width = 25
      Height = 25
      Cursor = crHandPoint
      ImageIndex = 1
      ImageName = 'show'
      Images = DM.VirtImgListPassword
      TabOrder = 4
      OnClick = BtnShowPasswordClick
    end
  end
end
