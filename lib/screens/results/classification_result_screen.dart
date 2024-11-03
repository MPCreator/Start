import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/services/classification_evaluation_service.dart';
import 'package:start/utils/sizes.dart';
import '../../models/answers.dart';
import '../../providers/answer_provider.dart';
import '../../providers/theme_provider.dart';

class ClassificationResultScreen extends StatelessWidget {

  final String quizId;

  const ClassificationResultScreen({super.key, required this.quizId});

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

    final ClassificationEvaluationService evaluationService = ClassificationEvaluationService();

    String phaseResult = evaluationService.determinarFase(answers);


    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Resultados de Clasificación")),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppSizes.mediumSpace(context)),
            Container(
              height: AppSizes.customSizeHeight(context, 0.06),
              width:  AppSizes.customSizeWidth(context, 0.8),
              padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Fase de la Startup: $phaseResult',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
            SizedBox(
              height: AppSizes.customSizeHeight(context, 0.05),
              width:  AppSizes.customSizeWidth(context, 0.4),
              child: ElevatedButton(
                onPressed: () async {
                  if (phaseResult == "Semilla" || phaseResult == "Temprana") {
                    Navigator.pushNamed(context, '/factor_selector');
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Fase no compatible"),
                          content: const Text(
                              "Esta aplicación está diseñada solo para evaluar startups en sus fases iniciales. Tu fase actual no es compatible."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/home', (route) => false);
                              },
                              child: const Text("Entendido"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text("Siguiente"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

