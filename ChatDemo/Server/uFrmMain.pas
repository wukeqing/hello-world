unit uFrmMain;

interface

uses
  Windows,Messages,SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, MsgCommon,
  StdCtrls, uSession, ScktComp;

type
  TFrmMain = class(TForm)
    srvSocket: TServerSocket;
    mmoLog: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure srvSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure srvSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure srvSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
    procedure AddLog(S: string);

    procedure RecvPacked(Session: PSession; MsgHeader: PSockMsgHeader; Data: PByte; DataLen: LongWord);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.AddLog(S: string);
begin
  mmoLog.Lines.Add(S);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  srvSocket.Port := SERVER_PORT;
  try
    SrvSocket.Active := True;
    AddLog('服务器已启动:' + IntToStr(SERVER_PORT));
  except
    on E: Exception do
    begin
      AddLog('服务器启动失败;' + E.Message);
    end;
  end;

  Init_g_Sessions;
end;

procedure TFrmMain.RecvPacked(Session: PSession; MsgHeader: PSockMsgHeader; Data: PByte;
  DataLen: LongWord);
var
  ClientMsgLogin: PClientMsgLogin;
begin
  case MsgHeader.Cmd of
    CM_LOGIN:
      begin
        if DataLen = SizeOf(TClientMsgLogin) then
        begin
          ClientMsgLogin := PClientMsgLogin(Data);
          AddLog(Format('用户名: %s;  密码: %s', [ClientMsgLogin.UserName, ClientMsgLogin.Password]));

          SendBuf(Session.Socket, SM_LOGIN, 1);
        end
        else
        begin

        end;
      end;
  end;
end;

procedure TFrmMain.srvSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  Session: PSession;
  IsFound: Boolean;
begin
  IsFound := False;
  for I := 0 to Length(g_Sessions) do
  begin
    Session := @g_Sessions[I];
    if Session.Socket = nil then
    begin
      ResetSession(Session);

      // 将Session在数组中的下标绑到 Socket.Data
      Socket.Data := Pointer(I);
      Session.Socket := Socket;

      IsFound := True;
      Break;
    end;
  end;

  if not IsFound then
  begin
    Socket.Close;
    AddLog('连接已满，断开新连接: ' + Socket.RemoteAddress);
  end
  else
  begin
    AddLog('客户端连接: ' + Socket.RemoteAddress);
  end;
end;

procedure TFrmMain.srvSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Index: Integer;
begin
  Index := Integer(Socket.Data);
  if (Index >= 0) and (Index < Length(g_Sessions)) and (g_Sessions[Index].Socket = Socket) then
  begin
    ResetSession(@g_Sessions[Index]);
  end;

  AddLog('客户端断开: ' + Socket.RemoteAddress);
end;

procedure TFrmMain.srvSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Header: PSockMsgHeader;
  pData: PByte;

  Index: Integer;
  Session: PSession;
begin
  Index := Integer(Socket.Data);
  if not ((Index >= 0) and (Index < Length(g_Sessions)) and (g_Sessions[Index].Socket = Socket)) then Exit;

  Session := @g_Sessions[Index];

  Session.RecvText := Session.RecvText + Socket.ReceiveText;

  while True do
  begin
    if Length(Session.RecvText) < SOCKET_HERADE_LEN then Exit;

    Header := @Session.RecvText[1];

    if Header.Flag <> SOCK_HEADER_FLAG then
    begin
      Socket.Close;
      AddLog('无法解析的数据包:' + Socket.RemoteAddress);
      Exit;
    end;

    if Length(Session.RecvText) < SOCKET_HERADE_LEN + Header.DataLen then Exit;

    if Header.DataLen > 0 then
      pData := @Session.RecvText[1 + SOCKET_HERADE_LEN]
    else
      pData := nil;

    RecvPacked(Session, Header, pData, Header.DataLen);

    // 丢弃前面处理过的包
    Session.RecvText := Copy(Session.RecvText, 1 + SOCKET_HERADE_LEN + Header.DataLen, MaxInt);
  end;
end;

end.
