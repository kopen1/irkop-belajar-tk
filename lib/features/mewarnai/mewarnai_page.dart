import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/widgets/kid_background.dart';
import 'painting_canvas.dart';

class MewarnaiPage extends StatefulWidget {
  const MewarnaiPage({super.key});

  @override
  State<MewarnaiPage> createState() => _MewarnaiPageState();
}

class _MewarnaiPageState extends State<MewarnaiPage> {
  static const colors = [
    Color(0xFFFF2433), Color(0xFFFF8A17), Color(0xFFFFD31B),
    Color(0xFF34C53C), Color(0xFF2587D9), Color(0xFF6844CF),
    Color(0xFFE436A7), Color(0xFF252A33),
  ];

  Color selected = colors.first;
  bool eraser = false;
  int clearSignal = 0;
  int fillSignal = 0;
  int drawingIndex = 0;
  // Daftar terus berputar, jadi setelah gambar terakhir kembali ke awal.
  // Anak dapat berpindah gambar kapan saja lewat pilihan di atas.
  static const drawings = [
    ('✏️', 'Bebas Menggambar'),
    ('🦖', 'Dinosaurus'),
    ('🐟', 'Ikan'),
    ('🐱', 'Kucing'),
    ('🚗', 'Mobil'),
    ('🌼', 'Bunga'),
    ('🏠', 'Rumah'),
    ('🦋', 'Kupu-kupu'),
    ('🍎', 'Apel'),
    ('🚀', 'Roket'),
    ('⚽', 'Bola'),
    ('☀️', 'Matahari'),
    ('🐦', 'Burung'),
    ('🪁', 'Layangan'),
    ('❤️', 'Hati'),
    ('🌳', 'Pohon'),
    ('🎈', 'Balon'),
    ('🍦', 'Es Krim'),
    ('⛵', 'Perahu'),
    ('🌙', 'Bulan'),
    ('☁️', 'Awan'),
  ];

  void _selectDrawing(int index) => setState(() {
    drawingIndex = index;
    clearSignal++;
  });

  void _nextDrawing() => _selectDrawing((drawingIndex + 1) % drawings.length);

  void _pick(Color color) => setState(() { selected = color; eraser = false; });
  void _useBrush() => setState(() => eraser = false);
  void _useEraser() => setState(() => eraser = true);
  void _clear() => setState(() => clearSignal++);
  void _fill() => setState(() => fillSignal++);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: KidBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            final s = (w / 820).clamp(.72, 1.0);
            return Column(
              children: [
                _header(w, s),
                _drawingSelector(s),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(w * .04, 8, w * .04, 16 * s),
                    child: Column(
                      children: [
                        _drawingPanel(s),
                        SizedBox(height: 14 * s),
                        _toolbar(s),
                        SizedBox(height: 10 * s),
                        _nextButton(s),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );

  Widget _drawingSelector(double s) => SizedBox(
    height: 64 * s,
    child: ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16 * s),
      scrollDirection: Axis.horizontal,
      itemCount: drawings.length,
      separatorBuilder: (context, index) => SizedBox(width: 8 * s),
      itemBuilder: (context, index) {
        final active = index == drawingIndex;
        return GestureDetector(
          onTap: () => _selectDrawing(index),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14 * s),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF278AC3) : Colors.white.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(18 * s),
              border: Border.all(color: active ? Colors.white : const Color(0xFFD4DEE6), width: 2),
            ),
            child: Text(
              drawings[index].$1 + ' ' + (index + 1).toString(),
              style: TextStyle(color: active ? Colors.white : const Color(0xFF26324A), fontWeight: FontWeight.w900, fontSize: 18 * s),
            ),
          ),
        );
      },
    ),
  );

  Widget _drawingPanel(double s) => Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 7 * s),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(18 * s)),
        child: Text(
          drawings[drawingIndex].$1 + ' Warnai ' + drawings[drawingIndex].$2,
          style: TextStyle(color: const Color(0xFF24354C), fontSize: 18 * s, fontWeight: FontWeight.w900),
        ),
      ),
      SizedBox(height: 7 * s),
      if (drawingIndex != 0) ...[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10 * s),
          decoration: BoxDecoration(color: const Color(0xFFFFF6D8), borderRadius: BorderRadius.circular(18 * s), border: Border.all(color: const Color(0xFFF1D26A), width: 2)),
          child: Row(children: [
            Text(drawings[drawingIndex].$1, style: TextStyle(fontSize: 46 * s)),
            SizedBox(width: 10 * s),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CONTOH HASIL JADI', style: TextStyle(fontSize: 14 * s, fontWeight: FontWeight.w900, color: const Color(0xFF9B6A00))),
              Text('Gunakan warna cerah seperti contoh ini', style: TextStyle(fontSize: 13 * s, fontWeight: FontWeight.w700, color: const Color(0xFF5B4A1E))),
            ])),
            const Icon(Icons.palette_rounded, color: Color(0xFF8A5BE8), size: 34),
          ]),
        ),
        SizedBox(height: 7 * s),
      ],
      AspectRatio(
        aspectRatio: 1.18,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14 * s),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .96),
            borderRadius: BorderRadius.circular(30 * s),
            border: Border.all(color: const Color(0xFFEAF2F7), width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x330D405C),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22 * s),
            child: Stack(
              children: [
                Positioned.fill(
                  child: PaintingCanvas(
                    color: eraser ? Colors.white : selected,
                    clearSignal: clearSignal,
                    fillSignal: fillSignal,
                    fillColor: selected,
                  ),
                ),
                if (drawingIndex != 0)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _DinoOutlinePainter(kind: drawingIndex - 1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _nextButton(double s) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: _nextDrawing,
      icon: const Icon(Icons.arrow_forward_rounded),
      label: const Text('Gambar Berikutnya'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFB91D),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14 * s),
        textStyle: TextStyle(fontSize: 19 * s, fontWeight: FontWeight.w900),
      ),
    ),
  );

  Widget _toolbar(double s) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(12 * s),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(26 * s),
      boxShadow: const [BoxShadow(color: Color(0x220D405C), blurRadius: 8, offset: Offset(0, 3))],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: colors.map((color) => _colorDot(color, selected == color && !eraser, s)).toList(),
        ),
        SizedBox(height: 14 * s),
        Row(
          children: [
            Expanded(child: _toolButton(icon: Icons.brush_rounded, color: const Color(0xFF2489D8), active: !eraser, onTap: _useBrush, s: s)),
            SizedBox(width: 8 * s),
            Expanded(child: _toolButton(icon: Icons.format_color_fill_rounded, color: const Color(0xFF6A54D9), active: false, onTap: _fill, s: s)),
            SizedBox(width: 8 * s),
            Expanded(child: _toolButton(icon: Icons.auto_fix_high_rounded, color: const Color(0xFFF4F0E7), foreground: const Color(0xFF42679E), active: eraser, onTap: _useEraser, s: s)),
            SizedBox(width: 8 * s),
            Expanded(child: _clearButton(s)),
          ],
        ),
      ],
    ),
  );

  Widget _colorDot(Color color, bool active, double s) => GestureDetector(
    onTap: () => _pick(color),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: 48 * s, height: 48 * s,
      decoration: BoxDecoration(
        color: color, shape: BoxShape.circle,
        border: Border.all(color: active ? Colors.white : const Color(0x33000000), width: active ? 4 : 2),
        boxShadow: [BoxShadow(color: color.withValues(alpha: .28), blurRadius: active ? 8 : 4, offset: const Offset(0, 3))],
      ),
    ),
  );

  Widget _toolButton({
    required IconData icon,
    required Color color,
    required bool active,
    required VoidCallback onTap,
    required double s,
    Color foreground = Colors.white,
  }) => Material(
    color: color,
    borderRadius: BorderRadius.circular(18 * s),
    elevation: active ? 5 : 2,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18 * s),
      child: SizedBox(height: 66 * s, child: Center(child: Icon(icon, color: foreground, size: 37 * s))),
    ),
  );

  Widget _clearButton(double s) => Material(
    color: const Color(0xFFFF2633),
    borderRadius: BorderRadius.circular(18 * s),
    elevation: 5,
    child: InkWell(
      onTap: _clear,
      borderRadius: BorderRadius.circular(18 * s),
      child: SizedBox(
        height: 70 * s,
        child: Center(child: Text('Bersihkan', style: TextStyle(color: Colors.white, fontSize: 24 * s, fontWeight: FontWeight.w900))),
      ),
    ),
  );

  Widget _header(double w, double s) => SizedBox(
    height: w * .16,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(left: w * .02, child: _roundButton(w * .115, Icons.arrow_back_rounded, const Color(0xFFFFC42D), () => Navigator.of(context).maybePop())),
        Positioned(right: w * .02, child: _roundButton(w * .115, Icons.music_note_rounded, const Color(0xFF29C63E), () {})),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ayo Mewarnai', maxLines: 1, style: TextStyle(fontSize: 35 * s, color: const Color(0xFFFFD32F), fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))])),
              Text('Warnai Gambar Sesukamu!', maxLines: 1, style: TextStyle(fontSize: 17 * s, color: Colors.white, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 2, offset: Offset(1, 2))])),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _roundButton(double size, IconData icon, Color color, VoidCallback onTap) => Material(
    color: color, shape: const CircleBorder(), elevation: 5,
    child: InkWell(
      customBorder: const CircleBorder(), onTap: onTap,
      child: SizedBox(width: size, height: size, child: Icon(icon, color: Colors.white, size: size * .55)),
    ),
  );
}

class _DinoOutlinePainter extends CustomPainter {
  final int kind;
  _DinoOutlinePainter({this.kind = 0});
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF151515)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.shortestSide * .010).clamp(3.2, 6.5)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Offset p(double x, double y) => Offset(size.width * x, size.height * y);

    if (kind != 0) {
      _simplePicture(canvas, size, kind, line, p);
      return;
    }

    // Clouds and sun from the reference scene.
    canvas.drawPath(Path()
      ..moveTo(p(.05, .16).dx, p(.05, .16).dy)
      ..quadraticBezierTo(p(.07, .08).dx, p(.07, .08).dy, p(.15, .12).dx, p(.15, .12).dy)
      ..quadraticBezierTo(p(.21, .05).dx, p(.21, .05).dy, p(.27, .13).dx, p(.27, .13).dy)
      ..quadraticBezierTo(p(.34, .10).dx, p(.34, .10).dy, p(.35, .19).dx, p(.35, .19).dy)
      ..quadraticBezierTo(p(.28, .25).dx, p(.28, .25).dy, p(.20, .22).dx, p(.20, .22).dy)
      ..quadraticBezierTo(p(.11, .25).dx, p(.11, .25).dy, p(.05, .16).dx, p(.05, .16).dy), line);

    canvas.drawCircle(p(.84, .18), size.shortestSide * .080, line);
    for (var i = 0; i < 8; i++) {
      final a = i * 3.1415926535 / 4;
      final center = p(.84, .18);
      final r1 = size.shortestSide * .105;
      final r2 = size.shortestSide * .145;
      canvas.drawLine(
        Offset(center.dx + r1 * math.cos(a), center.dy + r1 * math.sin(a)),
        Offset(center.dx + r2 * math.cos(a), center.dy + r2 * Math.sin(a)),
        line,
      );
    }

    canvas.drawPath(Path()
      ..moveTo(p(.74, .48).dx, p(.74, .48).dy)
      ..quadraticBezierTo(p(.76, .40).dx, p(.76, .40).dy, p(.82, .43).dx, p(.82, .43).dy)
      ..quadraticBezierTo(p(.87, .37).dx, p(.87, .37).dy, p(.91, .44).dx, p(.91, .44).dy)
      ..quadraticBezierTo(p(.98, .43).dx, p(.98, .43).dy, p(.96, .52).dx, p(.96, .52).dy)
      ..quadraticBezierTo(p(.89, .58).dx, p(.89, .58).dy, p(.82, .54).dx, p(.82, .54).dy)
      ..quadraticBezierTo(p(.77, .58).dx, p(.77, .58).dy, p(.74, .48).dx, p(.74, .48).dy), line);

    // Main dinosaur silhouette.
    final body = Path()
      ..moveTo(p(.18, .68).dx, p(.18, .68).dy)
      ..quadraticBezierTo(p(.11, .61).dx, p(.11, .61).dy, p(.17, .53).dx, p(.17, .53).dy)
      ..quadraticBezierTo(p(.20, .48).dx, p(.20, .48).dy, p(.30, .46).dx, p(.30, .46).dy)
      ..quadraticBezierTo(p(.34, .29).dx, p(.34, .29).dy, p(.48, .27).dx, p(.48, .27).dy)
      ..quadraticBezierTo(p(.51, .15).dx, p(.51, .15).dy, p(.66, .18).dx, p(.66, .18).dy)
      ..quadraticBezierTo(p(.75, .20).dx, p(.75, .20).dy, p(.77, .29).dx, p(.77, .29).dy)
      ..quadraticBezierTo(p(.82, .35).dx, p(.82, .35).dy, p(.76, .43).dx, p(.76, .43).dy)
      ..quadraticBezierTo(p(.72, .48).dx, p(.72, .48).dy, p(.64, .48).dx, p(.64, .48).dy)
      ..lineTo(p(.64, .72).dx, p(.64, .72).dy)
      ..quadraticBezierTo(p(.68, .81).dx, p(.68, .81).dy, p(.63, .90).dx, p(.63, .90).dy)
      ..lineTo(p(.53, .90).dx, p(.53, .90).dy)
      ..quadraticBezierTo(p(.49, .87).dx, p(.49, .87).dy, p(.50, .80).dx, p(.50, .80).dy)
      ..lineTo(p(.38, .80).dx, p(.38, .80).dy)
      ..lineTo(p(.36, .92).dx, p(.36, .92).dy)
      ..quadraticBezierTo(p(.29, .96).dx, p(.29, .96).dy, p(.23, .91).dx, p(.23, .91).dy)
      ..lineTo(p(.25, .77).dx, p(.25, .77).dy)
      ..quadraticBezierTo(p(.18, .74).dx, p(.18, .74).dy, p(.18, .68).dx, p(.18, .68).dy)
      ..close();
    canvas.drawPath(body, line);

    // Tail.
    canvas.drawPath(Path()
      ..moveTo(p(.27, .62).dx, p(.27, .62).dy)
      ..quadraticBezierTo(p(.08, .58).dx, p(.08, .58).dy, p(.08, .76).dx, p(.08, .76).dy)
      ..quadraticBezierTo(p(.16, .82).dx, p(.16, .82).dy, p(.30, .74).dx, p(.30, .74).dy), line);

    // Spikes.
    final spikes = [
      [.31,.43,.27,.33],[.37,.37,.34,.27],[.44,.33,.42,.22],
      [.29,.51,.25,.42],[.23,.58,.18,.51],[.21,.67,.15,.61],
    ];
    for (final s in spikes) {
      canvas.drawLine(p(s[0], s[1]), p(s[2], s[3]), line);
    }

    // Face, smile and body details.
    canvas.drawCircle(p(.62, .29), size.shortestSide * .018, line..style = PaintingStyle.fill);
    line.style = PaintingStyle.stroke;
    canvas.drawPath(Path()
      ..moveTo(p(.54, .42).dx, p(.54, .42).dy)
      ..quadraticBezierTo(p(.63, .53).dx, p(.63, .53).dy, p(.72, .43).dx, p(.72, .43).dy), line);
    canvas.drawLine(p(.57, .42), p(.61, .48), line);
    canvas.drawLine(p(.67, .48), p(.70, .43), line);

    // Arms.
    canvas.drawPath(Path()
      ..moveTo(p(.64, .58).dx, p(.64, .58).dy)
      ..quadraticBezierTo(p(.71, .61).dx, p(.71, .61).dy, p(.70, .67).dx, p(.70, .67).dy)
      ..lineTo(p(.66, .64).dx, p(.66, .64).dy), line);

    // Ground grass accents.
    for (final x in [.07,.16,.28,.72,.84,.94]) {
      canvas.drawLine(p(x, .90), p(x - .02, .84), line);
      canvas.drawLine(p(x, .90), p(x + .02, .85), line);
    }
  }

  void _simplePicture(Canvas canvas, Size size, int kind, Paint line, Offset Function(double, double) p) {
    final cx = size.width * .5;
    final cy = size.height * .5;
    final r = size.shortestSide * .18;
    switch (kind) {
      case 1: // fish
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - r * .25, cy), width: r * 2.5, height: r * 1.4), line);
        canvas.drawPath(Path()..moveTo(cx + r, cy)..lineTo(cx + r * 2.1, cy - r)..lineTo(cx + r * 2.1, cy + r)..close(), line);
        canvas.drawCircle(Offset(cx - r * .7, cy - r * .2), r * .10, line..style = PaintingStyle.fill); line.style = PaintingStyle.stroke;
        break;
      case 2: // cat
        canvas.drawCircle(Offset(cx, cy), r * 1.25, line);
        canvas.drawPath(Path()..moveTo(cx-r,cy-r)..lineTo(cx-r*.8,cy-r*2)..lineTo(cx-r*.1,cy-r), line);
        canvas.drawPath(Path()..moveTo(cx+r,cy-r)..lineTo(cx+r*.8,cy-r*2)..lineTo(cx+r*.1,cy-r), line);
        canvas.drawCircle(Offset(cx-r*.45,cy-r*.15),r*.1,line..style=PaintingStyle.fill); canvas.drawCircle(Offset(cx+r*.45,cy-r*.15),r*.1,line); line.style=PaintingStyle.stroke;
        break;
      case 3: // car
        canvas.drawPath(Path()..moveTo(cx-r*2,cy+r*.5)..lineTo(cx-r*1.4,cy-r*.5)..lineTo(cx+r,cy-r*.5)..lineTo(cx+r*1.7,cy+r*.5)..close(),line);
        canvas.drawCircle(Offset(cx-r,cy+r*.55),r*.35,line); canvas.drawCircle(Offset(cx+r,cy+r*.55),r*.35,line);
        break;
      case 4: // flower
        for (var i=0;i<6;i++){final a=i*math.pi/3; canvas.drawCircle(Offset(cx+math.cos(a)*r,cy+math.sin(a)*r),r*.7,line);} canvas.drawCircle(Offset(cx,cy),r*.6,line); canvas.drawLine(Offset(cx,cy+r*1.6),Offset(cx,cy+r*3),line);
        break;
      case 5: // house
        canvas.drawRect(Rect.fromCenter(center: Offset(cx,cy+r*.4),width:r*3,height:r*2),line); canvas.drawPath(Path()..moveTo(cx-r*1.8,cy-r*.5)..lineTo(cx,cy-r*2)..lineTo(cx+r*1.8,cy-r*.5),line); canvas.drawRect(Rect.fromCenter(center: Offset(cx,cy+r*.8),width:r*.7,height:r*1.2),line);
        break;
      case 6: // butterfly
        canvas.drawOval(Rect.fromCenter(center: Offset(cx-r*.7,cy),width:r*1.5,height:r*2.2),line); canvas.drawOval(Rect.fromCenter(center: Offset(cx+r*.7,cy),width:r*1.5,height:r*2.2),line); canvas.drawLine(Offset(cx,cy-r*1.4),Offset(cx,cy+r*1.5),line);
        break;
      case 7: // apple
        canvas.drawCircle(Offset(cx-r*.5,cy),r*1.1,line); canvas.drawCircle(Offset(cx+r*.5,cy),r*1.1,line); canvas.drawLine(Offset(cx,cy-r),Offset(cx+r*.2,cy-r*2),line);
        break;
      case 8: // rocket
        canvas.drawPath(Path()..moveTo(cx,cy-r*2)..quadraticBezierTo(cx+r*1.5,cy-r*.3,cx+r*.6,cy+r*1.6)..lineTo(cx-r*.6,cy+r*1.6)..quadraticBezierTo(cx-r*1.5,cy-r*.3,cx,cy-r*2)..close(),line); canvas.drawCircle(Offset(cx,cy-r*.2),r*.35,line);
        break;
      case 9: // ball
        canvas.drawCircle(Offset(cx,cy),r*1.5,line); canvas.drawLine(Offset(cx-r,cy-r),Offset(cx+r,cy+r),line); canvas.drawLine(Offset(cx+r,cy-r),Offset(cx-r,cy+r),line);
        break;
      case 10: // sun
        canvas.drawCircle(Offset(cx,cy),r,line); for(var i=0;i<10;i++){final a=i*math.pi/5; canvas.drawLine(Offset(cx+math.cos(a)*r*1.4,cy+math.sin(a)*r*1.4),Offset(cx+math.cos(a)*r*2.1,cy+math.sin(a)*r*2.1),line);}
        break;
      case 12: // kite
        canvas.drawPath(Path()..moveTo(cx,cy-r*1.8)..lineTo(cx+r*1.2,cy)..lineTo(cx,cy+r*1.8)..lineTo(cx-r*1.2,cy)..close(),line);
        canvas.drawLine(Offset(cx,cy+r*1.8),Offset(cx+r*.9,cy+r*3),line);
        break;
      case 13: // heart
        canvas.drawPath(Path()..moveTo(cx,cy+r*1.5)..cubicTo(cx-r*2,cy,cx-r*1.2,cy-r*1.7,cx,cy-r*.5)..cubicTo(cx+r*1.2,cy-r*1.7,cx+r*2,cy,cx,cy+r*1.5),line);
        break;
      case 14: // tree
        canvas.drawCircle(Offset(cx,cy-r*.6),r*1.1,line); canvas.drawCircle(Offset(cx-r*.8,cy-r*.1),r*.8,line); canvas.drawCircle(Offset(cx+r*.8,cy-r*.1),r*.8,line);
        canvas.drawRect(Rect.fromCenter(center: Offset(cx,cy+r*1.5),width:r*.65,height:r*2.1),line);
        break;
      case 15: // balloon
        canvas.drawOval(Rect.fromCenter(center: Offset(cx,cy-r*.3),width:r*2,height:r*2.7),line);
        canvas.drawLine(Offset(cx,cy+r*1.05),Offset(cx+r*.25,cy+r*2.7),line);
        break;
      case 16: // ice cream
        canvas.drawPath(Path()..moveTo(cx-r,cy)..lineTo(cx+r,cy)..lineTo(cx,cy+r*2.4)..close(),line);
        canvas.drawCircle(Offset(cx,cy-r*.55),r*1.05,line);
        break;
      case 17: // boat
        canvas.drawPath(Path()..moveTo(cx-r*2,cy+r)..lineTo(cx+r*2,cy+r)..lineTo(cx+r*1.3,cy+r*1.9)..lineTo(cx-r*1.3,cy+r*1.9)..close(),line);
        canvas.drawLine(Offset(cx,cy+r),Offset(cx,cy-r*2),line);
        canvas.drawPath(Path()..moveTo(cx,cy-r*1.9)..lineTo(cx+r*1.5,cy-r*.4)..lineTo(cx,cy-r*.4)..close(),line);
        break;
      case 18: // moon
        canvas.drawArc(Rect.fromCenter(center: Offset(cx,cy),width:r*3,height:r*3),math.pi*.25,math.pi*1.5,false,line);
        canvas.drawArc(Rect.fromCenter(center: Offset(cx+r*.65,cy-r*.25),width:r*2.4,height:r*2.4),math.pi*.25,math.pi*1.5,false,line);
        break;
      case 19: // cloud
        canvas.drawPath(Path()..moveTo(cx-r*1.9,cy+r*.6)..quadraticBezierTo(cx-r*2,cy-r*.4,cx-r*1.1,cy-r*.35)..quadraticBezierTo(cx-r*.7,cy-r*1.5,cx,cy-r*.55)..quadraticBezierTo(cx+r*.8,cy-r*1.5,cx+r*1.1,cy-r*.35)..quadraticBezierTo(cx+r*2,cy-r*.3,cx+r*1.8,cy+r*.6)..close(),line);
        break;
      default: // bird
        canvas.drawArc(Rect.fromCenter(center: Offset(cx-r*.45,cy),width:r*1.8,height:r*1.2),math.pi,math.pi,false,line); canvas.drawArc(Rect.fromCenter(center: Offset(cx+r*.45,cy),width:r*1.8,height:r*1.2),math.pi,math.pi,false,line);
    }
  }

  @override
  bool shouldRepaint(covariant _DinoOutlinePainter oldDelegate) => oldDelegate.kind != kind;
}

class Math {
  static double cos(double x) {
    return _cos(x);
  }

  static double sin(double x) {
    return _sin(x);
  }

  static double _sin(double x) {
    x %= 6.283185307;
    var term = x;
    var sum = x;
    for (var n = 1; n < 7; n++) {
      term *= -x * x / ((2 * n) * (2 * n + 1));
      sum += term;
    }
    return sum;
  }

  static double _cos(double x) => _sin(x + 1.57079632679);
}
