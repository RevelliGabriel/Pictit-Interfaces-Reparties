import 'package:flutter/material.dart';
import 'package:phoneview/services/enums/connection_state_enum.dart';
import 'package:phoneview/services/managers/connection_manager.dart';
import 'package:phoneview/services/managers/global.dart';
import 'package:phoneview/services/managers/lobby_manager.dart';
import 'package:phoneview/views/pages/main_menu.dart';
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
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectionManager.connect();
  }

  Widget get connectedText => Text("Connecté");

  Widget get disconnectedText => Text("Pas Connecté");

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
      body: MainMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          connectionManager.toggleConnection();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comm
    );
  }
}
