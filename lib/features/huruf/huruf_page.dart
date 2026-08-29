import 'package:flutter/material.dart';

import '../learning/learning_data.dart';
import '../learning/learning_page.dart';

class HurufPage extends StatelessWidget {
  const HurufPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningPage(
      title: 'Belajar Huruf 🔤',
      subtitle: 'Mengenal Huruf A - Z',
      items: hurufItems,
    );
  }
}
