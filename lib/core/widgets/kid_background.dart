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
            Color(0xFF74CFFF),
            Color(0xFFC8F2FF),
            Color(0xFFFFF8D5),
            Color(0xFFA9E59B),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 35,
            left: 15,
            child: Text(
              '☁️',
              style: TextStyle(fontSize: 50),
            ),
          ),
          const Positioned(
            top: 80,
            right: 20,
            child: Text(
              '☁️',
              style: TextStyle(fontSize: 42),
            ),
          ),
          const Positioned(
            top: 135,
            right: 40,
            child: Text(
              '🌈',
              style: TextStyle(fontSize: 48),
            ),
          ),
          const Positioned(
            bottom: 8,
            left: 10,
            child: Text(
              '🌼 🌷 🌸',
              style: TextStyle(fontSize: 25),
            ),
          ),
          const Positioned(
            bottom: 8,
            right: 10,
            child: Text(
              '🌷 🌼 🌸',
              style: TextStyle(fontSize: 25),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
