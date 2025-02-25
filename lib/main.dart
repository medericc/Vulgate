import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/chapter_screen.dart';
import 'screens/verse_screen.dart';

void main() {
  runApp(const VulgateApp());
}

class VulgateApp extends StatelessWidget {
  const VulgateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vulgate App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const HomeScreen(),
    );
  }
}
