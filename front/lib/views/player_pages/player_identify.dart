import 'package:flutter/material.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/managers/lobby_manager.dart';
import 'package:front/views/components/loading.dart';

class PlayerIdentify extends StatefulWidget {
  @override
  _PlayerIdentifyState createState() => _PlayerIdentifyState();
}

class _PlayerIdentifyState extends State<PlayerIdentify> {
  final _controller = TextEditingController();
  LobbyManager lobbyManager = Global().fetch(LobbyManager);
  bool chosenName = false;

  @override
  Widget build(BuildContext context) {
    if (chosenName) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("La partie va démarrer ..."),
          SizedBox(
            height: 50,
          ),
          Loading()
        ],
      );
    }
    return Column(children: [
      Flexible(flex: 1, child: Center(child: Text("Saisie ton pseudonyme"))),
      Flexible(
        flex: 1,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: _controller,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: ElevatedButton(
                    child: Text("Rejoindre la partie"),
                    onPressed: () {
                      lobbyManager.identify(_controller.text);
                      setState(() {
                        chosenName = true;
                      });
                    }),
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
