import 'package:flutter/material.dart';

import '../learning/learning_data.dart';
import '../learning/learning_page.dart';

class HijaiyahPage extends StatelessWidget {
  const HijaiyahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningPage(
      title: 'Belajar Hijaiyah 🕌',
      subtitle: 'Mengenal Huruf Arab',
      items: hijaiyahItems,
    );
  }
}
