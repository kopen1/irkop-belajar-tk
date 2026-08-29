import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../shared/widgets/menu_card.dart';

import '../huruf/huruf_page.dart';
import '../angka/angka_page.dart';
import '../hijaiyah/hijaiyah_page.dart';
import '../gambar/gambar_page.dart';
import '../warna/warna_page.dart';
import '../mewarnai/mewarnai_page.dart';
import '../titik_garis/titik_garis_page.dart';
import '../kuis/kuis_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void openPage(Widget page) {
    AudioService.click();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Huruf', '🔤', AppColors.secondary, const HurufPage()),
      ('Angka', '🔢', AppColors.yellow, const AngkaPage()),
      ('Hijaiyah', '🕌', AppColors.green, const HijaiyahPage()),
      ('Gambar', '🦁', AppColors.pink, const GambarPage()),
      ('Warna', '🎨', AppColors.purple, const WarnaPage()),
      ('Mewarnai', '🖍️', AppColors.primary, const MewarnaiPage()),
      ('Titik & Garis', '✏️', AppColors.secondary, const TitikGarisPage()),
      ('Kuis', '🏆', AppColors.yellow, const KuisPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌈 IRKOP Belajar TK'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              AudioService.backsoundOn
                  ? Icons.music_note
                  : Icons.music_off,
            ),
            onPressed: () {
              setState(() {
                AudioService.toggleBacksound();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: GridView.builder(
            itemCount: items.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return MenuCard(
                title: item.$1,
                emoji: item.$2,
                color: item.$3,
                onTap: () => openPage(item.$4),
              );
            },
          ),
        ),
      ),
    );
  }
}
