import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/components/loading.dart';
import 'package:front/views/components/show_players.dart';

class BoardLobby extends StatefulWidget {
  @override
  _BoardLobbyState createState() => _BoardLobbyState();
}

class _BoardLobbyState extends State<BoardLobby> {
  GameManager gameManager = Global().fetch(GameManager);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<bool>(
        stream: gameManager.gameUpdatedStream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ShowPlayers(players: gameManager.game.players),
                SizedBox(
                  height: 50,
                ),
                Loading()
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("En attente d'autres joueurs"),
              SizedBox(
                height: 50,
              ),
              Loading()
            ],
          );
        },
      ),
    );
  }
}
