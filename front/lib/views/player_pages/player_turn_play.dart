import 'package:flutter/material.dart';
import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/card.dart';
import 'package:front/views/components/show_hand.dart';

class PlayerTurnPlay extends StatefulWidget {
  @override
  _PlayerTurnPlayState createState() => _PlayerTurnPlayState();
}

class _PlayerTurnPlayState extends State<PlayerTurnPlay> {
  GameManager gameManager = Global().fetch(GameManager);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GamePlayerStateEnum>(
        stream: gameManager.gamePlayerStateStream,
        initialData: GamePlayerStateEnum.WAITING,
        builder: (context, snapshot) {
          if (snapshot.data == GamePlayerStateEnum.PLAYING) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(flex: 1, child: Text("La partie est en cours")),
                Flexible(flex: 1, child: Text("A vous de jouer !")),
                Flexible(
                    flex: 1,
                    child: ShowHand(
                      cards: gameManager.me.gameCards,
                      function: (GameCard card) {
                        gameManager.chooseCard(card.id);
                      },
                    )),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(flex: 1, child: Text("La partie est en cours")),
                Flexible(
                    flex: 1,
                    child: Text("Un autre joueur est en train de jouer")),
                Flexible(
                    flex: 1,
                    child: ShowHand(
                      cards: gameManager.me.gameCards,
                      disableSelection: true,
                    )),
              ],
            );
          }
        });
  }
}
