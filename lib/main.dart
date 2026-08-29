import 'package:flutter/material.dart';

import 'features/splash/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar TK',
      home: const SplashPage(),
    ),
  );
}
