import 'package:flutter/material.dart';

import 'screens/pokedex_screen.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE84B55),
          surface: const Color(0xFFF3F6F4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F6F4),
          foregroundColor: Color(0xFF202B27),
          elevation: 0,
        ),
      ),
      home: const PokedexScreen(),
    );
  }
}
