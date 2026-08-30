import 'dart:math';

import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class MiniQuizPanel extends StatefulWidget {
  const MiniQuizPanel({
    super.key,
    required this.items,
    this.questionPrefix = 'Manakah yang benar?',
  });

  final List<(String emoji, String label)> items;
  final String questionPrefix;

  @override
  State<MiniQuizPanel> createState() => _MiniQuizPanelState();
}

class _MiniQuizPanelState extends State<MiniQuizPanel> {
  final _audio = AudioService.instance;
  final _random = Random();
  int _target = 0;
  int? _selected;
  int _question = 1;
  int _correct = 0;
  List<int> _currentChoices = const [];

  @override
  void initState() {
    super.initState();
    _target = _random.nextInt(widget.items.length);
    _buildChoices();
  }

  void _next() {
    setState(() {
      var next = _random.nextInt(widget.items.length);
      if (widget.items.length > 1) {
        while (next == _target) {
          next = _random.nextInt(widget.items.length);
        }
      }
      _target = next;
      _selected = null;
      _question++;
      _buildChoices();
    });
  }

  void _buildChoices() {
    final pool = List<int>.generate(widget.items.length, (i) => i)..shuffle(_random);
    final values = <int>[_target];
    for (final i in pool) {
      if (i != _target && values.length < 4) values.add(i);
    }
    values.shuffle(_random);
    _currentChoices = values;
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.items[_target];
    final choices = _currentChoices;
    return LayoutBuilder(
      builder: (context, box) {
        final s = (box.maxWidth / 820).clamp(.72, 1.0);
        final answered = _selected != null;
        final correct = _selected == _target;
        return Padding(
          padding: EdgeInsets.fromLTRB(14 * s, 8 * s, 14 * s, 12 * s),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18 * s),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .94),
                    borderRadius: BorderRadius.circular(32 * s),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [BoxShadow(color: Color(0x33143F66), blurRadius: 16, offset: Offset(0, 8))],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 34 * s, vertical: 8 * s),
                        decoration: BoxDecoration(color: const Color(0xFF7651BE), borderRadius: BorderRadius.circular(18 * s)),
                        child: Text('MINI KUIS', style: TextStyle(color: Colors.white, fontSize: 24 * s, fontWeight: FontWeight.w900)),
                      ),
                      SizedBox(height: 8 * s),
                      Text('Pilih Jawaban yang Benar!', style: TextStyle(color: const Color(0xFF563A91), fontSize: 24 * s, fontWeight: FontWeight.w900)),
                      Text(widget.questionPrefix, style: TextStyle(color: const Color(0xFF42627D), fontSize: 17 * s, fontWeight: FontWeight.w800)),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(width: 170 * s, height: 170 * s, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFF9F5D5), Color(0xFFD5E8F5), Color(0xFFB9D8EC)]))),
                            Text(target.$1, style: TextStyle(fontSize: 100 * s)),
                          ],
                        ),
                      ),
                      _button('DENGARKAN PERTANYAAN', Icons.play_arrow_rounded, const Color(0xFF2767C6), () => _audio.speak('Apa nama gambar ini?'), s),
                      SizedBox(height: 10 * s),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: choices.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.1, crossAxisSpacing: 12 * s, mainAxisSpacing: 10 * s),
                        itemBuilder: (context, i) {
                          final value = choices[i];
                          final selected = _selected == value;
                          final isCorrect = value == _target;
                          var fill = const Color(0xFFF6F7FC);
                          var border = const Color(0xFFCDD9E8);
                          if (answered && isCorrect) { fill = const Color(0xFFE5F7E9); border = const Color(0xFF42A95A); }
                          if (selected && !isCorrect) { fill = const Color(0xFFFFECEA); border = const Color(0xFFE45A52); }
                          return Material(
                            color: fill,
                            borderRadius: BorderRadius.circular(20 * s),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20 * s),
                              onTap: answered ? null : () {
                                setState(() {
                                  _selected = value;
                                  if (value == _target) _correct++;
                                });
                                value == _target ? _audio.correct() : _audio.wrong();
                              },
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(20 * s)),
                                alignment: Alignment.center,
                                child: Text(widget.items[value].$2, textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFF23486F), fontSize: 22 * s, fontWeight: FontWeight.w900)),
                              ),
                            ),
                          );
                        },
                      ),
                      if (answered) ...[
                        SizedBox(height: 8 * s),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 8 * s),
                          decoration: BoxDecoration(color: correct ? const Color(0xFFEAF8ED) : const Color(0xFFFFF0EE), borderRadius: BorderRadius.circular(16 * s)),
                          child: Text(correct ? '✓ Hebat! Jawabanmu Benar! 🎉' : 'Coba lagi ya! 💪', textAlign: TextAlign.center, style: TextStyle(color: correct ? const Color(0xFF2D8B43) : const Color(0xFFC8463D), fontSize: 16 * s, fontWeight: FontWeight.w900)),
                        ),
                      ],
                      SizedBox(height: 8 * s),
                      _button('SOAL BERIKUTNYA', Icons.arrow_forward_rounded, const Color(0xFF2767C6), _next, s),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8 * s),
              Row(
                children: [
                  Expanded(child: _stat('SOAL', _question.toString(), s)),
                  SizedBox(width: 8 * s),
                  Expanded(child: _stat('BENAR', _correct.toString(), s)),
                  SizedBox(width: 8 * s),
                  Expanded(child: _stat('SKOR', (_correct * 50).toString(), s)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _button(String label, IconData icon, Color color, VoidCallback onTap, double s) => Material(
    color: color,
    borderRadius: BorderRadius.circular(22 * s),
    elevation: 4,
    child: InkWell(
      borderRadius: BorderRadius.circular(22 * s),
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 54 * s,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: 27 * s), SizedBox(width: 8 * s), Text(label, style: TextStyle(color: Colors.white, fontSize: 17 * s, fontWeight: FontWeight.w900))]),
      ),
    ),
  );

  Widget _stat(String label, String value, double s) => Container(
    height: 58 * s,
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(16 * s), border: Border.all(color: const Color(0xFFD7E4EF))),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: TextStyle(color: const Color(0xFF4D6A83), fontSize: 11 * s, fontWeight: FontWeight.w900)), Text(value, style: TextStyle(color: const Color(0xFF25486B), fontSize: 18 * s, fontWeight: FontWeight.w900))]),
  );
}
