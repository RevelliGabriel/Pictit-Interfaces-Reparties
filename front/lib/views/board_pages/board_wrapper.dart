import 'package:flutter/material.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/board_pages/board_lobby.dart';
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
              return Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Text(
                          "En attente de la sélection des autres joueurs")),
                  Flexible(
                      flex: 1,
                      child: ShowHand(
                        cards: gameManager.me.gameCards,
                        disableSelection: true,
                      ))
                ],
              );
            }
            return Container();
          }),
    );
  }
}
