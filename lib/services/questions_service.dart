import 'dart:convert';
import 'package:flutter/services.dart';

class QuestionService {
  Future<List<dynamic>> loadClassificationQuestions() async {
    final String response = await rootBundle.loadString(
        'assets/questions/classification_questions.json');
    final List<dynamic> data = await json.decode(response);
    return data;
  }

  Future<List<dynamic>> loadExternalFactorsQuestions() async {
    final String response = await rootBundle.loadString(
        'assets/questions/external_factors_questions.json');
    final data = await json.decode(response);
    return data;
  }

  Future<List<dynamic>> loadInternalFactorsQuestions() async {
    final String response = await rootBundle.loadString(
        'assets/questions/internal_factors_questions.json');
    final data = await json.decode(response);
    return data;
  }
}