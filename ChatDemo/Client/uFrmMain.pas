unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,Graphics,
  Controls, Forms, Dialogs, StdCtrls, ScktComp, MsgCommon;

type
  TFrmMain = class(TForm)
    ClientSocket: TClientSocket;
    btnConnect: TButton;
    btnSend: TButton;
    Label1: TLabel;
    edtUserName: TEdit;
    Label2: TLabel;
    edtPassword: TEdit;
    procedure btnConnectClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
    FRecvText: AnsiString;

    procedure RecvPacked(MsgHeader: PSockMsgHeader; Data: PByte; DataLen: LongWord);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.btnConnectClick(Sender: TObject);
begin
  ClientSocket.Address := SERVER_ADDR;
  ClientSocket.Port := SERVER_PORT;
  ClientSocket.Active := True;
end;

procedure TFrmMain.btnSendClick(Sender: TObject);
var
  MsgLogin: TClientMsgLogin;
begin
  MsgLogin.UserID := 0;
  MsgLogin.UserName := edtUserName.Text;
  MsgLogin.Password := edtPassword.Text;

  SendBuf(ClientSocket.Socket, CM_LOGIN, 0, 0, @MsgLogin, SizeOf(MsgLogin));
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FRecvText := '';
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FRecvText := '';
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  Header: PSockMsgHeader;
  pData: PByte;

  Index: Integer;
begin
  FRecvText := FRecvText + Socket.ReceiveText;

  while True do
  begin
    if Length(FRecvText) < SOCKET_HERADE_LEN then Exit;

    Header := @FRecvText[1];

    if Header.Flag <> SOCK_HEADER_FLAG then
    begin
      Socket.Close;
      Exit;
    end;

    if Length(FRecvText) < SOCKET_HERADE_LEN + Header.DataLen then Exit;

    if Header.DataLen > 0 then
      pData := @FRecvText[1 + SOCKET_HERADE_LEN]
    else
      pData := nil;

    RecvPacked(Header, pData, Header.DataLen);

    // 丢弃前面处理过的包
    FRecvText := Copy(FRecvText, 1 + SOCKET_HERADE_LEN + Header.DataLen, MaxInt);
  end;
end;

procedure TFrmMain.RecvPacked(MsgHeader: PSockMsgHeader; Data: PByte;
  DataLen: LongWord);
begin
  case MsgHeader.Cmd of
    SM_LOGIN:
      begin
        if MsgHeader.Param1 = 0 then
          Showmessage('登录成功')
        else
          ShowMessage('登录失败');
      end;
  end;
end;

end.
