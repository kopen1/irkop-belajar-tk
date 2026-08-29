import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class TitikGarisPage extends StatefulWidget {
  const TitikGarisPage({super.key});

  @override
  State<TitikGarisPage> createState() => _TitikGarisPageState();
}

class _TraceLevel {
  final String name;
  final String icon;
  final List<Offset> points;

  const _TraceLevel({
    required this.name,
    required this.icon,
    required this.points,
  });
}

class _TitikGarisPageState extends State<TitikGarisPage> {
  final audio = AudioService.instance;

  static const levels = <_TraceLevel>[
    _TraceLevel(name: 'Segitiga', icon: '🔺', points: [
      Offset(.50, .08), Offset(.84, .32), Offset(.70, .86),
      Offset(.30, .86), Offset(.16, .32),
    ]),
    _TraceLevel(name: 'Rumah', icon: '🏠', points: [
      Offset(.50, .08), Offset(.84, .34), Offset(.84, .86),
      Offset(.16, .86), Offset(.16, .34), Offset(.50, .08),
    ]),
    _TraceLevel(name: 'Bintang', icon: '⭐', points: [
      Offset(.50, .07), Offset(.61, .37), Offset(.93, .37),
      Offset(.67, .55), Offset(.77, .89), Offset(.50, .69),
      Offset(.23, .89), Offset(.33, .55), Offset(.07, .37),
      Offset(.39, .37),
    ]),
    _TraceLevel(name: 'Ikan', icon: '🐟', points: [
      Offset(.14, .50), Offset(.34, .23), Offset(.68, .23),
      Offset(.88, .10), Offset(.82, .36), Offset(.94, .50),
      Offset(.82, .64), Offset(.88, .90), Offset(.68, .77),
      Offset(.34, .77), Offset(.14, .50),
    ]),
    _TraceLevel(name: 'Roket', icon: '🚀', points: [
      Offset(.50, .06), Offset(.68, .26), Offset(.74, .58),
      Offset(.90, .78), Offset(.66, .73), Offset(.58, .92),
      Offset(.50, .76), Offset(.42, .92), Offset(.34, .73),
      Offset(.10, .78), Offset(.26, .58), Offset(.32, .26),
    ]),
  ];

  int levelIndex = 0;
  int progress = 1;
  Offset? start;
  Offset? drag;
  bool showSuccess = false;

  _TraceLevel get level => levels[levelIndex];

  void _selectLevel(int index) {
    setState(() {
      levelIndex = index;
      progress = 1;
      start = null;
      drag = null;
      showSuccess = false;
    });
    audio.speak('Mulai gambar ${levels[index].name}. Tarik garis sesuai urutan nomor.');
  }

  void _nextLevel() {
    _selectLevel((levelIndex + 1) % levels.length);
  }

  Future<void> _complete() async {
    setState(() {
      start = null;
      drag = null;
      showSuccess = true;
    });
    await audio.correct();
    await audio.speak('Hebat! ${level.name} selesai.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, box) {
              final w = box.maxWidth;
              final s = (w / 820).clamp(.72, 1.0);
              return Stack(
                children: [
                  Column(
                    children: [
                      _header(w, s),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * .10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 10 * s),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .88),
                            borderRadius: BorderRadius.circular(22 * s),
                          ),
                          child: Text(
                            'Tarik garis dari titik $progress ke titik ${progress + 1}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20 * s, fontWeight: FontWeight.w900, color: const Color(0xFF28354D)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10 * s),
                      _levelPicker(s),
                      SizedBox(height: 10 * s),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(w * .06, 0, w * .06, 18),
                          child: _drawingBoard(s),
                        ),
                      ),
                    ],
                  ),
                  if (showSuccess) _successPopup(s),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _drawingBoard(double s) {
    return LayoutBuilder(
      builder: (context, c) {
        final size = Size(c.maxWidth, c.maxHeight);
        Offset p(int i) => Offset(level.points[i].dx * size.width, level.points[i].dy * size.height);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .94),
            borderRadius: BorderRadius.circular(34 * s),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 12, offset: Offset(0, 6))],
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: showSuccess || progress >= level.points.length ? null : (d) {
              if ((d.localPosition - p(progress - 1)).distance < 52 * s) {
                setState(() {
                  start = p(progress - 1);
                  drag = d.localPosition;
                });
              }
            },
            onPanUpdate: (d) {
              if (start != null) setState(() => drag = d.localPosition);
            },
            onPanEnd: (_) async {
              if (start == null || progress >= level.points.length) return;
              final reached = ((drag ?? start!) - p(progress)).distance < 66 * s;
              if (reached) {
                final finished = progress + 1 >= level.points.length;
                setState(() {
                  progress++;
                  start = null;
                  drag = null;
                });
                if (finished) {
                  await _complete();
                } else {
                  await audio.speak('Bagus!');
                }
              } else {
                setState(() {
                  start = null;
                  drag = null;
                });
                await audio.wrong();
              }
            },
            child: CustomPaint(
              painter: _TracePainter(
                points: List.generate(level.points.length, p),
                completed: progress,
                previewStart: start,
                previewEnd: drag,
              ),
              child: Stack(
                children: List.generate(
                  level.points.length,
                  (i) => Positioned(
                    left: p(i).dx - 24 * s,
                    top: p(i).dy - 24 * s,
                    child: _dot(i + 1, i < progress, s),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _levelPicker(double s) {
    return SizedBox(
      height: 54 * s,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20 * s),
        itemCount: levels.length,
        separatorBuilder: (context, index) => SizedBox(width: 8 * s),
        itemBuilder: (context, i) {
          final active = i == levelIndex;
          return Material(
            color: active ? const Color(0xFF1E8DD3) : Colors.white.withValues(alpha: .88),
            borderRadius: BorderRadius.circular(18 * s),
            elevation: active ? 4 : 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(18 * s),
              onTap: () => _selectLevel(i),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14 * s),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(levels[i].icon, style: TextStyle(fontSize: 24 * s)),
                    SizedBox(width: 5 * s),
                    Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 18 * s,
                        fontWeight: FontWeight.w900,
                        color: active ? Colors.white : const Color(0xFF26324A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _successPopup(double s) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: .16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 26),
              padding: EdgeInsets.fromLTRB(24 * s, 20 * s, 24 * s, 18 * s),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28 * s),
                border: Border.all(color: const Color(0xFF2AB94A), width: 4),
                boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(level.icon, style: TextStyle(fontSize: 70 * s)),
                  SizedBox(height: 4 * s),
                  Text('Hebat!', style: TextStyle(color: const Color(0xFF159A35), fontSize: 30 * s, fontWeight: FontWeight.w900)),
                  SizedBox(height: 6 * s),
                  Text('${level.name} selesai!', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF26324A), fontSize: 17 * s, fontWeight: FontWeight.w800)),
                  SizedBox(height: 16 * s),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _nextLevel,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Gambar Berikutnya'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB91D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14 * s),
                        textStyle: TextStyle(fontSize: 18 * s, fontWeight: FontWeight.w900),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18 * s)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(double w, double s) => SizedBox(
    height: w * .15,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(left: w * .035, child: _round(w * .105, Icons.arrow_back_rounded, () => Navigator.of(context).maybePop())),
        Positioned(right: w * .035, child: _round(w * .105, Icons.music_note_rounded, () => audio.speak('Titik dan Garis. Pilih gambar lalu tarik garis sesuai urutan nomor.'))),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Titik & Garis', style: TextStyle(fontSize: 34 * s, color: const Color(0xFFFFD32F), fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))])),
            Text('Tarik Garis Sesuai Urutan Nomor', style: TextStyle(fontSize: 17 * s, color: Colors.white, fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    ),
  );

  Widget _round(double size, IconData icon, VoidCallback tap) => Material(
    color: icon == Icons.music_note_rounded ? const Color(0xFF29C63E) : const Color(0xFFFFC42D),
    shape: const CircleBorder(),
    elevation: 5,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: tap,
      child: SizedBox(width: size, height: size, child: Icon(icon, color: Colors.white, size: size * .56)),
    ),
  );

  Widget _dot(int n, bool done, double s) => Container(
    width: 48 * s,
    height: 48 * s,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: done ? const Color(0xFF4AA7E8) : const Color(0xFF1E8DD3),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 3))],
    ),
    child: Text(n.toString(), style: TextStyle(color: Colors.white, fontSize: 21 * s, fontWeight: FontWeight.w900)),
  );
}

class _TracePainter extends CustomPainter {
  final List<Offset> points;
  final int completed;
  final Offset? previewStart;
  final Offset? previewEnd;

  _TracePainter({required this.points, required this.completed, required this.previewStart, required this.previewEnd});

  @override
  void paint(Canvas canvas, Size size) {
    final dotted = Paint()
      ..color = const Color(0xFF667487)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < points.length - 1; i++) {
      _dashed(canvas, points[i], points[i + 1], dotted);
    }

    final done = Paint()
      ..color = const Color(0xFF247FC3)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < completed - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], done);
    }
    if (previewStart != null && previewEnd != null) {
      canvas.drawLine(previewStart!, previewEnd!, done);
    }
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint paint) {
    final delta = b - a;
    final length = delta.distance;
    final direction = delta / length;
    for (double distance = 0; distance < length; distance += 20) {
      canvas.drawLine(
        a + direction * distance,
        a + direction * (distance + 9).clamp(0, length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
