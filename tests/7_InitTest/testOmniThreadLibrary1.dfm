object frmTestOTL: TfrmTestOTL
  Left = 0
  Top = 0
  Caption = 'OmniThreadLibrary tester'
  ClientHeight = 286
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbLog: TListBox
    Left = 104
    Top = 0
    Width = 322
    Height = 286
    Align = alRight
    ItemHeight = 13
    TabOrder = 0
  end
  object btnTestSuccess: TButton
    Left = 8
    Top = 8
    Width = 90
    Height = 25
    Caption = 'Successful init'
    TabOrder = 1
    OnClick = btnTestSuccessClick
  end
  object btnTestFailure: TButton
    Left = 8
    Top = 39
    Width = 90
    Height = 25
    Caption = 'Failed init'
    TabOrder = 2
    OnClick = btnTestFailureClick
  end
  object OmniTaskEventDispatch1: TOmniTaskEventDispatch
    OnTaskTerminated = OmniTaskEventDispatch1TaskTerminated
    OnTaskMessage = OmniTaskEventDispatch1TaskMessage
    Left = 8
    Top = 248
  end
end
