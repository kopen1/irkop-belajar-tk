import 'package:flutter/material.dart';

import '../../core/constants/app_data.dart';
import '../../core/services/audio_service.dart';
import '../../shared/widgets/fun_page.dart';

class GambarPage extends StatelessWidget {
  const GambarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FunPage(
      title: 'Belajar Gambar',
      emoji: '🦁',
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppData.gambar.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (_, index) {
          final gambar = AppData.gambar[index];

          return InkWell(
            onTap: () => AudioService.speak(gambar),
            borderRadius: BorderRadius.circular(24),
            child: Card(
              child: Center(
                child: Text(
                  gambar,
                  style: const TextStyle(fontSize: 54),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
