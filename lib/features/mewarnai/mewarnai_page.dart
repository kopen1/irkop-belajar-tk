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
                        Expanded(child: _drawingPanel(s)),
                        SizedBox(height: 12 * s),
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

  Widget _drawingPanel(double s) => Container(
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
        SizedBox(height: 12 * s),
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
      width: 46 * s, height: 46 * s,
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
        height: 66 * s,
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
    final p = Paint()
      ..color = const Color(0xFF151515)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.shortestSide * .012).clamp(3.5, 7.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final body = Path()
      ..moveTo(size.width * .17, size.height * .64)
      ..quadraticBezierTo(size.width * .12, size.height * .46, size.width * .24, size.height * .40)
      ..quadraticBezierTo(size.width * .34, size.height * .30, size.width * .48, size.height * .33)
      ..quadraticBezierTo(size.width * .53, size.height * .15, size.width * .71, size.height * .20)
      ..quadraticBezierTo(size.width * .87, size.height * .24, size.width * .83, size.height * .39)
      ..quadraticBezierTo(size.width * .79, size.height * .46, size.width * .69, size.height * .47)
      ..lineTo(size.width * .68, size.height * .74)
      ..quadraticBezierTo(size.width * .72, size.height * .83, size.width * .67, size.height * .90)
      ..lineTo(size.width * .53, size.height * .90)
      ..quadraticBezierTo(size.width * .48, size.height * .86, size.width * .50, size.height * .78)
      ..lineTo(size.width * .39, size.height * .78)
      ..lineTo(size.width * .37, size.height * .91)
      ..quadraticBezierTo(size.width * .29, size.height * .95, size.width * .23, size.height * .89)
      ..lineTo(size.width * .25, size.height * .75)
      ..quadraticBezierTo(size.width * .16, size.height * .72, size.width * .17, size.height * .64)
      ..close();
    canvas.drawPath(body, p);

    final tail = Path()
      ..moveTo(size.width * .25, size.height * .63)
      ..quadraticBezierTo(size.width * .08, size.height * .61, size.width * .08, size.height * .76)
      ..quadraticBezierTo(size.width * .16, size.height * .79, size.width * .29, size.height * .73);
    canvas.drawPath(tail, p);

    canvas.drawCircle(Offset(size.width * .63, size.height * .31), size.shortestSide * .018, p..style = PaintingStyle.fill);
    p.style = PaintingStyle.stroke;

    final mouth = Path()
      ..moveTo(size.width * .56, size.height * .42)
      ..quadraticBezierTo(size.width * .64, size.height * .50, size.width * .73, size.height * .42);
    canvas.drawPath(mouth, p);

    for (final spike in const [[.30,.38,.27,.29],[.38,.34,.35,.24],[.47,.33,.45,.22]]) {
      canvas.drawLine(Offset(size.width * spike[0], size.height * spike[1]), Offset(size.width * spike[2], size.height * spike[3]), p);
    }

    canvas.drawCircle(Offset(size.width * .86, size.height * .16), size.shortestSide * .075, p);
  }

  @override
  bool shouldRepaint(covariant _DinoOutlinePainter oldDelegate) => false;
}
