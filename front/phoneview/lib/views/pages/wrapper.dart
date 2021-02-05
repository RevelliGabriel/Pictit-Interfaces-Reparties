import 'package:flutter/material.dart';
import 'package:phoneview/services/enums/game_step_enums.dart';
import 'package:phoneview/services/managers/game_manager.dart';
import 'package:phoneview/services/managers/global.dart';
import 'package:phoneview/views/components/show_hand.dart';

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
        initialData: GameStepEnum.DISTRIBUTION,
        builder: (context, snapshot) {
          if (snapshot.data == GameStepEnum.SHOWCARD) {
            return ShowHand(gameManager.me.gameCards);
          }
          return Container();
        });
  }
}
