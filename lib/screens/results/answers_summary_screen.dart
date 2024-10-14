import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/utils/sizes.dart';
import '../../models/answers.dart';
import '../../providers/answer_provider.dart';
import '../../providers/theme_provider.dart';

class AnswerSummaryScreen extends StatelessWidget {

  final String quizId;

  const AnswerSummaryScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    final answerProvider = Provider.of<AnswerProvider>(context);
    String jsonAnswers = answerProvider.getAnswersAsJson(quizId);
    List<dynamic> jsonList = json.decode(jsonAnswers);

    // Convertir la lista de mapas a una lista de objetos Answer
    List<Answer> answers = jsonList.map((json) => Answer(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      parentQuestionId: json['parentQuestionId'],
    )).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Resumen de respuestas")),
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
      body: Column(
        children: [
          SizedBox(height: AppSizes.mediumSpace(context)),
          SizedBox(
            height: AppSizes.customSizeHeight(context, 0.7),
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final answer = answers[index];
                return ListTile(
                  title: Text(
                    answer.question,
                  ),
                  subtitle: Text(
                    answer.answer ?? 'Sin respuesta',
                  ),
                );
              },
            ),
          ),
          SizedBox( height: AppSizes.customSizeHeight(context, 0.02)),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/factor_selector');
            },
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }
}

