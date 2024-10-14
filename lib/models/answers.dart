
class Answer {
  final String id;
  final String question;
  String? answer;
  String? parentQuestionId;
  String evaluation;

  Answer({
    required this.id,
    required this.question,
    this.answer,
    this.parentQuestionId,
    this.evaluation = 'Sin Evaluar',
  });
}

