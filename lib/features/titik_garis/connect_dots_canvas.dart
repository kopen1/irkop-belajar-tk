import 'package:flutter/material.dart';

class ConnectDotsCanvas extends StatefulWidget {
  const ConnectDotsCanvas({super.key});

  @override
  State<ConnectDotsCanvas> createState() =>
      _ConnectDotsCanvasState();
}

class _ConnectDotsCanvasState
    extends State<ConnectDotsCanvas> {

  final points = <Offset>[
    const Offset(80, 300),
    const Offset(160, 120),
    const Offset(260, 80),
    const Offset(360, 180),
    const Offset(320, 330),
    const Offset(200, 380),
  ];

  final List<Offset> connected = [];

  Offset? dragPoint;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return GestureDetector(
          onPanStart: (details) {
            final local = details.localPosition;

            if (currentIndex < points.length &&
                (local - points[currentIndex]).distance < 35) {
              setState(() {
                dragPoint = local;
              });
            }
          },
          onPanUpdate: (details) {
            if (dragPoint != null) {
              setState(() {
                dragPoint = details.localPosition;
              });
            }
          },
          onPanEnd: (details) {
            if (dragPoint == null ||
                currentIndex >= points.length) {
              return;
            }

            final targetIndex = currentIndex + 1;

            if (targetIndex < points.length &&
                (dragPoint! - points[targetIndex]).distance < 45) {
              setState(() {
                connected.add(points[currentIndex]);
                connected.add(points[targetIndex]);
                currentIndex++;
              });
            }

            setState(() {
              dragPoint = null;
            });
          },
          child: CustomPaint(
            painter: _DotsPainter(
              points: points,
              connectedCount: currentIndex,
              dragPoint: dragPoint,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _DotsPainter extends CustomPainter {
  final List<Offset> points;
  final int connectedCount;
  final Offset? dragPoint;

  _DotsPainter({
    required this.points,
    required this.connectedCount,
    required this.dragPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = Colors.orange;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < connectedCount; i++) {
      canvas.drawLine(
        points[i],
        points[i + 1],
        linePaint,
      );
    }

    if (dragPoint != null &&
        connectedCount < points.length) {
      canvas.drawLine(
        points[connectedCount],
        dragPoint!,
        linePaint,
      );
    }

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(
        points[i],
        16,
        dotPaint,
      );

      textPainter.text = TextSpan(
        text: '${i + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        points[i] -
            Offset(
              textPainter.width / 2,
              textPainter.height / 2,
            ),
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _DotsPainter oldDelegate,
  ) {
    return true;
  }
}
