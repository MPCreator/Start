
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'answer': answer,
      'question': question,
      'parentQuestionId': parentQuestionId,
      'evaluation': evaluation,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    // Imprime el mapa completo de cada respuesta
    print("Map de respuesta recibido: $map");

    // Verifica cada campo antes de la conversión
    print("Tipo de 'id': ${map['id'].runtimeType}");
    print("Tipo de 'answer': ${map['answer'].runtimeType}");
    print("Tipo de 'question': ${map['question'].runtimeType}");
    print("Tipo de 'parentQuestionId': ${map['parentQuestionId'].runtimeType}");
    print("Tipo de 'evaluation': ${map['evaluation'].runtimeType}");

    return Answer(
      id: map['id'] ?? '',
      answer: map['answer'] ?? '',
      question: map['question'] ?? '',
      parentQuestionId: map['parentQuestionId'] ?? '',
      evaluation: map['evaluation'] ?? '',
    );
  }

}


