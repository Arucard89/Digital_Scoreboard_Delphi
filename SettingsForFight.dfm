object FightSettings: TFightSettings
  Left = 435
  Top = 213
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086#1077#1076#1080#1085#1082#1072
  ClientHeight = 216
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 256
    Top = 32
    Width = 233
    Height = 24
    Caption = #1042#1088#1077#1084#1103' '#1087#1086#1077#1076#1080#1085#1082#1072' ('#1084#1080#1085'.):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ColorLabeledEdit: TLabeledEdit
    Left = 8
    Top = 104
    Width = 481
    Height = 32
    EditLabel.Width = 186
    EditLabel.Height = 20
    EditLabel.Caption = #1057#1087#1086#1088#1090#1089#1084#1077#1085' '#1074' '#1094#1074#1077#1090#1085#1086#1084
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object WhiteLabeledEdit: TLabeledEdit
    Left = 496
    Top = 104
    Width = 481
    Height = 32
    EditLabel.Width = 167
    EditLabel.Height = 20
    EditLabel.Caption = #1057#1087#1086#1088#1090#1089#1084#1077#1085' '#1074' '#1073#1077#1083#1086#1084
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object RoundTimeSpinEdit: TSpinEdit
    Left = 496
    Top = 32
    Width = 81
    Height = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MaxValue = 59
    MinValue = 1
    ParentFont = False
    TabOrder = 2
    Value = 5
  end
  object BitBtn1: TBitBtn
    Left = 720
    Top = 168
    Width = 105
    Height = 25
    TabOrder = 3
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 856
    Top = 168
    Width = 105
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    Kind = bkCancel
  end
end
