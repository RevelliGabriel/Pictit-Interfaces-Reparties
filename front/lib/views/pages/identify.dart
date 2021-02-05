import 'package:flutter/material.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/managers/lobby_manager.dart';

class Identify extends StatefulWidget {
  @override
  _IdentifyState createState() => _IdentifyState();
}

class _IdentifyState extends State<Identify> {
  final _controller = TextEditingController();
  LobbyManager lobbyManager = Global().fetch(LobbyManager);

  @override
  Widget build(BuildContext context) {
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
  }
}
