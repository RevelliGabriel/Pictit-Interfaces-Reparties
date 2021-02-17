import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/components/loading.dart';
import 'package:front/views/components/show_hand.dart';

class PlayerWord extends StatefulWidget {
  @override
  _PlayerWordState createState() => _PlayerWordState();
}

class _PlayerWordState extends State<PlayerWord> {
  GameManager gameManager = Global().fetch(GameManager);
  final _controller = TextEditingController();
  bool chosenWord = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
            flex: 1, child: Center(child: Text("Quel mot veux-tu choisir ?"))),
        Flexible(flex: 1, child: getChosenWord(context)),
        Flexible(
            flex: 2,
            child: ShowHand(
              cards: gameManager.me.gameCards,
              disableSelection: true,
            ))
      ],
    );
  }

  Widget getChosenWord(BuildContext context) {
    if (chosenWord) {
      return Loading();
    }
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: _controller,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: ElevatedButton(
                child: Text("Choisir ce mot"),
                onPressed: () {
                  gameManager.chooseWord(_controller.text);
                  setState(() {
                    chosenWord = true;
                  });
                }),
          ),
        )
      ],
    );
  }
}
