import 'package:flutter/material.dart';

class InitialTheme {
  final Color glaucous = Color(0xFF7D8CC4);
  final Color wildBlueYonder = Color(0xFF9CA8D3);
  final Color minionYellow = Color(0xFFFDE74C);
  final Color atomicTangerine = Color(0xFFF79256);
  final Color sinopia = Color(0xFFBA5A31);
  final Color red = Colors.red;
  final Color green = Colors.green;
  final Color black = Colors.black;
  final Color darkGrey = Colors.grey[900];
  final Color grey = Colors.grey;
  final Color white = Colors.white;

  ThemeData get theme {
    ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: atomicTangerine,
      primaryVariant: sinopia,
      secondary: glaucous,
      secondaryVariant: minionYellow,
      error: red,
      background: wildBlueYonder,
      onError: white,
      onSecondary: white,
      onBackground: darkGrey,
      onPrimary: white,
      onSurface: darkGrey,
      surface: white,
    );
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: colorScheme.primary,
        primaryColorDark: colorScheme.primaryVariant,
        errorColor: colorScheme.error,
        colorScheme: colorScheme,
        primaryColorBrightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        accentColor: colorScheme.secondary,
        primaryColorLight: colorScheme.secondaryVariant,
        backgroundColor: colorScheme.background,
        canvasColor: colorScheme.background);
  }
}
