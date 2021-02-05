import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/components/show_players.dart';

class BoardLobby extends StatefulWidget {
  @override
  _BoardLobbyState createState() => _BoardLobbyState();
}

class _BoardLobbyState extends State<BoardLobby> {
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: gameManager.gameUpdatedStream,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return ShowPlayers(players: gameManager.game.players);
        }
        return Text("Waiting for players ...");
      },
    );
  }
}
