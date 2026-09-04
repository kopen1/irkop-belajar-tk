import 'package:flutter/material.dart';
import '../../core/theme/kids_theme.dart';
import '../../services/background_music.dart';
import '../../core/widgets/kid_background.dart';
import '../angka/angka_page.dart';
import '../gambar/gambar_page.dart';
import '../hijaiyah/hijaiyah_page.dart';
import '../huruf/huruf_page.dart';
import '../kuis/kuis_page.dart';
import '../mewarnai/mewarnai_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../titik_garis/titik_garis_page.dart';
import '../warna/warna_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  void _go(BuildContext c, Widget p) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => p));

  @override
  Widget build(BuildContext context) {
    const entries = [
      _HomeEntry('🔤', 'Dunia Huruf', 'Kenali huruf A–Z', KidsTheme.pink),
      _HomeEntry('🔢', 'Dunia Angka', 'Belajar angka 1–10', KidsTheme.primary),
      _HomeEntry('🕌', 'Dunia Hijaiyah', 'Mengenal huruf Hijaiyah', KidsTheme.green),
      _HomeEntry('🐱', 'Dunia Gambar', 'Belajar nama benda & hewan', KidsTheme.orange),
      _HomeEntry('🎨', 'Dunia Warna', 'Kenali berbagai warna', KidsTheme.purple),
      _HomeEntry('🖍️', 'Mewarnai', 'Warnai gambar sesukamu', KidsTheme.pink),
      _HomeEntry('🔗', 'Titik & Garis', 'Hubungkan titik jadi gambar', KidsTheme.yellow),
      _HomeEntry('🧠', 'Kuis Seru', 'Uji kemampuan dengan kuis', KidsTheme.purple),
    ];
    const pages = [HurufPage(), AngkaPage(), HijaiyahPage(), GambarPage(), WarnaPage(), MewarnaiPage(), TitikGarisPage(), KuisPage()];

    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final compact = constraints.maxWidth < 430;
            final columns = constraints.maxWidth >= 760 ? 4 : 2;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(compact ? 14 : 24, 14, compact ? 14 : 24, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: Column(children: [
                    _Hero(compact: compact, onSettings: () => _go(context, const PengaturanPage())),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: columns == 2 ? 1.42 : 1.15,
                      ),
                      itemBuilder: (_, i) => _HomeCard(entry: entries[i], compact: compact, onTap: () => _go(context, pages[i])),
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
    return Container(
      padding: EdgeInsets.fromLTRB(compact ? 16 : 24, 14, compact ? 16 : 24, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Color(0x220D405C), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ValueListenableBuilder<bool>(
            valueListenable: music.enabled,
            builder: (_, on, __) => _RoundButton(
              icon: on ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: on ? KidsTheme.primary : KidsTheme.muted,
              onTap: () { music.toggle(); if (music.enabled.value) music.start(); },
            ),
          ),
          const SizedBox(width: 10),
          _RoundButton(icon: Icons.settings_rounded, color: KidsTheme.pink, onTap: onSettings),
        ]),
        const SizedBox(height: 2),
        Text('Halo, Teman Pintar! 👋', textAlign: TextAlign.center, style: TextStyle(fontSize: compact ? 26 : 34, fontWeight: FontWeight.w900, color: KidsTheme.ink)),
        const SizedBox(height: 2),
        Text.rich(const TextSpan(children: [
          TextSpan(text: 'IRKOP ', style: TextStyle(color: KidsTheme.primary)),
          TextSpan(text: 'Belajar ', style: TextStyle(color: KidsTheme.pink)),
          TextSpan(text: 'TK', style: TextStyle(color: KidsTheme.green)),
        ]), textAlign: TextAlign.center, style: TextStyle(fontSize: compact ? 30 : 42, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(color: const Color(0xFFFFF4C9), borderRadius: BorderRadius.circular(18)),
          child: const Text('Yuk belajar sambil bermain! 🌈', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: KidsTheme.ink)),
        ),
        const SizedBox(height: 8),
        Text('🐼', style: TextStyle(fontSize: compact ? 58 : 70)),
      ]),
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
    child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: SizedBox(width: 58, height: 58, child: Icon(icon, color: Colors.white, size: 30))),
  );
}

class _HomeEntry {
  final String emoji, title, subtitle;
  final Color color;
  const _HomeEntry(this.emoji, this.title, this.subtitle, this.color);
}

class _HomeCard extends StatelessWidget {
  final _HomeEntry entry;
  final bool compact;
  final VoidCallback onTap;
  const _HomeCard({required this.entry, required this.compact, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: .96),
    borderRadius: BorderRadius.circular(26),
    elevation: 3,
    child: InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 15),
        child: Row(children: [
          Container(width: compact ? 70 : 78, height: compact ? 70 : 78, decoration: BoxDecoration(color: entry.color.withValues(alpha: .15), shape: BoxShape.circle), child: Center(child: Text(entry.emoji, style: TextStyle(fontSize: compact ? 39 : 45)))),
          const SizedBox(width: 12),
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(entry.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 17 : 19, fontWeight: FontWeight.w900, color: entry.color)),
            const SizedBox(height: 4),
            Text(entry.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: KidsTheme.muted)),
          ])),
          const SizedBox(width: 4),
          Container(width: 40, height: 40, decoration: BoxDecoration(color: entry.color, shape: BoxShape.circle), child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 23)),
        ]),
      ),
    ),
  );
}
