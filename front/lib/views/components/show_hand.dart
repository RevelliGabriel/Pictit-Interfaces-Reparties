import 'package:flutter/material.dart';
import 'package:front/services/models/card.dart';
import 'package:front/views/components/show_card.dart';

// ignore: must_be_immutable
class ShowHand extends StatefulWidget {
  final List<GameCard> cards;
  final Function function;
  int selectedCardId;
  final bool disableSelection;

  ShowHand(
      {this.cards,
      this.function,
      this.selectedCardId,
      this.disableSelection = false});

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
          return Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: GestureDetector(
                onTap: () {
                  if (widget.function != null) {
                    widget.function(card);
                  }
                  if (!widget.disableSelection) {
                    setState(() {
                      widget.selectedCardId = card.id;
                    });
                  }
                },
                child: Center(
                  child: ShowCard(
                    card: card,
                    selected: widget.selectedCardId == card.id,
                    ratio: 1.5,
                  ),
                )),
          );
        });
  }
}
