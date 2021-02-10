import 'package:flutter/material.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/models/player.dart';
import 'package:front/views/components/loading.dart';

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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (Player player in gameManager.game.players)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(player.name + ' a rejoint la partie'),
                    ),
                  ),
                ),
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
    );
  }
}
