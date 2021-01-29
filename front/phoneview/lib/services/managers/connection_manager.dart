import 'dart:async';

import 'package:phoneview/services/enums/state.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'manager.dart';

class ConnectionManager implements Manager {
  State state;
  Socket _socket;

  Socket get socket => _socket;

  ConnectionManager() {
    try {
      // Configure socket transports must be sepecified
      _socket = io('http://127.0.0.1:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect to websocket
      _socket.connect();

      // Handle socket events
      _socket.on('connect', (_) => print('connect: ${_socket.id}'));
      _socket.on('disconnect', (_) => print('disconnect'));
      _socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
