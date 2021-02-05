import 'package:flutter/material.dart';
import 'package:phoneview/services/models/card.dart';

class ShowHand extends StatefulWidget {
  final List<GameCard> cards;

  ShowHand(this.cards);

  @override
  _ShowHandState createState() => _ShowHandState();
}

class _ShowHandState extends State<ShowHand> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          return widget.cards.elementAt(index).show();
        });
  }
}
