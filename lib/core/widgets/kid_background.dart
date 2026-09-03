import 'package:flutter/material.dart';

import '../theme/kids_theme.dart';

class KidBackground extends StatelessWidget {
  final Widget child;
  final Color? tint;

  const KidBackground({super.key, required this.child, this.tint});

  @override
  Widget build(BuildContext context) {
    final base = const [
      KidsTheme.sky,
      Color(0xFFBEEBFA),
      Color(0xFFFFF5CF),
      Color(0xFFDDF5D5),
    ];
    final colors = tint == null
        ? base
        : [
            Color.lerp(base[0], tint!, .30)!,
            Color.lerp(base[1], tint!, .20)!,
            Color.lerp(base[2], tint!, .12)!,
            Color.lerp(base[3], tint!, .10)!,
          ];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: const [0.0, 0.42, 0.72, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(top: 28, left: 14, child: Text('☁️', style: TextStyle(fontSize: 44))),
          const Positioned(top: 96, right: 16, child: Text('☁️', style: TextStyle(fontSize: 36))),
          const Positioned(top: 136, right: 34, child: Text('✨', style: TextStyle(fontSize: 30))),
          const Positioned(top: 174, left: 28, child: Text('🌼', style: TextStyle(fontSize: 24))),
          const Positioned(bottom: 8, left: 10, child: Text('🌷  🌸  🌼', style: TextStyle(fontSize: 22))),
          const Positioned(bottom: 8, right: 10, child: Text('🌼  🌸  🌷', style: TextStyle(fontSize: 22))),
          child,
        ],
      ),
    );
  }
}
