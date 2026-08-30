import 'package:flutter/material.dart';

import 'features/intro/play_intro_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar TK',
      home: const PlayIntroPage(),
    ),
  );
}
