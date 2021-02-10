import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/components/show_vote_players.dart';

class PlayerTurnVote extends StatefulWidget {
  @override
  _PlayerTurnVoteState createState() => _PlayerTurnVoteState();
}

class _PlayerTurnVoteState extends State<PlayerTurnVote> {
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(flex: 1, child: Text("C'est l'heure des votes")),
        Flexible(flex: 1, child: Text("Discutez, puis votez !")),
        Flexible(
            flex: 1,
            child: Center(
              child: ShowVotePlayers(
                players: gameManager.players,
                function: (String name) {
                  gameManager.chooseVote(name);
                },
              ),
            )),
      ],
    );
  }
}
