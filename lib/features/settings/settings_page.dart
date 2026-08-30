import 'package:flutter/material.dart';

import '../../core/services/app_settings.dart';
import '../../core/widgets/kid_background.dart';
import '../../services/background_music.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final music = BackgroundMusic.instance;
    final settings = AppSettings.instance;
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(children: [
                  Row(children: [
                    Material(color: const Color(0xFFFFD44B), shape: const CircleBorder(), elevation: 5,
                      child: InkWell(customBorder: const CircleBorder(), onTap: () => Navigator.of(context).maybePop(),
                        child: const SizedBox(width: 56, height: 56, child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 32)))),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Pengaturan', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFFFFE12E), shadows: [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))]))),
                    const SizedBox(width: 68),
                  ]),
                  const SizedBox(height: 16),
                  _section('Audio', Icons.volume_up_rounded, [
                    ValueListenableBuilder<bool>(valueListenable: music.enabled, builder: (_, value, __) => SwitchListTile(
                      value: value, onChanged: (_) { music.toggle(); if (music.enabled.value) music.start(); },
                      title: const Text('Musik Latar', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text(value ? 'Musik menyala' : 'Musik dimatikan'))),
                    ValueListenableBuilder<double>(valueListenable: settings.musicVolume, builder: (_, value, __) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Volume Musik', style: TextStyle(fontWeight: FontWeight.w800)),
                      Slider(value: value, min: 0, max: 1, onChanged: (v) => settings.musicVolume.value = v),
                    ])),
                    ValueListenableBuilder<bool>(valueListenable: settings.effectsEnabled, builder: (_, value, __) => SwitchListTile(
                      value: value, onChanged: (v) => settings.effectsEnabled.value = v,
                      title: const Text('Efek Suara', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: const Text('Suara benar, salah, dan interaksi'))),
                    ValueListenableBuilder<bool>(valueListenable: settings.narrationEnabled, builder: (_, value, __) => SwitchListTile(
                      value: value, onChanged: (v) => settings.narrationEnabled.value = v,
                      title: const Text('Suara Narasi', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: const Text('Pelafalan dan pertanyaan belajar'))),
                  ]),
                  const SizedBox(height: 12),
                  _section('Permainan', Icons.sports_esports_rounded, [
                    ValueListenableBuilder<bool>(valueListenable: settings.randomQuiz, builder: (_, value, __) => SwitchListTile(
                      value: value, onChanged: (v) => settings.randomQuiz.value = v,
                      title: const Text('Soal Acak', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text(value ? 'Pertanyaan tampil secara acak' : 'Pertanyaan tampil berurutan'))),
                    ListTile(leading: const Icon(Icons.restart_alt_rounded), title: const Text('Reset Skor', style: TextStyle(fontWeight: FontWeight.w900)), subtitle: const Text('Menghapus skor dan jawaban benar'),
                      onTap: () => settings.resetProgress()),
                  ]),
                  const SizedBox(height: 12),
                  _section('Tampilan', Icons.fullscreen_rounded, [
                    ValueListenableBuilder<bool>(valueListenable: settings.fullscreen, builder: (_, value, __) => SwitchListTile(
                      value: value, onChanged: (v) => settings.fullscreen.value = v,
                      title: const Text('Mode Layar Penuh', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: const Text('Status preferensi layar penuh aplikasi'))),
                    const ListTile(leading: Icon(Icons.format_size_rounded), title: Text('Tampilan Anak', style: TextStyle(fontWeight: FontWeight.w900)), subtitle: Text('Desain aplikasi sudah responsif untuk mobile')),
                  ]),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<int>(valueListenable: settings.totalScore, builder: (_, score, __) =>
                    ValueListenableBuilder<int>(valueListenable: settings.totalCorrect, builder: (_, correct, __) =>
                      ValueListenableBuilder<int>(valueListenable: settings.activitiesPlayed, builder: (_, played, __) =>
                        _section('Progress Belajar', Icons.bar_chart_rounded, [
                          Row(children: [_stat('Skor', '$score'), _stat('Benar', '$correct'), _stat('Aktivitas', '$played')]),
                          ListTile(leading: const Icon(Icons.delete_outline_rounded), title: const Text('Reset Semua Progress', style: TextStyle(fontWeight: FontWeight.w900)), onTap: () => settings.resetProgress()),
                        ])))),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) => Container(
    width: double.infinity, padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .95), borderRadius: BorderRadius.circular(26), boxShadow: const [BoxShadow(color: Color(0x220D405C), blurRadius: 10, offset: Offset(0, 4))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [CircleAvatar(backgroundColor: const Color(0xFF6B4AC5), child: Icon(icon, color: Colors.white)), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Color(0xFF3F3170)))]),
      const SizedBox(height: 8), ...children,
    ]),
  );

  Widget _stat(String title, String value) => Expanded(child: Container(
    margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: const Color(0xFFF4F1FF), borderRadius: BorderRadius.circular(16)),
    child: Column(children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))]),
  ));
}
