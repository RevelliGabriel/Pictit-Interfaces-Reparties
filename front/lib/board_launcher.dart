import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front/services/managers/connection_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/managers/lobby_manager.dart';
import 'package:front/services/themes/initial_theme.dart';
import 'package:front/views/board_pages/board_wrapper.dart';
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
        title: 'Pictit Board',
        theme: InitialTheme().theme,
        home: MyHomePage(title: 'Flutter WEEEEEB'),
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

  @override
  void initState() {
    connectionManager.connect();
    lobbyManager.identify("board");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BoardWrapper(),
    );
  }
}
