import 'dart:math' as math;

import 'package:flutter/material.dart';

enum WorldArt {
  letters,
  numbers,
  hijaiyah,
  pictures,
  colors,
  coloring,
  dotsLines,
  quiz,
}

class AnimatedWorldCard extends StatefulWidget {
  final WorldArt art;
  final Color accentColor;
  final String title;
  final String subtitle;
  final String badge;
  final Future<void> Function() onNavigate;

  const AnimatedWorldCard({
    super.key,
    required this.art,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onNavigate,
  });

  @override
  State<AnimatedWorldCard> createState() => _AnimatedWorldCardState();
}

class _AnimatedWorldCardState extends State<AnimatedWorldCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );

  bool _pressed = false;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _pressed = true;
    });

    await _controller.forward(from: 0);
    if (!mounted) return;
    setState(() => _pressed = false);

    await Future<void>.delayed(const Duration(milliseconds: 90));
    if (!mounted) return;
    await widget.onNavigate();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final softAccent = widget.accentColor.withValues(alpha: .12);
    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.subtitle}',
      child: AnimatedScale(
        scale: _pressed ? .955 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _busy ? null : _handleTap,
            borderRadius: BorderRadius.circular(24),
            splashColor: widget.accentColor.withValues(alpha: .10),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: .15),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: .12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: softAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.badge,
                            style: TextStyle(
                              color: widget.accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 31,
                          height: 31,
                          decoration: BoxDecoration(
                            color: widget.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => WorldIllustration(
                          art: widget.art,
                          accent: widget.accentColor,
                          progress: _controller.value,
                          pressed: _pressed,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF24445C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF718798),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WorldIllustration extends StatelessWidget {
  final WorldArt art;
  final Color accent;
  final double progress;
  final bool pressed;

  const WorldIllustration({
    super.key,
    required this.art,
    required this.accent,
    required this.progress,
    required this.pressed,
  });

  IconData get _icon => switch (art) {
        WorldArt.letters => Icons.text_fields_rounded,
        WorldArt.numbers => Icons.looks_one_rounded,
        WorldArt.hijaiyah => Icons.menu_book_rounded,
        WorldArt.pictures => Icons.photo_library_rounded,
        WorldArt.colors => Icons.palette_rounded,
        WorldArt.coloring => Icons.brush_rounded,
        WorldArt.dotsLines => Icons.route_rounded,
        WorldArt.quiz => Icons.psychology_alt_rounded,
      };

  List<String> get _miniLabels => switch (art) {
        WorldArt.letters => ['A', 'B', 'C'],
        WorldArt.numbers => ['1', '2', '3'],
        WorldArt.hijaiyah => ['أ', 'ب', 'ت'],
        WorldArt.pictures => ['🐱', '🌳', '☀'],
        WorldArt.colors => ['●', '●', '●'],
        WorldArt.coloring => ['✎', '★', '♥'],
        WorldArt.dotsLines => ['•', '•', '•'],
        WorldArt.quiz => ['?', '★', '✓'],
      };

  @override
  Widget build(BuildContext context) {
    final t = Curves.easeOutBack.transform(progress);
    final pulse = math.sin(progress * math.pi);
    final lift = pulse * 5;
    final scale = pressed ? .91 + t * .14 : 1.0;
    final glowAlpha = pressed ? .30 : .12 + pulse * .10;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Transform.translate(
          offset: Offset(0, 9 - lift * .25),
          child: Container(
            width: 100,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: accent.withValues(alpha: .14),
            ),
          ),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, .001)
            ..rotateZ(math.sin(progress * math.pi) * .025)
            ..scale(scale),
          child: Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, accent.withValues(alpha: .16)],
              ),
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: glowAlpha),
                  blurRadius: pressed ? 22 : 12,
                  spreadRadius: pressed ? 3 : 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 10,
                  right: 11,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .88),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent, accent.withValues(alpha: .65)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: .28),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(_icon, color: Colors.white, size: 36),
                ),
                ...List.generate(_miniLabels.length, (i) {
                  final angle = -math.pi / 2 + i * math.pi;
                  final radius = 44.0 + pulse * 2;
                  return Transform.translate(
                    offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
                    child: _MiniBubble(
                      label: _miniLabels[i],
                      accent: accent,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniBubble extends StatelessWidget {
  final String label;
  final Color accent;

  const _MiniBubble({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) => Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: accent.withValues(alpha: .30), width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accent,
            fontSize: label.length > 1 ? 8 : 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
}
