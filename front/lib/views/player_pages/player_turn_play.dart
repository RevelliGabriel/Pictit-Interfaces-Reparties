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
                Flexible(
                    flex: 1,
                    child: gameManager.me.isIntrus
                        ? Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Vous êtes l'intrus",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Open Sans',
                                      fontSize: 14),
                                )),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Le mot est : " + gameManager.word,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Open Sans',
                                      fontSize: 14),
                                )),
                          )),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "A toi de jouer !",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Open Sans',
                              fontSize: 16),
                        )),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      height: 150,
                      child: ShowHand(
                        ratio: 1.5,
                        cards: gameManager.me.gameCards,
                        function: (GameCard card) { gameManager.chooseCard(card.id); } ,
                      ),
                    )),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    flex: 1,
                    child: gameManager.me.isIntrus
                        ? Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Vous êtes l'intrus",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Open Sans',
                                      fontSize: 14),
                                )),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Le mot est : " + gameManager.word,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Open Sans',
                                      fontSize: 14),
                                )),
                          )),
                Flexible(
                    flex: 1,
                    child: Text("Un autre joueur est en train de jouer")),
                Flexible(
                    flex: 1,
                    child: Container(
                      height: 150,
                      child: ShowHand(
                        ratio: 1.5,
                        cards: gameManager.me.gameCards,
                        disableSelection: true,
                      ),
                    )),
              ],
            );
          }
        });
  }
}
