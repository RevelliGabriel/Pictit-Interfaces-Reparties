class GameCard {
  // variables
  String path;
  final String downPath = 'assets/images/CardBack.jpg';
  int id;

  // Constructor
  GameCard(String path, int id) {
    this.path = 'assets/images/' + path;
    this.id = id;
  }

  GameCard.fromJson(dynamic jsonGameCard) {
    path = 'assets/images/' + (jsonGameCard['path'] as String);
    id = jsonGameCard['id'] as int;
  }

  GameCard.fromId(int cardId) {
    path = 'assets/images/Card' + (cardId.toString()) + ".jpg";
    id = cardId;
  }
}
