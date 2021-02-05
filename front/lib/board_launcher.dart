import 'package:flutter/material.dart';
import 'package:front/services/managers/connection_manager.dart';
import 'package:front/services/managers/global.dart';
import 'package:front/services/managers/lobby_manager.dart';
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
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
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
    super.initState();
  }

  // Listen to all message events from connected users
  void handleMessage(Map<String, dynamic> data) {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GestureDetector(
        child: BoardWrapper(),
        onTap: () {
          lobbyManager.identify("board");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          connectionManager.connect();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comm
    );
  }
}
