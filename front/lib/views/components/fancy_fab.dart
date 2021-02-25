import 'package:flutter/material.dart';
import 'package:front/services/models/player.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  final List<Player> players;
  final Player me;
  final Function function;

  FancyFab(
      {this.onPressed,
      this.tooltip,
      this.icon,
      this.players,
      this.me,
      this.function});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Color(0xFF7D8CC4),
      end: Color(0xFFF79256),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget playerIcon(playerName) {
    return Container(
      child: FloatingActionButton(
        onPressed: () async {
          await animated_dialog_box.showScaleAlertBox(
              title: Center(
                  child: Text("Envoyer un message à " +
                      playerName)), // IF YOU WANT TO ADD
              context: context,
              firstButton: MaterialButton(
                // FIRST BUTTON IS REQUIRED
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: Colors.white,
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              icon: Icon(
                Icons.message,
                color: Colors.red,
              ), // IF YOU WANT TO ADD ICON
              yourWidget: Container(
                height: 300,
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Qui pensez-vous être l'intrus ?"),
                    generatePlayersShape(playerName),
                  ],
                ),
              ));
        },
        tooltip: 'Joueur',
        child: Text(playerName),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Actions',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  List<Widget> getPlayersIcons() {
    List<Widget> listWidget = [];
    int i = widget.players.length - 1;
    for (Player player in widget.players) {
      if (player.name != widget.me.name) {
        listWidget.add(Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * i,
            0.0,
          ),
          child: playerIcon(player.name),
        ));
        i--;
      }
    }
    return listWidget;
  }

  Widget generatePlayersShape(String playerTo) {
    List<Widget> listWidget = [];
    int i = widget.players.length - 1;
    for (Player player in widget.players) {
      if (player.name != widget.me.name) {
        listWidget.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: MaterialButton(
            height: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            color: playerTo == player.name
                ? Theme.of(context).primaryColorDark
                : Theme.of(context).primaryColor,
            child: Text(player.name),
            onPressed: () {
              widget.function(playerTo, player.name);
              Navigator.of(context).pop();
            },
          ),
        ));
      }
    }
    return SizedBox(
      height: 200,
      width: 200,
      child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: listWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ...getPlayersIcons(),
        toggle(),
      ],
    );
  }
}
