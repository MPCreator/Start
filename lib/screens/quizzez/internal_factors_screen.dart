import 'package:flutter/material.dart';
import 'package:start/services/questions_service.dart';
import '../../models/question.dart';
import '../../utils/quiz_template.dart';

class InternalFactorQuizScreen extends StatefulWidget {
  const InternalFactorQuizScreen({super.key});

  @override
  _InternalFactorQuizScreenState createState() => _InternalFactorQuizScreenState();
}

class _InternalFactorQuizScreenState extends BaseQuizScreen<InternalFactorQuizScreen> {

  @override
  Future<void> loadQuestions() async {
    quizId = "internal_factors_quiz";
    questionService = QuestionService();
    final List<dynamic> data = await questionService.loadInternalFactorsQuestions();

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
