import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/mini_quiz_panel.dart';

class WarnaPage extends StatefulWidget {
  const WarnaPage({super.key});
  @override
  State<WarnaPage> createState() => _WarnaPageState();
}

class _WarnaPageState extends State<WarnaPage> {
  final audio = AudioService.instance;
  final items = const [
    ('Merah', Color(0xFFFF1E2D)), ('Oranye', Color(0xFFFF7919)), ('Kuning', Color(0xFFFFD51E)),
    ('Hijau', Color(0xFF16B53B)), ('Biru', Color(0xFF2377D7)), ('Ungu', Color(0xFF7037CF)),
    ('Pink', Color(0xFFE637A0)), ('Cokelat', Color(0xFF813819)), ('Hitam', Color(0xFF111827)),
    ('Putih', Color(0xFFF9F9F9)), ('Abu-abu', Color(0xFF9AA0AD)), ('Biru Muda', Color(0xFF58C5DE)),
  ];
  int selected = 0;
  int _tab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: KidBackground(
      child: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          final w = box.maxWidth;
          final s = (w / 820).clamp(.72, 1.0);
          return Column(children: [
            _header(w, s),
            Padding(
              padding: EdgeInsets.fromLTRB(w * .05, 0, w * .05, 8),
              child: Row(children: [
                Expanded(child: _tabButton('WARNA', 0, s)),
                SizedBox(width: 8 * s),
                Expanded(child: _tabButton('MINI KUIS', 1, s)),
              ]),
            ),
            Expanded(
              child: _tab == 0
                  ? _lesson(w, s)
                  : MiniQuizPanel(
                      questions: const [
                        MiniQuizQuestion(prompt: 'Warna apakah ini?', visual: '🔴', choices: ['Merah','Biru','Hijau','Kuning'], answer: 'Merah'),
                        MiniQuizQuestion(prompt: 'Pilih warna yang sesuai nama!', visual: 'BIRU', choices: ['🔴','🔵','🟢','🟡'], answer: '🔵'),
                        MiniQuizQuestion(prompt: 'Warna apel yang umum adalah?', visual: '🍎', choices: ['Merah','Biru','Ungu','Hitam'], answer: 'Merah'),
                        MiniQuizQuestion(prompt: 'Pilih benda berwarna kuning!', visual: 'KUNING', choices: ['🍌','🍅','🫐','🍇'], answer: '🍌'),
                        MiniQuizQuestion(prompt: 'Warna apakah ini?', visual: '🟢', choices: ['Hijau','Pink','Oranye','Cokelat'], answer: 'Hijau'),
                        MiniQuizQuestion(prompt: 'Pilih warna langit!', visual: '☁️☀️', choices: ['Biru','Merah','Hitam','Ungu'], answer: 'Biru'),
                        MiniQuizQuestion(prompt: 'Pilih warna yang sesuai nama!', visual: 'UNGU', choices: ['🟣','🟠','🟤','⚪'], answer: '🟣'),
                        MiniQuizQuestion(prompt: 'Warna daun yang umum adalah?', visual: '🍃', choices: ['Hijau','Pink','Abu-abu','Hitam'], answer: 'Hijau'),
                        MiniQuizQuestion(prompt: 'Warna apakah ini?', visual: '🟠', choices: ['Oranye','Kuning','Merah','Cokelat'], answer: 'Oranye'),
                        MiniQuizQuestion(prompt: 'Pilih benda berwarna merah!', visual: 'MERAH', choices: ['🍓','🥝','🫐','🍋'], answer: '🍓'),
                      ],
                      totalQuestions: 10,
                    ),
            ),
          ]);
        }),
      ),
    ),
  );

  Widget _tabButton(String label, int value, double s) {
    final active = _tab == value;
    return Material(
      color: active ? Colors.white.withValues(alpha: .94) : Colors.white.withValues(alpha: .42),
      borderRadius: BorderRadius.circular(18 * s),
      child: InkWell(
        borderRadius: BorderRadius.circular(18 * s),
        onTap: () { setState(() => _tab = value); audio.click(); },
        child: SizedBox(height: 54 * s, child: Center(child: Text(label, style: TextStyle(color: active ? const Color(0xFF244B78) : Colors.white, fontSize: 16 * s, fontWeight: FontWeight.w900)))),
      ),
    );
  }

  Widget _lesson(double w, double s) {
    final current = items[selected];
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(w * .05, 8, w * .05, 24),
      child: Column(children: [
        Container(
          height: w * .47,
          padding: EdgeInsets.all(22 * s),
          decoration: BoxDecoration(color: const Color(0xFFFFF1D9).withValues(alpha: .96), borderRadius: BorderRadius.circular(38 * s), border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 14, offset: Offset(0, 7))]),
          child: Row(children: [
            Expanded(child: Center(child: _paintSplash(current.$2, 150 * s))),
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FittedBox(child: Text(current.$1, style: TextStyle(fontSize: 56 * s, color: current.$1 == 'Putih' ? Colors.black : current.$2, fontWeight: FontWeight.w900))),
              SizedBox(height: 28 * s),
              Material(color: const Color(0xFF29C63E), borderRadius: BorderRadius.circular(28 * s), elevation: 5, child: InkWell(onTap: () => audio.speak(current.$1), borderRadius: BorderRadius.circular(28 * s), child: SizedBox(width: 110 * s, height: 70 * s, child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 42 * s)))),
            ])),
          ]),
        ),
        SizedBox(height: 18 * s),
        Container(
          padding: EdgeInsets.all(18 * s),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .93), borderRadius: BorderRadius.circular(34 * s), boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 12, offset: Offset(0, 6))]),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16 * s, crossAxisSpacing: 16 * s, childAspectRatio: 1.55),
            itemBuilder: (context, i) {
              final item = items[i];
              final dark = item.$1 != 'Kuning' && item.$1 != 'Putih' && item.$1 != 'Biru Muda';
              return Material(color: item.$2, borderRadius: BorderRadius.circular(24 * s), elevation: i == selected ? 8 : 4, child: InkWell(
                onTap: () { setState(() => selected = i); audio.speak(item.$1); },
                borderRadius: BorderRadius.circular(24 * s),
                child: Center(child: FittedBox(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12 * s), child: Text(item.$1, style: TextStyle(fontSize: 28 * s, color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.w900))))),
              ));
            },
          ),
        ),
      ]),
    );
  }

  Widget _header(double w, double s) => SizedBox(height: w * .16, child: Stack(alignment: Alignment.center, children: [
    Positioned(left: 0, child: _round(w * .12, Icons.arrow_back_rounded, () => Navigator.of(context).maybePop())),
    Positioned(right: 0, child: _round(w * .12, Icons.music_note_rounded, () => audio.speak('Belajar Warna. Mengenal Berbagai Warna'))),
    Padding(padding: EdgeInsets.symmetric(horizontal: w * .17), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Belajar Warna', maxLines: 1, style: TextStyle(fontSize: 42 * s, color: const Color(0xFFFFD32F), fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))])),
      Text('Mengenal Berbagai Warna', maxLines: 1, style: TextStyle(fontSize: 22 * s, color: Colors.white, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 2, offset: Offset(1, 2))])),
    ])),
  ]));
  Widget _round(double size, IconData icon, VoidCallback onTap) => Material(color: icon == Icons.music_note_rounded ? const Color(0xFF29C63E) : const Color(0xFFFFC42D), shape: const CircleBorder(), elevation: 6, child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: SizedBox(width: size, height: size, child: Icon(icon, color: Colors.white, size: size * .56))));
  Widget _paintSplash(Color color, double size) => SizedBox(width: size, height: size, child: CustomPaint(painter: _SplashPainter(color)));
}

class _SplashPainter extends CustomPainter {
  final Color color;
  const _SplashPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final path = Path();
    final c = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < 24; i++) {
      final a = i * math.pi / 12;
      final r = i.isEven ? size.width * .46 : size.width * .31;
      final x = c.dx + r * math.cos(a);
      final y = c.dy + r * math.sin(a);
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    path.close();
    canvas.drawPath(path, p);
    canvas.drawCircle(c, size.width * .31, p);
  }
  @override
  bool shouldRepaint(covariant _SplashPainter old) => old.color != color;
}
