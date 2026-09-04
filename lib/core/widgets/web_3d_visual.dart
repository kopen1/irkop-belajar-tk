import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Adds the soft 3D/toy-like treatment only to the Web build.
/// Native Android keeps the original widget unchanged.
class Web3DVisual extends StatelessWidget {
  final Widget child;
  final double size;
  final double radius;
  final Color topColor;
  final Color bottomColor;

  const Web3DVisual({
    super.key,
    required this.child,
    this.size = 96,
    this.radius = 24,
    this.topColor = const Color(0xFFFFFFFF),
    this.bottomColor = const Color(0xFFDCECF5),
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 4,
            right: 4,
            bottom: -3,
            height: size * .72,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x260D405C),
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -2),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [topColor, bottomColor],
                ),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x300D405C),
                    blurRadius: 12,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 8,
                    top: 6,
                    right: 8,
                    height: size * .24,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: .72),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(radius),
                      ),
                    ),
                  ),
                  Center(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Web3DEmoji extends StatelessWidget {
  final String emoji;
  final double size;
  final double textSize;

  const Web3DEmoji({
    super.key,
    required this.emoji,
    this.size = 88,
    this.textSize = 54,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      emoji,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: textSize,
        height: 1,
        shadows: const [
          Shadow(color: Color(0x550D405C), blurRadius: 2, offset: Offset(2, 5)),
          Shadow(color: Color(0xFFFFFFFF), blurRadius: 1, offset: Offset(-1, -1)),
        ],
      ),
    );

    return Web3DVisual(size: size, radius: size * .26, child: text);
  }
}
