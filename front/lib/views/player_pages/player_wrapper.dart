import 'package:flutter/material.dart';
import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/card.dart';
import 'package:front/views/components/loading.dart';
import 'package:front/views/components/show_hand.dart';
import 'package:front/views/components/show_vote_players.dart';
import 'package:front/views/player_pages/player_identify.dart';
import 'package:front/views/player_pages/player_turn_play.dart';
import 'package:front/views/player_pages/player_word.dart';

class PlayerWrapper extends StatefulWidget {
  @override
  _PlayerWrapperState createState() => _PlayerWrapperState();
}

class _PlayerWrapperState extends State<PlayerWrapper> {
  bool wordOk = false;
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameStepEnum>(
        stream: gameManager.gameStepStream,
        initialData: GameStepEnum.IDENTIFYING,
        builder: (context, snapshot) {
          if (snapshot.data == GameStepEnum.IDENTIFYING) {
            return PlayerIdentify();
          } else if (snapshot.data == GameStepEnum.DISTRIBUTION) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    flex: 1,
                    child: Text(
                        "En attente de l'échange de cartes entre deux joueurs")),
                Flexible(
                    flex: 1,
                    child: ShowHand(
                      cards: gameManager.me.gameCards,
                      disableSelection: true,
                    ))
              ],
            );
          } else if (snapshot.data == GameStepEnum.SWAPCARD) {
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
          } else if (snapshot.data == GameStepEnum.WRITEWORD) {
            return PlayerWord();
          } else if (snapshot.data == GameStepEnum.TURNPLAY) {
            if (!wordOk) {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(gameManager.me.isIntrus
                        ? "Tu es l'intrus, ne te fais pas trouver !"
                        : "le mot est : " + gameManager.word),
                    ElevatedButton(
                        onPressed: () {
                          gameManager.wordOk();
                          setState(() {
                            wordOk = true;
                          });
                        },
                        child: Text("Oui ! j'ai compris"))
                  ],
                ),
              );
            }
            return PlayerTurnPlay();
          } else if (snapshot.data == GameStepEnum.TURNVOTE) {
            return Column(
              children: [
                Flexible(flex: 1, child: Text("C'est l'heure des votes")),
                Flexible(flex: 1, child: Text("Discutez, puis votez !")),
                Flexible(
                    flex: 1,
                    child: ShowVotePlayers(
                      players: gameManager.players,
                      function: (String name) {
                        gameManager.chooseVote(name);
                      },
                    )),
              ],
            );
          }
          return Container();
        });
  }
}
