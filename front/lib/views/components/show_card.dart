import 'package:flutter/material.dart';
import 'package:front/services/models/card.dart';

class ShowCard extends StatefulWidget {
  final bool faceDown;
  final bool selected;
  final GameCard card;
  final double ratio;
  final double weight = 70;
  final double height = 100;

  ShowCard(
      {this.faceDown = false,
      this.selected = false,
      @required this.card,
      this.ratio = 1});

  @override
  _ShowCardState createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.selected
          ? 1.2 * widget.ratio * widget.height
          : widget.ratio * widget.height,
      width: widget.selected
          ? 1.2 * widget.ratio * widget.weight
          : widget.ratio * widget.weight,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(
                  widget.faceDown ? widget.card.downPath : widget.card.path)),
          border: Border.all(
            width: widget.selected ? 1.2 * widget.ratio * 2 : widget.ratio * 2,
          ),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
