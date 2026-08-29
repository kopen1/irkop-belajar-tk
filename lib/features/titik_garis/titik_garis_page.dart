import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class TitikGarisPage extends StatefulWidget {
  const TitikGarisPage({super.key});

  @override
  State<TitikGarisPage> createState() => _TitikGarisPageState();
}

class _TitikGarisPageState extends State<TitikGarisPage> {
  final audio = AudioService.instance;

  final points = const [
    Offset(0.50, 0.08),
    Offset(0.62, 0.35),
    Offset(0.90, 0.35),
    Offset(0.68, 0.55),
    Offset(0.78, 0.90),
    Offset(0.50, 0.68),
    Offset(0.22, 0.90),
    Offset(0.32, 0.55),
    Offset(0.10, 0.35),
    Offset(0.38, 0.35),
  ];

  int progress = 1;
  Offset? _lastPoint;
  Offset? _dragPosition;

  void _reset() {
    setState(() {
      progress = 1;
      _lastPoint = null;
      _dragPosition = null;
    });
  }

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
                subtitle: 'Hubungkan titik sesuai urutan',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      progress == points.length
                          ? '🎉 Hebat! Bintangnya selesai!'
                          : 'Hubungkan titik $progress ke \${progress + 1}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF31536D),
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Ulangi',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    Offset point(int i) => Offset(
                          points[i].dx * size.width,
                          points[i].dy * size.height,
                        );

                    final completed = <Offset>[];
                    for (var i = 0; i < progress - 1; i++) {
                      completed.add(point(i));
                    }

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: progress >= points.length
                            ? null
                            : (details) {
                                final expected = point(progress - 1);
                                if ((details.localPosition - expected)
                                        .distance <=
                                    42) {
                                  setState(() {
                                    _lastPoint = expected;
                                    _dragPosition = details.localPosition;
                                  });
                                }
                              },
                        onPanUpdate: (details) {
                          if (_lastPoint == null) return;
                          setState(() {
                            _dragPosition = details.localPosition;
                          });
                        },
                        onPanEnd: (_) async {
                          if (_lastPoint == null || progress >= points.length) {
                            return;
                          }

                          final target = point(progress);
                          final current = _dragPosition ?? _lastPoint!;
                          final reached =
                              (current - target).distance <= 58;

                          if (reached) {
                            setState(() {
                              progress++;
                              _lastPoint = null;
                              _dragPosition = null;
                            });

                            if (progress == points.length) {
                              await audio.speak(
                                'Hebat! Gambar bintang selesai!',
                              );
                            } else {
                              await audio.speak('Bagus!');
                            }
                          } else {
                            setState(() {
                              _lastPoint = null;
                              _dragPosition = null;
                            });
                            await audio.wrong();
                          }
                        },
                        child: CustomPaint(
                          painter: _LinePainter(
                            points: completed,
                            previewStart: _lastPoint,
                            previewEnd: _dragPosition,
                          ),
                          child: Stack(
                            children: [
                              if (progress == points.length)
                                const Center(
                                  child: Text(
                                    '⭐',
                                    style: TextStyle(fontSize: 210),
                                  ),
                                ),
                              for (var i = 0; i < points.length; i++)
                                Positioned(
                                  left: point(i).dx - 22,
                                  top: point(i).dy - 22,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: i < progress
                                          ? const Color(0xFFFFD65C)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: i < progress
                                            ? const Color(0xFF52B96A)
                                            : const Color(0xFF5EA8F5),
                                        width: 4,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x22000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '\${i + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        color: Color(0xFF31536D),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<Offset> points;
  final Offset? previewStart;
  final Offset? previewEnd;

  const _LinePainter({
    required this.points,
    required this.previewStart,
    required this.previewEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final completedPaint = Paint()
      ..color = const Color(0xFF5EA8F5)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], completedPaint);
    }

    if (previewStart != null && previewEnd != null) {
      final previewPaint = Paint()
        ..color = const Color(0xFF5EA8F5).withValues(alpha: 0.75)
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(previewStart!, previewEnd!, previewPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.previewStart != previewStart ||
        oldDelegate.previewEnd != previewEnd;
  }
}
