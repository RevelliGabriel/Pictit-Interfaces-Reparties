import 'package:flutter/material.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/player.dart';
import 'package:front/views/board_pages/board_distribution.dart';
import 'package:front/views/board_pages/board_gameover.dart';
import 'package:front/views/board_pages/board_lobby.dart';
import 'package:front/views/components/show_card.dart';
import 'package:front/views/components/show_hand.dart';

class BoardWrapper extends StatefulWidget {
  @override
  _BoardWrapperState createState() => _BoardWrapperState();
}

class _BoardWrapperState extends State<BoardWrapper> {
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      child: StreamBuilder<GameStepEnum>(
          stream: gameManager.gameStepStream,
          initialData: GameStepEnum.IDENTIFYING,
          builder: (context, snapshot) {
            if (snapshot.data == GameStepEnum.IDENTIFYING) {
              return BoardLobby();
            } else if (snapshot.data == GameStepEnum.DISTRIBUTION) {
              return BoardDistribution(
                game: gameManager.game,
                text: "Distribution des cartes",
              );
            } else if (snapshot.data == GameStepEnum.SWAPCARD) {
              return BoardDistribution(
                game: gameManager.game,
                text: "Phase d'échange entre les joueurs",
              );
            } else if (snapshot.data == GameStepEnum.WRITEWORD) {
              return BoardDistribution(
                game: gameManager.game,
                text: "Choisissez un mot",
              );
            } else if (snapshot.data == GameStepEnum.TURNPLAY) {
              return BoardDistribution(
                  game: gameManager.game,
                  text:
                      "Choisissez la carte la plus représentative du mot de la partie");
            } else if (snapshot.data == GameStepEnum.TURNVOTE) {
              return Stack(
                // ignore: deprecated_member_use
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: [
                  BoardDistribution(
                    game: gameManager.game,
                    text: "Qui selon vous est l'intrus ?",
                  ),
                  Container(
                    color: Theme.of(context).backgroundColor.withOpacity(0.5),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            "Qui est l'intrus selon vous ?",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [...showPlayerCards()]),
                      ],
                    ),
                  )
                ],
              );
            } else if (snapshot.data == GameStepEnum.ENDGAME) {
              return BoardGameover(
                intruName: gameManager.game.intruName,
                intruWin: gameManager.game.isIntruWinner,
                word: gameManager.word,
              );
            }
            return Container();
          }),
    );
  }

  List<Widget> showPlayerCards() {
    List<Widget> playersCols = [];
    int i = 0;
    for (Player player in gameManager.game.players) {
      playersCols.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ShowCard(
              card: gameManager.game.playedCards[i],
              ratio: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  player.name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
      i = i + 1;
    }
    return playersCols;
  }
}
