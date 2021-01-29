import 'package:phoneview/services/managers/connection_manager.dart';
import 'package:phoneview/services/managers/manager.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'global.dart';

class LobbyManager implements Manager {
  ConnectionManager _connectionManager = Global().fetch(ConnectionManager);
  Socket _socket;

  LobbyManager(Socket socket) {
    _socket = socket;

    // _socket.on('in lobby', (_) {
    //   print('connect: ${_socket.id}');
    // });

    _socket.on('identify', (_) {
      print('connect: ${_socket.id}');
    });
  }

  Future<bool> identify(String name) async {
    try {
      _socket.emit(
        "identify",
        {
          "id": _socket.id,
          "message": "yodley", // Message to be sent
          "name": name,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
        },
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> join() async {
    try {
      _socket.emit(
        "join",
        {"name": "SuperGame1"},
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
