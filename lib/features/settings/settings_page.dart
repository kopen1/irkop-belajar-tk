import 'package:flutter/material.dart';

import '../../core/widgets/kid_background.dart';
import '../../services/background_music.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final music = BackgroundMusic.instance;
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Material(
                      color: const Color(0xFFFFD44B),
                      shape: const CircleBorder(),
                      elevation: 5,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 34),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Pengaturan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFFE12E),
                          shadows: [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))],
                        ),
                      ),
                    ),
                    const SizedBox(width: 72),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .94),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 14, offset: Offset(0, 6))],
                  ),
                  child: Column(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: music.enabled,
                        builder: (context, enabled, _) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 27,
                            backgroundColor: const Color(0xFF35C84A),
                            child: Icon(enabled ? Icons.music_note_rounded : Icons.music_off_rounded, color: Colors.white, size: 30),
                          ),
                          title: const Text('Musik Latar', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                          subtitle: Text(enabled ? 'Musik sedang menyala' : 'Musik sedang dimatikan'),
                          trailing: Switch(
                            value: enabled,
                            onChanged: (_) {
                              music.toggle();
                              if (music.enabled.value) music.start();
                            },
                          ),
                        ),
                      ),
                      const Divider(),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 27,
                          backgroundColor: Color(0xFF5EA8F5),
                          child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 30),
                        ),
                        title: Text('Suara Belajar', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                        subtitle: Text('Tombol suara tersedia di setiap permainan'),
                      ),
                      const Divider(),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 27,
                          backgroundColor: Color(0xFFFFA64D),
                          child: Icon(Icons.fullscreen_rounded, color: Colors.white, size: 30),
                        ),
                        title: Text('Layar Penuh', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                        subtitle: Text('Gunakan mode layar penuh browser untuk pengalaman terbaik'),
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
