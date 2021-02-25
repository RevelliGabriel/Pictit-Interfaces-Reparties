import 'package:flutter/material.dart';

class PlayerEndGame extends StatefulWidget {
  @override
  _PlayerEndGameState createState() => _PlayerEndGameState();
}

class _PlayerEndGameState extends State<PlayerEndGame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                    height: 40,
                    width: 40,
                    child: Image.asset("assets/images/tada_left.png")),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Regarde l'écran de jeu pour découvrir le vainqueur !",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Open Sans',
                        fontSize: 12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                    height: 40,
                    width: 40,
                    child: Image.asset("assets/images/tada_right.png")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
