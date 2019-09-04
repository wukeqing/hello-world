object FrmMain: TFrmMain
  Left = 453
  Top = 390
  Width = 551
  Height = 359
  Caption = #32842#22825#26381#21153#22120
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmoLog: TMemo
    Left = 0
    Top = 0
    Width = 535
    Height = 320
    Align = alClient
    TabOrder = 0
  end
  object srvSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = srvSocketClientConnect
    OnClientDisconnect = srvSocketClientDisconnect
    OnClientRead = srvSocketClientRead
    Left = 104
    Top = 104
  end
end
