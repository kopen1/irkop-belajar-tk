import 'package:flutter/material.dart';

import '../home/home_page.dart';

class PlayIntroPage extends StatelessWidget {
  const PlayIntroPage({super.key});

  void _openMenu(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
    );
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
              Color(0xFF2195D6),
              Color(0xFF6FC9E9),
              Color(0xFF98D86D),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(left: -38, top: 38, child: _Cloud(width: 190)),
              const Positioned(right: -48, top: 122, child: _Cloud(width: 175)),
              const Positioned(right: 30, top: 20, child: _Sun()),
              const Positioned(left: 30, top: 118, child: Text('🦋', style: TextStyle(fontSize: 42))),
              const Positioned(right: 36, top: 290, child: Text('🦋', style: TextStyle(fontSize: 40))),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _Ground(),
              ),
              const Positioned(
                right: 26,
                bottom: 125,
                child: _School(),
              ),
              const Positioned(
                left: 24,
                bottom: 56,
                child: _Flowers(),
              ),
              const Positioned(
                right: 12,
                bottom: 35,
                child: _Flowers(),
              ),
              Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _Rainbow(),
                        const SizedBox(height: 2),
                        _LogoText(),
                        const SizedBox(height: 8),
                        const Text(
                          'Ayo Bermain & Belajar Bersama!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
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
                        const SizedBox(height: 20),
                        const _PandaMascot(),
                        const SizedBox(height: 20),
                        _PlayButton(onTap: () => _openMenu(context)),
                      ],
                    ),
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

class _LogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'BELAJAR TK',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: MediaQuery.sizeOf(context).width < 380 ? 44 : 54,
        height: .95,
        fontWeight: FontWeight.w900,
        letterSpacing: -2,
        foreground: Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF4F4F4)],
          ).createShader(const Rect.fromLTWH(0, 0, 500, 90)),
        shadows: const [
          Shadow(
            color: Color(0xFF004DA0),
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
          Shadow(
            color: Color(0xFF004DA0),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class _Rainbow extends StatelessWidget {
  const _Rainbow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 115,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: const [
          _RainbowArc(size: 240, color: Color(0xFFFF5A3A)),
          _RainbowArc(size: 208, color: Color(0xFFFF9B2D)),
          _RainbowArc(size: 176, color: Color(0xFFFFDF39)),
          _RainbowArc(size: 144, color: Color(0xFF62C95C)),
          _RainbowArc(size: 112, color: Color(0xFF5E8FE6)),
          _RainbowArc(size: 80, color: Color(0xFF8B67D8)),
          _RainbowArc(size: 48, color: Color(0xFF77C9EA)),
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size),
          topRight: Radius.circular(size),
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
      width: 270,
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 18,
            child: Container(
              width: 185,
              height: 188,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7F4),
                borderRadius: BorderRadius.circular(105),
                border: Border.all(color: const Color(0xFF24262C), width: 5),
              ),
            ),
          ),
          const Positioned(top: 0, left: 48, child: _Ear()),
          const Positioned(top: 0, right: 48, child: _Ear()),
          const Positioned(top: 78, left: 55, child: _EyePatch()),
          const Positioned(top: 78, right: 55, child: _EyePatch()),
          Positioned(
            top: 125,
            child: Container(
              width: 20,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF14161B),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            top: 145,
            child: Container(
              width: 70,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFF16181E),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 30,
                  height: 13,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7186),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 35,
            child: Container(
              width: 175,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB512),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFFD77A00), width: 4),
              ),
              child: const Center(
                child: Text('●', style: TextStyle(color: Color(0xFF46A936), fontSize: 24)),
              ),
            ),
          ),
          Positioned(
            top: 13,
            child: Container(
              width: 195,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFA900),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(90),
                ),
                border: Border.all(color: const Color(0xFFD77A00), width: 4),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              width: 155,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7F4),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(80),
                ),
                border: Border.all(color: const Color(0xFF24262C), width: 5),
              ),
            ),
          ),
          const Positioned(bottom: 15, left: 26, child: _PandaArm()),
          Positioned(
            right: 4,
            bottom: 58,
            child: Transform.rotate(
              angle: -.55,
              child: const _PandaArm(),
            ),
          ),
          const Positioned(bottom: 0, left: 68, child: _Foot()),
          const Positioned(bottom: 0, right: 68, child: _Foot()),
        ],
      ),
    );
  }
}

class _Ear extends StatelessWidget {
  const _Ear();

  @override
  Widget build(BuildContext context) => Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF24262C),
          shape: BoxShape.circle,
        ),
      );
}

class _EyePatch extends StatelessWidget {
  const _EyePatch();

  @override
  Widget build(BuildContext context) => Container(
        width: 58,
        height: 72,
        decoration: const BoxDecoration(
          color: Color(0xFF25272D),
          borderRadius: BorderRadius.all(Radius.elliptical(40, 50)),
        ),
        child: const Center(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: SizedBox(width: 18, height: 24),
          ),
        ),
      );
}

class _PandaArm extends StatelessWidget {
  const _PandaArm();

  @override
  Widget build(BuildContext context) => Container(
        width: 76,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF22242A),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: const Color(0xFF16181E), width: 4),
        ),
      );
}

class _Foot extends StatelessWidget {
  const _Foot();

  @override
  Widget build(BuildContext context) => Container(
        width: 58,
        height: 38,
        decoration: const BoxDecoration(
          color: Color(0xFF22242A),
          borderRadius: BorderRadius.all(Radius.elliptical(40, 26)),
        ),
      );
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 74,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD84A), Color(0xFFFFA800)],
        ),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: Colors.white.withValues(alpha: .75), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x660D405C),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(38),
          onTap: onTap,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 38),
              SizedBox(width: 8),
              Text(
                'Mulai Bermain',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(color: Color(0x66001D58), blurRadius: 2, offset: Offset(0, 2)),
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

class _Sun extends StatelessWidget {
  const _Sun();

  @override
  Widget build(BuildContext context) => Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD62B),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Color(0x33FFB300), blurRadius: 18)],
        ),
        child: const Center(
          child: Text('☀', style: TextStyle(fontSize: 56, color: Color(0xFFFFB300))),
        ),
      );
}

class _Ground extends StatelessWidget {
  const _Ground();

  @override
  Widget build(BuildContext context) => Container(
        height: 175,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9DE34F), Color(0xFF118A58)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(520, 75)),
        ),
      );
}

class _School extends StatelessWidget {
  const _School();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 110,
        height: 130,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 88,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE06A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFF8A3D), width: 3),
              ),
            ),
            Positioned(
              top: 12,
              child: Container(
                width: 105,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7153),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              child: Icon(Icons.door_front_door_rounded, color: Color(0xFF4A92D6), size: 42),
            ),
          ],
        ),
      );
}

class _Flowers extends StatelessWidget {
  const _Flowers();

  @override
  Widget build(BuildContext context) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🌼', style: TextStyle(fontSize: 30)),
          SizedBox(width: 8),
          Text('🌸', style: TextStyle(fontSize: 28)),
          SizedBox(width: 8),
          Text('🌺', style: TextStyle(fontSize: 30)),
        ],
      );
}

class _Cloud extends StatelessWidget {
  const _Cloud({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: width * .36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .74),
          borderRadius: BorderRadius.circular(width),
        ),
      );
}
