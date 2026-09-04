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
            final desktop = constraints.maxWidth >= 900;
            final compact = constraints.maxWidth < 430;
            final columns = desktop ? 4 : 2;
            final maxContent = desktop ? 1160.0 : 980.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                desktop ? 34 : (compact ? 14 : 24),
                desktop ? 22 : 10,
                desktop ? 34 : (compact ? 14 : 24),
                desktop ? 42 : 28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContent),
                  child: Column(children: [
                    _Hero(
                      compact: compact,
                      desktop: desktop,
                      onSettings: () => _go(context, const PengaturanPage()),
                    ),
                    SizedBox(height: desktop ? 26 : 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: desktop ? 20 : 12,
                        mainAxisSpacing: desktop ? 20 : 12,
                        childAspectRatio: desktop ? 1.34 : 1.02,
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
  final bool desktop;
  final VoidCallback onSettings;
  const _Hero({required this.compact, required this.desktop, required this.onSettings});

  @override
  Widget build(BuildContext context) {
    final music = BackgroundMusic.instance;
    final title = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Halo, Teman Pintar! 👋',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: desktop ? 34 : (compact ? 26 : 30),
            fontWeight: FontWeight.w900,
            color: KidsTheme.ink,
          ),
        ),
        const SizedBox(height: 3),
        Text.rich(
          const TextSpan(children: [
            TextSpan(text: 'IRKOP ', style: TextStyle(color: KidsTheme.primary)),
            TextSpan(text: 'Belajar ', style: TextStyle(color: KidsTheme.pink)),
            TextSpan(text: 'TK', style: TextStyle(color: KidsTheme.green)),
          ]),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: desktop ? 42 : (compact ? 30 : 36),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4C9),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'Yuk belajar sambil bermain! 🌈',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: KidsTheme.ink),
          ),
        ),
      ],
    );

    final settings = _RoundButton(
      icon: Icons.settings_rounded,
      color: KidsTheme.pink,
      onTap: onSettings,
    );
    final speaker = ValueListenableBuilder<bool>(
      valueListenable: music.enabled,
      builder: (_, on, __) => _RoundButton(
        icon: on ? Icons.volume_up_rounded : Icons.volume_off_rounded,
        color: on ? KidsTheme.primary : KidsTheme.muted,
        onTap: music.toggle,
      ),
    );

    if (desktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          settings,
          const Expanded(child: SizedBox()),
          title,
          const Expanded(child: SizedBox()),
          speaker,
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [settings, const Spacer(), speaker],
        ),
        const SizedBox(height: 4),
        title,
        const SizedBox(height: 8),
      ],
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
          child: const SizedBox(
            width: 58,
            height: 58,
            child: Icon(Icons.settings_rounded, color: Colors.white, size: 30),
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
