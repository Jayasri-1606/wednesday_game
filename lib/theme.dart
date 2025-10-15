import 'package:flutter/material.dart';

final ThemeData wednesdayDarkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true, // optional, but recommended for latest Flutter
  colorScheme: ColorScheme.dark(
    primary: Colors.black,
    onPrimary: Colors.white,
    background: Colors.black,
    onBackground: Colors.white,
    surface: Colors.grey[900]!,
    onSurface: Colors.white70,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  cardColor: Colors.grey[900],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[800],
      foregroundColor: Colors.white,
    ),
  ),
  // Text theme
  textTheme: Typography.whiteMountainView, // gives white text by default
);
