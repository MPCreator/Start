class Question {
  final String id;
  final String questionText;
  final QuestionType type;
  String? answer;
  final List<String>? options;
  final List<SubQuestion>? subQuestions;

  final List<String>? scaleLabels;
  final double? minScale;
  final double? maxScale;

  Question({
    required this.id,
    required this.questionText,
    required this.type,
    this.answer,
    this.options,
    this.subQuestions,
    this.scaleLabels,
    this.minScale,
    this.maxScale,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['questionText'],
      type: QuestionType.values.firstWhere(
              (e) => e.toString() == 'QuestionType.${json['type']}'),
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      subQuestions: json['subQuestions'] != null
          ? (json['subQuestions'] as List)
          .map((item) => SubQuestion.fromJson(item))
          .toList()
          : null,
      scaleLabels: json['scaleLabels'] != null
          ? List<String>.from(json['scaleLabels'])
          : null,
      minScale: json['minScale']?.toDouble(),
      maxScale: json['maxScale']?.toDouble(),
    );
  }
}

class SubQuestion {
  final String id;
  final String questionText;
  final QuestionType type;
  String? answer;
  final String triggerAnswer;
  final List<String>? options;

  final List<String>? scaleLabels;
  final double? minScale;
  final double? maxScale;

  SubQuestion({
    required this.id,
    required this.questionText,
    required this.type,
    this.answer,
    required this.triggerAnswer,
    this.options,
    this.scaleLabels,
    this.minScale,
    this.maxScale,
  });

  factory SubQuestion.fromJson(Map<String, dynamic> json) {
    return SubQuestion(
      id: json['id'],
      questionText: json['questionText'],
      type: QuestionType.values.firstWhere(
              (e) => e.toString() == 'QuestionType.${json['type']}'),
      triggerAnswer: json['triggerAnswer'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      scaleLabels: json['scaleLabels'] != null
          ? List<String>.from(json['scaleLabels'])
          : null,
      minScale: json['minScale']?.toDouble(),
      maxScale: json['maxScale']?.toDouble(),
    );
  }
}

enum QuestionType {
  SI_NO,
  TEXTO,
  COMBO_BOX,
  MULTIPLE_OPTIONS,
  ESCALA,
}
