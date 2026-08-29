import 'package:flutter/material.dart';
import '../features/home/home_page.dart';

class IrkopApp extends StatelessWidget {
  const IrkopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IRKOP Belajar TK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        scaffoldBackgroundColor: const Color(0xFFEAF8FF),
      ),
      home: const HomePage(),
    );
  }
}
