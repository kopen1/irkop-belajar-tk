import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

/// Reusable Rive-powered world card.
///
/// Every world uses the same artboard/state-machine contract:
/// artboard: WorldCard
/// state machine: card_states
/// number input: touchState (0 idle, 1 pressed, 2 released/selected)
class AnimatedWorldCard extends StatefulWidget {
  final String riveAsset;
  final Color accentColor;
  final String title;
  final String subtitle;
  final Future<void> Function() onNavigate;
  final double riveSize;

  const AnimatedWorldCard({
    super.key,
    required this.riveAsset,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.onNavigate,
    this.riveSize = 92,
  });

  @override
  State<AnimatedWorldCard> createState() => _AnimatedWorldCardState();
}

class _AnimatedWorldCardState extends State<AnimatedWorldCard> {
  late final rive.FileLoader _fileLoader;
  rive.NumberInput? _touchState;
  bool _busy = false;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _fileLoader = rive.FileLoader.fromAsset(
      widget.riveAsset,
      riveFactory: rive.Factory.rive,
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _fileLoader.dispose();
    super.dispose();
  }

  void _onLoaded(rive.RiveLoaded state) {
    _touchState = state.controller.stateMachine.number('touchState');
    _touchState?.value = 0;
  }

  void _setTouchState(double value) {
    final input = _touchState;
    if (input == null) return;
    input.value = value;
  }

  void _onTapDown(TapDownDetails _) {
    if (_busy) return;
    _setTouchState(1);
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    if (_busy) return;
    _busy = true;
    _setTouchState(2);

    // Released/Selected animation is intentionally given enough time to
    // complete its bounce + sparkle + glow sequence before navigation.
    await Future<void>.delayed(const Duration(milliseconds: 620));
    if (!mounted) return;

    await widget.onNavigate();
    if (!mounted) return;

    _setTouchState(0);
    _busy = false;
  }

  void _onTapCancel() {
    if (_busy) return;
    _setTouchState(0);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .97),
      borderRadius: BorderRadius.circular(26),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: _busy ? null : () {},
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, right: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: widget.riveSize,
                          height: widget.riveSize,
                          child: rive.RiveWidgetBuilder(
                            fileLoader: _fileLoader,
                            artboardSelector:
                                const rive.ArtboardNamed('WorldCard'),
                            stateMachineSelector:
                                const rive.StateMachineNamed('card_states'),
                            onLoaded: _onLoaded,
                            builder: (context, state) => switch (state) {
                              rive.RiveLoading() => const SizedBox.shrink(),
                              rive.RiveFailed() => const Icon(
                                Icons.auto_awesome_rounded,
                                size: 46,
                                color: Color(0xFFB8CAD4),
                              ),
                              rive.RiveLoaded() => rive.RiveWidget(
                                controller: state.controller,
                                fit: rive.Fit.contain,
                              ),
                            },
                          ),
                        ),
                        const SizedBox(height: 4),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF718798),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
