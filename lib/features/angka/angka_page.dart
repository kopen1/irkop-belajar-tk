import 'package:flutter/material.dart';

import '../../core/constants/app_data.dart';
import '../../core/services/audio_service.dart';
import '../../shared/widgets/fun_page.dart';

class AngkaPage extends StatelessWidget {
  const AngkaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: 'Belajar Angka',
      emoji: '🔢',
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppData.angka.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final angka = AppData.angka[index];

          return InkWell(
            onTap: () => AudioService.speak(angka),
            borderRadius: BorderRadius.circular(20),
            child: Card(
              child: Center(
                child: Text(
                  angka,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
