class Question {
  final String question;
  final List<String> options;
  final int answerIndex;

  Question({required this.question, required this.options, required this.answerIndex});

  factory Question.fromMap(Map<String, dynamic> m) {
    return Question(
      question: m['question'] as String,
      options: List<String>.from(m['options'] as List<dynamic>),
      answerIndex: m['answerIndex'] as int,
    );
  }
}
