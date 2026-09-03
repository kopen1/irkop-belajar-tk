import 'package:flutter/material.dart';

/// Little Explorer — clean, cheerful and touch-first visual language for TK.
class KidsTheme {
  static const primary = Color(0xFF4DB6E8);
  static const yellow = Color(0xFFFFD45C);
  static const green = Color(0xFF62C98B);
  static const pink = Color(0xFFF58BA8);
  static const orange = Color(0xFFFFAB62);
  static const purple = Color(0xFF9B8AEF);
  static const teal = Color(0xFF55C6B0);
  static const ink = Color(0xFF24445C);
  static const muted = Color(0xFF718798);
  static const background = Color(0xFFF5FAFD);
  static const border = Color(0xFFDCEBF2);
  static const card = Colors.white;

  static ThemeData data() {
    final scheme = ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light, primary: primary, secondary: yellow, surface: background);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: ink, elevation: 0, centerTitle: false, titleTextStyle: TextStyle(color: ink, fontSize: 22, fontWeight: FontWeight.w900)),
      tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent, labelColor: ink, unselectedLabelColor: muted, indicatorColor: primary, indicatorSize: TabBarIndicatorSize.label, labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 15), unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      cardTheme: CardThemeData(color: card, elevation: 2, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: border))),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(minimumSize: const Size(0, 54), padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14), backgroundColor: primary, foregroundColor: Colors.white, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: card, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: border, width: 1.5)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: border, width: 1.5)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: primary, width: 2))),
    );
  }
}
