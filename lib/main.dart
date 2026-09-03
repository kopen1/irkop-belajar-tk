import 'package:flutter/material.dart';

import 'features/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar TK',
      home: HomePage(),
    ),
  );
}
