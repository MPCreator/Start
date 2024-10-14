import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/utils/sizes.dart';

import '../models/answers.dart';
import '../models/question.dart';
import '../providers/answer_provider.dart';
import '../providers/theme_provider.dart';
import '../services/questions_service.dart';
import '../widgets/question_widget.dart';
import '../widgets/subquestion_widget.dart';

abstract class BaseQuizScreen<T extends StatefulWidget> extends State<T> {
  int currentIndex = 0;
  List<Question> questions = [];
  late String quizId;
  late QuestionService questionService;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    //Limpieza de las respuestas anteriroes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnswerProvider>().clearAnswers(quizId);
    });


  }

  Future<void> loadQuestions();

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    if (questions.isEmpty) {
      return _buildLoadingScreen();
    }

    final currentQuestion = questions[currentIndex];

    String appBarTitle;
    if (quizId == "classification_quiz") {
      appBarTitle = "Clasificador de Fase";
    } else if (quizId == "external_factors_quiz") {
      appBarTitle = "Cuestionario de Factores Externos";
    } else if (quizId == "internal_factors_quiz") {
      appBarTitle = "Cuestionario de Factores Internos";
    } else {
      appBarTitle = "Quiz";
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(appBarTitle)),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.yellow,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
        child: SingleChildScrollView(
          child: SizedBox(
            height: AppSizes.customSizeHeight(context, 0.85),
            child: Column(
              children: [
                SizedBox(height: AppSizes.smallSpace(context)),
                _buildProgressIndicator(),
                SizedBox(height: AppSizes.mediumSpace(context)),
                _buildQuestionWidget(currentQuestion),
                if (currentQuestion.subQuestions != null) ..._buildSubQuestions(currentQuestion),
                const Spacer(),
                _buildNextButton(),
                SizedBox(height: AppSizes.customSizeHeight(context, 0.2)),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Cargando...')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: AppSizes.customSizeHeight(context, 0.01),
      child: LinearProgressIndicator(
        value: (currentIndex + 1) / questions.length,
      ),
    );
  }

  Widget _buildQuestionWidget(Question currentQuestion) {
    return QuestionWidget(
      question: currentQuestion,
      onAnswerChanged: (answer) {
        setState(() {
          currentQuestion.answer = answer;
        });
      },
    );
  }

  List<Widget> _buildSubQuestions(Question question) {
    return question.subQuestions!
        .where((subQuestion) => subQuestion.triggerAnswer == question.answer)
        .map((subQuestion) => SubQuestionWidget(
      subQuestion: subQuestion,
      onAnswerChanged: (answer) {
        setState(() {
          subQuestion.answer = answer;
        });
      },
    ))
        .toList();
  }

  void _addAnswer(String id, String questionText, String answer, {String? parentId}) {
    final answerProvider = Provider.of<AnswerProvider>(context, listen: false);

    String? scaleLabel = _getScaleLabel(id, answer);
    if (scaleLabel != null) {
      answer = scaleLabel;
    }

    answerProvider.addAnswers(
      quizId,
      [
        Answer(
          id: id,
          question: questionText,
          answer: answer,
          parentQuestionId: parentId,
        ),
      ],
    );
  }

  SizedBox _buildNextButton() {
    return SizedBox(
      width: AppSizes.customSizeWidth(context, 0.3),
      child: ElevatedButton(
        onPressed: _validateAndProceed,
        child: Text(currentIndex < questions.length - 1 ? 'Siguiente' : 'Finalizar'),
      ),
    );
  }

  void _validateAndProceed() {
    final currentQuestion = questions[currentIndex];

    if (_isQuestionAnswered(currentQuestion)) {
      _validateSubQuestions(currentQuestion);
      _addAnswer(currentQuestion.id, currentQuestion.questionText, currentQuestion.answer!);

      final activeSubQuestions = currentQuestion.subQuestions
          ?.where((subQuestion) => subQuestion.triggerAnswer == currentQuestion.answer)
          .toList();

      for (var subQuestion in activeSubQuestions ?? []) {
        if (subQuestion.answer != null && subQuestion.answer!.isNotEmpty) {
          _addAnswer(subQuestion.id, subQuestion.questionText, subQuestion.answer!, parentId: currentQuestion.id);
        }
      }

      if (currentIndex < questions.length - 1) {
        setState(() => currentIndex++);
      } else {
        navigateToResults(quizId);
      }
    } else {
      _showError('Por favor, responde a la pregunta antes de continuar.');
    }
  }

  bool _isQuestionAnswered(Question question) {
    return question.answer != null && question.answer!.isNotEmpty;
  }

  void _validateSubQuestions(Question question) {
    final activeSubQuestions = question.subQuestions
        ?.where((subQuestion) => subQuestion.triggerAnswer == question.answer)
        .toList();

    for (var subQuestion in activeSubQuestions ?? []) {
      if (subQuestion.answer == null || subQuestion.answer!.isEmpty) {
        _showError('Por favor, responde a todas las subpreguntas.');
        throw Exception('Validation failed');
      }
    }
  }

  void _showError(String message) {
    _showDialog('Error', message);
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  String? _getScaleLabel(String questionId, String answer) {
    // Pregunta predeterminada para manejar el caso en que no se encuentra ninguna pregunta
    final Question defaultQuestion = Question(
        id: questionId,
        type: QuestionType.ESCALA,
        scaleLabels: [],
        questionText: ''
    );

    // Buscar en las preguntas principales
    final question = questions.firstWhere((q) => q.id == questionId, orElse: () {
      // Si no se encuentra, buscar en subpreguntas
      for (var mainQuestion in questions) {
        // Construir el ID de la subpregunta
        final subQuestionId = '${mainQuestion.id}.${questionId.split('.').last}';

        // Buscar la subpregunta correspondiente
        final subQuestion = mainQuestion.subQuestions?.firstWhere(
              (sq) => sq.id == subQuestionId,
            orElse: () => SubQuestion(
                id: questionId,
                type: QuestionType.ESCALA,
                scaleLabels: [],
                questionText: '',
                triggerAnswer: ''
            )
        );

        // Si se encuentra una subpregunta, retornarla como pregunta
        if (subQuestion != null) {
          return Question(
            id: subQuestion.id,
            type: subQuestion.type,
            scaleLabels: subQuestion.scaleLabels,
            questionText: subQuestion.questionText,
          );
        }
      }
      return defaultQuestion;
    });

    if (question.type == QuestionType.ESCALA) {
      int index = (double.tryParse(answer) ?? 0).toInt();

      if (index > 0 && index <= question.scaleLabels!.length) {
        return question.scaleLabels![index - 1];
      } else {
        print('Índice fuera de límites: $index, scaleLabels.length: ${question.scaleLabels!.length}');
      }
    }

    return null;
  }




  void navigateToResults(String quizId);
}
