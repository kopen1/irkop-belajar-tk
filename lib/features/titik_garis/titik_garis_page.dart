import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class TitikGarisPage extends StatefulWidget {
  const TitikGarisPage({super.key});
  @override
  State<TitikGarisPage> createState() => _TitikGarisPageState();
}

class _TitikGarisPageState extends State<TitikGarisPage> {
  final audio = AudioService.instance;
  final points = const [
    Offset(.50,.08), Offset(.64,.35), Offset(.92,.38), Offset(.70,.57), Offset(.80,.91),
    Offset(.50,.70), Offset(.20,.91), Offset(.30,.57), Offset(.08,.38), Offset(.36,.35),
  ];
  int progress = 1;
  Offset? start;
  Offset? drag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: KidBackground(child: SafeArea(child: LayoutBuilder(builder: (context, box) {
      final w = box.maxWidth;
      final s = (w / 820).clamp(.72, 1.0);
      return Column(children: [
        _header(w, s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .13),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 10 * s),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .86), borderRadius: BorderRadius.circular(22 * s)),
            child: Text(progress >= points.length ? 'Bintang selesai!' : 'Tarik garis dari titik $progress ke titik ${progress + 1}', style: TextStyle(fontSize: 20 * s, fontWeight: FontWeight.w900, color: const Color(0xFF28354D))),
          ),
        ),
        SizedBox(height: 14 * s),
        Expanded(child: Padding(
          padding: EdgeInsets.fromLTRB(w * .06, 0, w * .06, 18),
          child: LayoutBuilder(builder: (context, c) {
            final size = Size(c.maxWidth, c.maxHeight);
            Offset p(int i) => Offset(points[i].dx * size.width, points[i].dy * size.height);
            return Container(
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(34 * s), border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 12, offset: Offset(0, 6))]),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: progress >= points.length ? null : (d) {
                  if ((d.localPosition - p(progress - 1)).distance < 50) setState(() { start = p(progress - 1); drag = d.localPosition; });
                },
                onPanUpdate: (d) { if (start != null) setState(() => drag = d.localPosition); },
                onPanEnd: (_) async {
                  if (start == null || progress >= points.length) return;
                  final reached = ((drag ?? start!) - p(progress)).distance < 65;
                  if (reached) {
                    setState(() { progress++; start = null; drag = null; });
                    await audio.speak(progress >= points.length ? 'Hebat! Bintang selesai!' : 'Bagus!');
                  } else {
                    setState(() { start = null; drag = null; });
                    await audio.wrong();
                  }
                },
                child: CustomPaint(
                  painter: _StarPainter(
                    all: List.generate(points.length, p),
                    completed: progress,
                    previewStart: start,
                    previewEnd: drag,
                  ),
                  child: Stack(children: [
                    if (progress >= points.length) const Center(child: Text('⭐', style: TextStyle(fontSize: 180))),
                    ...List.generate(
                      points.length,
                      (i) => Positioned(
                        left: p(i).dx - 24,
                        top: p(i).dy - 24,
                        child: _dot(i + 1, i < progress, s),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }),
        )),
      ]);
    }))));
  }

  Widget _header(double w, double s) => SizedBox(height: w * .15, child: Stack(alignment: Alignment.center, children: [
    Positioned(left: w * .035, child: _round(w * .105, Icons.arrow_back_rounded, () => Navigator.of(context).maybePop())),
    Positioned(right: w * .035, child: _round(w * .105, Icons.music_note_rounded, () => audio.speak('Titik dan Garis. Tarik garis sesuai urutan nomor'))),
    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Titik & Garis', style: TextStyle(fontSize: 34 * s, color: const Color(0xFFFFD32F), fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))])),
      Text('Tarik Garis Sesuai Urutan Nomor', style: TextStyle(fontSize: 17 * s, color: Colors.white, fontWeight: FontWeight.w900)),
    ]),
  ]));
  Widget _round(double size, IconData icon, VoidCallback tap) => Material(color: icon == Icons.music_note_rounded ? const Color(0xFF29C63E) : const Color(0xFFFFC42D), shape: const CircleBorder(), elevation: 5, child: InkWell(customBorder: const CircleBorder(), onTap: tap, child: SizedBox(width: size, height: size, child: Icon(icon, color: Colors.white, size: size * .56))));
  Widget _dot(int n, bool done, double s) => Container(width: 48 * s, height: 48 * s, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, color: done ? const Color(0xFF4AA7E8) : const Color(0xFF1E8DD3), border: Border.all(color: Colors.white, width: 2), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 3))]), child: Text(n.toString(), style: TextStyle(color: Colors.white, fontSize: 21 * s, fontWeight: FontWeight.w900)));
}

class _StarPainter extends CustomPainter {
  final List<Offset> all;
  final int completed;
  final Offset? previewStart;
  final Offset? previewEnd;
  _StarPainter({required this.all, required this.completed, required this.previewStart, required this.previewEnd});
  @override
  void paint(Canvas canvas, Size size) {
    final dotted = Paint()..color = const Color(0xFF667487)..strokeWidth = 7..strokeCap = StrokeCap.round;
    for (var i = 0; i < all.length - 1; i++) { _dashed(canvas, all[i], all[i + 1], dotted); }
    final done = Paint()..color = const Color(0xFF247FC3)..strokeWidth = 7..strokeCap = StrokeCap.round;
    for (var i = 0; i < completed - 1; i++) { canvas.drawLine(all[i], all[i + 1], done); }
    if (previewStart != null && previewEnd != null) canvas.drawLine(previewStart!, previewEnd!, done);
  }
  void _dashed(Canvas c, Offset a, Offset b, Paint p) {
    final d = b - a; final len = d.distance; final step = d / len;
    for (double x = 0; x < len; x += 20) { c.drawLine(a + step * x, a + step * (x + 9).clamp(0, len), p); }
  }
  @override
  bool shouldRepaint(covariant _StarPainter old) => true;
}
