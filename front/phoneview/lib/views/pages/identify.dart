import 'package:flutter/material.dart';
import 'package:phoneview/services/enums/connection_state_enum.dart';
import 'package:phoneview/services/managers/game_manager.dart';
import 'package:phoneview/services/managers/global.dart';
import 'package:phoneview/services/managers/lobby_manager.dart';
import 'package:phoneview/services/models/player.dart';
import 'package:phoneview/views/components/show_hand.dart';

class Identify extends StatefulWidget {
  @override
  _IdentifyState createState() => _IdentifyState();
}

class _IdentifyState extends State<Identify> {
  final _controller = TextEditingController();
  LobbyManager lobbyManager = Global().fetch(LobbyManager);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
        stream: lobbyManager.inLobbyPlayersStream,
        builder: (context, snapshot) {
          if (snapshot.data.length == 2) {}
          return Container(
            child: Row(
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
                      child: Text("Join Lobby"),
                      onPressed: () {
                        lobbyManager.identify(_controller.text);
                      }),
                )
              ],
            ),
          );
        });
  }
}
