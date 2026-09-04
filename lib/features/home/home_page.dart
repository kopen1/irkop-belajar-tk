import 'package:flutter/material.dart';
import '../../core/theme/kids_theme.dart';
import '../../services/background_music.dart';
import '../angka/angka_page.dart';
import '../gambar/gambar_page.dart';
import '../hijaiyah/hijaiyah_page.dart';
import '../huruf/huruf_page.dart';
import '../kuis/kuis_page.dart';
import '../mewarnai/mewarnai_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../titik_garis/titik_garis_page.dart';
import '../warna/warna_page.dart';
import '../../core/widgets/animated_world_card.dart';
import '../../core/widgets/kid_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _go(BuildContext c, Widget p) async {
    await Navigator.of(c).push(MaterialPageRoute(builder: (_) => p));
  }

  @override
  Widget build(BuildContext context) {
    const entries = [
      _HomeEntry(WorldArt.letters, 'Dunia Huruf', 'Kenali huruf A–Z', 'A–Z', KidsTheme.pink),
      _HomeEntry(WorldArt.numbers, 'Dunia Angka', 'Belajar angka 1–10', '1–10', KidsTheme.primary),
      _HomeEntry(WorldArt.hijaiyah, 'Dunia Hijaiyah', 'Mengenal huruf Hijaiyah', 'أ–ي', KidsTheme.green),
      _HomeEntry(WorldArt.pictures, 'Dunia Gambar', 'Belajar nama benda & hewan', '🖼', KidsTheme.orange),
      _HomeEntry(WorldArt.colors, 'Dunia Warna', 'Kenali berbagai warna', '🎨', KidsTheme.purple),
      _HomeEntry(WorldArt.coloring, 'Mewarnai', 'Warnai gambar sesukamu', '✎', KidsTheme.pink),
      _HomeEntry(WorldArt.dotsLines, 'Titik & Garis', 'Hubungkan titik jadi gambar', '•—•', KidsTheme.yellow),
      _HomeEntry(WorldArt.quiz, 'Kuis Seru', 'Uji kemampuan dengan kuis', '★', KidsTheme.purple),
    ];
    const pages = [
      HurufPage(), AngkaPage(), HijaiyahPage(), GambarPage(),
      WarnaPage(), MewarnaiPage(), TitikGarisPage(), KuisPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final compact = constraints.maxWidth < 430;
            final columns = constraints.maxWidth >= 760 ? 4 : 2;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(compact ? 14 : 24, 10, compact ? 14 : 24, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: Column(children: [
                    _Hero(compact: compact, onSettings: () => _go(context, const PengaturanPage())),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: columns == 2 ? 1.02 : 1.08,
                      ),
                      itemBuilder: (_, i) => _HomeCard(
                        entry: entries[i],
                        onTap: () => _go(context, pages[i]),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final bool compact;
  final VoidCallback onSettings;
  const _Hero({required this.compact, required this.onSettings});

  @override
  Widget build(BuildContext context) {
    final music = BackgroundMusic.instance;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoundButton(
                icon: Icons.settings_rounded,
                color: KidsTheme.pink,
                onTap: onSettings,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: music.enabled,
                builder: (_, on, __) => _RoundButton(
                  icon: on ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: on ? KidsTheme.primary : KidsTheme.muted,
                  onTap: music.toggle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Halo, Teman Pintar! 👋',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 26 : 34,
              fontWeight: FontWeight.w900,
              color: KidsTheme.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text.rich(
            const TextSpan(children: [
              TextSpan(text: 'IRKOP ', style: TextStyle(color: KidsTheme.primary)),
              TextSpan(text: 'Belajar ', style: TextStyle(color: KidsTheme.pink)),
              TextSpan(text: 'TK', style: TextStyle(color: KidsTheme.green)),
            ]),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 30 : 42,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4C9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Yuk belajar sambil bermain! 🌈',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: KidsTheme.ink,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _RoundButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        elevation: 4,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 58,
            height: 58,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      );
}

class _HomeEntry {
  final WorldArt art;
  final String title, subtitle, badge;
  final Color color;
  const _HomeEntry(this.art, this.title, this.subtitle, this.badge, this.color);
}

class _HomeCard extends StatelessWidget {
  final _HomeEntry entry;
  final Future<void> Function() onTap;
  const _HomeCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedWorldCard(
      art: entry.art,
      accentColor: entry.color,
      title: entry.title,
      subtitle: entry.subtitle,
      badge: entry.badge,
      onNavigate: onTap,
    );
  }
}
