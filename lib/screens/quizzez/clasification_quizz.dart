import 'package:flutter/material.dart';
import 'package:start/services/questions_service.dart';
import '../../models/question.dart';
import '../../utils/quiz_template.dart';

class ClassificationQuizScreen extends StatefulWidget {
  const ClassificationQuizScreen({super.key});

  @override
  _ClassificationQuizScreenState createState() => _ClassificationQuizScreenState();
}

class _ClassificationQuizScreenState extends BaseQuizScreen<ClassificationQuizScreen> {



  @override
  Future<void> loadQuestions() async {
    quizId = "classification_quiz";
    questionService = QuestionService();
    final List<dynamic> data = await questionService.loadClassificationQuestions();

    setState(() {
      questions = data.map((item) => Question.fromJson(item)).toList();
    });
  }

  @override
  void navigateToResults(String quizId) {
    Navigator.popAndPushNamed(
      context,
      '/classification_result',
      arguments: quizId,
    );
  }
}
