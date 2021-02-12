import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/game.dart';
import 'package:front/services/models/player.dart';
import 'package:front/views/components/show_hand.dart';

class BoardDistribution extends StatefulWidget {
  final Game game;
  final String text;

  BoardDistribution({@required this.game, this.text = ""});

  @override
  _BoardDistributionState createState() => _BoardDistributionState();
}

class _BoardDistributionState extends State<BoardDistribution> {
  GameManager gameManager = Global().fetch(GameManager);
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (widget.game.players.length < 2) {
      return Container();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      getStackPlayer1(context),
      Expanded(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      getStackPlayer0(context),
    ]);
  }

  Widget getStackPlayer1(BuildContext context) {
    double widthStack = width * 0.5;
    double heightStack = height * 0.3;
    Player player = widget.game.players[1];
    return Container(
      alignment: Alignment.topCenter,
      width: widthStack,
      height: heightStack,
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
              top: 0,
              width: widthStack * 0.7,
              height: heightStack * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Theme.of(context).accentColor,
                ),
                child: Container(),
              )),
          Positioned(
            top: 30,
            child: ShowHand(
                isScrollable: false,
                cards: player.gameCards,
                faceDown: true,
                disableSelection: true,
                ratio: 2 * widthStack / 1000),
          ),
          Positioned(
            top: heightStack * 0.9,
            left: widthStack * 0.7,
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
          )
        ],
      ),
    );
  }

  Widget getStackPlayer0(BuildContext context) {
    double widthStack = width * 0.5;
    double heightStack = height * 0.3;
    Player player = widget.game.players[0];
    return Container(
      alignment: Alignment.bottomCenter,
      width: widthStack,
      height: heightStack,
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Positioned(
              bottom: 0,
              width: widthStack * 0.7,
              height: heightStack * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Theme.of(context).accentColor,
                ),
                child: Container(),
              )),
          Positioned(
            bottom: 30,
            child: ShowHand(
                isScrollable: false,
                cards: player.gameCards,
                faceDown: true,
                disableSelection: true,
                ratio: 2 * widthStack / 1000),
          ),
          Positioned(
            bottom: heightStack * 0.9,
            right: widthStack * 0.7,
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
          )
        ],
      ),
    );
  }
}
