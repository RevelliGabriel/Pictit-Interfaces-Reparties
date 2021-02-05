import 'dart:async';

import 'package:phoneview/services/enums/game_step_enums.dart';
import 'package:phoneview/services/managers/manager.dart';
import 'package:phoneview/services/models/game.dart';
import 'package:phoneview/services/models/player.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GameManager implements Manager {
  Game game;
  Player me;
  Socket _socket;
  StreamController<GameStepEnum> _gameStepController =
      StreamController.broadcast();

  Stream<GameStepEnum> get gameStepStream => _gameStepController.stream;

  void _addStep(GameStepEnum gameStep) =>
      _gameStepController.sink.add(gameStep);

  GameManager(Socket socket) {
    game = Game([], GameStepEnum.DISTRIBUTION);

    _socket = socket;

    _socket.on('game_started', (dynamic json) {
      me.addFromJsonPosition(json['position']);
      me.addFromJsonIsIntru(json['isIntru']);
      _addStep(GameStepEnum.SHOWCARD);
    });

    _socket.on('hand', (dynamic json) {
      me.addFromJsonCards(json['cards']);
    });
  }

  @override
  void dispose() {
    _gameStepController.close();
    // TODO: implement dispose
  }
}
