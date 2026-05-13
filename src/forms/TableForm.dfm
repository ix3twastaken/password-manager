object SpreadsheetForm: TSpreadsheetForm
  Left = 0
  Top = 0
  Width = 875
  Height = 501
  VertScrollBar.Smooth = True
  VertScrollBar.Visible = False
  AutoScroll = True
  Caption = #1058#1072#1073#1083#1080#1094#1072
  Color = clBtnFace
  Constraints.MinHeight = 360
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseMove = FormMouseMove
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 859
    Height = 105
    Align = alTop
    TabOrder = 0
    object LabeledEdit1: TLabeledEdit
      Left = 16
      Top = 40
      Width = 273
      Height = 23
      EditLabel.Width = 41
      EditLabel.Height = 17
      EditLabel.Caption = #1055#1086#1080#1089#1082
      EditLabel.Font.Charset = ANSI_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'Century Gothic'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      TabOrder = 0
      Text = ''
    end
    object SortAtoZBtn: TBitBtn
      Left = 312
      Top = 15
      Width = 32
      Height = 32
      TabOrder = 1
    end
    object SortZtoABtn: TBitBtn
      Left = 350
      Top = 15
      Width = 32
      Height = 32
      TabOrder = 2
    end
  end
  object DataStringGrid: TStringGrid
    Left = 0
    Top = 105
    Width = 834
    Height = 305
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Century Gothic'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goEditing, goTabs, goFixedRowDefAlign]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnSetEditText = DataStringGridSetEditText
    ColWidths = (
      64
      227
      191
      190
      156)
  end
  object MainMenu: TMainMenu
    Left = 808
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object MM_SaveFile: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ShortCut = 16467
        OnClick = MM_SaveFileClick
      end
    end
    object MM_Profile: TMenuItem
      Caption = #1055#1088#1086#1092#1080#1083#1100
      object MM_ChangePassword: TMenuItem
        Caption = #1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103
      end
      object MM_Exit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = MM_ExitClick
      end
    end
    object MM_About: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnClick = MM_AboutClick
    end
  end
  object ActivityTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = ActivityTimerTimer
    Left = 760
  end
  object SaveFileTimer: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = SaveFileTimerTimer
    Left = 712
  end
end
