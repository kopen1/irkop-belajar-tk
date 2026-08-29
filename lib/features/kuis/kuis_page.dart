import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() =>
      _KuisPageState();
}

class _Question {
  final String visual;
  final String answer;
  final List<String> options;

  const _Question({
    required this.visual,
    required this.answer,
    required this.options,
  });
}

class _KuisPageState extends State<KuisPage> {
  final audio = AudioService.instance;
  final random = Random();

  late ConfettiController confetti;
  late _Question question;

  int score = 0;
  int number = 1;

  String? selected;
  bool locked = false;

  final bank = const [
    _Question(
      visual: '🍎',
      answer: 'Apel',
      options: [
        'Apel',
        'Bola',
        'Kucing',
        'Mobil',
      ],
    ),
    _Question(
      visual: '🔴',
      answer: 'Merah',
      options: [
        'Merah',
        'Biru',
        'Hijau',
        'Kuning',
      ],
    ),
    _Question(
      visual: '🐱',
      answer: 'Kucing',
      options: [
        'Kucing',
        'Ikan',
        'Gajah',
        'Singa',
      ],
    ),
    _Question(
      visual: '5️⃣',
      answer: '5',
      options: [
        '3',
        '4',
        '5',
        '6',
      ],
    ),
    _Question(
      visual: 'A',
      answer: 'A',
      options: [
        'A',
        'B',
        'C',
        'D',
      ],
    ),
    _Question(
      visual: 'ب',
      answer: 'ب',
      options: [
        'ا',
        'ب',
        'ت',
        'ث',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    confetti = ConfettiController(
      duration:
          const Duration(seconds: 2),
    );

    question = bank.first;

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) => _speakQuestion(),
    );
  }

  void _next() {
    setState(() {
      number++;
      selected = null;
      locked = false;
      question =
          bank[random.nextInt(bank.length)];
    });

    _speakQuestion();
  }

  void _speakQuestion() {
    audio.question(
      'Pertanyaan nomor $number. '
      'Mana ${question.answer}?',
    );
  }

  Future<void> _answer(
    String answer,
  ) async {
    if (locked) return;

    setState(
      () => selected = answer,
    );

    if (answer != question.answer) {
      await audio.wrong();

      await Future.delayed(
        const Duration(
          milliseconds: 700,
        ),
      );

      if (mounted) {
        setState(
          () => selected = null,
        );
      }

      return;
    }

    setState(() {
      locked = true;
      score++;
    });

    confetti.play();
    await audio.correct();

    await Future.delayed(
      const Duration(
        milliseconds: 1200,
      ),
    );

    if (mounted) {
      _next();
    }
  }

  Color _color(String option) {
    if (selected == option) {
      return option == question.answer
          ? Colors.green
          : Colors.red;
    }

    final i =
        question.options.indexOf(option);

    return [
      const Color(0xFF5EA8F5),
      const Color(0xFFFFA84D),
      const Color(0xFF7DCF72),
      const Color(0xFFB28AF5),
    ][i % 4];
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
        child: Stack(
          children: [
            Column(
              children: [
                const Padding(
                  padding:
                      EdgeInsets.all(14),
                  child: KidHeader(
                    title: 'Kuis Seru 🧠',
                    subtitle:
                        'Dengarkan lalu pilih jawaban',
                  ),
                ),

                Text(
                  '⭐ Skor: $score   📝 Soal: $number',
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child:
                      SingleChildScrollView(
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets
                                  .all(28),
                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.94,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              32,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x220D405C),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                question.visual,
                                style:
                                    const TextStyle(
                                  fontSize: 110,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FilledButton.icon(
                                onPressed:
                                    _speakQuestion,
                                icon: const Icon(
                                  Icons
                                      .volume_up_rounded,
                                ),
                                label:
                                    const Text(
                                  'Dengar Pertanyaan',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        GridView.count(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.6,
                          mainAxisSpacing:
                              12,
                          crossAxisSpacing:
                              12,
                          children: question
                              .options
                              .map(
                                (option) =>
                                    Material(
                                  color:
                                      _color(
                                    option,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    24,
                                  ),
                                  child:
                                      InkWell(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      24,
                                    ),
                                    onTap: () =>
                                        _answer(
                                      option,
                                    ),
                                    child:
                                        Center(
                                      child:
                                          Text(
                                        option,
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize: 24,
                                          fontWeight:
                                              FontWeight
                                                  .w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        const Text(
                          '🎲 Kuis terus berputar tanpa batas!',
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Align(
              alignment:
                  Alignment.topCenter,
              child: ConfettiWidget(
                confettiController:
                    confetti,
                blastDirectionality:
                    BlastDirectionality
                        .explosive,
                numberOfParticles:
                    35,
                gravity: 0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
