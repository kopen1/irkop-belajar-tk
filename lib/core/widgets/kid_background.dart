import 'package:flutter/material.dart';

import '../theme/kids_theme.dart';

/// Shared Sunny Kids Adventure backdrop used by Home and every learning world.
class KidBackground extends StatelessWidget {
  final Widget child;
  final Color? tint;

  const KidBackground({super.key, required this.child, this.tint});

  @override
  Widget build(BuildContext context) {
    final top = tint == null
        ? KidsTheme.sky
        : Color.lerp(KidsTheme.sky, tint!, .22)!;
    final middle = tint == null
        ? const Color(0xFFBEEBFA)
        : Color.lerp(const Color(0xFFBEEBFA), tint!, .14)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, middle, const Color(0xFFFFF8DC), const Color(0xFFE4F7DF)],
          stops: const [0, .38, .72, 1],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(top: 18, left: -8, child: _Cloud(size: 70)),
          const Positioned(top: 84, right: -10, child: _Cloud(size: 56)),
          const Positioned(top: 28, right: 68, child: Text('☀️', style: TextStyle(fontSize: 34))),
          const Positioned(top: 142, left: 20, child: Text('🌼', style: TextStyle(fontSize: 22))),
          const Positioned(top: 132, right: 28, child: Text('✨', style: TextStyle(fontSize: 24))),
          const Positioned(bottom: 10, left: 10, child: Text('🌷  🌸  🌼', style: TextStyle(fontSize: 20))),
          const Positioned(bottom: 10, right: 10, child: Text('🌼  🌸  🌷', style: TextStyle(fontSize: 20))),
          child,
        ],
      ),
    );
  }
}

class _Cloud extends StatelessWidget {
  final double size;
  const _Cloud({required this.size});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size * .58,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: size,
              height: size * .34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .78),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
            Positioned(
              left: size * .16,
              bottom: size * .10,
              child: _puff(size * .38),
            ),
            Positioned(
              right: size * .13,
              bottom: size * .10,
              child: _puff(size * .34),
            ),
          ],
        ),
      );

  Widget _puff(double s) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .84),
          shape: BoxShape.circle,
        ),
      );
}
