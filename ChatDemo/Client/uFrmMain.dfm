object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Width = 598
  Height = 348
  Caption = #23458#25143#31471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 96
    Width = 48
    Height = 13
    Caption = #29992#25143#21517#65306
  end
  object Label2: TLabel
    Left = 32
    Top = 124
    Width = 36
    Height = 13
    Caption = #23494#30721#65306
  end
  object btnConnect: TButton
    Left = 32
    Top = 32
    Width = 75
    Height = 25
    Caption = #36830#25509
    TabOrder = 0
    OnClick = btnConnectClick
  end
  object btnSend: TButton
    Left = 126
    Top = 147
    Width = 75
    Height = 25
    Caption = #30331#24405
    TabOrder = 1
    OnClick = btnSendClick
  end
  object edtUserName: TEdit
    Left = 80
    Top = 93
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'edtUserName'
  end
  object edtPassword: TEdit
    Left = 80
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    Left = 48
    Top = 176
  end
end
