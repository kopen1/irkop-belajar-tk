import 'package:flutter/material.dart';
import '../theme/kids_theme.dart';

/// Clean Little Explorer background shared by every learning world.
class KidBackground extends StatelessWidget {
  final Widget child;
  final Color? tint;
  const KidBackground({super.key, required this.child, this.tint});

  @override
  Widget build(BuildContext context) {
    final top = tint == null ? const Color(0xFFEAF8FD) : Color.lerp(const Color(0xFFEAF8FD), tint!, .08)!;
    final bottom = tint == null ? KidsTheme.background : Color.lerp(KidsTheme.background, tint!, .05)!;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom])),
      child: Stack(fit: StackFit.expand, children: [
        const Positioned(top: 18, left: -10, child: _Cloud(72)),
        const Positioned(top: 74, right: -14, child: _Cloud(54)),
        const Positioned(top: 24, right: 54, child: Text('☀️', style: TextStyle(fontSize: 30))),
        const Positioned(bottom: 10, left: 18, child: Text('🌱  🌼', style: TextStyle(fontSize: 18))),
        const Positioned(bottom: 10, right: 18, child: Text('🌼  🌱', style: TextStyle(fontSize: 18))),
        child,
      ]),
    );
  }
}

class _Cloud extends StatelessWidget {
  final double size;
  const _Cloud(this.size);
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size * .55, child: Stack(alignment: Alignment.bottomCenter, children: [
    Container(width: size, height: size * .30, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .85), borderRadius: BorderRadius.circular(size))),
    Positioned(left: size * .15, bottom: size * .07, child: _puff(size * .36)),
    Positioned(right: size * .14, bottom: size * .07, child: _puff(size * .32)),
  ]));
  Widget _puff(double s) => Container(width: s, height: s, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), shape: BoxShape.circle));
}
