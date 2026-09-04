import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'core/theme/kids_theme.dart';
import 'core/widgets/web_mobile_shell.dart';
import 'features/home/home_page.dart';
import 'services/background_music.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await rive.RiveNative.init();
  BackgroundMusic.instance.start();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IRKOP Belajar TK',
      theme: KidsTheme.data(),
      builder: (context, child) => WebMobileShell(
        child: child ?? const SizedBox.shrink(),
      ),
      home: const HomePage(),
    ),
  );
}
