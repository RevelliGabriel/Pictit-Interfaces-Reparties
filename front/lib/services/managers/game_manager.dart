import 'dart:async';

import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/manager.dart';
import 'package:front/services/models/game.dart';
import 'package:front/services/models/player.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GameManager implements Manager {
  Game game;
  Player other;
  Player me;
  List<Player> players;
  String word;
  Socket _socket;
  StreamController<GameStepEnum> _gameStepController =
      StreamController.broadcast();
  StreamController<GamePlayerStateEnum> _gamePlayerStateStepController =
      StreamController.broadcast();
  StreamController<bool> _gameUpdated = StreamController.broadcast();

  Stream<bool> get gameUpdatedStream => _gameUpdated.stream;
  Stream<GameStepEnum> get gameStepStream => _gameStepController.stream;
  Stream<GamePlayerStateEnum> get gamePlayerStateStream => _gamePlayerStateStepController.stream;

  void _addStep(GameStepEnum gameStep) {
    _gameStepController.sink.add(gameStep);
    game.status = gameStep;
  }

  void _addPlayerStep(GamePlayerStateEnum playerStep) {
    _gamePlayerStateStepController.sink.add(playerStep);
    me.state = playerStep;
  }

  GameManager(Socket socket) {
    me = Player();
    other = Player();

    game = Game();
    _addStep(GameStepEnum.IDENTIFYING);

    _socket = socket;

    _socket.on('game-started', (dynamic json) {
      me.addFromJsonIsIntru(json['isIntru']);
      _addStep(GameStepEnum.DISTRIBUTION);
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
      word = data;
      _socket.emit('word-ok', "ok");
      _addPlayerStep(GamePlayerStateEnum.WAITING);
      _addStep(GameStepEnum.TURNPLAY);
    });

    _socket.on('ask-card', (json) {

      print("C'est a vous de jouer");
      _addPlayerStep(GamePlayerStateEnum.PLAYING);
      _addStep(GameStepEnum.TURNPLAY);
    });

    _socket.on('ask-vote', (json) {
      // json['players'] assign to var
      print("Time to vote");
      this.updatePlayers(json);
      _addStep(GameStepEnum.TURNVOTE);
    });

    _socket.on('hand', (dynamic json) {
      me.addFromJsonCards(json['cards']);
      print("Ma nouvelle main");
      print(me.gameCards.toString());
    });

    _socket.on('self-player-out', (data) {
      _addStep(GameStepEnum.ELIMINATED);
    });

    _socket.on('player-out', (player) {
      print("un joueur a été éliminé");
      _addStep(GameStepEnum.TURNPLAY);
      me.state = GamePlayerStateEnum.WAITING;
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

  Future<bool> chooseCard(int cardId) async {
    try {
      _socket.emit(
        "choose-card",
        cardId,
      );
      _addPlayerStep(GamePlayerStateEnum.WAITING);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> chooseVote(String name) async {
    try {
      _socket.emit(
        "choose-vote",
        name,
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void updatePlayers(dynamic json) {
    print("Trying to update players");
    this.players = [];
    for (dynamic jsonPlayer in json['players']) {
      this.players.add(Player.fromJson(jsonPlayer));
    }
    print("Players updated");
  }

  @override
  void dispose() {
    _gameUpdated.close();
    _gameStepController.close();
    _gamePlayerStateStepController.close();
    // TODO: implement dispose
  }
}
