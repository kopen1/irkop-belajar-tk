import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
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
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const HomePage(),
    );
  }
}
