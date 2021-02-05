import 'package:flutter/material.dart';

class GameCard {
  // variables
  bool _isFaceUp;
  bool _isSelected;
  String path;
  final String _downPath = 'assets/images/GameCardBack.jpg';
  int id;

  // Constructor
  GameCard(String path, int id) {
    _isFaceUp = false;
    _isSelected = false;
    this.path = 'assets/images/' + path;
    this.id = id;
  }

  GameCard.fromJson(dynamic jsonGameCard) {
    path = 'assets/images/' + (jsonGameCard['path'] as String);
    id = jsonGameCard['id'] as int;
    _isFaceUp = false;
    _isSelected = false;
  }

  // Getters

  // Functions
  Widget show() {
    return Container(
      height: 120,
      width: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(_isFaceUp ? path : _downPath),
      ),
    );
  }
}
