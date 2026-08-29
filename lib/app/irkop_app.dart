import 'package:flutter/material.dart';

import 'app_router.dart';
import 'app_theme.dart';

class IrkopApp extends StatelessWidget {
  const IrkopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IRKOP Belajar TK',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      initialRoute: AppRouter.home,

      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
