class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}
