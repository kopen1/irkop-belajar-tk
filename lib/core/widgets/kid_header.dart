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
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
        child: Row(
          children: [
            if (Navigator.of(context).canPop())
              _roundButton(
                icon: Icons.arrow_back_rounded,
                onTap: () {
                  audio.click();
                  Navigator.of(context).maybePop();
                },
              ),

            if (Navigator.of(context).canPop())
              const SizedBox(width: 12),

            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 92),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.93),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 16,
                      offset: Offset(0, 7),
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
                        fontSize: 27,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF668398),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            _roundButton(
              icon: audio.backgroundOn
                  ? Icons.music_note_rounded
                  : Icons.music_off_rounded,
              onTap: () {
                setState(() {
                  audio.toggleBackground();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      elevation: 5,
      shadowColor: Colors.black38,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Icon(
            icon,
            size: 34,
            color: const Color(0xFF31536D),
          ),
        ),
      ),
    );
  }
}
