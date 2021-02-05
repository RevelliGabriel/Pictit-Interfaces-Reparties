import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/models/card.dart';

class Player {
  bool isIntrus;
  String name;
  List<GameCard> gameCards;
  GamePlayerStateEnum state;

  Player() {
    isIntrus = null;
    name = null;
    state = GamePlayerStateEnum.JOINED_GAME;
    gameCards = [];
  }

  Player.fromJson(dynamic jsonPlayer) {
    this.name = jsonPlayer['name'] as String;
    for (dynamic jsonGameCard in jsonPlayer['hand']) {
      this.gameCards.add(GameCard.fromJson(jsonGameCard));
    }
    this.isIntrus = false;
  }

  void addFromJsonCards(dynamic jsonCards) {
    this.gameCards = [];
    for (dynamic jsonCard in jsonCards) {
      gameCards
          .add(GameCard(jsonCard['path'] as String, jsonCard['id'] as int));
    }
  }

  void addFromJsonIsIntru(dynamic json) {
    isIntrus = json as bool;
  }
}
