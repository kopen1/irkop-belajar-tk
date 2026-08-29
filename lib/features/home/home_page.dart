import 'package:flutter/material.dart';

import '../../core/widgets/kid_background.dart';
import '../angka/angka_page.dart';
import '../gambar/gambar_page.dart';
import '../hijaiyah/hijaiyah_page.dart';
import '../huruf/huruf_page.dart';
import '../kuis/kuis_page.dart';
import '../mewarnai/mewarnai_page.dart';
import '../titik_garis/titik_garis_page.dart';
import '../warna/warna_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final entries = <_HomeEntry>[
      const _HomeEntry('🔤', 'Dunia Huruf', 'Belajar A sampai Z', HurufPage()),
      const _HomeEntry('🔢', 'Dunia Angka', 'Belajar angka sambil bermain', AngkaPage()),
      const _HomeEntry('🕌', 'Hijaiyah', 'Kenali huruf Hijaiyah', HijaiyahPage()),
      const _HomeEntry('🐱', 'Dunia Gambar', 'Hewan, buah dan benda', GambarPage()),
      const _HomeEntry('🎨', 'Dunia Warna', 'Mengenal berbagai warna', WarnaPage()),
      const _HomeEntry('🖍️', 'Mewarnai', 'Pilih warna dan gambar', MewarnaiPage()),
      const _HomeEntry('🔗', 'Titik & Garis', 'Tarik garis mengikuti urutan', TitikGarisPage()),
      const _HomeEntry('🧠', 'Kuis Seru', 'Pertanyaan tanpa batas', KuisPage()),
    ];

    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 560
                      ? 2
                      : 1;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: Column(
                      children: [
                        const Text(
                          '🎓 IRKOP Belajar TK',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF31536D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ayo bermain sambil belajar! 🌈',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF55758C),
                          ),
                        ),
                        const SizedBox(height: 22),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: entries.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: columns == 1 ? 3.55 : 1.55,
                          ),
                          itemBuilder: (context, i) {
                            final entry = entries[i];
                            return _HomeCard(
                              entry: entry,
                              onTap: () => _go(context, entry.page),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeEntry {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget page;

  const _HomeEntry(this.emoji, this.title, this.subtitle, this.page);
}

class _HomeCard extends StatelessWidget {
  final _HomeEntry entry;
  final VoidCallback onTap;

  const _HomeCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(30),
      elevation: 5,
      shadowColor: const Color(0x440D405C),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Text(entry.emoji, style: const TextStyle(fontSize: 52)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF31536D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF668398),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF5EA8F5),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
