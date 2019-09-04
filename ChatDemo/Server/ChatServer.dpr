program ChatServer;

uses
  Forms,
  uFrmMain in 'uFrmMain.pas' {FrmMain},
  uFrmSetting in 'uFrmSetting.pas' {FrmSetting},
  MsgCommon in '..\Common\MsgCommon.pas',
  uSession in 'uSession.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmSetting, FrmSetting);
  Application.Run;
end.
