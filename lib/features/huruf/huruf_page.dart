import 'package:flutter/material.dart';

import '../../core/constants/app_data.dart';
import '../../core/services/audio_service.dart';
import '../../shared/widgets/fun_page.dart';

class HurufPage extends StatelessWidget {
  const HurufPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: 'Belajar Huruf',
      emoji: '🔤',
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppData.huruf.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final huruf = AppData.huruf[index];

          return InkWell(
            onTap: () => AudioService.speak(huruf),
            borderRadius: BorderRadius.circular(20),
            child: Card(
              child: Center(
                child: Text(
                  huruf,
                  style: const TextStyle(
                    fontSize: 38,
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
