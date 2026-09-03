import 'package:flutter/material.dart';
import '../../services/background_music.dart';
import '../services/audio_service.dart';
import '../theme/kids_theme.dart';

class KidHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  const KidHeader({super.key, required this.title, required this.subtitle});
  @override State<KidHeader> createState() => _KidHeaderState();
}

class _KidHeaderState extends State<KidHeader> {
  final audio = AudioService.instance;
  final music = BackgroundMusic.instance;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final compact = constraints.maxWidth < 390;
    return Row(children: [
      if (Navigator.of(context).canPop()) _circle(Icons.arrow_back_rounded, () { audio.speak('Kembali'); Navigator.of(context).maybePop(); }, compact),
      if (Navigator.of(context).canPop()) SizedBox(width: compact ? 6 : 10),
      Expanded(child: Container(
        height: compact ? 82 : 92,
        padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18, vertical: compact ? 8 : 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: KidsTheme.border), boxShadow: const [BoxShadow(color: Color(0x160D405C), blurRadius: 12, offset: Offset(0, 5))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 20 : 24, fontWeight: FontWeight.w900, color: KidsTheme.ink)),
          const SizedBox(height: 3),
          Text(widget.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 13 : 15, fontWeight: FontWeight.w700, color: KidsTheme.muted)),
        ]),
      )),
      SizedBox(width: compact ? 6 : 10),
      ValueListenableBuilder<bool>(valueListenable: music.enabled, builder: (_, on, __) => _circle(on ? Icons.music_note_rounded : Icons.music_off_rounded, () async {
        music.toggle();
        setState(() {});
        await audio.speak(on ? 'Musik dimatikan' : 'Musik dinyalakan');
      }, compact)),
    ]);
  });

  Widget _circle(IconData icon, VoidCallback onTap, bool compact) => Material(
    color: icon == Icons.music_note_rounded ? KidsTheme.green : KidsTheme.yellow,
    shape: const CircleBorder(), elevation: 2,
    child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: SizedBox(width: compact ? 54 : 60, height: compact ? 54 : 60, child: Icon(icon, size: compact ? 28 : 30, color: Colors.white))),
  );
}
