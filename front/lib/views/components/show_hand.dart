import 'package:flutter/material.dart';
import 'package:front/services/models/card.dart';
import 'package:front/views/components/show_card.dart';

// ignore: must_be_immutable
class ShowHand extends StatefulWidget {
  final List<GameCard> cards;
  final Function function;
  int selectedCardId;
  final bool disableSelection;
  final bool faceDown;
  final double ratio;
  final bool isScrollable;

  ShowHand({
    @required this.cards,
    this.function,
    this.selectedCardId,
    this.disableSelection = false,
    this.faceDown = false,
    this.ratio = 1.5,
    this.isScrollable = true,
  });

  @override
  _ShowHandState createState() => _ShowHandState();
}

class _ShowHandState extends State<ShowHand> {
  @override
  Widget build(BuildContext context) {
    if (widget.isScrollable) {
      return Container(
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.cards.length,
            itemBuilder: (context, index) {
              return constructCard(widget.cards.elementAt(index));
            }),
      );
    }
    return Container(
      child: Row(
        children: [...widget.cards.map((e) => constructCard(e))],
      ),
    );
  }

  Widget constructCard(GameCard card) {
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
          child: ShowCard(
            card: card,
            selected: widget.selectedCardId == card.id,
            ratio: widget.ratio,
            faceDown: widget.faceDown,
          )),
    );
  }
}
