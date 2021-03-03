import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/models/card.dart';
import 'package:front/services/models/player.dart';

class Game {
  List<Player> players;
  List<Player> allPlayers;
  List<GameCard> playedCards;
  List<String> playersPlay;
  GameStepEnum status;
  String intruName;
  bool isIntruWinner;

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
    this.allPlayers = [];
    this.playedCards = [];
    this.playersPlay = [];
    for (dynamic jsonPlayer in json['oldPlayers']) {
      this.allPlayers.add(Player.fromJson(jsonPlayer));
    }
    for (dynamic jsonPlayer in json['players']) {
      this.players.add(Player.fromJson(jsonPlayer));
    }
    for (dynamic jsonCard in json['playersCards']) {
      this.playedCards.add(GameCard.fromJson(jsonCard));
    }
    this.status = GameStepEnum.values.elementAt(json['state']);
    if (json['intrusPosPlayer'] as int < this.players.length) {
      this.players.elementAt(json['intrusPosPlayer'] as int).isIntrus = true;
    }
    for (dynamic jsonPlayerName in json['playersPlay']) {
      this.playersPlay.add(jsonPlayerName as String);
      print("LES PLAYERS QUI ONT JOUé");
      print(this.playersPlay);
    }
    if (this.status == GameStepEnum.TURNPLAY) {
      setPlayerPlaying(json['currentPosPlayer'] as int);
    } else {
      print("BEFORE BIG MAP");
      // this.players.map((player) {
      //   if (this.playersPlay.length > 0 &&
      //       this.playersPlay.contains(player.name)) {
      //     player.state = GamePlayerStateEnum.WAITING;
      //     print(player.name + " n'a pas joué");
      //   } else {
      //     player.state = GamePlayerStateEnum.PLAYING;
      //     print(player.name + " a joué");
      //   }
      // });
      for (Player player in this.players){
        if (this.playersPlay.contains(player.name)) {
          player.state = GamePlayerStateEnum.WAITING;
          print(player.name + " a joué");
        } else {
          player.state = GamePlayerStateEnum.PLAYING;
          print(player.name + " n'a pas joué");
        }
      }
    }
    this.intruName = json['intrusName'];
    this.isIntruWinner =
        this.players.map((e) => e.name).contains(this.intruName);
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
