import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _Question {
  final String prompt;
  final String answer;
  final List<(String, String)> options;

  const _Question(this.prompt, this.answer, this.options);
}

class _KuisPageState extends State<KuisPage> {
  final audio = AudioService.instance;
  final random = Random();
  late final ConfettiController confetti;

  int number = 1;
  bool? result;
  int _questionIndex = 0;
  final List<int> _questionQueue = [];

  final bank = const <_Question>[
    _Question('Mana gambar ikan?', 'Ikan', [('🐱', 'Kucing'), ('🐟', 'Ikan'), ('🚗', 'Mobil')]),
    _Question('Mana gambar apel?', 'Apel', [('🍎', 'Apel'), ('⚽', 'Bola'), ('🐘', 'Gajah')]),
    _Question('Mana warna merah?', 'Merah', [('🔵', 'Biru'), ('🔴', 'Merah'), ('🟢', 'Hijau')]),
    _Question('Mana gambar kucing?', 'Kucing', [('🐟', 'Ikan'), ('🐱', 'Kucing'), ('🐘', 'Gajah')]),
    _Question('Mana gambar mobil?', 'Mobil', [('🚗', 'Mobil'), ('🚌', 'Bus'), ('🚲', 'Sepeda')]),
    _Question('Mana gambar gajah?', 'Gajah', [('🦁', 'Singa'), ('🐘', 'Gajah'), ('🦒', 'Jerapah')]),
    _Question('Mana warna kuning?', 'Kuning', [('🟢', 'Hijau'), ('🟡', 'Kuning'), ('🔵', 'Biru')]),
    _Question('Mana gambar bebek?', 'Bebek', [('🐥', 'Bebek'), ('🐔', 'Ayam'), ('🐦', 'Burung')]),
    _Question('Mana gambar singa?', 'Singa', [('🦁', 'Singa'), ('🐯', 'Harimau'), ('🐼', 'Panda')]),
    _Question('Mana gambar bola?', 'Bola', [('⚽', 'Bola'), ('🍎', 'Apel'), ('🚗', 'Mobil')]),
    _Question('Mana warna hijau?', 'Hijau', [('🔴', 'Merah'), ('🟢', 'Hijau'), ('🟣', 'Ungu')]),
    _Question('Mana gambar burung?', 'Burung', [('🐦', 'Burung'), ('🐘', 'Gajah'), ('🐱', 'Kucing')]),
  ];

  _Question get question => bank[_questionIndex];

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    _refillQueue();
    _takeNextQuestion(initial: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => audio.question(question.prompt));
  }

  void _refillQueue() {
    _questionQueue
      ..clear()
      ..addAll(List<int>.generate(bank.length, (index) => index))
      ..shuffle(random);

    if (bank.length > 1 && _questionQueue.first == _questionIndex) {
      final first = _questionQueue.removeAt(0);
      _questionQueue.add(first);
    }
  }

  void _takeNextQuestion({bool initial = false}) {
    if (_questionQueue.isEmpty) _refillQueue();
    _questionIndex = _questionQueue.removeAt(0);
    if (!initial) number++;
    result = null;
  }

  Future<void> choose(String value) async {
    if (result != null) return;

    final ok = value == question.answer;
    setState(() => result = ok);

    if (ok) {
      confetti.play();
      await audio.correct();
    } else {
      await audio.wrong();
    }
  }

  void _nextQuestion() {
    setState(() => _takeNextQuestion());
    audio.question(question.prompt);
  }

  void _tryAgain() {
    setState(() => result = null);
    audio.question(question.prompt);
  }

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _header(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
                      child: _quizPanel(),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 34,
                  gravity: .25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quizPanel() {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 430;
    final options = [...question.options]..shuffle(Random(_questionIndex));

    return Container(
      padding: EdgeInsets.fromLTRB(16, compact ? 10 : 14, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260D405C),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF56B9E8),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3356B9E8),
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'Pertanyaan $number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            question.prompt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 27 : 31,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF17223B),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: options.map((option) => _answerCard(option, compact)).toList(),
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            _resultPanel(result!),
          ],
        ],
      ),
    );
  }

  Widget _answerCard((String, String) option, bool compact) {
    final selected = result != null && option.$2 == question.answer;
    final wrongSelected = result == false && option.$2 != question.answer;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          elevation: 2,
          child: InkWell(
            onTap: () => choose(option.$2),
            borderRadius: BorderRadius.circular(22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: compact ? 142 : 156,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF18A83B)
                      : wrongSelected
                          ? const Color(0xFFE4544D)
                          : const Color(0xFFD7DCE3),
                  width: selected || wrongSelected ? 4 : 2,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (selected)
                    const Positioned(
                      top: -20,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF22B83F),
                        child: Icon(Icons.check_rounded, color: Colors.white, size: 30),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(option.$1, style: TextStyle(fontSize: compact ? 52 : 62)),
                      const SizedBox(height: 4),
                      Text(
                        option.$2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: compact ? 15 : 17,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF26324A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultPanel(bool ok) {
    final title = ok ? 'Benar! Hebat sekali!' : 'Coba lagi ya!';
    final subtitle = ok
        ? 'Jawaban kamu benar. Yuk lanjut ke soal berikutnya!'
        : 'Tidak apa-apa, pilih jawaban yang lain.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: ok
            ? const Color(0xFFE8FBEA)
            : const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: ok ? const Color(0xFF31B650) : const Color(0xFFE66A62),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(ok ? '⭐' : '💪', style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: ok ? const Color(0xFF147F2D) : const Color(0xFFC7443D),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF26324A),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: ok ? _nextQuestion : _tryAgain,
              icon: Icon(ok ? Icons.arrow_forward_rounded : Icons.replay_rounded),
              label: Text(ok ? 'Soal Berikutnya' : 'Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ok
                    ? const Color(0xFFFFB91D)
                    : const Color(0xFF56B9E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 104,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 18,
            top: 18,
            child: _roundButton(
              const Color(0xFFFFC42D),
              Icons.arrow_back_rounded,
              () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            right: 18,
            top: 18,
            child: _roundButton(
              const Color(0xFF29C63E),
              Icons.music_note_rounded,
              () => audio.question(question.prompt),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 86),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '🏆 Kuis Seru',
                    style: TextStyle(
                      fontSize: 35,
                      color: Color(0xFFFFD32F),
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Color(0xFF17417B),
                          blurRadius: 3,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Ayo Jawab Pertanyaannya!',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
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

  Widget _roundButton(Color color, IconData icon, VoidCallback onTap) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 5,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 62,
          height: 62,
          child: Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}
