import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Esp32SecurityApp());
}

class Esp32SecurityApp extends StatelessWidget {
  const Esp32SecurityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ESP32 Security',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
