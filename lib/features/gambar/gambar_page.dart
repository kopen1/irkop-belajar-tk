import 'package:flutter/material.dart';

import '../learning/learning_data.dart';
import '../learning/learning_page.dart';

class GambarPage extends StatelessWidget {
  const GambarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningPage(
      title: 'Belajar Gambar 🦁',
      subtitle: 'Mengenal Benda di Sekitar Kita',
      items: gambarItems,
    );
  }
}
