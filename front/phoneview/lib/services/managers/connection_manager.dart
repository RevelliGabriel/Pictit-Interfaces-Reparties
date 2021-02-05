import 'dart:async';

import 'package:phoneview/services/enums/connection_state_enum.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'manager.dart';

class ConnectionManager implements Manager {
  // private
  StreamController<ConnectionStateEnum> _connectionStateStreamController =
      StreamController.broadcast();
  Socket _socket;
  ConnectionStateEnum _currentConnectionStateEnum =
      ConnectionStateEnum.DISCONNECTED;

  void _setState(ConnectionStateEnum state) {
    _connectionStateStreamController.sink.add(state);
    _currentConnectionStateEnum = state;
  }

  // public
  Stream<ConnectionStateEnum> get connectionStateStream =>
      _connectionStateStreamController.stream;
  Socket get socket => _socket;

  ConnectionManager(Socket socket) {
    _socket = socket;

    // Handle socket events
    _socket.on('connect', (_) {
      print('connect: ${_socket.id}');
      _setState(ConnectionStateEnum.CONNECTED);
    });

    // Handle socket events
    _socket.on('disconnect', (_) {
      print('disconnect: ${_socket.id}');
      _setState(ConnectionStateEnum.DISCONNECTED);
    });
  }

  void connect() {
    try {
      if (_currentConnectionStateEnum != ConnectionStateEnum.CONNECTED) {
        // Connect to websocket
        _socket.connect();
        _setState(ConnectionStateEnum.CONNECTED);
      }
    } catch (e) {
      print(e.toString());
      _setState(ConnectionStateEnum.DISCONNECTED);
    }
  }

  void disconnect() {
    try {
      if (_currentConnectionStateEnum != ConnectionStateEnum.DISCONNECTED) {
        // Connect to websocket
        _socket.disconnect();
      }
    } catch (e) {
      print(e.toString());
      _setState(ConnectionStateEnum.CONNECTED);
    }
  }

  void toggleConnection() {
    _currentConnectionStateEnum == ConnectionStateEnum.CONNECTED
        ? disconnect()
        : connect();
  }

  @override
  void dispose() {
    _connectionStateStreamController.close();
    // TODO: implement dispose
  }
}
