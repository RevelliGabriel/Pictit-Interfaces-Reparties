import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/card.dart';
import 'package:front/views/components/loading.dart';
import 'package:front/views/components/show_hand.dart';
import 'package:front/views/player_pages/player_eliminated.dart';
import 'package:front/views/player_pages/player_end_game.dart';
import 'package:front/views/player_pages/player_identify.dart';
import 'package:front/views/player_pages/player_turn_play.dart';
import 'package:front/views/player_pages/player_turn_vote.dart';
import 'package:front/views/player_pages/player_word.dart';

class PlayerWrapper extends StatefulWidget {
  @override
  _PlayerWrapperState createState() => _PlayerWrapperState();
}

class _PlayerWrapperState extends State<PlayerWrapper> {
  bool wordOk = false;
  bool swapOk = false;
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    gameManager.hintStream.listen((event) {
      Fluttertoast.showToast(
          msg: "This is Center Short Toast",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    return StreamBuilder<GameStepEnum>(
        stream: gameManager.gameStepStream,
        initialData: GameStepEnum.IDENTIFYING,
        builder: (context, snapshot) {
          if (snapshot.data == GameStepEnum.IDENTIFYING) {
            return PlayerIdentify();
          } else if (snapshot.data == GameStepEnum.DISTRIBUTION) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(
                    flex: 1,
                    child: Text(
                        "En attente de l'échange de cartes entre deux joueurs")),
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
          } else if (snapshot.data == GameStepEnum.SWAPCARD) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 1,
                    child: Container(
                      height: 150,
                      child: ShowHand(
                          ratio: 1.5,
                          cards: gameManager.other.gameCards,
                          function: (GameCard card) {
                            gameManager.tradeCard(card.id);
                            setState(() {
                              swapOk = true;
                            });
                          }),
                    )),
                Flexible(
                  flex: 1,
                  child: (swapOk)
                      ? Loading()
                      : Text(
                          "Veuillez choisir une carte dans la mains de l'adversaire"),
                ),
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
          } else if (snapshot.data == GameStepEnum.WRITEWORD) {
            return PlayerWord();
          } else if (snapshot.data == GameStepEnum.TURNPLAY) {
            if (!wordOk) {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("La partie vas commencer, tiens-toi prêt !"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Tous les joueurs ont proposé un mot et un d'entre eux a été séléctionné. L'intrus a également été tiré au sort !"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(gameManager.me.isIntrus
                          ? "Tu es l'intrus, tu ne sais donc pas quelle est le mot ! Fait attention, analyse les choix des adversaires, et essaye de ne pas te faire repérer !"
                          : "Tu n'es pas l'intrus, et le mot est : " +
                              gameManager.word +
                              ""),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            gameManager.wordOk();
                            setState(() {
                              wordOk = true;
                            });
                          },
                          child: Text("Oui ! j'ai compris")),
                    )
                  ],
                ),
              );
            }
            return PlayerTurnPlay();
          } else if (snapshot.data == GameStepEnum.TURNVOTE) {
            return PlayerTurnVote();
          } else if (snapshot.data == GameStepEnum.ENDGAME &&
              gameManager.me.state == GamePlayerStateEnum.ELIMINATED) {
            return PlayerEliminated();
          } else if (snapshot.data == GameStepEnum.ENDGAME) {
            return PlayerEndGame();
          }
          return Container();
        });
  }
}
