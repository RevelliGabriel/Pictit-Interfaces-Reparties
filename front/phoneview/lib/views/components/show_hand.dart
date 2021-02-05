import 'package:flutter/material.dart';
import 'package:phoneview/services/models/card.dart';

// ignore: must_be_immutable
class ShowHand extends StatefulWidget {
  final List<GameCard> cards;
  final Function function;
  // ignore: avoid_init_to_null
  int selectedCardId = null;

  ShowHand({this.cards, this.function, this.selectedCardId});

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
          GameCard card = widget.cards.elementAt(index);
          return GestureDetector(
              onTap: () {
                widget.function(card);
                setState(() {
                  widget.selectedCardId = card.id;
                });
              },
              child: card.show(widget.selectedCardId == card.id));
        });
  }
}
