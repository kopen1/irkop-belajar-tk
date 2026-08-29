import 'package:flutter/material.dart';
import '../learning/learning_data.dart';
import '../learning/learning_page.dart';

class WarnaPage extends StatelessWidget {
  const WarnaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningPage(
      title: 'Dunia Warna',
      subtitle: 'Klik warna dan lihat dunia berubah',
      items: warnaItems,
      colorMode: true,
    );
  }
}
