import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Adds the soft 3D/toy-like treatment only to the Web build.
/// Native Android keeps the original widget unchanged.
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
  double _tiltX = 0;
  double _tiltY = 0;

  bool get _isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    if (!_isWeb) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(event.position);
    final half = widget.size / 2;
    final nx = ((local.dy - half) / half).clamp(-1.0, 1.0);
    final ny = ((local.dx - half) / half).clamp(-1.0, 1.0);
    setState(() {
      _tiltX = -nx * 0.10;
      _tiltY = ny * 0.12;
    });
  }

  void _onExit(PointerEvent event) {
    if (!_isWeb) return;
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isWeb) return widget.child;

    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final breathe = math.sin(_controller.value * math.pi) * 0.018;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 180),
            builder: (context, _, __) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0018)
                ..rotateX(_tiltX + breathe)
                ..rotateY(_tiltY - breathe * 0.8)
                ..translate(0.0, -2.0 - breathe * widget.size * 0.35),
              child: child,
            ),
          );
        },
        child: SizedBox(
          width: widget.size,
          height: widget.size + 8,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 4,
                right: 4,
                bottom: 0,
                height: widget.size * .72,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0x260D405C),
                    borderRadius: BorderRadius.circular(widget.radius),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x220D405C),
                        blurRadius: 10,
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
                      color: Color(0x380D405C),
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
                      top: 6,
                      right: 8,
                      height: widget.size * .24,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: .78),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(widget.radius),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 9,
                      child: Container(
                        width: widget.size * .16,
                        height: widget.size * .16,
                        decoration: const BoxDecoration(
                          color: Color(0x24FFFFFF),
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
