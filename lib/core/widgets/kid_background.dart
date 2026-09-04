import 'package:flutter/material.dart';
import '../theme/kids_theme.dart';

/// Little Explorer park background shared by the Android app and Flutter Web.
class KidBackground extends StatelessWidget {
  final Widget child;
  final Color? tint;
  const KidBackground({super.key, required this.child, this.tint});

  @override
  Widget build(BuildContext context) {
    final sky = tint == null ? const Color(0xFFBFEFFF) : Color.lerp(const Color(0xFFBFEFFF), tint!, .08)!;
    final ground = tint == null ? const Color(0xFFEAF9F0) : Color.lerp(const Color(0xFFEAF9F0), tint!, .06)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [sky, ground], stops: const [0, .82]),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(top: 8, left: -8, child: Text('☀️', style: TextStyle(fontSize: 54))),
          const Positioned(top: 22, left: 92, child: _Cloud(86)),
          const Positioned(top: 54, right: -18, child: _Cloud(72)),
          const Positioned(top: 12, right: 30, child: Text('🎈', style: TextStyle(fontSize: 38))),
          const Positioned(bottom: 0, left: -18, child: Text('🌳🌼🌱', style: TextStyle(fontSize: 38))),
          const Positioned(bottom: -2, right: -18, child: Text('🌱🌼🌳', style: TextStyle(fontSize: 38))),
          const Positioned(bottom: 18, left: 12, child: Text('🌷 🌼 🌸', style: TextStyle(fontSize: 18))),
          const Positioned(bottom: 18, right: 12, child: Text('🌸 🌼 🌷', style: TextStyle(fontSize: 18))),
          child,
        ],
      ),
    );
  }
}

class _Cloud extends StatelessWidget {
  final double size;
  const _Cloud(this.size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * .55,
      child: Stack(alignment: Alignment.bottomCenter, children: [
        Container(width: size, height: size * .30, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .88), borderRadius: BorderRadius.circular(size))),
        Positioned(left: size * .14, bottom: size * .07, child: _puff(size * .38)),
        Positioned(right: size * .13, bottom: size * .07, child: _puff(size * .34)),
        Positioned(left: size * .40, bottom: size * .09, child: _puff(size * .28)),
      ]),
    );
  }

  Widget _puff(double s) => Container(width: s, height: s, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), shape: BoxShape.circle));
}
