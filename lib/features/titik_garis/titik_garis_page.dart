import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class DotLevel {
  final String name;
  final String finalImage;
  final List<Offset> points;

  const DotLevel({
    required this.name,
    required this.finalImage,
    required this.points,
  });
}

class TitikGarisPage extends StatefulWidget {
  const TitikGarisPage({super.key});

  @override
  State<TitikGarisPage> createState() => _TitikGarisPageState();
}

class _TitikGarisPageState extends State<TitikGarisPage> {
  final levels = const [
    DotLevel(
      name: 'Bintang',
      finalImage: '⭐',
      points: [
        Offset(.50, .05),
        Offset(.61, .37),
        Offset(.95, .37),
        Offset(.68, .57),
        Offset(.78, .92),
        Offset(.50, .70),
        Offset(.22, .92),
        Offset(.32, .57),
        Offset(.05, .37),
        Offset(.39, .37),
      ],
    ),
    DotLevel(
      name: 'Rumah',
      finalImage: '🏠',
      points: [
        Offset(.15, .48),
        Offset(.50, .10),
        Offset(.85, .48),
        Offset(.85, .88),
        Offset(.15, .88),
      ],
    ),
    DotLevel(
      name: 'Ikan',
      finalImage: '🐟',
      points: [
        Offset(.15, .50),
        Offset(.35, .20),
        Offset(.70, .25),
        Offset(.88, .50),
        Offset(.70, .75),
        Offset(.35, .80),
      ],
    ),
    DotLevel(
      name: 'Bunga',
      finalImage: '🌸',
      points: [
        Offset(.50, .10),
        Offset(.75, .25),
        Offset(.85, .50),
        Offset(.75, .75),
        Offset(.50, .90),
        Offset(.25, .75),
        Offset(.15, .50),
        Offset(.25, .25),
      ],
    ),
    DotLevel(
      name: 'Mobil',
      finalImage: '🚗',
      points: [
        Offset(.10, .65),
        Offset(.25, .35),
        Offset(.70, .35),
        Offset(.90, .65),
        Offset(.85, .85),
        Offset(.15, .85),
      ],
    ),
  ];

  int level = 0;
  int reached = 0;
  bool finished = false;

  void _reset() {
    setState(() {
      reached = 0;
      finished = false;
    });
    AudioService.instance.speak('Tarik dari titik satu ke titik dua');
  }

  void _update(Offset position, Size size) {
    if (finished) return;

    final current = levels[level];
    final targetIndex = reached + 1;

    if (targetIndex >= current.points.length) {
      setState(() => finished = true);
      AudioService.instance.speak(
        'Hebat! Kamu berhasil membuat gambar ${current.name}',
      );
      return;
    }

    final target = Offset(
      current.points[targetIndex].dx * size.width,
      current.points[targetIndex].dy * size.height,
    );

    if ((position - target).distance < 35) {
      setState(() => reached++);
      AudioService.instance.speak('${reached + 1}');

      if (reached >= current.points.length - 1) {
        setState(() => finished = true);
        AudioService.instance.correct();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    AudioService.instance.speak(
      'Tarik garis dari nomor satu ke nomor dua',
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = levels[level];

    return Scaffold(
      body: KidBackground(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: KidHeader(
                title: 'Titik & Garis',
                subtitle: 'Tarik garis dari 1 ke 2, lalu lanjutkan',
              ),
            ),

            Wrap(
              spacing: 8,
              children: List.generate(levels.length, (i) {
                return ChoiceChip(
                  label: Text('${i + 1}. ${levels[i].name}'),
                  selected: level == i,
                  onSelected: (_) {
                    setState(() {
                      level = i;
                      reached = 0;
                      finished = false;
                    });
                  },
                );
              }),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return GestureDetector(
                    onPanUpdate: (details) {
                      _update(
                        details.localPosition,
                        size,
                      );
                    },
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: size,
                          painter: DotPainter(
                            points: current.points,
                            reached: reached,
                          ),
                        ),

                        if (finished)
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🎉 Selesai!',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  current.finalImage,
                                  style: const TextStyle(fontSize: 150),
                                ),
                                Text(
                                  current.name,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: _reset,
                                  child: const Text('Main Lagi'),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotPainter extends CustomPainter {
  final List<Offset> points;
  final int reached;

  DotPainter({
    required this.points,
    required this.reached,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.orange
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < reached; i++) {
      final a = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );

      final b = Offset(
        points[i + 1].dx * size.width,
        points[i + 1].dy * size.height,
      );

      canvas.drawLine(a, b, line);
    }

    for (int i = 0; i < points.length; i++) {
      final p = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );

      final circle = Paint()
        ..color = i <= reached
            ? Colors.green
            : Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(p, 22, circle);

      final border = Paint()
        ..color = Colors.deepOrange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      canvas.drawCircle(p, 22, border);

      final text = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      text.layout();
      text.paint(
        canvas,
        p - Offset(
          text.width / 2,
          text.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant DotPainter oldDelegate) {
    return oldDelegate.reached != reached;
  }
}
