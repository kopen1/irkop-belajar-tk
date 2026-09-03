import 'package:flutter/material.dart';

import 'core/theme/kids_theme.dart';
import 'features/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IRKOP Belajar TK',
      theme: KidsTheme.data(),
      home: const HomePage(),
    ),
  );
}
