import 'package:flutter/material.dart';

class KidBackground extends StatelessWidget {
  final Widget child;

  const KidBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF63B8E6),
            Color(0xFFB9E8F7),
            Color(0xFFFFF6C9),
            Color(0xFFA8E39B),
          ],
          stops: [0.0, 0.42, 0.72, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(top: 42, left: 16, child: Text('☁️', style: TextStyle(fontSize: 48))),
          const Positioned(top: 112, right: 18, child: Text('☁️', style: TextStyle(fontSize: 40))),
          const Positioned(top: 150, right: 42, child: Text('🌈', style: TextStyle(fontSize: 58))),
          const Positioned(bottom: 10, left: 10, child: Text('🌼 🌷 🌸', style: TextStyle(fontSize: 24))),
          const Positioned(bottom: 10, right: 10, child: Text('🌷 🌼 🌸', style: TextStyle(fontSize: 24))),
          child,
        ],
      ),
    );
  }
}
