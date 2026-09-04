import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/services/app_settings.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/fullscreen_service.dart';
import '../../core/theme/kids_theme.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final _fullscreen = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _fullscreen.dispose();
    super.dispose();
  }

  Future<void> _toggleFullscreen() async {
    final next = !_fullscreen.value;
    await FullscreenService.setFullscreen(next);
    if (mounted) _fullscreen.value = next;
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.instance;
    final audio = AudioService.instance;

    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const KidHeader(
                title: 'Pengaturan',
                subtitle: 'Atur suara agar nyaman belajar 🎵',
              ),
              const SizedBox(height: 16),
              _SettingsCard(
                title: '🔊 Suara Belajar',
                child: Column(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: settings.narrationEnabled,
                      builder: (_, enabled, __) {
                        return SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Suara pembelajaran',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: KidsTheme.ink,
                            ),
                          ),
                          subtitle: const Text(
                            'Bacakan huruf, angka, pertanyaan, dan jawaban',
                            style: TextStyle(color: KidsTheme.muted),
                          ),
                          value: enabled,
                          onChanged: (value) =>
                              settings.narrationEnabled.value = value,
                        );
                      },
                    ),
                    const Divider(height: 22),
                    ValueListenableBuilder<double>(
                      valueListenable: settings.speechRate,
                      builder: (_, rate, __) {
                        final label = rate <= .36
                            ? 'Pelan'
                            : rate <= .43
                                ? 'Sedang'
                                : rate <= .53
                                    ? 'Normal'
                                    : 'Cepat';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Kecepatan suara',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: KidsTheme.ink,
                                    ),
                                  ),
                                ),
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: KidsTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              min: .30,
                              max: .65,
                              divisions: 7,
                              value: rate,
                              label: label,
                              onChanged: audio.setSpeechRate,
                            ),
                            const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '🐢 Pelan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: KidsTheme.muted,
                                  ),
                                ),
                                Text(
                                  '🐰 Cepat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: KidsTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => audio.speak(
                                  'Halo teman pintar! Yuk belajar bersama.',
                                ),
                                icon: const Icon(Icons.volume_up_rounded),
                                label: const Text(
                                  'Coba suara',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SettingsCard(
                title: '🎮 Permainan',
                child: ValueListenableBuilder<bool>(
                  valueListenable: settings.randomQuiz,
                  builder: (_, enabled, __) {
                    return SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Acak soal kuis',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: KidsTheme.ink,
                        ),
                      ),
                      subtitle: const Text(
                        'Soal kuis dibuat lebih bervariasi',
                        style: TextStyle(color: KidsTheme.muted),
                      ),
                      value: enabled,
                      onChanged: (value) => settings.randomQuiz.value = value,
                    );
                  },
                ),
              ),
              if (kIsWeb) ...[
                const SizedBox(height: 14),
                _SettingsCard(
                  title: '📱 Tampilan Web',
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _fullscreen,
                    builder: (_, enabled, __) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gunakan layar penuh agar pengalaman belajar lebih mirip aplikasi mobile.',
                            style: TextStyle(
                              color: KidsTheme.muted,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _toggleFullscreen,
                              icon: Icon(
                                enabled
                                    ? Icons.fullscreen_exit_rounded
                                    : Icons.fullscreen_rounded,
                              ),
                              label: Text(
                                enabled
                                    ? 'Keluar dari Fullscreen'
                                    : 'Aktifkan Fullscreen',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: settings.resetProgress,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Reset progres belajar',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: KidsTheme.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140D405C),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: KidsTheme.ink,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
