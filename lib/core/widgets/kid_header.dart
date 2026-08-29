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

    return Row(
      children: [
        if (canPop)
          _circle(
            Icons.arrow_back_rounded,
            () {
              audio.click();
              Navigator.of(context).maybePop();
            },
          ),

        if (canPop) const SizedBox(width: 10),

        Expanded(
          child: Container(
            height: 104,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 5),
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
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF31536D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
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
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 70,
          height: 70,
          child: Icon(
            icon,
            size: 32,
            color: const Color(0xFF31536D),
          ),
        ),
      ),
    );
  }
}
