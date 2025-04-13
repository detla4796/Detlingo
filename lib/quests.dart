class Quests {
  final String questionText;
  final List<Answer> answers;
  final int correctIndex;

  Quests({required this.questionText, required this.answers, required this.correctIndex});
}

class Answer {
  final String answerText;

  Answer({required this.answerText});
}
