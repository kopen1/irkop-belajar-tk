import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/services/audio_service.dart';
import '../../shared/widgets/fun_page.dart';
import 'quiz_bank.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  final Random random = Random();

  int score = 0;
  late int questionIndex;

  @override
  void initState() {
    super.initState();
    questionIndex =
        random.nextInt(QuizBank.questions.length);
  }

  void answer(int index) {
    final question =
        QuizBank.questions[questionIndex];

    final correct =
        index == question.correctIndex;

    if (correct) {
      AudioService.correct();

      setState(() {
        score++;
        questionIndex =
            random.nextInt(QuizBank.questions.length);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Hebat! Jawaban Benar!'),
        ),
      );
    } else {
      AudioService.wrong();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('😄 Belum tepat, coba lagi ya!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question =
        QuizBank.questions[questionIndex];

    return FunPage(
      title: 'Kuis Seru',
      emoji: '🏆',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '⭐ Skor: $score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ...List.generate(
              question.answers.length,
              (index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () => answer(index),
                      child: Text(
                        question.answers[index],
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
