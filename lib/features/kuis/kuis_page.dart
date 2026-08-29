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
  late _Question question;

  final bank = const [
    _Question(
      'Mana gambar ikan?',
      'Ikan',
      [('🐱', 'Kucing'), ('🐟', 'Ikan'), ('🚗', 'Mobil')],
    ),
    _Question(
      'Mana gambar apel?',
      'Apel',
      [('🍎', 'Apel'), ('⚽', 'Bola'), ('🐘', 'Gajah')],
    ),
    _Question(
      'Mana warna merah?',
      'Merah',
      [('🔵', 'Biru'), ('🔴', 'Merah'), ('🟢', 'Hijau')],
    ),
  ];

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    question = bank.first;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => audio.question(question.prompt),
    );
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
    setState(() {
      number++;
      question = bank[random.nextInt(bank.length)];
      result = null;
    });
    audio.question(question.prompt);
  }

  void _tryAgain() {
    setState(() => result = null);
  }

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: KidBackground(
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _header(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .94),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B9E8),
                                borderRadius: BorderRadius.circular(18),
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
                            const SizedBox(height: 16),
                            Text(
                              question.prompt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF17223B),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: question.options
                                  .map(
                                    (o) => Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          elevation: 3,
                                          child: InkWell(
                                            onTap: () => choose(o.$2),
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            child: SizedBox(
                                              height: 132,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    o.$1,
                                                    style: const TextStyle(
                                                      fontSize: 62,
                                                    ),
                                                  ),
                                                  Text(
                                                    o.$2,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: confetti,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 38,
                    gravity: .25,
                  ),
                ),
                if (result != null) _feedbackPopup(result!),
              ],
            ),
          ),
        ),
      );

  Widget _header() => SizedBox(
        height: 92,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 22,
              child: Material(
                color: const Color(0xFFFFC42D),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const SizedBox(
                    width: 62,
                    height: 62,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 22,
              child: CircleAvatar(
                radius: 31,
                backgroundColor: Color(0xFF29C63E),
                child: Icon(
                  Icons.music_note_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🏆 Kuis Seru',
                  style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFFFFD32F),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Ayo Jawab Pertanyaannya!',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _feedbackPopup(bool ok) => Positioned.fill(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: .18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: ok
                        ? const Color(0xFF2AB94A)
                        : const Color(0xFFFF7A70),
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ok ? '🦕' : '🐯',
                      style: const TextStyle(fontSize: 84),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ok ? 'Hebat!' : 'Coba lagi ya!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ok
                            ? const Color(0xFF159A35)
                            : const Color(0xFFE4544D),
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ok
                          ? 'Jawaban kamu benar!'
                          : 'Tidak apa-apa, coba sekali lagi.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF26324A),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: ok ? _nextQuestion : _tryAgain,
                        icon: Icon(
                          ok
                              ? Icons.arrow_forward_rounded
                              : Icons.replay_rounded,
                        ),
                        label: Text(
                          ok ? 'Soal Berikutnya' : 'Coba Lagi',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ok
                              ? const Color(0xFFFFB91D)
                              : const Color(0xFF56B9E8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
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
              ),
            ),
          ),
        ),
      );
}
