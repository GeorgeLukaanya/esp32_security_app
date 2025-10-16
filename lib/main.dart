import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Esp32SecurityApp());
}

class Esp32SecurityApp extends StatelessWidget {
  const Esp32SecurityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ESP32 Security',
            theme: themeProvider.getTheme(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
