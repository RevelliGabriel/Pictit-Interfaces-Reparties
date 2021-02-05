import 'package:flutter/material.dart';
import 'package:front/services/models/player.dart';

class ShowPlayers extends StatelessWidget {
  final List<Player> players;

  ShowPlayers({this.players});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: this.players.length,
        itemBuilder: (context, index) {
          return Text(this.players.elementAt(index).name);
        });
  }
}
