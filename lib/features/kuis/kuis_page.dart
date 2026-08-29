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
  final List<(String emoji, String label)> options;

  const _Question(this.prompt, this.answer, this.options);
}

class _KuisPageState extends State<KuisPage> {
  final audio = AudioService.instance;
  final random = Random();
  late final ConfettiController confetti;

  int number = 1;
  bool? result;
  String? selectedAnswer;
  late List<int> _queue;
  final List<int> _recentQuestions = <int>[];
  int _queuePosition = 0;
  late int _questionIndex;
  late List<(String emoji, String label)> _visibleOptions;

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
    _Question('Mana gambar pisang?', 'Pisang', [('🍌', 'Pisang'), ('🍓', 'Stroberi'), ('🍇', 'Anggur')]),
    _Question('Mana gambar anjing?', 'Anjing', [('🐶', 'Anjing'), ('🐱', 'Kucing'), ('🐰', 'Kelinci')]),
    _Question('Mana warna biru?', 'Biru', [('🟡', 'Kuning'), ('🔵', 'Biru'), ('🔴', 'Merah')]),
    _Question('Mana gambar rumah?', 'Rumah', [('🏠', 'Rumah'), ('🚗', 'Mobil'), ('🚲', 'Sepeda')]),
    _Question('Mana gambar kelinci?', 'Kelinci', [('🐰', 'Kelinci'), ('🐼', 'Panda'), ('🐻', 'Beruang')]),
    _Question('Mana warna ungu?', 'Ungu', [('🟣', 'Ungu'), ('🟠', 'Oranye'), ('🟢', 'Hijau')]),
    _Question('Mana gambar bunga?', 'Bunga', [('🌼', 'Bunga'), ('🌳', 'Pohon'), ('☀️', 'Matahari')]),
    _Question('Mana gambar matahari?', 'Matahari', [('🌙', 'Bulan'), ('⭐', 'Bintang'), ('☀️', 'Matahari')]),
    _Question('Mana gambar panda?', 'Panda', [('🐼', 'Panda'), ('🐯', 'Harimau'), ('🦁', 'Singa')]),
    _Question('Mana warna oranye?', 'Oranye', [('🟠', 'Oranye'), ('🟣', 'Ungu'), ('🔵', 'Biru')]),
    _Question('Mana gambar roket?', 'Roket', [('🚀', 'Roket'), ('✈️', 'Pesawat'), ('🚁', 'Helikopter')]),
    _Question('Mana gambar buku?', 'Buku', [('📘', 'Buku'), ('⚽', 'Bola'), ('🎈', 'Balon')]),
  ];

  _Question get question => bank[_questionIndex];

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    _queue = List<int>.generate(bank.length, (i) => i)..shuffle(random);
    _loadQuestion(initial: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => audio.question(question.prompt));
  }

  void _newQueue() {
    final previous = _questionIndex;
    _queue = List<int>.generate(bank.length, (i) => i)..shuffle(random);
    if (bank.length > 1 && _queue.first == previous) {
      final first = _queue.removeAt(0);
      _queue.add(first);
    }
    _queuePosition = 0;
  }

  void _loadQuestion({bool initial = false}) {
    if (!initial) {
      _queuePosition++;
      number++;
    }
    if (_queuePosition >= _queue.length) {
      _newQueue();
    }
    _questionIndex = _queue[_queuePosition];
    while (_recentQuestions.contains(_questionIndex) && _queuePosition < _queue.length - 1) {
      _queuePosition++;
      _questionIndex = _queue[_queuePosition];
    }
    _recentQuestions.add(_questionIndex);
    if (_recentQuestions.length > 8) _recentQuestions.removeAt(0);
    _visibleOptions = List<(String emoji, String label)>.from(question.options)..shuffle(random);
    result = null;
    selectedAnswer = null;
  }

  Future<void> choose(String value) async {
    if (result != null) return;
    final ok = value == question.answer;
    setState(() {
      selectedAnswer = value;
      result = ok;
    });
    if (ok) {
      confetti.play();
      await audio.correct();
    } else {
      await audio.wrong();
    }
  }

  void _nextQuestion() {
    setState(() => _loadQuestion());
    audio.question(question.prompt);
  }

  void _tryAgain() {
    setState(() {
      result = null;
      selectedAnswer = null;
    });
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
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
    final compact = MediaQuery.sizeOf(context).width < 430;
    return Container(
      padding: EdgeInsets.fromLTRB(16, compact ? 10 : 14, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: Color(0x260D405C), blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          _progressHeader(),
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
            children: _visibleOptions.map((option) => _answerCard(option, compact)).toList(),
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            _resultPanel(result!),
          ],
        ],
      ),
    );
  }

  Widget _progressHeader() {
    final dots = List<bool>.generate(8, (i) => i == (number - 1) % 8);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF2D98C8),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            'Pertanyaan $number',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: dots
                .map((active) => Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? const Color(0xFF2D98C8) : const Color(0xFFD5D9DD),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _answerCard((String emoji, String label) option, bool compact) {
    final correct = option.$2 == question.answer;
    final selectedCorrect = result == true && selectedAnswer == option.$2 && correct;
    final selectedWrong = result == false && selectedAnswer == option.$2 && !correct;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          elevation: 2,
          child: InkWell(
            onTap: result == null ? () => choose(option.$2) : null,
            borderRadius: BorderRadius.circular(22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: compact ? 142 : 156,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selectedCorrect
                      ? const Color(0xFF18A83B)
                      : selectedWrong
                          ? const Color(0xFFE4544D)
                          : const Color(0xFFD7DCE3),
                  width: selectedCorrect || selectedWrong ? 4 : 2,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (selectedWrong)
                    const Positioned(
                      top: -20,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFE4544D),
                        child: Icon(Icons.close_rounded, color: Colors.white, size: 30),
                      ),
                    ),
                  if (selectedWrong)
                    const Positioned(
                      top: -20,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFE4544D),
                        child: Icon(Icons.close_rounded, color: Colors.white, size: 30),
                      ),
                    ),
                  if (selectedCorrect)
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFFE9FBEA) : const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ok ? const Color(0xFF2CAB4A) : const Color(0xFFE66A62), width: 3),
      ),
      child: Row(
        children: [
          Text(ok ? '🦖' : '🦖💧', style: const TextStyle(fontSize: 64)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ok ? 'Hebat sekali!' : 'Coba lagi ya!',
                  style: TextStyle(
                    color: ok ? const Color(0xFF147F2D) : const Color(0xFFC7443D),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ok ? 'Jawaban kamu benar. Yuk lanjut!' : 'Tidak apa-apa. Pilih jawaban yang lain.',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF26324A)),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: ok ? _nextQuestion : _tryAgain,
                  icon: Icon(ok ? Icons.arrow_forward_rounded : Icons.replay_rounded),
                  label: Text(ok ? 'Soal Berikutnya' : 'Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ok ? const Color(0xFFFFB91D) : const Color(0xFF56B9E8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
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
            child: _roundButton(const Color(0xFFFFC42D), Icons.arrow_back_rounded, () => Navigator.of(context).maybePop()),
          ),
          Positioned(
            right: 18,
            top: 18,
            child: _roundButton(const Color(0xFF29C63E), Icons.music_note_rounded, () => audio.question(question.prompt)),
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
                      shadows: [Shadow(color: Color(0xFF17417B), blurRadius: 3, offset: Offset(2, 3))],
                    ),
                  ),
                ),
                SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Ayo Jawab Pertanyaannya!',
                    style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w900),
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
        child: SizedBox(width: 62, height: 62, child: Icon(icon, color: Colors.white, size: 35)),
      ),
    );
  }
}
