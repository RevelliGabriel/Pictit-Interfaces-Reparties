import 'package:flutter/material.dart';
import 'package:front/services/enums/game_player_state_enum.dart';
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
      Row(
        children: [
          getStackPlayer3(context),
          getStackPlayer2(context),
        ],
      ),
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
      Row(
        children: [
          getStackPlayer0(context),
          getStackPlayer1(context),
        ],
      ),
    ]);
  }

  Widget getStackPlayer3(BuildContext context) {
    double widthStack = width * 0.5;
    double heightStack = height * 0.3;
    String playerName = widget.game.allPlayers[3].name;
    Player plyFound = widget.game.players.firstWhere(
        (element) => element.name == playerName,
        orElse: () => null);
    bool isDead = plyFound == null;
    Player player = isDead
        ? widget.game.allPlayers[3]
        : widget.game.players
            .where((element) => element.name == playerName)
            .first;
    return Container(
      alignment: Alignment.topLeft,
      width: widthStack,
      height: heightStack,
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        alignment: Alignment.topLeft,
        children: [
          Positioned(
              top: 0,
              left: 10,
              width: widthStack * 0.7,
              height: heightStack * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: isDead
                      ? Colors.grey[700]
                      : (player.state == GamePlayerStateEnum.PLAYING)
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).accentColor,
                ),
                child: Container(),
              )),
          Positioned(
            top: 30,
            left: 50,
            child: isDead
                ? Container()
                : ShowHand(
                    isScrollable: false,
                    cards: player.gameCards,
                    faceDown: true,
                    disableSelection: true,
                    ratio: 2 * widthStack / 1000),
          ),
          Positioned(
            top: heightStack * 0.9,
            left: 50,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    isDead ? Colors.grey[700] : Theme.of(context).primaryColor,
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

  Widget getStackPlayer2(BuildContext context) {
    double widthStack = width * 0.5;
    double heightStack = height * 0.3;
    String playerName = widget.game.allPlayers[2].name;
    Player plyFound = widget.game.players.firstWhere(
        (element) => element.name == playerName,
        orElse: () => null);
    bool isDead = plyFound == null;
    Player player = isDead
        ? widget.game.allPlayers[2]
        : widget.game.players
            .where((element) => element.name == playerName)
            .first;
    return Container(
      alignment: Alignment.topRight,
      width: widthStack,
      height: heightStack,
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        alignment: Alignment.topRight,
        children: [
          Positioned(
              top: 0,
              right: 10,
              width: widthStack * 0.7,
              height: heightStack * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: isDead
                      ? Colors.grey[700]
                      : (player.state == GamePlayerStateEnum.PLAYING)
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).accentColor,
                ),
                child: Container(),
              )),
          Positioned(
            top: 30,
            right: 50,
            child: isDead
                ? Container()
                : ShowHand(
                    isScrollable: false,
                    cards: player.gameCards,
                    faceDown: true,
                    disableSelection: true,
                    ratio: 2 * widthStack / 1000),
          ),
          Positioned(
            top: heightStack * 0.9,
            right: 50,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    isDead ? Colors.grey[700] : Theme.of(context).primaryColor,
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

  Widget getStackPlayer1(BuildContext context) {
    double widthStack = width * 0.5;
    double heightStack = height * 0.3;
    String playerName = widget.game.allPlayers[1].name;
    Player plyFound = widget.game.players.firstWhere(
        (element) => element.name == playerName,
        orElse: () => null);
    bool isDead = plyFound == null;
    Player player = isDead
        ? widget.game.allPlayers[1]
        : widget.game.players
            .where((element) => element.name == playerName)
            .first;
    return Container(
      alignment: Alignment.bottomRight,
      width: widthStack,
      height: heightStack,
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
              bottom: 0,
              right: 10,
              width: widthStack * 0.7,
              height: heightStack * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: isDead
                      ? Colors.grey[700]
                      : (player.state == GamePlayerStateEnum.PLAYING)
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).accentColor,
                ),
                child: Container(),
              )),
          Positioned(
            bottom: 30,
            right: 50,
            child: isDead
                ? Container()
                : ShowHand(
                    isScrollable: false,
                    cards: player.gameCards,
                    faceDown: true,
                    disableSelection: true,
                    ratio: 2 * widthStack / 1000),
          ),
          Positioned(
            bottom: heightStack * 0.9,
            right: 50,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    isDead ? Colors.grey[700] : Theme.of(context).primaryColor,
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
    String playerName = widget.game.allPlayers[0].name;
    Player plyFound = widget.game.players.firstWhere(
        (element) => element.name == playerName,
        orElse: () => null);
    bool isDead = plyFound == null;
    Player player = isDead
        ? widget.game.allPlayers[0]
        : widget.game.players
            .where((element) => element.name == playerName)
            .first;
    return Container(
      alignment: Alignment.bottomLeft,
      width: widthStack,
      height: heightStack,
      child: Stack(
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        alignment: Alignment.bottomLeft,
        children: [
          Positioned(
              bottom: 0,
              left: 10,
              width: widthStack * 0.7,
              height: heightStack * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: isDead
                      ? Colors.grey[700]
                      : (player.state == GamePlayerStateEnum.PLAYING)
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).accentColor,
                ),
                child: Container(),
              )),
          Positioned(
            bottom: 30,
            left: 50,
            child: isDead
                ? Container()
                : ShowHand(
                    isScrollable: false,
                    cards: player.gameCards,
                    faceDown: true,
                    disableSelection: true,
                    ratio: 2 * widthStack / 1000),
          ),
          Positioned(
            bottom: heightStack * 0.9,
            left: 50,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    isDead ? Colors.grey[700] : Theme.of(context).primaryColor,
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
