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
                desktop ? 18 : 8,
                desktop ? 34 : (compact ? 14 : 24),
                desktop ? 42 : 28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContent),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _RoundButton(
                            icon: Icons.settings_rounded,
                            color: KidsTheme.pink,
                            onTap: () => _go(context, const PengaturanPage()),
                          ),
                          const SizedBox(width: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: BackgroundMusic.instance.enabled,
                            builder: (_, on, __) => _RoundButton(
                              icon: on ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                              color: on ? KidsTheme.primary : KidsTheme.muted,
                              onTap: BackgroundMusic.instance.toggle,
                            ),
                          ),
                        ],
                      ),
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
          child: SizedBox(width: 58, height: 58, child: Icon(icon, color: Colors.white, size: 30)),
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
