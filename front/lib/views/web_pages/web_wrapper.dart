import 'package:flutter/material.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/card.dart';
import 'package:front/views/components/show_hand.dart';
import 'package:front/views/web_pages/web_lobby.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameStepEnum>(
        stream: gameManager.gameStepStream,
        initialData: GameStepEnum.IDENTIFYING,
        builder: (context, snapshot) {
          if (snapshot.data == GameStepEnum.IDENTIFYING) {
            return Lobby();
          } else if (snapshot.data == GameStepEnum.DISTRIBUTION) {
            return Column(
              children: [
                Flexible(
                    flex: 1,
                    child:
                        Text("En attente de la sélection des autres joueurs")),
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
        });
  }
}
