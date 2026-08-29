import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/models/learning_item.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';
import '../learning/learning_data.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  final random = Random();
  final audio = AudioService.instance;

  late ConfettiController confetti;
  late LearningItem question;
  late List<LearningItem> answers;

  String feedback = '';
  int score = 0;
  int questionNumber = 1;

  int? selectedIndex;
  bool locked = false;

  List<LearningItem> get bank => [
        ...hurufItems,
        ...angkaItems,
        ...hijaiyahItems,
        ...gambarItems,
        ...warnaItems,
      ];

  @override
  void initState() {
    super.initState();

    confetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _next();
  }

  @override
  void dispose() {
    audio.stop();
    confetti.dispose();
    super.dispose();
  }

  void _next() {
    question = bank[random.nextInt(bank.length)];

    final other = [...bank]
      ..removeWhere((item) => item.title == question.title)
      ..shuffle(random);

    answers = [
      question,
      ...other.take(3),
    ]..shuffle(random);

    setState(() {
      feedback = '';
      selectedIndex = null;
      locked = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      audio.question(
        'Pertanyaan nomor $questionNumber. Mana ${question.title}?',
      );
    });
  }

  Future<void> _answer(
    LearningItem answer,
    int index,
  ) async {
    if (locked) return;

    setState(() {
      selectedIndex = index;
    });

    final correct = answer.title == question.title;

    if (!correct) {
      setState(() {
        feedback = '😊 Belum tepat, coba lagi!';
      });

      await audio.wrong();

      if (!mounted) return;

      Future.delayed(
        const Duration(milliseconds: 900),
        () {
          if (!mounted || locked) return;

          setState(() {
            selectedIndex = null;
          });
        },
      );

      return;
    }

    setState(() {
      locked = true;
      score++;
      feedback = '🎉 BENAR! HEBAT!';
    });

    confetti.play();
    await audio.correct();

    Future.delayed(
      const Duration(milliseconds: 1300),
      () {
        if (!mounted) return;

        setState(() {
          questionNumber++;
        });

        _next();
      },
    );
  }

  Color _buttonColor(
    int index,
    LearningItem item,
  ) {
    if (selectedIndex == index) {
      if (item.title == question.title) {
        return const Color(0xFF62C86B);
      }

      return const Color(0xFFFF6B6B);
    }

    return const [
      Color(0xFF62A8F7),
      Color(0xFFFFA94D),
      Color(0xFF8BCF72),
      Color(0xFFB28AF5),
    ][index % 4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KidBackground(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: KidHeader(
                    title: 'Kuis Seru 🧠',
                    subtitle: 'Jawab dan dengarkan pertanyaannya',
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _pill(
                      'Soal',
                      '$questionNumber',
                      '📝',
                    ),
                    const SizedBox(width: 10),
                    _pill(
                      'Skor',
                      '$score',
                      '⭐',
                    ),
                  ],
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      14,
                      18,
                      92,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 16,
                                offset: Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                question.visual,
                                style: const TextStyle(fontSize: 98),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Mana jawaban yang benar?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2F4F6B),
                                ),
                              ),

                              const SizedBox(height: 12),

                              FilledButton.icon(
                                onPressed: () {
                                  audio.question(
                                    'Pertanyaan nomor '
                                    '$questionNumber. '
                                    'Mana ${question.title}?',
                                  );
                                },
                                icon: const Icon(
                                  Icons.volume_up_rounded,
                                ),
                                label: const Text(
                                  'Dengar Pertanyaan',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (feedback.isNotEmpty)
                          AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 250,
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: feedback.contains('BENAR')
                                  ? const Color(0xFFDFF7DE)
                                  : const Color(0xFFFFE2E2),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Text(
                              feedback,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: answers.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.55,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            final item = answers[index];

                            return AnimatedScale(
                              duration: const Duration(
                                milliseconds: 180,
                              ),
                              scale:
                                  selectedIndex == index ? 0.96 : 1,
                              child: Material(
                                color: _buttonColor(
                                  index,
                                  item,
                                ),
                                borderRadius:
                                    BorderRadius.circular(24),
                                elevation: 5,
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.circular(24),
                                  onTap: () => _answer(
                                    item,
                                    index,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(10),
                                      child: Text(
                                        item.title,
                                        textAlign:
                                            TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          '🎲 Pertanyaan akan terus berubah dan tidak terbatas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2F4F6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            ConfettiWidget(
              confettiController: confetti,
              blastDirectionality:
                  BlastDirectionality.explosive,
              numberOfParticles: 35,
              gravity: 0.25,
              shouldLoop: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(
    String label,
    String value,
    String emoji,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        '$emoji $label: $value',
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xFF2F4F6B),
        ),
      ),
    );
  }
}
