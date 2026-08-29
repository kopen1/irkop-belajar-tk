import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class KidHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const KidHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;

    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  color: Color(0xFF2F4F6B),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF57728A),
                ),
              ),
            ],
          ),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return IconButton(
              onPressed: () {
                audio.toggleBackground();
                setState(() {});
              },
              icon: Icon(
                audio.backgroundOn
                    ? Icons.music_note_rounded
                    : Icons.music_off_rounded,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }
}
