import 'package:flutter/material.dart';
import 'package:start/services/questions_service.dart';
import '../../models/question.dart';
import '../../utils/quiz_template.dart';

class ExternalFactorQuizScreen extends StatefulWidget {
  const ExternalFactorQuizScreen({super.key});

  @override
  _ExternalFactorQuizScreenState createState() => _ExternalFactorQuizScreenState();
}

class _ExternalFactorQuizScreenState extends BaseQuizScreen<ExternalFactorQuizScreen> {

  @override
  Future<void> loadQuestions() async {
    quizId = "external_factors_quiz";
    questionService = QuestionService();
    final List<dynamic> data = await questionService.loadExternalFactorsQuestions();

    setState(() {
      questions = data.map((item) => Question.fromJson(item)).toList();
    });
  }

  @override
  void navigateToResults(String quizId) {
    Navigator.popAndPushNamed(
      context,
      '/answers_summary',
      arguments: quizId,
    );
  }
}
