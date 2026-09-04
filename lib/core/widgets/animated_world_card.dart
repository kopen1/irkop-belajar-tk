import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Native vector illustration for a learning world.
///
/// Deliberately does not use image assets or generic icon packs. Every world
/// gets its own composition, while the animation is driven by Flutter's
/// AnimationController so it behaves identically on mobile and web.
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
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

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
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    setState(() => _pressed = false);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    await widget.onNavigate();
    if (!mounted) return;
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final softAccent = widget.accentColor.withValues(alpha: .12);
    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.subtitle}',
      child: AnimatedScale(
        scale: _pressed ? .955 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _busy ? null : _handleTap,
            borderRadius: BorderRadius.circular(28),
            splashColor: widget.accentColor.withValues(alpha: .10),
            highlightColor: widget.accentColor.withValues(alpha: .05),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: .16),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: _pressed ? .27 : .13),
                    blurRadius: _pressed ? 24 : 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: softAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.badge,
                            style: TextStyle(
                              color: widget.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: widget.accentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withValues(alpha: .25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 19),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 5),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF24445C)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF718798)),
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
    final wave = math.sin(progress * math.pi * 2);
    final lift = wave * 4.0;
    final tilt = wave * .035;
    final scale = pressed ? .91 : 1 + wave * .018;
    final glow = accent.withValues(alpha: pressed ? .30 : .14 + (wave + 1) * .035);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Transform.translate(
          offset: Offset(0, 10 - lift * .35),
          child: Container(
            width: 108,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: accent.withValues(alpha: .16),
              boxShadow: [BoxShadow(color: accent.withValues(alpha: .18), blurRadius: 14, spreadRadius: 2)],
            ),
          ),
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, .0012)
            ..rotateZ(tilt)
            ..scale(scale),
          child: Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  accent.withValues(alpha: .17),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: .9), width: 3),
              boxShadow: [
                BoxShadow(color: glow, blurRadius: pressed ? 28 : 20, spreadRadius: pressed ? 5 : 2, offset: const Offset(0, 7)),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 11,
                  right: 12,
                  child: _Shine(color: accent),
                ),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent.withValues(alpha: .98), accent.withValues(alpha: .62)],
                    ),
                    boxShadow: [
                      BoxShadow(color: accent.withValues(alpha: .34), blurRadius: 12, offset: const Offset(0, 7)),
                    ],
                  ),
                  child: Icon(_icon, color: Colors.white, size: 38),
                ),
                ...List.generate(_miniLabels.length, (i) {
                  final angle = -math.pi / 2 + i * math.pi;
                  final radius = 46.0 + wave * 2;
                  return Transform.translate(
                    offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
                    child: _MiniBubble(
                      label: _miniLabels[i],
                      accent: accent,
                      index: i,
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
  final int index;
  const _MiniBubble({required this.label, required this.accent, required this.index});

  @override
  Widget build(BuildContext context) => Container(
        width: 27,
        height: 27,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: accent.withValues(alpha: .35), width: 2),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: .16), blurRadius: 7, offset: const Offset(0, 3))],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accent,
            fontSize: label.length > 1 ? 8 : 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
}

class _Shine extends StatelessWidget {
  final Color color;
  const _Shine({required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 13,
        height: 13,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .88),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: .35), blurRadius: 7)],
        ),
      );
}
