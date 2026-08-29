import 'dart:async';

import 'package:flutter/material.dart';

import '../home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  Timer? _fallbackTimer;
  bool _opened = false;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _openHome();
      }
    });

    // Cadangan agar splash tidak pernah berhenti berputar.
    _fallbackTimer = Timer(const Duration(seconds: 3), _openHome);
  }

  void _openHome() {
    if (_opened || !mounted) return;
    _opened = true;
    _fallbackTimer?.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2395D8),
              Color(0xFF77C9EA),
              Color(0xFF8DDB76),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                left: -50,
                top: 110,
                child: _Cloud(width: 210),
              ),
              const Positioned(
                right: -55,
                top: 175,
                child: _Cloud(width: 190),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF54C95A), Color(0xFF087C55)],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(420, 75),
                    ),
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _Rainbow(),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            shadows: [
                              Shadow(
                                color: Color(0x77001D58),
                                blurRadius: 7,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          children: [
                            TextSpan(
                              text: 'BELAJAR ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'TK',
                              style: TextStyle(color: Color(0xFFFFDD2E)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ayo Bermain & Belajar Bersama!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              color: Color(0x55001D58),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _PandaMascot(),
                      const SizedBox(height: 26),
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) => SizedBox(
                          width: 58,
                          height: 58,
                          child: CircularProgressIndicator(
                            value: _progressController.value,
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'by IRKOP',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
    );
  }
}

class _Rainbow extends StatelessWidget {
  const _Rainbow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 76,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: const [
          _RainbowArc(size: 130, color: Color(0xFFFF5A36)),
          _RainbowArc(size: 112, color: Color(0xFFFFB62E)),
          _RainbowArc(size: 94, color: Color(0xFFFFE34D)),
          _RainbowArc(size: 76, color: Color(0xFF62C95C)),
          _RainbowArc(size: 58, color: Color(0xFF5C7CE0)),
          _RainbowArc(size: 40, color: Color(0xFF9A63D8)),
        ],
      ),
    );
  }
}

class _RainbowArc extends StatelessWidget {
  const _RainbowArc({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size),
            topRight: Radius.circular(size),
          ),
        ),
      ),
    );
  }
}

class _PandaMascot extends StatelessWidget {
  const _PandaMascot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 8,
            left: 28,
            child: _circle(72, const Color(0xFF20242D)),
          ),
          Positioned(
            top: 8,
            right: 28,
            child: _circle(72, const Color(0xFF20242D)),
          ),
          Positioned(
            top: 42,
            child: Container(
              width: 205,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F6),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: const Color(0xFF252A31),
                  width: 5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 92,
            left: 52,
            child: _eyePatch(rotation: -0.35),
          ),
          Positioned(
            top: 92,
            right: 52,
            child: _eyePatch(rotation: 0.35),
          ),
          Positioned(
            top: 126,
            child: Container(
              width: 18,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF15191F),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            top: 144,
            child: Container(
              width: 58,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF171B21),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 25,
                  height: 11,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7790),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            child: Container(
              width: 150,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F6),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(70),
                ),
                border: Border.all(
                  color: const Color(0xFF252A31),
                  width: 5,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            left: 34,
            child: _circle(66, const Color(0xFF20242D)),
          ),
          Positioned(
            bottom: 18,
            right: 34,
            child: _circle(66, const Color(0xFF20242D)),
          ),
        ],
      ),
    );
  }

  static Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget _eyePatch({required double rotation}) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 58,
        height: 72,
        decoration: const BoxDecoration(
          color: Color(0xFF20242D),
          borderRadius: BorderRadius.all(Radius.elliptical(40, 50)),
        ),
        child: Center(
          child: Container(
            width: 17,
            height: 23,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * .42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .62),
        borderRadius: BorderRadius.circular(width),
      ),
    );
  }
}
