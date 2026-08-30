import 'package:flutter/material.dart';

import '../../core/widgets/kid_background.dart';
import '../../core/services/audio_service.dart';
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
      const _HomeEntry('🔤', 'Huruf', [Color(0xFFFF5B83), Color(0xFFE91E63)], HurufPage()),
      const _HomeEntry('🔢', 'Angka', [Color(0xFF3CA7E8), Color(0xFF1375C8)], AngkaPage()),
      const _HomeEntry('🕌', 'Hijaiyah', [Color(0xFF80D64E), Color(0xFF1FA35B)], HijaiyahPage()),
      const _HomeEntry('🦁', 'Gambar', [Color(0xFFFF9B3F), Color(0xFFFF6E25)], GambarPage()),
      const _HomeEntry('🎨', 'Warna', [Color(0xFF9A5BE7), Color(0xFF6B32BF)], WarnaPage()),
      const _HomeEntry('🖍️', 'Mewarnai', [Color(0xFFC45AE7), Color(0xFF7A38C7)], MewarnaiPage()),
      const _HomeEntry('📝', 'Titik & Garis', [Color(0xFFFFC94E), Color(0xFFFF9E20)], TitikGarisPage()),
      const _HomeEntry('🏆', 'Kuis Seru', [Color(0xFF7B68E8), Color(0xFF4939B9)], KuisPage()),
    ];

    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 390;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(compact ? 12 : 18, 8, compact ? 12 : 18, 26),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      children: [
                        _HomeHero(compact: compact),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x330D405C),
                                blurRadius: 14,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: entries.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: compact ? 8 : 12,
                              mainAxisSpacing: compact ? 8 : 12,
                              childAspectRatio: compact ? 1.08 : 1.22,
                            ),
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              return _HomeCard(
                                entry: entry,
                                compact: compact,
                                onTap: () => _go(context, entry.page),
                              );
                            },
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

class _HomeHero extends StatelessWidget {
  final bool compact;

  const _HomeHero({required this.compact});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          left: compact ? 4 : 12,
          top: 16,
          child: const Text('⭐', style: TextStyle(fontSize: 34)),
        ),
        Positioned(
          right: compact ? 6 : 14,
          top: 52,
          child: const Text('⭐', style: TextStyle(fontSize: 30)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            children: [
              Row(
                children: [
                  _roundIcon(
                    icon: Icons.home_rounded,
                    onTap: () {},
                    compact: compact,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: compact ? 30 : 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                              shadows: const [
                                Shadow(
                                  color: Color(0x66001D58),
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            children: const [
                              TextSpan(
                                text: 'BELAJAR TK',
                                style: TextStyle(color: Color(0xFFFFE12E)),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Belajar, Bermain, Menjadi Anak Pintar',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compact ? 12 : 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Color(0x99001D58),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _roundIcon(
                    icon: Icons.volume_up_rounded,
                    onTap: () => audio.speak('Belajar TK. Pilih permainan yang kamu suka.'),
                    compact: compact,
                  ),
                ],
              ),
              SizedBox(height: compact ? 2 : 8),
              Transform.translate(
                offset: const Offset(0, 6),
                child: const Text('🐼', style: TextStyle(fontSize: 84, height: 0.72)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roundIcon({
    required IconData icon,
    required VoidCallback onTap,
    required bool compact,
  }) {
    final size = compact ? 54.0 : 66.0;
    return Material(
      color: icon == Icons.volume_up_rounded
          ? const Color(0xFF35C84A)
          : const Color(0xFFFFD44B),
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: const Color(0x660D405C),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: compact ? 30 : 38,
            color: Colors.white,
            shadows: const [
              Shadow(color: Color(0x66001D58), blurRadius: 3, offset: Offset(0, 2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeEntry {
  final String emoji;
  final String title;
  final List<Color> colors;
  final Widget page;

  const _HomeEntry(this.emoji, this.title, this.colors, this.page);
}

class _HomeCard extends StatelessWidget {
  final _HomeEntry entry;
  final bool compact;
  final VoidCallback onTap;

  const _HomeCard({
    required this.entry,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      shadowColor: const Color(0x550D405C),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: entry.colors,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 6 : 10,
              vertical: compact ? 8 : 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(entry.emoji, style: const TextStyle(fontSize: 76)),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 20 : 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Color(0x99001A4D),
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
