import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/answers.dart';

class AnswerProvider with ChangeNotifier {
  final Map<String, List<Answer>> _answersMap = {};

  void addAnswers(String quizId, List<Answer> newAnswers) {
    if (_answersMap.containsKey(quizId)) {
      _answersMap[quizId]!.addAll(newAnswers);
    } else {
      _answersMap[quizId] = newAnswers;
    }
    notifyListeners();
  }

  List<Answer>? getAnswers(String quizId) {
    return _answersMap[quizId];
  }

  String getAnswersAsJson(String quizId) {
    List<Map<String, dynamic>> allAnswers = [];

    if (_answersMap.containsKey(quizId)) {
      for (var answer in _answersMap[quizId]!) {
        allAnswers.add({
          'id': answer.id,
          'question': answer.question,
          'answer': answer.answer,
          'parentQuestionId': answer.parentQuestionId,
          'evaluation': answer.evaluation
        });
      }
    }

    return json.encode(allAnswers);
  }

  // Método para limpiar respuestas por quizId
  void clearAnswers(String quizId) {
    _answersMap.remove(quizId);
    notifyListeners();
  }


  bool hasAnswersFor(String quizId) {
    return _answersMap.containsKey(quizId) && _answersMap[quizId] != null;
  }

  // Método para actualizar la evaluación de una respuesta por su id
  void updateEvaluation(String quizId, String questionId, String evaluation) {
    if (_answersMap.containsKey(quizId)) {
      for (var answer in _answersMap[quizId]!) {
        if (answer.id == questionId) {
          if (['Positiva', 'Negativa', 'Neutra'].contains(evaluation)) {
            answer.evaluation = evaluation;
            notifyListeners();
          } else {
            throw ArgumentError('Evaluación no válida. Use "Positiva", "Negativa" o "Neutra".');
          }
        }
      }
    }
  }

}
