import 'package:front/services/managers/connection_manager.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/lobby_manager.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'manager.dart';

/// Singleton manager that is accessible from everywhere
class Global {
  // Configure socket transports must be sepecified
  Socket _socket = io('http://localhost:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  Map<dynamic, Manager> repository = {};

  Map<dynamic, Function(dynamic)> _factories = {
    GameManager: (socket) => GameManager(socket),
    LobbyManager: (socket) => LobbyManager(socket),
    ConnectionManager: (socket) => ConnectionManager(socket)
  };

  static final Global _singleton = Global._internal();

  factory Global() => _singleton;

  Global._internal();

  /// summon the singleton [name]
  _summon(name) => repository[name] = _factories[name](_socket);

  /// access the singleton [name] and if it's not summoned, it summon it
  fetch(name) =>
      repository.containsKey(name) ? repository[name] : _summon(name);

  /// to destroy the singleton [name]
  release(name) {
    Manager manager = repository[name];
    manager.dispose();
    repository.remove(name);
  }
}
