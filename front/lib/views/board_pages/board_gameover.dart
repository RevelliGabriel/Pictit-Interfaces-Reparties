import 'package:flutter/material.dart';

class BoardGameover extends StatefulWidget {
  final bool intruWin;
  final String word;
  final String intruName;

  BoardGameover({this.intruName, this.word, this.intruWin});

  @override
  _BoardGameoverState createState() => _BoardGameoverState();
}

class _BoardGameoverState extends State<BoardGameover> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("La partie est fini !"),
          // Text("Françis a gagné !"),
          Text(
            'La partie est finie..!',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w900,
                fontFamily: 'Open Sans',
                fontSize: 40),
          ),
          Text(
            'le mot était : ' + widget.word,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w900,
                fontFamily: 'Open Sans',
                fontSize: 30),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/images/tada_left.png")),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      (!widget.intruWin)
                          ? Text(
                              "On a trouvé ${widget.intruName} !",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Open Sans',
                                  fontSize: 40),
                            )
                          : Text(
                              "${widget.intruName} a gagné !",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Open Sans',
                                  fontSize: 40),
                            ),
                      Text(
                        "Il était l'intrus",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Open Sans',
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/images/tada_right.png")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
