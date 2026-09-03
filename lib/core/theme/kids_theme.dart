import 'package:flutter/material.dart';

/// Shared visual language for the Sunny Kids Adventure theme.
class KidsTheme {
  static const sky = Color(0xFF62C8F5);
  static const sunny = Color(0xFFFFD95A);
  static const pink = Color(0xFFFF8FB3);
  static const mint = Color(0xFF76D69B);
  static const orange = Color(0xFFFFAE5C);
  static const purple = Color(0xFFA98BEF);
  static const ink = Color(0xFF244B6F);
  static const surface = Color(0xFFF7FCFF);

  static ThemeData data() {
    final scheme = ColorScheme.fromSeed(
      seedColor: sky,
      brightness: Brightness.light,
      primary: sky,
      secondary: sunny,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: true,
      ),
      tabBarTheme: const TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: ink,
        unselectedLabelColor: Color(0xFF6F8CA5),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFD8E8F2), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFD8E8F2), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: sky, width: 2),
        ),
      ),
    );
  }
}
