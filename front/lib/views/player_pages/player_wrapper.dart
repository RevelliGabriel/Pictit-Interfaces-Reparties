import 'package:flutter/material.dart';
import 'package:front/services/enums/game_player_state_enum.dart';
import 'package:front/services/enums/game_step_enums.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/card.dart';
import 'package:front/views/components/show_hand.dart';
import 'package:front/views/components/show_vote_players.dart';
import 'package:front/views/player_pages/player_identify.dart';

class PlayerWrapper extends StatefulWidget {
  @override
  _PlayerWrapperState createState() => _PlayerWrapperState();
}

class _PlayerWrapperState extends State<PlayerWrapper> {
  GameManager gameManager = Global().fetch(GameManager);
  final _controller = TextEditingController();

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
            return Column(
              children: [
                Flexible(
                    flex: 1,
                    child: Text("alors c'est quoi ton mot ? hein ? oh !")),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _controller,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: RaisedButton(
                            child: Text("Choose Word"),
                            onPressed: () {
                              gameManager.chooseWord(_controller.text);
                            }),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: ShowHand(
                  cards: gameManager.me.gameCards,
                  disableSelection: true,
                ))
              ],
            );
          } else if (snapshot.data == GameStepEnum.TURNPLAY) {
            if (gameManager.me.state == GamePlayerStateEnum.WAITING) {
              return Column(
                children: [
                  Flexible(flex: 1, child: Text("La partie est en cours")),
                  Flexible(
                      flex: 1,
                      child: Text("Un autre joueur est en train de jouer")),
                  Flexible(
                      flex: 1,
                      child: ShowHand(
                        cards: gameManager.me.gameCards,
                        disableSelection: true,
                      )),
                ],
              );
            } else if (gameManager.me.state == GamePlayerStateEnum.PLAYING) {
              return Column(
                children: [
                  Flexible(flex: 1, child: Text("La partie est en cours")),
                  Flexible(flex: 1, child: Text("A vous de jouer !")),
                  Flexible(
                      flex: 1,
                      child: ShowHand(
                        cards: gameManager.me.gameCards,
                        function: (GameCard card) {
                          gameManager.chooseCard(card.id);
                        },
                      )),
                ],
              );
            }
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
