import 'package:flutter/material.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

/// Polished, asset-free animated card for the eight learning worlds.
///
/// The animation is supplied by the Rive Animated Icons package (local Rive
/// assets), while the whole card owns the touch interaction so it works well
/// on phones and does not depend on mouse/hover input.
class AnimatedWorldCard extends StatefulWidget {
  final RiveIcon icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final String badge;
  final Future<void> Function() onNavigate;

  const AnimatedWorldCard({
    super.key,
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onNavigate,
  });

  @override
  State<AnimatedWorldCard> createState() => _AnimatedWorldCardState();
}

class _AnimatedWorldCardState extends State<AnimatedWorldCard> {
  bool _pressed = false;
  bool _busy = false;

  Future<void> _handleTap() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _pressed = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 140));
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
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutBack,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _busy ? null : _handleTap,
            borderRadius: BorderRadius.circular(26),
            splashColor: widget.accentColor.withValues(alpha: .10),
            highlightColor: widget.accentColor.withValues(alpha: .05),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: .16),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: _pressed ? .25 : .12),
                    blurRadius: _pressed ? 22 : 14,
                    offset: const Offset(0, 7),
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
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: softAccent,
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withValues(alpha: _pressed ? .28 : .10),
                                blurRadius: _pressed ? 24 : 14,
                                spreadRadius: _pressed ? 3 : 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: RiveAnimatedIcon(
                              riveIcon: widget.icon,
                              width: 60,
                              height: 60,
                              color: widget.accentColor,
                              strokeWidth: 2.6,
                              loopAnimation: true,
                              enableAbsorbPointer: true,
                              semanticLabel: widget.title,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
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
