import 'package:flutter/material.dart';

class PlayerEliminated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Vous avez été éliminé...!",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w900,
            fontFamily: 'Open Sans',
            fontSize: 20),
      ),
    );
  }
}
