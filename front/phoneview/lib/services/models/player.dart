import 'package:phoneview/services/enums/game_player_state_enum.dart';
import 'package:phoneview/services/models/card.dart';

class Player {
  int id;
  bool isIntrus;
  String name;
  List<GameCard> gameCards;
  GamePlayerStateEnum state;

  Player(String name) {
    id = null;
    isIntrus = null;
    this.name = name;
    state = GamePlayerStateEnum.IN_LOBBY;
    gameCards = [];
  }

  Player.fromJson(dynamic jsonPlayer) {
    for (dynamic jsonGameCard in jsonPlayer['GameCards']) {
      this.gameCards.add(GameCard.fromJson(jsonGameCard));
    }
    this.state =
        GamePlayerStateEnum.values.elementAt((jsonPlayer['state'] as int));
    this.name = jsonPlayer['name'] as String;
  }

  void addFromJsonCards(dynamic jsonCards) {
    for (dynamic jsonCard in jsonCards) {
      gameCards
          .add(GameCard(jsonCard['path'] as String, jsonCard['id'] as int));
    }
  }

  void addFromJsonPosition(dynamic json) {
    id = json as int;
  }

  void addFromJsonIsIntru(dynamic json) {
    isIntrus = json as bool;
  }
}
