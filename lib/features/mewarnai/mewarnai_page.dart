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

  void _pick(Color color) => setState(() { selected = color; eraser = false; });
  void _useBrush() => setState(() => eraser = false);
  void _useEraser() => setState(() => eraser = true);
  void _clear() => setState(() => clearSignal++);

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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(w * .04, 8, w * .04, 16 * s),
                    child: Column(
                      children: [
                        _drawingPanel(s),
                        SizedBox(height: 14 * s),
                        _toolbar(s),
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

  Widget _drawingPanel(double s) => AspectRatio(
    aspectRatio: 1.18,
    child: Container(
    width: double.infinity,
    padding: EdgeInsets.all(14 * s),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .96),
      borderRadius: BorderRadius.circular(30 * s),
      border: Border.all(color: const Color(0xFFEAF2F7), width: 3),
      boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 12, offset: Offset(0, 5))],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22 * s),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DinoOutlinePainter())),
          Positioned.fill(child: PaintingCanvas(color: eraser ? Colors.white : selected, clearSignal: clearSignal)),
        ],
      ),
    ),
  ));

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
            Expanded(flex: 4, child: _toolButton(icon: Icons.brush_rounded, color: const Color(0xFF2489D8), active: !eraser, onTap: _useBrush, s: s)),
            SizedBox(width: 10 * s),
            Expanded(flex: 2, child: _toolButton(icon: Icons.auto_fix_high_rounded, color: const Color(0xFFF4F0E7), foreground: const Color(0xFF42679E), active: eraser, onTap: _useEraser, s: s)),
            SizedBox(width: 10 * s),
            Expanded(flex: 4, child: _clearButton(s)),
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
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF151515)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.shortestSide * .010).clamp(3.2, 6.5)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Offset p(double x, double y) => Offset(size.width * x, size.height * y);

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
        Offset(center.dx + r1 * Math.cos(a), center.dy + r1 * Math.sin(a)),
        Offset(center.dx + r2 * Math.cos(a), center.dy + r2 * Math.sin(a)),
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

  @override
  bool shouldRepaint(covariant _DinoOutlinePainter oldDelegate) => false;
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
