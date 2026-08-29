import 'package:flutter/material.dart';

import '../learning/learning_page.dart';

class HijaiyahPage extends StatelessWidget {
  const HijaiyahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningPage(
      type: LearningType.hijaiyah,
    );
  }
}
