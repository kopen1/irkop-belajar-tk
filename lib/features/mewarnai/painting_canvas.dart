import 'package:flutter/material.dart';

class PaintingCanvas extends StatefulWidget {
  final Color color;
  const PaintingCanvas({super.key, required this.color});
  @override
  State<PaintingCanvas> createState() => _PaintingCanvasState();
}

class _PaintingCanvasState extends State<PaintingCanvas> {
  final lines = <_Stroke>[];
  List<Offset>? current;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) {
        final box = context.findRenderObject() as RenderBox;
        current = [box.globalToLocal(d.globalPosition)];
        setState(() => lines.add(_Stroke(widget.color, current!)));
      },
      onPanUpdate: (d) {
        final box = context.findRenderObject() as RenderBox;
        setState(() => current?.add(box.globalToLocal(d.globalPosition)));
      },
      onPanEnd: (_) => current = null,
      child: CustomPaint(painter: _Painter(lines), child: const SizedBox.expand()),
    );
  }
}

class _Stroke {
  final Color color;
  final List<Offset> points;
  _Stroke(this.color, this.points);
}

class _Painter extends CustomPainter {
  final List<_Stroke> lines;
  _Painter(this.lines);
  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      final p = Paint()..color = line.color.withValues(alpha: .78)..strokeWidth = 18..strokeCap = StrokeCap.round;
      for (var i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(line.points[i], line.points[i + 1], p);
      }
    }
  }
  @override
  bool shouldRepaint(covariant _Painter old) => true;
}
