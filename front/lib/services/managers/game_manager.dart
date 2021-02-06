import 'dart:async';

import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/manager.dart';
import 'package:front/services/models/game.dart';
import 'package:front/services/models/player.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GameManager implements Manager {
  Game game;
  Player other;
  Player me;
  Socket _socket;
  StreamController<GameStepEnum> _gameStepController =
      StreamController.broadcast();
  StreamController<bool> _gameUpdated = StreamController.broadcast();

  Stream<bool> get gameUpdatedStream => _gameUpdated.stream;
  Stream<GameStepEnum> get gameStepStream => _gameStepController.stream;

  void _addStep(GameStepEnum gameStep) {
    _gameStepController.sink.add(gameStep);
    game.status = gameStep;
  }

  GameManager(Socket socket) {
    me = Player();
    other = Player();

    game = Game();
    _addStep(GameStepEnum.IDENTIFYING);

    _socket = socket;

    _socket.on('game-started', (dynamic json) {
      me.addFromJsonIsIntru(json['isIntru']);
      print("game started babys");
    });

    _socket.on('trade-cards', (json) {
      other.addFromJsonCards(json['cards']);
      _addStep(GameStepEnum.SWAPCARD);
    });

    _socket.on('ask-word', (json) {
      _addStep(GameStepEnum.WRITEWORD);
    });

    _socket.on('game-word', (data) {
      print('get word from server: $data');
      _socket.emit('word-ok', "ok");
    });

    _socket.on('hand', (dynamic json) {
      me.addFromJsonCards(json['cards']);
      if (game.status != GameStepEnum.IDENTIFYING) {
        _addStep(GameStepEnum.WRITEWORD);
      } else {
        _addStep(GameStepEnum.DISTRIBUTION);
      }
      print(me.gameCards.toString());
    });

    _socket.on('update-game', (dynamic json) {
      game.updateGameFromJson(json['game']);
      _gameUpdated.sink.add(true);
    }); 
  }

  Future<bool> tradeCard(int id) async {
    try {
      _socket.emit(
        "card-trade",
        id,
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> chooseWord(String word) async {
    try {
      _socket.emit(
        "choose-word",
        word,
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _gameUpdated.close();
    _gameStepController.close();
    // TODO: implement dispose
  }
}
