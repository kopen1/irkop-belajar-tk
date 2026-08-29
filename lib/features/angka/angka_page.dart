import 'package:flutter/material.dart';

import '../learning/learning_data.dart';
import '../learning/learning_page.dart';

class AngkaPage extends StatelessWidget {
  const AngkaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningPage(
      title: 'Dunia Angka 🔢',
      subtitle: 'Belajar angka sambil bermain',
      items: angkaItems,
    );
  }
}
