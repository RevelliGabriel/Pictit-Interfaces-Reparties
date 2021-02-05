import 'dart:convert';

import 'package:phoneview/services/enums/game_step_enums.dart';
import 'package:phoneview/services/models/card.dart';
import 'package:phoneview/services/models/player.dart';

class Game {
  List<Player> players;
  List<GameCard> deck;
  GameStepEnum status;

  Game(List<Player> players, GameStepEnum status) {
    this.status = status;
    this.players = players;
    this.deck = [];
  }

  Game.fromJson(dynamic jsonGame) {
    for (dynamic jsonPlayer in jsonGame['players']) {
      this.players.add(Player.fromJson(jsonPlayer));
    }
    this.status = GameStepEnum.values.elementAt((jsonGame['status'] as int));
    this.deck = [];
  }
}
