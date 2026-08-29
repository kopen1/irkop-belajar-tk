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
    return Row(
      children: [
        if (Navigator.of(context).canPop())
          _circle(
            Icons.arrow_back_rounded,
            () {
              audio.click();
              Navigator.of(context).maybePop();
            },
          ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF31536D),
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF668398),
                  ),
                ),
              ],
            ),
          ),
        ),

        _circle(
          audio.backgroundOn
              ? Icons.music_note_rounded
              : Icons.music_off_rounded,
          () {
            setState(audio.toggleBackground);
          },
        ),
      ],
    );
  }

  Widget _circle(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: const Color(0xFF31536D),
          ),
        ),
      ),
    );
  }
}
