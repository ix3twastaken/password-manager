object SpreadsheetForm: TSpreadsheetForm
  Left = 0
  Top = 0
  Width = 880
  Height = 502
  VertScrollBar.Smooth = True
  VertScrollBar.Visible = False
  AutoScroll = True
  Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1087#1072#1088#1086#1083#1077#1081
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
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseMove = FormMouseMove
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object SearchGrid: TStringGrid
    Left = 0
    Top = 80
    Width = 859
    Height = 362
    Enabled = False
    RowCount = 2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Century Gothic'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs, goFixedRowDefAlign]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    OnKeyDown = SearchGridKeyDown
    OnMouseDown = SearchGridMouseDown
    OnSelectCell = SearchGridSelectCell
    OnSetEditText = SearchGridSetEditText
    ColWidths = (
      64
      227
      191
      190
      156)
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 864
    Height = 80
    Align = alTop
    TabOrder = 0
    DesignSize = (
      864
      80)
    object SortAtoZBtn: TBitBtn
      Left = 10
      Top = 12
      Width = 32
      Height = 32
      Hint = 
        #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1090#1072#1073#1083#1080#1094#1099'              '#13#10#1086#1090' '#1040' '#1076#1086' '#1071' '#1087#1086' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1084#1091'     '#13 +
        #10#1089#1090#1086#1083#1073#1094#1091'.'
      ImageIndex = 0
      ImageName = 'sort-amount-down'
      Images = DM.VirtImgSorting
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = SortAtoZBtnClick
    end
    object SortZtoABtn: TBitBtn
      Left = 48
      Top = 12
      Width = 32
      Height = 32
      Hint = 
        #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1090#1072#1073#1083#1080#1094#1099'              '#13#10#1086#1090' '#1071' '#1076#1086' '#1040' '#1087#1086' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1084#1091'     '#13 +
        #10#1089#1090#1086#1083#1073#1094#1091'.'
      ImageIndex = 1
      ImageName = 'sort-amount-up'
      Images = DM.VirtImgSorting
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = False
      OnClick = SortZtoABtnClick
    end
    object SearchEdit: TButtonedEdit
      AlignWithMargins = True
      Left = 638
      Top = 12
      Width = 216
      Height = 25
      Margins.Left = 12
      Margins.Top = 12
      Margins.Right = 10
      Margins.Bottom = 12
      TabStop = False
      Anchors = [akTop, akRight]
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Century Gothic'
      Font.Style = []
      Images = DM.VirtImgSearch
      LeftButton.ImageIndex = 1
      LeftButton.Visible = True
      ParentFont = False
      RightButton.ImageIndex = 0
      RightButton.Visible = True
      TabOrder = 2
      TextHint = #1055#1086#1080#1089#1082
      OnChange = SearchEditChange
      OnRightButtonClick = SearchEditRightButtonClick
    end
  end
  object DataStringGrid: TStringGrid
    Left = 0
    Top = 80
    Width = 859
    Height = 362
    RowCount = 2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Century Gothic'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs, goFixedRowDefAlign]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnKeyDown = DataStringGridKeyDown
    OnMouseDown = DataStringGridMouseDown
    OnSelectCell = DataStringGridSelectCell
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
    object MM_File: TMenuItem
      Caption = #1060#1072#1081#1083
      object MM_SaveFile: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ShortCut = 16467
        OnClick = MM_SaveFileClick
      end
    end
    object MM_Profile: TMenuItem
      Caption = #1055#1088#1086#1092#1080#1083#1100
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
