import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class TitikGarisPage extends StatefulWidget {
  const TitikGarisPage({super.key});

  @override
  State<TitikGarisPage> createState() =>
      _TitikGarisPageState();
}

class _TitikGarisPageState
    extends State<TitikGarisPage> {
  final audio = AudioService.instance;

  final points = const [
    Offset(0.5, 0.08),
    Offset(0.62, 0.35),
    Offset(0.9, 0.35),
    Offset(0.68, 0.55),
    Offset(0.78, 0.9),
    Offset(0.5, 0.68),
    Offset(0.22, 0.9),
    Offset(0.32, 0.55),
    Offset(0.1, 0.35),
    Offset(0.38, 0.35),
  ];

  int progress = 1;
  final List<Offset> lines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(14),
              child: KidHeader(
                title: 'Titik & Garis 🔗',
                subtitle:
                    'Tarik garis mengikuti nomor',
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  Offset point(int i) {
                    return Offset(
                      points[i].dx * size.width,
                      points[i].dy * size.height,
                    );
                  }

                  return GestureDetector(
                    onPanEnd: (_) {
                      if (progress <
                          points.length) {
                        setState(
                          () {
                            lines.add(
                              point(progress - 1),
                            );
                            progress++;
                          },
                        );

                        audio.speak(
                          'Bagus!',
                        );

                        if (progress ==
                            points.length) {
                          audio.speak(
                            'Hebat! Gambar bintang selesai!',
                          );
                        }
                      }
                    },
                    child: Stack(
                      children: [
                        if (progress ==
                            points.length)
                          const Center(
                            child: Text(
                              '⭐',
                              style: TextStyle(
                                fontSize: 240,
                              ),
                            ),
                          ),

                        for (
                          var i = 0;
                          i < points.length;
                          i++
                        )
                          Positioned(
                            left: point(i).dx - 22,
                            top: point(i).dy - 22,
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment:
                                  Alignment.center,
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: i <
                                          progress
                                      ? Colors.green
                                      : Colors.blue,
                                  width: 4,
                                ),
                              ),
                              child: Text(
                                '${i + 1}',
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                progress == points.length
                    ? '🎉 Selesai! Ini gambar bintang!'
                    : 'Mulai dari titik $progress',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
