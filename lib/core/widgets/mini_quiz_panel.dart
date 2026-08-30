import 'dart:math';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class MiniQuizQuestion {
  const MiniQuizQuestion({required this.prompt, required this.visual, required this.choices, required this.answer, this.spokenPrompt});
  final String prompt;
  final String visual;
  final List<String> choices;
  final String answer;
  final String? spokenPrompt;
}

class MiniQuizPanel extends StatefulWidget {
  const MiniQuizPanel({super.key, required this.questions, this.totalQuestions = 10});
  final List<MiniQuizQuestion> questions;
  final int totalQuestions;
  $override
  State<MiniQuizPanel> createState() => _MiniQuizPanelState();
}

class _MiniQuizPanelState extends State<MiniQuizPanel> {
  final _audio = AudioService.instance;
  final _random = Random();
  final Set<int> _used = <int>{};
  int _questionNo = 1, _correct = 0, _wrong = 0, _current = 0;
  String? _selected;
  bool _finished = false;
  MiniQuizQuestion get _q => widget.questions[_current];

  $override
  void initState() { super.initState(); _start(); }

  void _start() {
    _questionNo = 1; _correct = 0; _wrong = 0; _selected = null; _finished = false; _used.clear(); _pickQuestion();
  }

  void _pickQuestion() {
    final available = List<int>.generate(widget.questions.length, (i) => i).where((i) => !_used.contains(i)).toList();
    if (available.isEmpty) { _used.clear(); available.addAll(List<int>.generate(widget.questions.length, (i) => i)); }
    _current = available[_random.nextInt(available.length)];
    _used.add(_current);
    _selected = null;
  }

  void _answer(String value) {
    if (_selected != null || _finished) return;
    final correct = value == _q.answer;
    setState(() { _selected = value; if (correct) { _correct++; } else { _wrong++; } });
    correct ? _audio.correct() : _audio.wrong();
    Future.delayed(Duration(milliseconds: correct ? 1500 : 1700), () {
      if (!mounted) return;
      setState(() {
        if (correct) {
          if (_questionNo >= widget.totalQuestions) { _finished = true; } else { _questionNo++; _pickQuestion(); }
        } else { _selected = null; }
      });
    });
  }

  $override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) return const Center(child: Text('Belum ada soal kuis.'));
    return LayoutBuilder(builder: (context, box) {
      final s = (box.maxWidth / 820).clamp(.72, 1.0);
      if (_finished) return _result(s);
      final answered = _selected != null;
      final correct = _selected == _q.answer;
      return Padding(
        padding: EdgeInsets.fromLTRB(14 * s, 8 * s, 14 * s, 12 * s),
        child: Column(children: [
          Expanded(child: Stack(children: [_quizCard(s), if (answered) _feedbackOverlay(correct, s)])),
          SizedBox(height: 8 * s),
          _stats(s),
        ]),
      );
    });
  }

  Widget _quizCard(double s) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(18 * s),
    decoration: _panel(s),
    child: Column(children: [
      _badge(s),
      SizedBox(height: 10 * s),
      Text(_q.prompt, textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF563A91), fontSize: 22 * s, fontWeight: FontWeight.w900)),
      SizedBox(height: 6 * s),
      Expanded(child: Center(child: Container(
        constraints: BoxConstraints(maxWidth: 420 * s),
        padding: EdgeInsets.all(16 * s),
        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFF9D7), Color(0xFFDDEFFC), Color(0xFFBEDCEB)])),
        child: FittedBox(fit: BoxFit.scaleDown, child: Text(_q.visual, textAlign: TextAlign.center, style: TextStyle(fontSize: _q.visual.length > 18 ? 46 * s : 82 * s, height: 1.05, fontWeight: FontWeight.w900, color: const Color(0xFF244B78)))),
      ))),
      _listenButton(s),
      SizedBox(height: 10 * s),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _q.choices.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.05, crossAxisSpacing: 12 * s, mainAxisSpacing: 10 * s),
        itemBuilder: (context, index) {
          final value = _q.choices[index];
          final selected = _selected == value;
          final isCorrect = value == _q.answer;
          final fill = _selected != null && isCorrect ? const Color(0xFFE5F7E9) : selected && !isCorrect ? const Color(0xFFFFECEA) : const Color(0xFFF6F7FC);
          final border = _selected != null && isCorrect ? const Color(0xFF42A95A) : selected && !isCorrect ? const Color(0xFFE45A52) : const Color(0xFFCDD9E8);
          return Material(color: fill, borderRadius: BorderRadius.circular(20 * s), child: InkWell(
            borderRadius: BorderRadius.circular(20 * s),
            onTap: _selected != null ? null : () => _answer(value),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8 * s),
              decoration: BoxDecoration(border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(20 * s)),
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(value, textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF23486F), fontSize: 22 * s, fontWeight: FontWeight.w900))),
            ),
          ));
        },
      ),
    ]),
  );

  Widget _feedbackOverlay(bool correct, double s) {
    final image = correct ? 'assets/images/quiz_correct_dino.jpg' : 'assets/images/quiz_wrong_tiger.jpg';
    final color = correct ? const Color(0xFF58B72D) : const Color(0xFFF15B4D);
    final title = correct ? 'Jawaban Benar!' : 'Jawaban Salah';
    final message = correct ? 'Hebat! Jawabanmu tepat!' : 'Coba lagi ya!\nJawabanmu belum tepat.';
    return Positioned.fill(child: Container(
      padding: EdgeInsets.all(10 * s),
      decoration: BoxDecoration(color: const Color(0xFF10233A).withValues(alpha: .72), borderRadius: BorderRadius.circular(34 * s)),
      child: Container(
        padding: EdgeInsets.fromLTRB(18 * s, 14 * s, 18 * s, 18 * s),
        decoration: BoxDecoration(color: correct ? const Color(0xFFF8FFE9) : const Color(0xFFFFF7F3), borderRadius: BorderRadius.circular(30 * s), border: Border.all(color: color, width: 4 * s), boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 16)]),
        child: Column(children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 24 * s, vertical: 8 * s), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16 * s), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 3))]), child: Text(title, style: TextStyle(color: Colors.white, fontSize: 26 * s, fontWeight: FontWeight.w900))),
          SizedBox(height: 8 * s),
          Text(correct ? 'Hebat!' : 'Coba lagi ya!', style: TextStyle(color: correct ? const Color(0xFF267A23) : const Color(0xFFC93B31), fontSize: 27 * s, fontWeight: FontWeight.w900)),
          Expanded(child: Padding(padding: EdgeInsets.symmetric(vertical: 4 * s), child: Image.asset(image, width: double.infinity, fit: BoxFit.contain, filterQuality: FilterQuality.high, errorBuilder: (_, __, ___) => Icon(correct ? Icons.celebration_rounded : Icons.sentiment_dissatisfied_rounded, size: 150 * s, color: color)))),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: correct ? const Color(0xFF245A26) : const Color(0xFF7B382F), fontSize: 17 * s, height: 1.35, fontWeight: FontWeight.w900)),
        ]),
      ),
    ));
  }

  Widget _result(double s) {
    final stars = _correct >= 9 ? 3 : (_correct >= 6 ? 2 : 1);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(14 * s, 8 * s, 14 * s, 12 * s),
      padding: EdgeInsets.all(22 * s),
      decoration: _panel(s),
      child: SingleChildScrollView(child: Column(children: [
        Text('🎉', style: TextStyle(fontSize: 54 * s)),
        Text('Kuis Selesai!', style: TextStyle(color: const Color(0xFF563A91), fontSize: 30 * s, fontWeight: FontWeight.w900)),
        SizedBox(height: 8 * s),
        Text('Hebat! Kamu sudah menyelesaikan semua soal.', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF42627D), fontSize: 17 * s, fontWeight: FontWeight.w800)),
        SizedBox(height: 14 * s),
        Image.asset('assets/images/quiz_correct_dino.jpg', height: 150 * s, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(Icons.celebration_rounded, size: 120 * s, color: const Color(0xFF2D8B43))),
        SizedBox(height: 10 * s),
        Text('Skor Kamu', style: TextStyle(color: const Color(0xFF42627D), fontSize: 17 * s, fontWeight: FontWeight.w900)),
        Text('${_correct} / ${widget.totalQuestions}', style: TextStyle(color: const Color(0xFF244B78), fontSize: 38 * s, fontWeight: FontWeight.w900)),
        Text(List.filled(stars, '⭐').join(), style: TextStyle(fontSize: 28 * s)),
        SizedBox(height: 14 * s),
        Row(children: [
          Expanded(child: _summary('✓ BENAR', '${_correct}', const Color(0xFF2D8B43), s)),
          SizedBox(width: 8 * s),
          Expanded(child: _summary('↻ SALAH', '${_wrong}', const Color(0xFFC8463D), s)),
          SizedBox(width: 8 * s),
          Expanded(child: _summary('★ SKOR', '${_correct * 50}', const Color(0xFFFFA000), s)),
        ]),
        SizedBox(height: 16 * s),
        _actionButton('MAIN LAGI', Icons.replay_rounded, () => setState(_start), s),
      ])),
    );
  }

  BoxDecoration _panel(double s) => BoxDecoration(color: Colors.white.withValues(alpha: .95), borderRadius: BorderRadius.circular(32 * s), border: Border.all(color: Colors.white, width: 2), boxShadow: const [BoxShadow(color: Color(0x33143F66), blurRadius: 16, offset: Offset(0, 8))]);

  Widget _badge(double s) => Container(padding: EdgeInsets.symmetric(horizontal: 30 * s, vertical: 8 * s), decoration: BoxDecoration(color: const Color(0xFF7651BE), borderRadius: BorderRadius.circular(18 * s)), child: Text('MINI KUIS', style: TextStyle(color: Colors.white, fontSize: 23 * s, fontWeight: FontWeight.w900)));

  Widget _listenButton(double s) => _actionButton('DENGARKAN PERTANYAAN', Icons.volume_up_rounded, () => _audio.speak(_q.spokenPrompt ?? _q.prompt), s);

  Widget _actionButton(String label, IconData icon, VoidCallback onTap, double s) => Material(color: const Color(0xFF2C66B0), borderRadius: BorderRadius.circular(22 * s), elevation: 4, child: InkWell(borderRadius: BorderRadius.circular(22 * s), onTap: onTap, child: SizedBox(width: double.infinity, height: 54 * s, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: 27 * s), SizedBox(width: 8 * s), Text(label, style: TextStyle(color: Colors.white, fontSize: 17 * s, fontWeight: FontWeight.w900))]))));

  Widget _stats(double s) => Row(children: [
    Expanded(child: _stat('SOAL', '${_questionNo} / ${widget.totalQuestions}', s)),
    SizedBox(width: 8 * s),
    Expanded(child: _stat('BENAR', '${_correct}', s)),
    SizedBox(width: 8 * s),
    Expanded(child: _stat('SKOR', '${_correct * 50}', s)),
  ]);

  Widget _stat(String label, String value, double s) => Container(height: 58 * s, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(16 * s), border: Border.all(color: const Color(0xFFD7E4EF))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: TextStyle(color: const Color(0xFF4D6A83), fontSize: 11 * s, fontWeight: FontWeight.w900)), Text(value, style: TextStyle(color: const Color(0xFF25486B), fontSize: 18 * s, fontWeight: FontWeight.w900))]));

  Widget _summary(String label, String value, Color color, double s) => Container(padding: EdgeInsets.symmetric(vertical: 10 * s), decoration: BoxDecoration(color: color.withValues(alpha: .08), borderRadius: BorderRadius.circular(16 * s), border: Border.all(color: color.withValues(alpha: .25))), child: Column(children: [Text(label, style: TextStyle(color: color, fontSize: 11 * s, fontWeight: FontWeight.w900)), SizedBox(height: 3 * s), Text(value, style: TextStyle(color: const Color(0xFF25486B), fontSize: 18 * s, fontWeight: FontWeight.w900))]));
}
