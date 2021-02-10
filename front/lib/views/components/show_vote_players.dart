import 'package:flutter/material.dart';
import 'package:front/services/models/player.dart';

class ShowVotePlayers extends StatelessWidget {
  final List<Player> players;
  final Function function;

  ShowVotePlayers({this.players, this.function});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: this.players.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                function(players.elementAt(index).name);
              },
              child: Text(this.players.elementAt(index).name),
            ),
          );
        });
  }
}
