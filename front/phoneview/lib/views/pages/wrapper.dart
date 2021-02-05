import 'package:flutter/material.dart';
import 'package:phoneview/services/enums/game_step_enums.dart';
import 'package:phoneview/services/managers/game_manager.dart';
import 'package:phoneview/services/managers/global.dart';
import 'package:phoneview/services/models/card.dart';
import 'package:phoneview/views/components/show_hand.dart';
import 'package:phoneview/views/pages/identify.dart';

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
            return Identify();
          } else if (snapshot.data == GameStepEnum.SHOWCARD) {
            return Column(
              children: [
                Flexible(
                    flex: 1,
                    child: ShowHand(
                        cards: gameManager.other.gameCards,
                        function: (GameCard card) {
                          gameManager.tradeCard(card.id);
                        })),
                Flexible(
                    flex: 1, child: ShowHand(cards: gameManager.me.gameCards))
              ],
            );
          }
          return Container();
        });
  }
}
