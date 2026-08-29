import 'package:flutter/material.dart';

class PaintingCanvas extends StatefulWidget {
  final Color color;

  const PaintingCanvas({
    super.key,
    required this.color,
  });

  @override
  State<PaintingCanvas> createState() => _PaintingCanvasState();
}

class _PaintingCanvasState extends State<PaintingCanvas> {
  final List<List<Offset>> lines = [];
  List<Offset>? currentLine;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final box = context.findRenderObject() as RenderBox;
        final point = box.globalToLocal(details.globalPosition);

        setState(() {
          currentLine = [point];
          lines.add(currentLine!);
        });
      },
      onPanUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final point = box.globalToLocal(details.globalPosition);

        setState(() {
          currentLine?.add(point);
        });
      },
      onPanEnd: (_) {
        currentLine = null;
      },
      child: CustomPaint(
        painter: _Painter(
          lines: lines,
          color: widget.color,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black26),
          ),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final List<List<Offset>> lines;
  final Color color;

  _Painter({
    required this.lines,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(
          line[i],
          line[i + 1],
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) {
    return true;
  }
}
