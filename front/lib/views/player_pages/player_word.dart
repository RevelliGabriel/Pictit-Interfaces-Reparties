import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/components/loading.dart';
import 'package:front/views/components/show_hand.dart';
import 'package:front/views/components/show_card.dart';
import 'package:front/services/models/card.dart';

class PlayerWord extends StatefulWidget {
  @override
  _PlayerWordState createState() => _PlayerWordState();
}

class _PlayerWordState extends State<PlayerWord> {
  GameManager gameManager = Global().fetch(GameManager);
  final _controller = TextEditingController();
  bool chosenWord = false;
  bool showTrades = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
                flex: 1,
                child: Center(child: Text("Quel mot veux-tu choisir ?"))),
            Flexible(flex: 1, child: getChosenWord(context)),
            Flexible(
                flex: 2,
                child: Container(
                  height: 150,
                  child: ShowHand(
                    ratio: 1.5,
                    cards: gameManager.me.gameCards,
                    disableSelection: true,
                  ),
                )),
          ],
        ),
        showTrades
            ? Container(
                color: Theme.of(context).backgroundColor.withOpacity(0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...showPlayersTrades(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showTrades = false;
                            });
                          },
                          child: Text("D'accord !")),
                    )
                  ],
                ),
              )
            : Container()
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

  List<Widget> showPlayersTrades() {
    List<Widget> listWidget = [];
    Widget cardStealed;
    Widget cardToSteal;
    for (dynamic trade in gameManager.trades) {
      if (trade['player']['name'].toString() == gameManager.me.name) {
        cardToSteal = Column(
          children: [
            ShowCard(
              card: GameCard.fromId(trade['cardToSteal'] as int),
              ratio: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Carte que vous avez volé à " +
                  trade['playerToSteal']['name']),
            )
          ],
        );
      }
      if (trade['playerToSteal']['name'].toString() == gameManager.me.name) {
        cardStealed = Column(
          children: [
            ShowCard(
              card: GameCard.fromId(trade['cardToSteal'] as int),
              ratio: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(trade['player']['name'] + " vous a volé cette carte"),
            )
          ],
        );
      }
    }
    listWidget.add(cardStealed);
    listWidget.add(cardToSteal);
    return listWidget;
  }
}
