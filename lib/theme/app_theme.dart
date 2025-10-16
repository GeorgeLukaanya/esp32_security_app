import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: Colors.deepOrangeAccent,
    colorScheme: const ColorScheme.dark(
      primary: Colors.deepOrangeAccent,
      secondary: Colors.blueAccent,
      error: Colors.redAccent,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
