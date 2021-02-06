import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/services/enums/connection_state_enum.dart';
import 'package:front/services/managers/connection_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/player_pages/player_wrapper.dart';

class PlayerMenu extends StatefulWidget {
  @override
  _PlayerMenuState createState() => _PlayerMenuState();
}

class _PlayerMenuState extends State<PlayerMenu> {
  ConnectionManager connectionManager = Global().fetch(ConnectionManager);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionStateEnum>(
        stream: connectionManager.connectionStateStream,
        initialData: ConnectionStateEnum.DISCONNECTED,
        builder: (context, snapshot) {
          if (snapshot.data == ConnectionStateEnum.CONNECTED) {
            return PlayerWrapper();
          }
          return Container(
            child: Column(
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(
                    flex: 2,
                    child: ElevatedButton(
                        child: Text("Jouer"),
                        onPressed: () {
                          connectionManager.connect();
                        })),
              ],
            ),
          );
        });
  }
}
