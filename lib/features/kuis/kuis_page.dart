import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/models/learning_item.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/answer_button.dart';
import '../../core/widgets/kid_background.dart';
import '../../core/widgets/kid_header.dart';
import '../learning/learning_data.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  late ConfettiController confetti;
  final random = Random();

  late LearningItem question;
  late List<LearningItem> answers;

  String feedback = '';
  int score = 0;
  int questionNumber = 1;

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
    confetti.dispose();
    super.dispose();
  }

  void _next() {
    question = bank[random.nextInt(bank.length)];

    final other = [...bank]
      ..removeWhere((e) => e.title == question.title)
      ..shuffle(random);

    answers = [
      question,
      ...other.take(3),
    ]..shuffle(random);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService.instance.question(
        'Pertanyaan nomor $questionNumber. Mana ${question.title}?',
      );
    });

    setState(() => feedback = '');
  }

  void _answer(LearningItem answer) {
    if (answer.title == question.title) {
      score++;
      feedback = '🎉 BENAR! HEBAT!';
      confetti.play();
      AudioService.instance.correct();

      setState(() {});

      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!mounted) return;
          questionNumber++;
          _next();
        },
      );
    } else {
      setState(() {
        feedback = '😊 Belum tepat, coba lagi!';
      });
      AudioService.instance.wrong();
    }
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
                  padding: EdgeInsets.all(16),
                  child: KidHeader(
                    title: 'Kuis Seru',
                    subtitle: 'Pertanyaan dari semua dunia belajar',
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _pill('Soal', '$questionNumber'),
                    _pill('Skor', '$score ⭐'),
                  ],
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              AudioService.instance.question(
                                'Mana ${question.title}?',
                              );
                            },
                            icon: const Icon(Icons.volume_up),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            question.visual,
                            style: const TextStyle(fontSize: 105),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'Jawaban yang benar adalah?',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 16),

                          if (feedback.isNotEmpty)
                            Text(
                              feedback,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                          const SizedBox(height: 12),

                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: answers.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (_, index) {
                              return AnswerButton(
                                text: answers[index].title,
                                color: const [
                                  Color(0xFF5BA9F7),
                                  Color(0xFFFF9F43),
                                  Color(0xFF7ACB72),
                                  Color(0xFFB082F5),
                                ][index],
                                onTap: () => _answer(answers[index]),
                              );
                            },
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Kuis akan terus membuat pertanyaan baru 🎲',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
