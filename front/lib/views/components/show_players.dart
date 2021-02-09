import 'package:flutter/material.dart';
import 'package:front/services/models/player.dart';

class ShowPlayers extends StatefulWidget {
  final List<Player> players;

  ShowPlayers({this.players});

  @override
  _ShowPlayersState createState() => _ShowPlayersState();
}

class _ShowPlayersState extends State<ShowPlayers> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: this.widget.players.length,
          itemBuilder: (context, index) {
            return Text(this.widget.players.elementAt(index).name);
          },
    );
  }
}
