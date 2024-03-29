unit MsgCommon;

interface

uses
  ScktComp;

const
  SERVER_PORT = 6767;
  SERVER_ADDR = '127.0.0.1';

const
  SOCK_HEADER_FLAG = $92013154;

type
  PSockMsgHeader = ^TSockMsgHeader;
  TSockMsgHeader = packed record
    Flag: LongWord;       // 包标记
    Cmd: Word;
    Param1: Word;
    Param2: LongWord;
    DataLen: LongWord;
  end;

  { 用户登录 }
  PClientMsgLogin = ^TClientMsgLogin;
  TClientMsgLogin = packed record
    UserID: LongWord;
    UserName: string[23];   // ansistring
    Password: string[23];   // ansistring
  end;

const
  SOCKET_HERADE_LEN = SizeOf(TSockMsgHeader);

//-------------------------- 客户端包标记
const
  CM_LOGIN = 10000;
  CM_REGISTER = 10000;


//--------------------------服务器返回包标记
const
  SM_LOGIN = 10000;



  function SendBuf(Socket: TCustomWinSocket; Cmd: Word; Param1: Word = 0; Param2: LongWord = 0; Data: PByte = nil; DataLen: LongWord = 0): LongWord;

implementation

function SendBuf(Socket: TCustomWinSocket; Cmd: Word; Param1: Word = 0; Param2: LongWord = 0; Data: PByte = nil; DataLen: LongWord = 0): LongWord;
var
  Header: PSockMsgHeader;
  Buf, pSendData: PByte;
  Len: LongWord;
begin
  Result := 0;
  if not Socket.Connected then Exit;

  if Data = nil then DataLen := 0;

  Len := SizeOf(TSockMsgHeader) + DataLen;
  GetMem(Buf, Len);
  try
    Header := PSockMsgHeader(Buf);
    Header.Flag := SOCK_HEADER_FLAG;
    Header.Cmd := Cmd;
    Header.Param1 := Param1;
    Header.Param2 := Param2;
    Header.DataLen := DataLen;

    if (DataLen > 0) then
    begin
      pSendData := Buf;
      Inc(pSendData, SizeOf(TSockMsgHeader));

      Move(Data^, pSendData^, DataLen);
    end;

    Socket.SendBuf(Buf^, Len);
  finally
    FreeMem(Buf, Len);
  end;

end;

end.
