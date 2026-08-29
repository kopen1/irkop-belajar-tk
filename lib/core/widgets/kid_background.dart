import 'package:flutter/material.dart';

class KidBackground extends StatelessWidget {
  final Widget child;

  const KidBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF86D8FF),
                Color(0xFFDDF7FF),
                Color(0xFFFFF7D6),
                Color(0xFFCFF3BE),
              ],
            ),
          ),
        ),

        const Positioned(
          top: 28,
          left: 12,
          child: Text(
            '☁️',
            style: TextStyle(fontSize: 56),
          ),
        ),

        const Positioned(
          top: 82,
          right: 18,
          child: Text(
            '☁️',
            style: TextStyle(fontSize: 42),
          ),
        ),

        const Positioned(
          top: 145,
          left: 26,
          child: Text(
            '🌈',
            style: TextStyle(fontSize: 44),
          ),
        ),

        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 70,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(42),
                ),
                color: Color(0xFF9CDE8D),
              ),
            ),
          ),
        ),

        const Positioned(
          bottom: 12,
          left: 16,
          child: Text(
            '🌼 🌷 🌼',
            style: TextStyle(fontSize: 28),
          ),
        ),

        const Positioned(
          bottom: 12,
          right: 16,
          child: Text(
            '🌷 🌼 🌸',
            style: TextStyle(fontSize: 28),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}
