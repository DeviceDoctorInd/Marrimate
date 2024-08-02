/*
//import 'package:socket_io_client/socket_io_client.dart' as IO;
//import 'package:adhara_socket_io/adhara_socket_io.dart';

class SocketUtils{
  //static String _serverIP = 'https://innova8ors.com/beta.merrimate';
  //static String _serverIP = 'https://merrimate.com/';
  //static String _serverIP = 'ws://13.233.226.99:6001/';
  static String _serverIP = 'https://demo.piesocket.com';
  //static String _serverIP = 'https://petzola-chat-manager.herokuapp.com';
  static String _connectUrl = '$_serverIP';

  static String _key = "petzola eyJraWQiOiIxIiwiYWxnIjoiSFMzODQifQ.eyJzdWIiOiIyMyIsImNoYXRJZCI6ImFmYmYyZTk3LTlhMzYtNDNkYS04ZDdkLWNjZDEzZjFjMjdjNyIsInJvbGVzIjpbIlJPTEVfVVNFUiJdLCJuYW1lIjoiemVlc2hhbiBoYWlkZXIiLCJleHAiOjE2NjIxMjMzMTMsInVzZXJJZCI6IjIzIn0.UD15zTARGwlWb64ukvGTWTXpM7gzeO3eN2ldib2o9aryVLKU_HWQehCnBUsC0zbz";

  //IO.Socket _socket;

  SocketIO _socket;
  SocketIOManager _manager;

  initSocket()async{
    await _init();
  }

  _init()async{
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  _socketOptions(){
    return SocketOptions(
        _connectUrl,
        //namespace: "/app/2c6ce5295db69c2081e7?protocol=7&client=js&version=4.3.1&flash=false",
        namespace: "/v3/channel_1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self",
        //namespace: "/26",
        enableLogging: true,
        transports: [Transports.webSocket],
        //query: {"token": _key}
        );
  }

  connectToSocket()async{
    if(_socket == null){
      print('Socket is null');
      return;
    }

    await _socket.connect();
    /*var temp = await _socket.isConnected();
    print(temp.toString());
    print("###");*/
  }


  initSocket({String clinicID, String token}) async{
    print('Connecting socket...');
    _socket = IO.io(_connectUrl,
        IO.OptionBuilder()
        .setTransports(['websocket'])
            //.setPath("/app/2c6ce5295db69c2081e7?protocol=7&client=js&version=4.3.1&flash=false")
            .setPath("/v3/channel_1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self")
            //.setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'})
            .disableAutoConnect()
            .build()
        );
    connectToSocket();
  }

  connectToSocket()async{
    if(_socket == null){
      print('Socket is null');
      return;
    }
    _socket.connect();

    _socket.onConnect((_){
      print("0:" );
    });
    _socket.onError((data){
      print("1:");
      print(data.toString());
    });
    _socket.onDisconnect((data){
      print("2:");
      print(data.toString());
    });
    _socket.onConnectTimeout((data){
      print("3:");
      print(data.toString());
      _socket.close();
    });
    _socket.onConnectError((data){
      print("4:");
      print(data.toString());
      _socket.close();
    });
  }

  setOnConnectionListener(Function onConnect){
    _socket.onConnect.listen((data) {
      print("1");
      onConnect(data);
    });
  }

  setOnConnectionErrorTimeOutListener(Function onConnectionTimedOut){
    _socket.onConnectTimeout.listen((data) {
      print("2");
      onConnectionTimedOut(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectionError){
    _socket.onConnectError.listen((data) {
      print("3");
      onConnectionError(data);
    });
  }

  setOnErrorListener(Function onError){
    _socket.onError.listen((data) {
      print("4");
      onError(data);
    });
  }

  setOnDisconnectListener(Function onDisconnect){
    _socket.onDisconnect.listen((data) {
      print("5");
      onDisconnect(data);
    });
  }

  closeConnection(){
    if(_socket != null){
      print('Closing connection...');
      _manager.clearInstance(_socket);
    }
  }


}
*/