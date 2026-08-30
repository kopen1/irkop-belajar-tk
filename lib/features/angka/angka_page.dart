import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/mini_quiz_panel.dart';

class AngkaPage extends StatefulWidget {
  const AngkaPage({super.key});
  @override
  State<AngkaPage> createState() => _AngkaPageState();
}

class _AngkaPageState extends State<AngkaPage> with SingleTickerProviderStateMixin {
  final audio = AudioService.instance;
  late final TabController _tabs;
  int _index = 0, _score = 0, _correct = 0;
  int? _selected;

  static const _arab = ['١','٢','٣','٤','٥','٦','٧','٨','٩','١٠'];
  static const _words = ['Satu','Dua','Tiga','Empat','Lima','Enam','Tujuh','Delapan','Sembilan','Sepuluh'];
  static const _emoji = ['✏️','🐍','🐦','🪑','🤡','🐍','🦯','🥜','🎈','🪄⚽'];
  static const _analogy = ['Seperti pensil atau lilin','Seperti ular yang meliuk','Seperti burung terbang','Seperti kursi terbalik','Seperti badut','Seperti ular','Seperti tongkat nenek','Seperti kacang','Seperti balon terbang','Seperti lidi dan bola'];
  int get number => _index + 1;

  @override
  void initState() { super.initState(); _tabs = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  void _pick(int i) { setState(() => _index = i); audio.speak('Angka ' + (i + 1).toString() + '. ' + _words[i]); }
  void _prev() { setState(() => _index = (_index + 9) % 10); }
  void _next() { setState(() { _index = (_index + 1) % 10; _selected = null; }); }

  void _answerQuiz(int value, int target) {
    if (_selected != null) return;
    final correct = value == target;
    setState(() {
      _selected = value;
      if (correct) { _correct++; _score++; }
    });
    correct ? audio.correct() : audio.wrong();
    Future.delayed(Duration(milliseconds: correct ? 1100 : 900), () {
      if (!mounted) return;
      setState(() => _selected = null);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: KidBackground(
      child: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          final compact = box.maxWidth < 430 || box.maxHeight < 780;
          return Column(children: [
            _header(compact),
            _tabBar(compact),
            Expanded(child: TabBarView(controller: _tabs, children: [
              _learn(false),
              _learn(true),
              _quiz(),
            ])),
          ]);
        }),
      ),
    ),
  );

  Widget _header(bool compact) {
    final side = compact ? 58.0 : 70.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(18, compact ? 8 : 14, 18, 8),
      child: SizedBox(height: compact ? 94 : 110, child: Stack(alignment: Alignment.center, children: [
        Positioned(left: 0, child: _circle(side, const Color(0xFFFFC12B), Icons.arrow_back_rounded, () => Navigator.of(context).maybePop())),
        Positioned(right: 0, child: _circle(side, const Color(0xFF2BC33A), Icons.volume_up_rounded, () => audio.speak('Dunia Angka. Belajar angka sambil bermain.'))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: side + 18),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FittedBox(child: Text('Dunia Angka', style: TextStyle(fontSize: compact ? 38 : 46, fontWeight: FontWeight.w900, color: const Color(0xFFFFD332), shadows: const [Shadow(color: Color(0xFF174B83), offset: Offset(2,3), blurRadius: 2)]))),
            const SizedBox(height: 3),
            FittedBox(child: Text('Belajar angka sambil bermain', style: TextStyle(fontSize: compact ? 18 : 22, fontWeight: FontWeight.w900, color: Colors.white, shadows: const [Shadow(color: Color(0xFF285276), offset: Offset(1,2), blurRadius: 2)]))),
          ]),
        ),
      ])),
    );
  }

  Widget _tabBar(bool compact) => SizedBox(
    height: compact ? 62 : 70,
    child: TabBar(
      controller: _tabs,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x220D3E67), blurRadius: 8, offset: Offset(0,4))]),
      labelColor: const Color(0xFF244B78),
      unselectedLabelColor: Colors.white.withValues(alpha: .82),
      labelStyle: TextStyle(fontSize: compact ? 15 : 18, fontWeight: FontWeight.w900),
      unselectedLabelStyle: TextStyle(fontSize: compact ? 15 : 18, fontWeight: FontWeight.w900),
      tabs: const [Tab(text: 'ANGKA ID'), Tab(text: 'ANGKA ARAB'), Tab(text: 'KUIS MINI')],
    ),
  );

  Widget _learn(bool arabic) => LayoutBuilder(builder: (context, box) {
    final s = min(1.0, max(.68, box.maxHeight / 760));
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
      child: Column(children: [
        Expanded(flex: 8, child: _lessonCard(arabic, s)),
        SizedBox(height: 10 * s),
        Row(children: [
          Expanded(child: _nav('←  SEBELUMNYA', _prev, s)),
          SizedBox(width: 10 * s),
          Container(width: 110 * s, height: 56 * s, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFF1E4C82), borderRadius: BorderRadius.circular(20 * s)), child: Text((_index + 1).toString() + ' / 10', style: TextStyle(color: Colors.white, fontSize: 19 * s, fontWeight: FontWeight.w900))),
          SizedBox(width: 10 * s),
          Expanded(child: _nav('SELANJUTNYA  →', _next, s)),
        ]),
        SizedBox(height: 10 * s),
        Expanded(flex: 1, child: _numberStrip(arabic, s)),
      ]),
    );
  });

  Widget _lessonCard(bool arabic, double s) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(16 * s),
    decoration: _panel(),
    child: Column(children: [
      Expanded(
        child: Stack(alignment: Alignment.center, children: [
          Container(width: 245 * s, height: 245 * s, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFDF3C6), Color(0xFFD5E8F5), Color(0xFFB4D5EA)]))),
          Positioned(top: 14 * s, child: Text('✦', style: TextStyle(fontSize: 30 * s, color: const Color(0xFFFFC72E)))),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(arabic ? _arab[_index] : number.toString(), style: TextStyle(height: .85, fontSize: 185 * s, fontWeight: FontWeight.w900, color: const Color(0xFFFFB20F), shadows: const [Shadow(color: Color(0x55364A5D), blurRadius: 2, offset: Offset(2,4))])),
            Transform.translate(
              offset: Offset(0, -4 * s),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 42 * s, vertical: 8 * s),
                decoration: BoxDecoration(color: const Color(0xFF7DA8DF), borderRadius: BorderRadius.circular(12 * s), boxShadow: const [BoxShadow(color: Color(0x33204E87), blurRadius: 6, offset: Offset(0,3))]),
                child: Text(_words[_index], style: TextStyle(fontSize: 31 * s, color: Colors.white, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Color(0xFF244B78), offset: Offset(1,2), blurRadius: 1)])),
              ),
            ),
          ]),
        ]),
      ),
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 12 * s),
        decoration: BoxDecoration(color: const Color(0xFFF8FBFF), border: Border.all(color: const Color(0xFFC4DCEF), width: 2), borderRadius: BorderRadius.circular(20 * s)),
        child: Row(children: [
          Text(_emoji[_index], style: TextStyle(fontSize: 48 * s)),
          SizedBox(width: 10 * s),
          Expanded(child: Text(_analogy[_index], textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF2F4F72), fontSize: 19 * s, fontWeight: FontWeight.w900))),
        ]),
      ),
      SizedBox(height: 10 * s),
      _button('DENGARKAN', Icons.volume_up_rounded, const Color(0xFF24B92D), () => audio.speak('Angka ' + number.toString() + '. ' + _words[_index] + '. ' + _analogy[_index]), s),
    ]),
  );

  Widget _quiz() => MiniQuizPanel(
    items: const [
      ('1', '1'), ('2', '2'), ('3', '3'), ('4', '4'), ('5', '5'),
      ('6', '6'), ('7', '7'), ('8', '8'), ('9', '9'), ('10', '10'),
    ],
    questionPrefix: 'Angka manakah ini?',
    totalQuestions: 10,
  ););

  BoxDecoration _panel() => BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white, width: 2), boxShadow: const [BoxShadow(color: Color(0x33143F66), blurRadius: 16, offset: Offset(0,8))]);

  Widget _button(String label, IconData icon, Color color, VoidCallback onTap, double s) => Material(
    color: color, borderRadius: BorderRadius.circular(22 * s), elevation: 4,
    child: InkWell(borderRadius: BorderRadius.circular(22 * s), onTap: onTap, child: SizedBox(width: double.infinity, height: 56 * s, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: Colors.white, size: 28 * s), SizedBox(width: 9 * s),
      Text(label, style: TextStyle(color: Colors.white, fontSize: 18 * s, fontWeight: FontWeight.w900)),
    ]))),
  );

  Widget _nav(String label, VoidCallback onTap, double s) => Material(
    color: const Color(0xFF2C63A0), borderRadius: BorderRadius.circular(20 * s), elevation: 4,
    child: InkWell(borderRadius: BorderRadius.circular(20 * s), onTap: onTap, child: SizedBox(height: 56 * s, child: Center(child: FittedBox(child: Text(label, style: TextStyle(color: Colors.white, fontSize: 14 * s, fontWeight: FontWeight.w900)))))),
  );

  // Strip angka 1–10 dapat digeser ke samping agar angka 6–10 tetap mudah dipilih.
  Widget _numberStrip(bool arabic, double s) => LayoutBuilder(
    builder: (context, box) => ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 2 * s),
      itemCount: 10,
      separatorBuilder: (_, __) => SizedBox(width: 8 * s),
      itemBuilder: (context, i) => SizedBox(
        width: min(box.maxWidth * .22, 72 * s),
        child: Material(
          color: i == _index ? const Color(0xFFFFD149) : Colors.white.withValues(alpha: .92),
          borderRadius: BorderRadius.circular(16 * s),
          elevation: i == _index ? 5 : 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(16 * s),
            onTap: () => _pick(i),
            child: Center(
              child: Text(
                arabic ? _arab[i] : (i + 1).toString(),
                style: TextStyle(
                  color: const Color(0xFF25486B),
                  fontSize: 26 * s,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _stat(String icon, String label, String value, double s) => Container(
    height: 64 * s,
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(16 * s), border: Border.all(color: const Color(0xFFD7E4EF))),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(icon, style: TextStyle(fontSize: 22 * s)), SizedBox(width: 5 * s),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label, style: TextStyle(color: const Color(0xFF4D6A83), fontSize: 10 * s, fontWeight: FontWeight.w900)),
        Text(value, style: TextStyle(color: const Color(0xFF25486B), fontSize: 17 * s, fontWeight: FontWeight.w900)),
      ]),
    ]),
  );

  Widget _circle(double size, Color color, IconData icon, VoidCallback onTap) => Material(
    color: color, shape: const CircleBorder(), elevation: 7, shadowColor: const Color(0x550D3E67),
    child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: SizedBox(width: size, height: size, child: Icon(icon, color: Colors.white, size: size * .52))),
  );
}
