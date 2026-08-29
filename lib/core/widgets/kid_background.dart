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
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF9FE7FF),
                Color(0xFFEAF9FF),
                Color(0xFFCFF6C5),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 40,
          left: 20,
          child: Text('☁️', style: TextStyle(fontSize: 48)),
        ),
        const Positioned(
          top: 70,
          right: 20,
          child: Text('☁️', style: TextStyle(fontSize: 38)),
        ),
        const Positioned(
          bottom: 10,
          left: 20,
          child: Text('🌼 🌷 🌼', style: TextStyle(fontSize: 25)),
        ),
        const Positioned(
          bottom: 10,
          right: 20,
          child: Text('🌷 🌼', style: TextStyle(fontSize: 25)),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
