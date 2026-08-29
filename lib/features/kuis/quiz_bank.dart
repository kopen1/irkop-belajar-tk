import '../../shared/models/quiz_question.dart';

class QuizBank {
  static final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'Huruf apakah ini? A',
      answers: ['A', 'B', 'C'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Angka setelah 2 adalah?',
      answers: ['1', '3', '5'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Warna langit biasanya?',
      answers: ['Biru', 'Merah', 'Hijau'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Hewan yang bisa mengeong?',
      answers: ['Kucing', 'Ikan', 'Burung'],
      correctIndex: 0,
    ),
  ];
}
