import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class HijaiyahPage extends StatefulWidget {
  const HijaiyahPage({super.key});

  @override
  State<HijaiyahPage> createState() => _HijaiyahPageState();
}

class _HijaiyahPageState extends State<HijaiyahPage> with SingleTickerProviderStateMixin {
  final audio = AudioService.instance;
  static const letters = [
    'ا','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص',
    'ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','هـ','و','ي',
  ];
  static const names = [
    'Alif','Ba','Ta','Tsa','Jim','Ha','Kha','Dal','Dzal','Ra','Zai','Sin','Syin','Shad',
    'Dhad','Tha','Zha','Ain','Ghain','Fa','Qaf','Kaf','Lam','Mim','Nun','Ha','Wau','Ya',
  ];
  int index = 0;
  final Random _quizRandom = Random();
  int quizQuestion = 1;
  int quizCorrect = 0;
  int quizScore = 0;
  String? selectedAnswer;
  bool quizAnswered = false;
  late final TabController _tabs;

  @override
  void initState() { super.initState(); _tabs = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  List<int> get _gridOrder {
    final result = <int>[];
    for (var start = 0; start < letters.length; start += 7) {
      final end = start + 7 > letters.length ? letters.length : start + 7;
      for (var i = end - 1; i >= start; i--) {
        result.add(i);
      }
    }
    return result;
  }

  void select(int value) {
    setState(() => index = value);
    audio.speak('Huruf ${names[index]}');
  }

  @override
  Widget build(BuildContext context) {
    final item = letters[index];
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, box) {
              final w = box.maxWidth;
              final s = (w / 820).clamp(.72, 1.0);
              return Column(children: [
                  _header(w, s),
                  TabBar(controller: _tabs, isScrollable: true, tabAlignment: TabAlignment.center, tabs: const [Tab(text: 'HURUF'), Tab(text: 'KUIS MINI')]),
                  Expanded(child: TabBarView(controller: _tabs, children: [
                    SingleChildScrollView(padding: EdgeInsets.fromLTRB(w * .04, 8, w * .04, 24), child: Column(children: [
                  SizedBox(height: 14 * s),
                  Container(
                    height: w * .49,
                    padding: EdgeInsets.all(18 * s),
                    decoration: _panel(const Color(0xFFEEC6F1), s),
                    child: Row(children: [
                      Expanded(child: Container(
                        alignment: Alignment.center,
                        decoration: _card(s),
                        child: _centeredArabic(item, 176 * s, const Color(0xFF8A22C8), FontWeight.w800),
                      )),
                      SizedBox(width: 16 * s),
                      Expanded(child: Container(
                        decoration: _card(s),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SizedBox(
                            height: 78 * s,
                            child: _centeredArabic(item, 72 * s, const Color(0xFF8A22C8), FontWeight.w900),
                          ),
                          SizedBox(height: 8 * s),
                          Text(names[index], style: TextStyle(fontSize: 34 * s, color: const Color(0xFF201B2A), fontWeight: FontWeight.w900)),
                          Text('"${names[index]}"', style: TextStyle(fontSize: 24 * s, color: const Color(0xFF8421B6), fontWeight: FontWeight.w800)),
                          SizedBox(height: 12 * s),
                          _soundButton(() => audio.speak(names[index]), s),
                        ]),
                      )),
                    ]),
                  ),
                  SizedBox(height: 14 * s),
                  Row(children: [
                    _round(w * .13, Icons.chevron_left_rounded, () { setState(() => index = (index - 1 + letters.length) % letters.length); }),
                    Expanded(child: Center(child: _counter('${index + 1} / ${letters.length}', s))),
                    _round(w * .13, Icons.chevron_right_rounded, () { setState(() => index = (index + 1) % letters.length); }),
                  ]),
                  SizedBox(height: 20 * s),
                  Container(
                    padding: EdgeInsets.all(16 * s),
                    decoration: _panel(Colors.white, s),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _gridOrder.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, crossAxisSpacing: 10 * s, mainAxisSpacing: 12 * s, childAspectRatio: .92),
                      itemBuilder: (context, displayIndex) {
                        final i = _gridOrder[displayIndex];
                        final palette = [const Color(0xFFE8B6F4), const Color(0xFFB9DCF5), const Color(0xFFB8F0D6), const Color(0xFFFFD0A5), const Color(0xFFC9C4F6), const Color(0xFFF5C1E5)];
                        return Material(
                          color: i == index ? const Color(0xFFE4A7F2) : palette[displayIndex % palette.length],
                          borderRadius: BorderRadius.circular(22 * s),
                          elevation: i == index ? 7 : 3,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22 * s),
                            onTap: () => select(i),
                            child: _centeredArabic(letters[i], 40 * s, Colors.black, FontWeight.w900),
                          ),
                        );
                      },
                    ),
                  ),
                ])),
                    _quizTab(w, s),
                  ])),
                ]);
            },
          ),
        ),
      ),
    );
  }


  Widget _quizTab(double w, double s) {
    final answer = letters[index];
    final options = <String>{answer, letters[(index + 1) % letters.length], letters[(index + 5) % letters.length], letters[(index + 10) % letters.length]}.toList()
      ..sort((a, b) => a.codeUnitAt(0).compareTo(b.codeUnitAt(0)));
    final visual = _quizVisual(index);
    final scale = w < 430 ? s * .88 : s;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(w * .04, 10 * scale, w * .04, 16 * scale),
      child: Center(child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 720 * scale),
        child: Container(
          padding: EdgeInsets.all(18 * scale), decoration: _quizPanel(scale),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _quizBadge(scale), SizedBox(height: 10 * scale),
            Text('Pilih Jawaban yang Benar!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26 * scale, color: const Color(0xFF493483), fontWeight: FontWeight.w900)),
            SizedBox(height: 2 * scale),
            Text('Huruf apakah ini?', style: TextStyle(fontSize: 18 * scale, color: const Color(0xFF3A4D66), fontWeight: FontWeight.w800)),
            SizedBox(height: 8 * scale),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 142 * scale, height: 142 * scale,
                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFE8E4FB), border: Border.all(color: const Color(0xFFC9C1F4), width: 2.5 * scale), boxShadow: const [BoxShadow(color: Color(0x180D405C), blurRadius: 12, offset: Offset(0, 5))]),
                child: _centeredArabic(answer, 86 * scale, const Color(0xFF6A3BB7), FontWeight.w900)),
              SizedBox(width: 12 * scale),
              Expanded(child: Container(
                constraints: BoxConstraints(maxWidth: 190 * scale), padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 8 * scale),
                decoration: BoxDecoration(color: const Color(0xFFFFF9E9), borderRadius: BorderRadius.circular(24 * scale), border: Border.all(color: const Color(0xFFF2D77B), width: 2)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(visual.emoji, style: TextStyle(fontSize: 54 * scale)), SizedBox(height: 2 * scale),
                  Text('${names[index]} (${answer})', textAlign: TextAlign.center, style: TextStyle(fontSize: 18 * scale, color: const Color(0xFF51388B), fontWeight: FontWeight.w900)),
                  Text('Seperti ${visual.label}', textAlign: TextAlign.center, style: TextStyle(fontSize: 14 * scale, color: const Color(0xFF546276), fontWeight: FontWeight.w700)),
                ]),
              )),
            ]),
            SizedBox(height: 10 * scale), _quizListenButton(scale), SizedBox(height: 12 * scale),
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: options.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12 * scale, mainAxisSpacing: 10 * scale, childAspectRatio: 2.15),
              itemBuilder: (context, optionIndex) {
                final option = options[optionIndex], isSelected = selectedAnswer == option;
                final isCorrect = quizAnswered && option == answer, isWrong = quizAnswered && isSelected && option != answer;
                return Material(color: isCorrect ? const Color(0xFFE7F8E8) : isWrong ? const Color(0xFFFFE8E8) : const Color(0xFFF6F7FC), borderRadius: BorderRadius.circular(22 * scale),
                  child: InkWell(borderRadius: BorderRadius.circular(22 * scale), onTap: quizAnswered ? null : () => _answerQuiz(option, answer),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22 * scale), border: Border.all(color: isCorrect ? const Color(0xFF32A852) : isWrong ? const Color(0xFFE26A6A) : const Color(0xFFC8D0DD), width: isCorrect || isWrong ? 2.5 : 1.8)),
                      child: Stack(alignment: Alignment.center, children: [
                        _centeredArabic(option, 42 * scale, const Color(0xFF233E66), FontWeight.w900),
                        if (isCorrect) const Positioned(right: 10, top: 8, child: Icon(Icons.check_circle_rounded, color: Color(0xFF24A148))),
                      ]),
                    ),
                  ));
              }),
            if (quizAnswered) ...[
              SizedBox(height: 10 * scale),
              Container(width: double.infinity, padding: EdgeInsets.symmetric(vertical: 9 * scale, horizontal: 14 * scale),
                decoration: BoxDecoration(color: selectedAnswer == answer ? const Color(0xFFE8F8E9) : const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(18 * scale)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(selectedAnswer == answer ? Icons.check_circle_rounded : Icons.favorite_rounded, color: selectedAnswer == answer ? const Color(0xFF1E9C43) : const Color(0xFFE25C6A)),
                  const SizedBox(width: 8),
                  Flexible(child: Text(selectedAnswer == answer ? 'Hebat! Jawabanmu Benar! 🎉' : 'Tidak apa-apa, ayo lanjut belajar!', textAlign: TextAlign.center, style: TextStyle(color: selectedAnswer == answer ? const Color(0xFF1F7E3A) : const Color(0xFFB14B59), fontSize: 15 * scale, fontWeight: FontWeight.w900))),
                ])),
            ],
            SizedBox(height: 12 * scale), _nextQuizButton(scale), SizedBox(height: 12 * scale), _quizStats(scale),
          ]),
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    index = _quizRandom.nextInt(letters.length);
  }

  void _answerQuiz(String option, String answer) {
    if (quizAnswered) return;
    setState(() {
      selectedAnswer = option; quizAnswered = true;
      if (option == answer) { quizCorrect++; quizScore += 50; }
    });
    audio.speak(option == answer ? 'Hebat, jawabanmu benar' : 'Belum tepat, ayo belajar lagi');
  }

  void _nextQuiz() => setState(() {
    var nextIndex = _quizRandom.nextInt(letters.length);
    if (letters.length > 1) {
      while (nextIndex == index) {
        nextIndex = _quizRandom.nextInt(letters.length);
      }
    }
    index = nextIndex;
    quizQuestion = quizQuestion == 20 ? 1 : quizQuestion + 1;
    selectedAnswer = null;
    quizAnswered = false;
  });

  _QuizVisual _quizVisual(int value) {
    const visuals = [
      _QuizVisual('🪵', 'tongkat lurus'), _QuizVisual('🦆', 'bebek'), _QuizVisual('🍎', 'apel'), _QuizVisual('🦋', 'kupu-kupu'),
      _QuizVisual('🐪', 'unta'), _QuizVisual('🌙', 'bulan'), _QuizVisual('☁️', 'awan'), _QuizVisual('🚪', 'pintu'),
      _QuizVisual('🌽', 'jagung'), _QuizVisual('🌸', 'bunga'), _QuizVisual('⭐', 'bintang'), _QuizVisual('🐍', 'ular'),
      _QuizVisual('☀️', 'matahari'), _QuizVisual('🐟', 'ikan'), _QuizVisual('🍃', 'daun'), _QuizVisual('🛶', 'perahu'),
      _QuizVisual('🎈', 'balon'), _QuizVisual('👁️', 'mata'), _QuizVisual('☁️', 'awan besar'), _QuizVisual('🔑', 'kunci'),
      _QuizVisual('🌙', 'bulan sabit'), _QuizVisual('✋', 'telapak tangan'), _QuizVisual('🪜', 'tangga'), _QuizVisual('🏔️', 'gunung'),
      _QuizVisual('🌱', 'tunas'), _QuizVisual('💡', 'lampu'), _QuizVisual('🌊', 'ombak'), _QuizVisual('🪝', 'kail'),
    ];
    return visuals[value % visuals.length];
  }

  Widget _quizBadge(double s) => Container(
    padding: EdgeInsets.symmetric(horizontal: 30 * s, vertical: 9 * s),
    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7B4BC1), Color(0xFF4D2797)]), borderRadius: BorderRadius.circular(18 * s), boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 8, offset: Offset(0, 4))]),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('⭐', style: TextStyle(fontSize: 24)), const SizedBox(width: 8),
      Text('MINI KUIS', style: TextStyle(color: Colors.white, fontSize: 23 * s, fontWeight: FontWeight.w900)),
      const SizedBox(width: 8), const Text('⭐', style: TextStyle(fontSize: 24)),
    ]),
  );

  Widget _quizListenButton(double s) => SizedBox(
    width: double.infinity, height: 56 * s,
    child: Material(color: const Color(0xFF2D61B8), borderRadius: BorderRadius.circular(22 * s), elevation: 5,
      child: InkWell(borderRadius: BorderRadius.circular(22 * s), onTap: () => audio.speak('Pilih huruf ${names[index]}'),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.volume_up_rounded, color: Colors.white, size: 30 * s), SizedBox(width: 10 * s),
          Text('DENGARKAN PERTANYAAN', style: TextStyle(color: Colors.white, fontSize: 17 * s, fontWeight: FontWeight.w900)),
        ])),
    ),
  );

  Widget _nextQuizButton(double s) => SizedBox(
    width: double.infinity, height: 58 * s,
    child: Material(color: const Color(0xFF6438B5), borderRadius: BorderRadius.circular(22 * s), elevation: 5,
      child: InkWell(borderRadius: BorderRadius.circular(22 * s), onTap: _nextQuiz,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('SOAL BERIKUTNYA', style: TextStyle(color: Colors.white, fontSize: 19 * s, fontWeight: FontWeight.w900)),
          SizedBox(width: 10 * s), Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 30 * s),
        ])),
    ),
  );

  Widget _quizStats(double s) => Row(children: [
    Expanded(child: _statCard(Icons.assignment_rounded, 'SOAL', '$quizQuestion / 20', const Color(0xFF6B4AC5), s)),
    SizedBox(width: 8 * s), Expanded(child: _statCard(Icons.check_circle_rounded, 'BENAR', '$quizCorrect', const Color(0xFF27A653), s)),
    SizedBox(width: 8 * s), Expanded(child: _statCard(Icons.star_rounded, 'SKOR', '$quizScore', const Color(0xFFFFB319), s)),
  ]);

  Widget _statCard(IconData icon, String title, String value, Color color, double s) => Container(
    padding: EdgeInsets.symmetric(vertical: 9 * s, horizontal: 6 * s),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), borderRadius: BorderRadius.circular(18 * s), border: Border.all(color: color.withValues(alpha: .24), width: 1.5)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 23 * s), SizedBox(height: 2 * s),
      Text(title, style: TextStyle(fontSize: 11 * s, color: const Color(0xFF5A6380), fontWeight: FontWeight.w900)),
      Text(value, style: TextStyle(fontSize: 17 * s, color: const Color(0xFF233E66), fontWeight: FontWeight.w900)),
    ]),
  );

  BoxDecoration _quizPanel(double s) => BoxDecoration(
    color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(34 * s),
    border: Border.all(color: Colors.white.withValues(alpha: .9), width: 3),
    boxShadow: const [BoxShadow(color: Color(0x2B0D405C), blurRadius: 20, offset: Offset(0, 8))],
  );

  Widget _centeredArabic(String value, double fontSize, Color color, FontWeight weight) {
    return Center(
      child: Text(
        value,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        strutStyle: StrutStyle(
          fontSize: fontSize,
          height: 1,
          leading: 0,
          forceStrutHeight: true,
        ),
        style: TextStyle(
          fontSize: fontSize,
          height: 1,
          color: color,
          fontWeight: weight,
        ),
      ),
    );
  }

  Widget _header(double w, double s) => SizedBox(height: w * .16, child: Stack(alignment: Alignment.center, children: [
    Positioned(left: 0, child: _round(w * .12, Icons.arrow_back_rounded, () => Navigator.of(context).maybePop())),
    Positioned(right: 0, child: _round(w * .12, Icons.music_note_rounded, () => audio.speak('Belajar Hijaiyah. Mengenal Huruf Arab'))),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: w * .17),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Belajar Hijaiyah', maxLines: 1, style: TextStyle(fontSize: 40 * s, color: const Color(0xFFFFD32F), fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))])),
        Text('Mengenal Huruf Arab', maxLines: 1, style: TextStyle(fontSize: 23 * s, color: Colors.white, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF17417B), blurRadius: 2, offset: Offset(1, 2))])),
      ]),
    ),
  ]));

  BoxDecoration _panel(Color color, double s) => BoxDecoration(color: color.withValues(alpha: .92), borderRadius: BorderRadius.circular(34 * s), border: Border.all(color: Colors.white.withValues(alpha: .8), width: 3), boxShadow: const [BoxShadow(color: Color(0x330D405C), blurRadius: 14, offset: Offset(0, 7))]);
  BoxDecoration _card(double s) => BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(28 * s), boxShadow: const [BoxShadow(color: Color(0x220D405C), blurRadius: 8, offset: Offset(0, 4))]);
  Widget _round(double size, IconData icon, VoidCallback onTap) => Material(color: icon == Icons.music_note_rounded ? const Color(0xFF29C63E) : const Color(0xFFFFC42D), shape: const CircleBorder(), elevation: 6, child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: SizedBox(width: size, height: size, child: Icon(icon, color: Colors.white, size: size * .56))));
  Widget _soundButton(VoidCallback onTap, double s) => Material(color: const Color(0xFF28C83E), borderRadius: BorderRadius.circular(28 * s), elevation: 5, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(28 * s), child: SizedBox(width: 100 * s, height: 64 * s, child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 39 * s))));
  Widget _counter(String text, double s) => Container(padding: EdgeInsets.symmetric(horizontal: 30 * s, vertical: 15 * s), decoration: BoxDecoration(color: const Color(0xFF174F7E), borderRadius: BorderRadius.circular(28 * s)), child: Text(text, style: TextStyle(color: Colors.white, fontSize: 28 * s, fontWeight: FontWeight.w900)));
}

class _QuizVisual {
  final String emoji;
  final String label;
  const _QuizVisual(this.emoji, this.label);
}
