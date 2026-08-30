import 'package:flutter/material.dart';

import '../../services/background_music.dart';
import '../home/home_page.dart';

class PlayIntroPage extends StatelessWidget {
  const PlayIntroPage({super.key});

  void _openMenu(BuildContext context) {
    BackgroundMusic.instance.start();
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
              Color(0xFF1595D7),
              Color(0xFF74CAE8),
              Color(0xFFBDE2C7),
            ],
            stops: [0, .58, 1],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 690;
              return Stack(
                fit: StackFit.expand,
                children: [
                  const _SkyDecoration(),
                  Positioned(
                    top: 14,
                    right: 16,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: BackgroundMusic.instance.enabled,
                      builder: (context, musicOn, _) => Material(
                        color: musicOn
                            ? const Color(0xFF2DBB45)
                            : const Color(0xFF7C8796),
                        shape: const CircleBorder(),
                        elevation: 6,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            BackgroundMusic.instance.toggle();
                            if (BackgroundMusic.instance.enabled.value) {
                              BackgroundMusic.instance.start();
                            }
                          },
                          child: SizedBox(
                            width: 62,
                            height: 62,
                            child: Icon(
                              musicOn
                                  ? Icons.music_note_rounded
                                  : Icons.music_off_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        compact ? 8 : 18,
                        16,
                        compact ? 12 : 22,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _RainbowLogo(compact: compact),
                            const SizedBox(height: 4),
                            const Text(
                              'Ayo Bermain & Belajar Bersama!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7A2500),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    color: Color(0x55FFFFFF),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compact ? 8 : 14),
                            const _PandaHero(),
                            SizedBox(height: compact ? 8 : 16),
                            _PlayButton(onTap: () => _openMenu(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RainbowLogo extends StatelessWidget {
  const _RainbowLogo({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 560.0);
    final titleSize = width < 390 ? 48.0 : 64.0;

    return SizedBox(
      width: width,
      height: compact ? 170 : 205,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: CustomPaint(
              size: Size(width * .72, compact ? 125 : 150),
              painter: _RainbowPainter(),
            ),
          ),
          Positioned(
            top: compact ? 62 : 76,
            child: Column(
              children: [
                Text(
                  'BELAJAR TK',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    height: .82,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -2.8,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFE7EDF8),
                        ],
                      ).createShader(const Rect.fromLTWH(0, 0, 500, 100)),
                    shadows: const [
                      Shadow(
                        color: Color(0xFF00479B),
                        blurRadius: 0,
                        offset: Offset(5, 5),
                      ),
                      Shadow(
                        color: Color(0xFF00479B),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFE05C),
                        Color(0xFFFFB81C),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFFF9A00),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33004C8F),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Ayo Bermain & Belajar Bersama!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8B2A00),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RainbowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final colors = <Color>[
      const Color(0xFFFF5A3A),
      const Color(0xFFFF8A24),
      const Color(0xFFFFD83D),
      const Color(0xFF58C964),
      const Color(0xFF48A4E8),
      const Color(0xFF8067D9),
    ];

    var radius = size.width * .48;
    for (final color in colors) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .055
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        3.141592653589793,
        3.141592653589793,
        false,
        paint,
      );
      radius -= size.width * .055;
    }
  }

  @override
  bool shouldRepaint(covariant _RainbowPainter oldDelegate) => false;
}

class _SkyDecoration extends StatelessWidget {
  const _SkyDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(left: -42, top: 42, child: _Cloud(width: 205)),
        const Positioned(right: -52, top: 150, child: _Cloud(width: 170)),
        const Positioned(right: 24, top: 20, child: _HappySun()),
        const Positioned(left: 58, top: 118, child: Text('🦋', style: TextStyle(fontSize: 39))),
        const Positioned(right: 42, top: 270, child: Text('🦋', style: TextStyle(fontSize: 36))),
        const Positioned(left: 145, top: 34, child: Text('⌁', style: TextStyle(fontSize: 38, color: Color(0x99FFFFFF)))),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _Landscape(),
        ),
      ],
    );
  }
}

class _HappySun extends StatelessWidget {
  const _HappySun();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 108,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
            8,
            (index) => Transform.rotate(
              angle: index * 3.141592653589793 / 4,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 13,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC91E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD62B),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('😊', style: TextStyle(fontSize: 42)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Landscape extends StatelessWidget {
  const _Landscape();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 118,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9DE64B), Color(0xFF3AAE45)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(700, 85),
              ),
            ),
          ),
          const Positioned(left: 16, bottom: 30, child: _Flower('🌺', 46)),
          const Positioned(left: 86, bottom: 16, child: _Flower('🌼', 38)),
          const Positioned(right: 18, bottom: 28, child: _Flower('🌸', 42)),
          const Positioned(right: 100, bottom: 10, child: _Flower('🌻', 36)),
          const Positioned(right: 38, bottom: 72, child: _School()),
          const Positioned(left: -26, bottom: 48, child: _Bush(width: 120)),
          const Positioned(right: -32, bottom: 42, child: _Bush(width: 150)),
        ],
      ),
    );
  }
}

class _Bush extends StatelessWidget {
  const _Bush({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * .48,
      decoration: BoxDecoration(
        color: const Color(0xFF07885E),
        borderRadius: BorderRadius.circular(width),
      ),
    );
  }
}

class _Flower extends StatelessWidget {
  const _Flower(this.emoji, this.size);

  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
        emoji,
        style: TextStyle(fontSize: size),
      );
}

class _School extends StatelessWidget {
  const _School();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 138,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 90,
            height: 82,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE46B),
              border: Border.all(
                color: const Color(0xFFFF8B38),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Positioned(
            top: 15,
            child: CustomPaint(
              size: const Size(116, 65),
              painter: _RoofPainter(),
            ),
          ),
          const Positioned(
            bottom: 0,
            child: Icon(
              Icons.door_front_door_rounded,
              size: 43,
              color: Color(0xFF3F94D8),
            ),
          ),
          const Positioned(
            left: 27,
            bottom: 37,
            child: Icon(Icons.window_rounded, color: Color(0xFF3F94D8), size: 19),
          ),
          const Positioned(
            right: 27,
            bottom: 37,
            child: Icon(Icons.window_rounded, color: Color(0xFF3F94D8), size: 19),
          ),
        ],
      ),
    );
  }
}

class _RoofPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFF6951);
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawRect(
      Rect.fromLTWH(size.width * .73, 8, 3, 28),
      Paint()..color = const Color(0xFF8B552C),
    );
  }

  @override
  bool shouldRepaint(covariant _RoofPainter oldDelegate) => false;
}

class _PandaHero extends StatelessWidget {
  const _PandaHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 315,
      height: 350,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 30,
            child: Container(
              width: 218,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F8F4),
                border: Border.all(
                  color: const Color(0xFF20242B),
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(118),
              ),
            ),
          ),
          const Positioned(top: 0, left: 52, child: _Ear()),
          const Positioned(top: 0, right: 52, child: _Ear()),
          Positioned(
            top: 44,
            child: Container(
              width: 205,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFFFA800),
                border: Border.all(
                  color: const Color(0xFFD87800),
                  width: 4,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(110),
                ),
              ),
            ),
          ),
          Positioned(
            top: 72,
            child: Container(
              width: 190,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB51A),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(60),
                ),
              ),
            ),
          ),
          const Positioned(top: 118, left: 64, child: _EyePatch()),
          const Positioned(top: 118, right: 64, child: _EyePatch()),
          Positioned(
            top: 176,
            child: Container(
              width: 23,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFF15181D),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            top: 198,
            child: Container(
              width: 78,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF171A20),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(44),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 35,
                  height: 14,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6C7B),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            child: Container(
              width: 182,
              height: 132,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F8F4),
                border: Border.all(
                  color: const Color(0xFF20242B),
                  width: 5,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(92),
                ),
              ),
            ),
          ),
          const Positioned(bottom: 30, left: 34, child: _PandaArm()),
          Positioned(
            right: 7,
            bottom: 86,
            child: Transform.rotate(
              angle: -.62,
              child: const _PandaArm(waving: true),
            ),
          ),
          const Positioned(bottom: 8, left: 83, child: _Foot()),
          const Positioned(bottom: 8, right: 83, child: _Foot()),
          Positioned(
            top: 50,
            child: const Text(
              '🌱',
              style: TextStyle(fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ear extends StatelessWidget {
  const _Ear();

  @override
  Widget build(BuildContext context) => Container(
        width: 74,
        height: 74,
        decoration: const BoxDecoration(
          color: Color(0xFF20242B),
          shape: BoxShape.circle,
        ),
      );
}

class _EyePatch extends StatelessWidget {
  const _EyePatch();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: .18,
      child: Container(
        width: 63,
        height: 78,
        decoration: const BoxDecoration(
          color: Color(0xFF20242B),
          borderRadius: BorderRadius.all(
            Radius.elliptical(42, 54),
          ),
        ),
        child: const Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 22, height: 28),
          ),
        ),
      ),
    );
  }
}

class _PandaArm extends StatelessWidget {
  const _PandaArm({this.waving = false});

  final bool waving;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: waving ? 118 : 126,
      decoration: BoxDecoration(
        color: const Color(0xFF20242B),
        borderRadius: BorderRadius.circular(62),
        border: Border.all(
          color: const Color(0xFF15181D),
          width: 4,
        ),
      ),
    );
  }
}

class _Foot extends StatelessWidget {
  const _Foot();

  @override
  Widget build(BuildContext context) => Container(
        width: 64,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF20242B),
          borderRadius: BorderRadius.all(
            Radius.elliptical(44, 28),
          ),
        ),
      );
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 285,
      height: 78,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFDE4C),
            Color(0xFFFFA500),
          ],
        ),
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: const Color(0xFFFFF1A3),
          width: 4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x770E6D4C),
            blurRadius: 10,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(42),
          onTap: onTap,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 43,
                shadows: [
                  Shadow(
                    color: Color(0xFF9B3D00),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              SizedBox(width: 9),
              Text(
                'Mulai Bermain',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: Color(0xFF8C3000),
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
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

class _Cloud extends StatelessWidget {
  const _Cloud({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * .48,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: width,
            height: width * .25,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .8),
              borderRadius: BorderRadius.circular(width),
            ),
          ),
          Positioned(
            left: width * .15,
            bottom: width * .08,
            child: Container(
              width: width * .32,
              height: width * .32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: width * .18,
            bottom: width * .05,
            child: Container(
              width: width * .4,
              height: width * .4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
