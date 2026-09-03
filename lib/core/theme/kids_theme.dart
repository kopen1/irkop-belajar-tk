import 'package:flutter/material.dart';

/// Sunny Kids Adventure — one visual language for every native Flutter screen.
class KidsTheme {
  static const sky = Color(0xFF62C8F5);
  static const sunny = Color(0xFFFFD95A);
  static const pink = Color(0xFFFF8FB3);
  static const mint = Color(0xFF76D69B);
  static const orange = Color(0xFFFFAE5C);
  static const purple = Color(0xFFA98BEF);
  static const ink = Color(0xFF244B6F);
  static const muted = Color(0xFF6F8CA5);
  static const surface = Color(0xFFF7FCFF);
  static const card = Colors.white;

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
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: true,
      ),
      tabBarTheme: const TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: ink,
        unselectedLabelColor: muted,
        indicatorColor: sky,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
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
        fillColor: card,
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
