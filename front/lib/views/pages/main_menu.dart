import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/services/enums/connection_state_enum.dart';
import 'package:front/services/managers/connection_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/views/pages/identify.dart';
import 'package:front/views/pages/wrapper.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
            return Wrapper();
          }
          return Container(
            child: Row(
              children: [
                Flexible(child: Container()),
                Flexible(
                    flex: 1,
                    child: RaisedButton(
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
