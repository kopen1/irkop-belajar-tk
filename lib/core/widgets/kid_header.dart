import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class KidHeader extends StatefulWidget {
  final String title;
  final String subtitle;

  const KidHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<KidHeader> createState() => _KidHeaderState();
}

class _KidHeaderState extends State<KidHeader> {
  final audio = AudioService.instance;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 390;
        final buttonSize = compact ? 52.0 : 62.0;
        final titleSize = compact ? 20.0 : 24.0;
        final subtitleSize = compact ? 13.0 : 16.0;

        return Row(
      children: [
        if (canPop) _circle(Icons.arrow_back_rounded, () {
          audio.click();
          Navigator.of(context).maybePop();
        }),
        if (canPop) SizedBox(width: compact ? 6 : 10),
        Expanded(
          child: Container(
            height: compact ? 82 : 92,
            padding: const EdgeInsets.symmetric(horizontal: compact ? 12 : 18, vertical: compact ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x300D405C),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF31536D),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: subtitleSize,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF668398),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _circle(
          audio.backgroundOn ? Icons.music_note_rounded : Icons.music_off_rounded,
          () => setState(audio.toggleBackground),
        ),
      ],
    );
      },
    );
  }

  Widget _circle(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: const Color(0x330D405C),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 62,
          height: 62,
          child: Icon(icon, size: 30, color: const Color(0xFF31536D)),
        ),
      ),
    );
  }
}
