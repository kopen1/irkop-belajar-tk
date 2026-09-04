import 'package:flutter/material.dart';
import '../../core/services/app_settings.dart';
import '../../core/services/audio_service.dart';
import '../../core/theme/kids_theme.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppSettings.instance;
    final a = AudioService.instance;
    return Scaffold(body: KidBackground(child: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
      const KidHeader(title: 'Pengaturan', subtitle: 'Atur suara agar nyaman belajar 🎵'),
      const SizedBox(height: 16),
      _Card(title: '🔊 Suara Belajar', child: Column(children: [
        ValueListenableBuilder<bool>(valueListenable: s.narrationEnabled, builder: (_, v, __) => SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, title: const Text('Suara pembelajaran', style: TextStyle(fontWeight: FontWeight.w900, color: KidsTheme.ink)), subtitle: const Text('Bacakan huruf, angka, pertanyaan, dan jawaban', style: TextStyle(color: KidsTheme.muted)), value: v, onChanged: (x) => s.narrationEnabled.value = x)),
        const Divider(height: 22),
        ValueListenableBuilder<double>(valueListenable: s.speechRate, builder: (_, rate, __) {
          final label = rate <= .36 ? 'Pelan' : rate <= .43 ? 'Sedang' : rate <= .53 ? 'Normal' : 'Cepat';
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Expanded(child: Text('Kecepatan suara', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: KidsTheme.ink))), Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: KidsTheme.primary))]),
            Slider(min: .30, max: .65, divisions: 7, value: rate, label: label, onChanged: (v) => a.setSpeechRate(v)),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('🐢 Pelan', style: TextStyle(fontWeight: FontWeight.w800, color: KidsTheme.muted)), Text('🐰 Cepat', style: TextStyle(fontWeight: FontWeight.w800, color: KidsTheme.muted))]),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => a.speak('Halo teman pintar! Yuk belajar bersama.'), icon: const Icon(Icons.volume_up_rounded), label: const Text('Coba suara', style: TextStyle(fontWeight: FontWeight.w900))))
          ]);
        })
      ])),
      const SizedBox(height: 14),
      _Card(title: '🎮 Permainan', child: ValueListenableBuilder<bool>(valueListenable: s.randomQuiz, builder: (_, v, __) => SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, title: const Text('Acak soal kuis', style: TextStyle(fontWeight: FontWeight.w900, color: KidsTheme.ink)), subtitle: const Text('Soal kuis dibuat lebih bervariasi', style: TextStyle(color: KidsTheme.muted)), value: v, onChanged: (x) => s.randomQuiz.value = x))),
      const SizedBox(height: 14),
      OutlinedButton.icon(onPressed: () => s.resetProgress(), icon: const Icon(Icons.refresh_rounded), label: const Text('Reset progres belajar', style: TextStyle(fontWeight: FontWeight.w900)))
    ]))));
  }
}
class _Card extends StatelessWidget {
  final String title; final Widget child;
  const _Card({required this.title, required this.child});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: KidsTheme.border), boxShadow: const [BoxShadow(color: Color(0x140D405C), blurRadius: 12, offset: Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: KidsTheme.ink)), const SizedBox(height: 8), child]);
}
