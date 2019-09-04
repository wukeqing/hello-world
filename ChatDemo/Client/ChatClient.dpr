program ChatClient;

uses
  Forms,
  uFrmMain in 'uFrmMain.pas' {FrmMain},
  MsgCommon in '..\Common\MsgCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
