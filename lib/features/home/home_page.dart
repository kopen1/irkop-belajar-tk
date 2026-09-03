import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../services/background_music.dart';
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
    const entries = <_HomeEntry>[
      _HomeEntry('🔤', 'Dunia Huruf', [Color(0xFFFF7FA4), Color(0xFFE83D72)]),
      _HomeEntry('🔢', 'Dunia Angka', [Color(0xFF68C5F0), Color(0xFF2589D5)]),
      _HomeEntry('🕌', 'Dunia Hijaiyah', [Color(0xFF91D96B), Color(0xFF32A96B)]),
      _HomeEntry('🐱', 'Dunia Gambar', [Color(0xFFFFB45E), Color(0xFFFF7B3D)]),
      _HomeEntry('🎨', 'Dunia Warna', [Color(0xFFB78AF0), Color(0xFF7B50D1)]),
      _HomeEntry('🖍️', 'Mewarnai', [Color(0xFFF18BE8), Color(0xFFB752D0)]),
      _HomeEntry('🔗', 'Titik & Garis', [Color(0xFFFFD86A), Color(0xFFFFA62E)]),
      _HomeEntry('🧠', 'Kuis Seru', [Color(0xFF8C8CF1), Color(0xFF5B55C9)]),
    ];
    const pages = [
      HurufPage(), AngkaPage(), HijaiyahPage(), GambarPage(),
      WarnaPage(), MewarnaiPage(), TitikGarisPage(), KuisPage(),
    ];

    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 430;
              final columns = constraints.maxWidth >= 700 ? 4 : 2;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(compact ? 12 : 20, 12, compact ? 12 : 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        _Hero(compact: compact),
                        const SizedBox(height: 14),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: entries.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: compact ? 10 : 14,
                            mainAxisSpacing: compact ? 10 : 14,
                            childAspectRatio: columns == 2 ? 1.02 : 1.0,
                          ),
                          itemBuilder: (context, index) => _HomeCard(
                            entry: entries[index],
                            compact: compact,
                            onTap: () => _go(context, pages[index]),
                          ),
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

class _Hero extends StatelessWidget {
  final bool compact;
  const _Hero({required this.compact});

  @override
  Widget build(BuildContext context) {
    final music = BackgroundMusic.instance;
    return Container(
      padding: EdgeInsets.fromLTRB(compact ? 14 : 22, 14, compact ? 14 : 22, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .24),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withValues(alpha: .55), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              ValueListenableBuilder<bool>(
                valueListenable: music.enabled,
                builder: (context, on, _) => _SoundButton(
                  on: on,
                  onTap: () {
                    music.toggle();
                    if (music.enabled.value) music.start();
                  },
                ),
              ),
            ],
          ),
          Text('Halo, Teman Pintar! 👋', textAlign: TextAlign.center, style: TextStyle(fontSize: compact ? 28 : 38, fontWeight: FontWeight.w900, color: const Color(0xFF174B7D))),
          const SizedBox(height: 2),
          Text('IRKOP Belajar TK', textAlign: TextAlign.center, style: TextStyle(fontSize: compact ? 34 : 46, fontWeight: FontWeight.w900, color: const Color(0xFFFFD83D), shadows: const [Shadow(color: Color(0xFF174B7D), blurRadius: 2, offset: Offset(2, 3))])),
          const SizedBox(height: 2),
          Text('Belajar • Bermain • Jadi Hebat! 🌈', textAlign: TextAlign.center, style: TextStyle(fontSize: compact ? 15 : 19, fontWeight: FontWeight.w800, color: Colors.white, shadows: const [Shadow(color: Color(0x66264C68), blurRadius: 3, offset: Offset(1, 2))])),
          Transform.translate(offset: const Offset(0, 8), child: Text('🐼', style: TextStyle(fontSize: compact ? 68 : 86))),
        ],
      ),
    );
  }
}

class _SoundButton extends StatelessWidget {
  final bool on;
  final VoidCallback onTap;
  const _SoundButton({required this.on, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: on ? const Color(0xFF35C84A) : const Color(0xFF7C8B99),
    shape: const CircleBorder(),
    elevation: 6,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: const SizedBox(width: 60, height: 60, child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 34)),
    ),
  );
}

class _HomeEntry {
  final String emoji;
  final String title;
  final List<Color> colors;
  const _HomeEntry(this.emoji, this.title, this.colors);
}

class _HomeCard extends StatelessWidget {
  final _HomeEntry entry;
  final bool compact;
  final VoidCallback onTap;
  const _HomeCard({required this.entry, required this.compact, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(30),
    elevation: 7,
    shadowColor: const Color(0x440D405C),
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: entry.colors),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: .65), width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(compact ? 10 : 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: FittedBox(fit: BoxFit.contain, child: Text(entry.emoji, style: const TextStyle(fontSize: 82)))),
              const SizedBox(height: 5),
              Text(entry.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 18 : 22, height: 1.05, fontWeight: FontWeight.w900, color: Colors.white, shadows: const [Shadow(color: Color(0x8800184A), blurRadius: 2, offset: Offset(0, 2))])),
            ],
          ),
        ),
      ),
    ),
  );
}
