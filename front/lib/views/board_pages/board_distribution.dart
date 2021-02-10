import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/components/show_hand.dart';

class BoardDistribution extends StatefulWidget {
  @override
  _BoardDistributionState createState() => _BoardDistributionState();
}

class _BoardDistributionState extends State<BoardDistribution> {
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: ShowHand(
                  cards: gameManager.game.players[0].gameCards,
                  disableSelection: true,
                  faceDown: true,
                ),
              )),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: ShowHand(
                  cards: gameManager.game.players[1].gameCards,
                  disableSelection: true,
                  faceDown: true,
                ),
              )),
        ),
        Align(
          alignment: Alignment.center,
          child: Text("Les Cartes ont été distribuées"),
        )
      ],
    );
  }
}
