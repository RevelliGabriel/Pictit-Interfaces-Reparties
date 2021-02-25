import 'package:flutter/material.dart';
import 'package:front/services/managers/connection_manager.dart';
import 'package:front/services/managers/game_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/managers/lobby_manager.dart';
import 'package:front/services/models/player.dart';
import 'package:front/services/themes/initial_theme.dart';
import 'package:front/views/components/fancy_fab.dart';
import 'package:front/views/player_pages/player_menu.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => Global(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: InitialTheme().theme,
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectionManager connectionManager = Global().fetch(ConnectionManager);
  LobbyManager lobbyManager = Global().fetch(LobbyManager);
  GameManager gameManager = Global().fetch(GameManager);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayerMenu(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     gameManager.sendHint(null);
      //   },
      //   child: Icon(Icons.navigation),
      //   backgroundColor: Colors.green,
      // ),
      floatingActionButton: StreamBuilder<List<Player>>(
          stream: gameManager.playersStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FancyFab(
                players: snapshot.data,
                me: gameManager.me,
                function: (String playerTo, String playerIntrus) { gameManager.sendHint(playerTo, playerIntrus); },
              );
            }
            return Container();
          }),
    );
  }
}
