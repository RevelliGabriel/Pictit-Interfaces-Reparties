import 'dart:async';

import 'package:phoneview/services/managers/game_manager.dart';
import 'package:phoneview/services/managers/manager.dart';
import 'package:phoneview/services/models/player.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'global.dart';

class LobbyManager implements Manager {
  // Variables
  GameManager _gameManager = Global().fetch(GameManager);
  StreamController<List<Player>> _myIentificationStreamController =
      StreamController.broadcast();
  Socket _socket;

  // Getters
  Stream get inLobbyPlayersStream => _myIentificationStreamController.stream;

  // Constructors
  LobbyManager(Socket socket) {
    _socket = socket;

    // _socket.on('in lobby', (_) {
    //   print('connect: ${_socket.id}');
    // });

    _socket.on('identify', (_) {
      print('connect: ${_socket.id}');
    });

    _socket.on('hand', (data) {
      print('get hand from server: $data');
      _socket.emit('hand-ok', "ok");
    });
  }

  // Socket functions
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
      // initialisation du player
      _gameManager.me = Player(name);
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
    _myIentificationStreamController.close();
    // TODO: implement dispose
  }
}
