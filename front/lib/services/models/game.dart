import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/models/player.dart';

class Game {
  List<Player> players;
  GameStepEnum status;

  Game() {
    this.status = GameStepEnum.IDENTIFYING;
    this.players = [];
  }

  Game.fromJson(dynamic jsonGame) {
    for (dynamic jsonPlayer in jsonGame['players']) {
      this.players.add(Player.fromJson(jsonPlayer));
    }
    this.status = GameStepEnum.values.elementAt((jsonGame['status'] as int));
  }

  void updateGameFromJson(dynamic json) {
    this.players = [];
    for (dynamic jsonPlayer in json['players']) {
      print(jsonPlayer);
      this.players.add(Player.fromJson(jsonPlayer));
    }
    this.status = GameStepEnum.values.elementAt(json['state']);
    if (json['intrusPosPlayer'] as int < this.players.length) {
      this.players.elementAt(json['intrusPosPlayer'] as int).isIntrus = true;
    }
    setPlayerPlaying(json['currentPosPlayer'] as int);
  }

  void setPlayerPlaying(int pos) {
    if (status != GameStepEnum.IDENTIFYING &&
        status != GameStepEnum.WRITEWORD &&
        status != GameStepEnum.TURNVOTE) {
      this.players.map((e) => e.state = GamePlayerStateEnum.WAITING);
      this.players.elementAt(pos).state = GamePlayerStateEnum.PLAYING;
    } else if (status == GameStepEnum.WRITEWORD ||
        status == GameStepEnum.TURNVOTE) {
      this.players.map((e) => e.state = GamePlayerStateEnum.PLAYING);
    } else {
      this.players.map((e) => e.state = GamePlayerStateEnum.JOINED_GAME);
    }
    print("c'est à toi de jouer " + pos.toString());
  }
}
