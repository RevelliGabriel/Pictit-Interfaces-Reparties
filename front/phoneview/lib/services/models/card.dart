import 'package:flutter/material.dart';

class GameCard {
  // variables
  String path;
  final String _downPath = 'assets/images/CardBack.jpg';
  int id;

  // Constructor
  GameCard(String path, int id) {
    this.path = 'assets/images/' + path;
    this.id = id;
  }

  GameCard.fromJson(dynamic jsonGameCard) {
    path = 'assets/images/' + (jsonGameCard['path'] as String);
    id = jsonGameCard['id'] as int;
  }

  // Getters

  // Functions

  Widget show(bool selected) {
    return Container(
      height: selected ? 200 : 150,
      width: selected ? 120 : 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(path),
      ),
    );
  }
}
