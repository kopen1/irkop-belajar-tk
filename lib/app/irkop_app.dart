import 'package:flutter/material.dart';

import '../features/intro/play_intro_page.dart';

class IrkopApp extends StatelessWidget {
  const IrkopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar TK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5EA8F5),
        ),
      ),
      home: const PlayIntroPage(),
    );
  }
}
