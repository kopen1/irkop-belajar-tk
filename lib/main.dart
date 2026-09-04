import 'package:flutter/material.dart';

import 'core/theme/kids_theme.dart';
import 'features/home/home_page.dart';
import 'services/background_music.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundMusic.instance.start();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IRKOP Belajar TK',
      theme: KidsTheme.data(),
      home: const HomePage(),
    ),
  );
}
