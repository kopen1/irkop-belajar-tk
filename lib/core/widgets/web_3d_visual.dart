import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lightweight animated 3D-style visual used on Web and Android.
///
/// This is intentionally not a real-time 3D engine: it uses Flutter's GPU
/// transform, gradients and shadows so the visuals stay small and smooth on
/// preschool phones while still looking dimensional.
class Web3DVisual extends StatefulWidget {
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
  State<Web3DVisual> createState() => _Web3DVisualState();
}

class _Web3DVisualState extends State<Web3DVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: SizedBox(
          width: widget.size,
          height: widget.size + 12,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: widget.size * .08,
                right: widget.size * .08,
                bottom: 0,
                height: widget.size * .28,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0x300D405C),
                    borderRadius: BorderRadius.circular(widget.radius),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x250D405C),
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [widget.topColor, widget.bottomColor],
                  ),
                  borderRadius: BorderRadius.circular(widget.radius),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3A0D405C),
                      blurRadius: 16,
                      offset: Offset(0, 9),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 7,
                      top: 5,
                      right: 7,
                      height: widget.size * .24,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: .82),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(widget.radius),
                        ),
                      ),
                    ),
                    Positioned(
                      right: widget.size * .10,
                      bottom: widget.size * .10,
                      child: Container(
                        width: widget.size * .16,
                        height: widget.size * .16,
                        decoration: const BoxDecoration(
                          color: Color(0x28FFFFFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(child: widget.child),
                  ],
                ),
              ),
            ],
          ),
        ),
        builder: (context, child) {
          final phase = _controller.value * math.pi * 2;
          final bob = math.sin(phase) * widget.size * .055;
          final rotateY = math.sin(phase) * .075;
          final rotateX = math.cos(phase) * .035;
          final scale = 1 + math.sin(phase * 2) * .018;
          final shadowScale = 1 - math.sin(phase) * .10;

          return SizedBox(
            width: widget.size,
            height: widget.size + 14,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 2,
                  child: Transform.scale(
                    scaleX: shadowScale,
                    child: Container(
                      width: widget.size * .56,
                      height: widget.size * .10,
                      decoration: BoxDecoration(
                        color: const Color(0x280D405C),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0014)
                    ..rotateX(rotateX)
                    ..rotateY(rotateY)
                    ..scale(scale)
                    ..translate(0.0, -6.0 - bob),
                  child: child,
                ),
              ],
            ),
          );
        },
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
          Shadow(
            color: Color(0x660D405C),
            blurRadius: 2,
            offset: Offset(3, 6),
          ),
          Shadow(
            color: Color(0xFFFFFFFF),
            blurRadius: 1,
            offset: Offset(-2, -2),
          ),
        ],
      ),
    );

    return Web3DVisual(size: size, radius: size * .26, child: text);
  }
}
