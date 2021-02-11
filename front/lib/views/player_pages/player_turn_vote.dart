import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/components/loading.dart';
import 'package:front/views/components/show_vote_players.dart';

class PlayerTurnVote extends StatefulWidget {
  @override
  _PlayerTurnVoteState createState() => _PlayerTurnVoteState();
}

class _PlayerTurnVoteState extends State<PlayerTurnVote> {
  GameManager gameManager = Global().fetch(GameManager);
  bool voted = false;

  @override
  Widget build(BuildContext context) {
    if (voted) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("En attente des votes des autres joueurs !"),
          Loading(),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(flex: 1, child: Text("C'est l'heure des votes")),
        Flexible(flex: 1, child: Text("Discutez, puis votez !")),
        Flexible(
            flex: 1,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ShowVotePlayers(
                  players: gameManager.players,
                  function: (String name) {
                    gameManager.chooseVote(name);
                    setState(() {
                      voted = true;
                    });
                  },
                ),
              ),
            )),
      ],
    );
  }
}
