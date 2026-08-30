import 'dart:math';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class MiniQuizPanel extends StatefulWidget {
  const MiniQuizPanel({
    super.key,
    required this.items,
    this.questionPrefix = 'Manakah yang benar?',
    this.totalQuestions = 10,
  });

  final List<(String emoji, String label)> items;
  final String questionPrefix;
  final int totalQuestions;

  @override
  State<MiniQuizPanel> createState() => _MiniQuizPanelState();
}

class _MiniQuizPanelState extends State<MiniQuizPanel> {
  final _audio = AudioService.instance;
  final _random = Random();
  final Set<int> _usedTargets = <int>{};

  int _target = 0;
  int? _selected;
  int _question = 1;
  int _correct = 0;
  int _wrong = 0;
  bool _finished = false;
  List<int> _choices = const [];

  @override
  void initState() {
    super.initState();
    _startQuiz();
  }

  void _startQuiz() {
    _question = 1;
    _correct = 0;
    _wrong = 0;
    _finished = false;
    _selected = null;
    _usedTargets.clear();
    _prepareQuestion();
  }

  void _prepareQuestion() {
    final available = List<int>.generate(widget.items.length, (i) => i)
        .where((i) => !_usedTargets.contains(i))
        .toList();
    if (available.isEmpty) {
      _usedTargets.clear();
      available.addAll(List<int>.generate(widget.items.length, (i) => i));
    }
    _target = available[_random.nextInt(available.length)];
    _usedTargets.add(_target);
    _selected = null;

    final pool = List<int>.generate(widget.items.length, (i) => i)..shuffle(_random);
    final values = <int>[_target];
    for (final value in pool) {
      if (value != _target && !values.contains(value) && values.length < 4) {
        values.add(value);
      }
    }
    values.shuffle(_random);
    _choices = values;
  }

  void _answer(int value) {
    if (_selected != null || _finished) return;
    final correct = value == _target;
    setState(() {
      _selected = value;
      if (correct) {
        _correct++;
      } else {
        _wrong++;
      }
    });
    correct ? _audio.correct() : _audio.wrong();

    Future.delayed(Duration(milliseconds: correct ? 1200 : 1400), () {
      if (!mounted) return;
      setState(() {
        if (correct) {
          if (_question >= widget.totalQuestions) {
            _finished = true;
          } else {
            _question++;
            _prepareQuestion();
          }
        } else {
          _selected = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: Text('Belum ada soal kuis.'));
    }

    return LayoutBuilder(builder: (context, box) {
      final s = (box.maxWidth / 820).clamp(.72, 1.0);
      if (_finished) return _resultPage(s);

      final target = widget.items[_target];
      final answered = _selected != null;
      final correct = _selected == _target;

      return Padding(
        padding: EdgeInsets.fromLTRB(14 * s, 8 * s, 14 * s, 12 * s),
        child: Column(children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(18 * s),
              decoration: _panel(s),
              child: Column(children: [
                _badge(s),
                SizedBox(height: 8 * s),
                Text('Pilih Jawaban yang Benar!', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF563A91), fontSize: 24 * s, fontWeight: FontWeight.w900)),
                Text(widget.questionPrefix, textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF42627D), fontSize: 17 * s, fontWeight: FontWeight.w800)),
                Expanded(
                  child: Stack(alignment: Alignment.center, children: [
                    Container(width: 170 * s, height: 170 * s, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFF9F5D5), Color(0xFFD5E8F5), Color(0xFFB9D8EC)]))),
                    Text(target.$1, style: TextStyle(fontSize: 100 * s)),
                  ]),
                ),
                _button('DENGARKAN PERTANYAAN', Icons.play_arrow_rounded, const Color(0xFF2767C6), () => _audio.speak(widget.questionPrefix), s),
                SizedBox(height: 10 * s),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _choices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.1, crossAxisSpacing: 12 * s, mainAxisSpacing: 10 * s),
                  itemBuilder: (context, i) {
                    final value = _choices[i];
                    final selected = _selected == value;
                    final isCorrect = value == _target;
                    final fill = answered && isCorrect ? const Color(0xFFE5F7E9) : selected && !isCorrect ? const Color(0xFFFFECEA) : const Color(0xFFF6F7FC);
                    final border = answered && isCorrect ? const Color(0xFF42A95A) : selected && !isCorrect ? const Color(0xFFE45A52) : const Color(0xFFCDD9E8);
                    return Material(
                      color: fill,
                      borderRadius: BorderRadius.circular(20 * s),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20 * s),
                        onTap: answered ? null : () => _answer(value),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(20 * s)),
                          child: Text(widget.items[value].$2, textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF23486F), fontSize: 22 * s, fontWeight: FontWeight.w900)),
                        ),
                      ),
                    );
                  },
                ),
                if (answered) ...[
                  SizedBox(height: 10 * s),
                  _feedbackCard(correct, s),
                ],
              ]),
            ),
          ),
          SizedBox(height: 8 * s),
          _stats(s),
        ]),
      );
    });
  }

  Widget _feedbackCard(bool correct, double s) {
    final image = correct ? 'assets/images/quiz_correct_dino.jpg' : 'assets/images/quiz_wrong_tiger.jpg';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
      decoration: BoxDecoration(
        color: correct ? const Color(0xFFEAF8ED) : const Color(0xFFFFF0EE),
        borderRadius: BorderRadius.circular(18 * s),
        border: Border.all(color: correct ? const Color(0xFF8ED39B) : const Color(0xFFE89A93), width: 2),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16 * s),
          child: Image.asset(
            image,
            width: 82 * s,
            height: 82 * s,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 82 * s,
              height: 82 * s,
              alignment: Alignment.center,
              color: correct ? const Color(0xFFDFF5E3) : const Color(0xFFFFE0DD),
              child: Icon(correct ? Icons.celebration_rounded : Icons.sentiment_dissatisfied_rounded, size: 46 * s, color: correct ? const Color(0xFF2D8B43) : const Color(0xFFC8463D)),
            ),
          ),
        ),
        SizedBox(width: 12 * s),
        Expanded(child: Text(correct ? 'Hebat! Jawabanmu Benar! 🎉' : 'Belum tepat. Coba lagi ya! 💪', style: TextStyle(color: correct ? const Color(0xFF2D8B43) : const Color(0xFFC8463D), fontSize: 16 * s, fontWeight: FontWeight.w900))),
      ]),
    );
  }

  Widget _resultPage(double s) {
    final stars = _correct >= 9 ? 3 : (_correct >= 6 ? 2 : 1);
    return Padding(
      padding: EdgeInsets.fromLTRB(14 * s, 8 * s, 14 * s, 12 * s),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(22 * s),
        decoration: _panel(s),
        child: SingleChildScrollView(
          child: Column(children: [
            Text('🎉', style: TextStyle(fontSize: 52 * s)),
            Text('Kuis Selesai!', style: TextStyle(color: const Color(0xFF563A91), fontSize: 30 * s, fontWeight: FontWeight.w900)),
            SizedBox(height: 8 * s),
            Text('Hebat! Kamu sudah menyelesaikan semua soal.', textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF42627D), fontSize: 17 * s, fontWeight: FontWeight.w800)),
            SizedBox(height: 14 * s),
            ClipRRect(
              borderRadius: BorderRadius.circular(28 * s),
              child: Image.asset('assets/images/quiz_correct_dino.jpg', width: 150 * s, height: 150 * s, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.celebration_rounded, size: 120 * s, color: const Color(0xFF2D8B43))),
            ),
            SizedBox(height: 14 * s),
            Text('Skor Kamu', style: TextStyle(color: const Color(0xFF42627D), fontSize: 17 * s, fontWeight: FontWeight.w900)),
            Text('${_correct} / ${widget.totalQuestions}', style: TextStyle(color: const Color(0xFF244B78), fontSize: 38 * s, fontWeight: FontWeight.w900)),
            SizedBox(height: 6 * s),
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
            _button('MAIN LAGI', Icons.replay_rounded, const Color(0xFF2767C6), () => setState(_startQuiz), s),
          ]),
        ),
      ),
    );
  }

  BoxDecoration _panel(double s) => BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(32 * s), border: Border.all(color: Colors.white, width: 2), boxShadow: const [BoxShadow(color: Color(0x33143F66), blurRadius: 16, offset: Offset(0, 8))]);

  Widget _badge(double s) => Container(
    padding: EdgeInsets.symmetric(horizontal: 34 * s, vertical: 8 * s),
    decoration: BoxDecoration(color: const Color(0xFF7651BE), borderRadius: BorderRadius.circular(18 * s)),
    child: Text('MINI KUIS', style: TextStyle(color: Colors.white, fontSize: 24 * s, fontWeight: FontWeight.w900)),
  );

  Widget _button(String label, IconData icon, Color color, VoidCallback onTap, double s) => Material(
    color: color,
    borderRadius: BorderRadius.circular(22 * s),
    elevation: 4,
    child: InkWell(
      borderRadius: BorderRadius.circular(22 * s),
      onTap: onTap,
      child: SizedBox(width: double.infinity, height: 54 * s, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: 27 * s), SizedBox(width: 8 * s), Text(label, style: TextStyle(color: Colors.white, fontSize: 17 * s, fontWeight: FontWeight.w900))])),
    ),
  );

  Widget _stats(double s) => Row(children: [
    Expanded(child: _stat('SOAL', '${_question} / ${widget.totalQuestions}', s)),
    SizedBox(width: 8 * s),
    Expanded(child: _stat('BENAR', '${_correct}', s)),
    SizedBox(width: 8 * s),
    Expanded(child: _stat('SKOR', '${_correct * 50}', s)),
  ]);

  Widget _stat(String label, String value, double s) => Container(
    height: 58 * s,
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(16 * s), border: Border.all(color: const Color(0xFFD7E4EF))),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(label, style: TextStyle(color: const Color(0xFF4D6A83), fontSize: 11 * s, fontWeight: FontWeight.w900)),
      Text(value, style: TextStyle(color: const Color(0xFF25486B), fontSize: 18 * s, fontWeight: FontWeight.w900)),
    ]),
  );

  Widget _summary(String label, String value, Color color, double s) => Container(
    padding: EdgeInsets.symmetric(vertical: 10 * s),
    decoration: BoxDecoration(color: color.withValues(alpha: .08), borderRadius: BorderRadius.circular(16 * s), border: Border.all(color: color.withValues(alpha: .25))),
    child: Column(children: [
      Text(label, style: TextStyle(color: color, fontSize: 11 * s, fontWeight: FontWeight.w900)),
      SizedBox(height: 3 * s),
      Text(value, style: TextStyle(color: const Color(0xFF25486B), fontSize: 18 * s, fontWeight: FontWeight.w900)),
    ]),
  );
}
