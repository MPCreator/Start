import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/services/gemini_service.dart';
import 'package:start/utils/sizes.dart';

import '../providers/answer_provider.dart';
import '../providers/theme_provider.dart';

class FactorSelectorScreen extends StatelessWidget {
  const FactorSelectorScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final answerProvider = Provider.of<AnswerProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    // Verifica si hay respuestas para los cuestionarios
    bool hasExternalAnswers = answerProvider.hasAnswersFor('external_factors_quiz');
    bool hasInternalAnswers = answerProvider.hasAnswersFor('internal_factors_quiz');

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Selecciona un Factor")),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Primer botón de selección de factor
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/external_factors_questions');
              },
              child: Container(
                padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
                margin: EdgeInsets.only(bottom: AppSizes.customSizeHeight(context, 0.02)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: AppSizes.customSizeHeight(context, 0.03),
                        ),
                        SizedBox(width: AppSizes.customSizeWidth(context,0.02)),
                        Text(
                          'Factores Externos',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ],
                ),
              ),
            ),

            // Segundo botón de selección de factor
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/internal_factors_questions');
              },
              child: Container(
                padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
                margin: EdgeInsets.only(bottom: AppSizes.customSizeHeight(context, 0.02)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: AppSizes.customSizeHeight(context, 0.03),
                        ),
                        SizedBox(width: AppSizes.customSizeWidth(context,0.02)),
                        Text(
                          'Factores Internos',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ],
                ),
              ),
            ),
            if (hasExternalAnswers && hasInternalAnswers)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/evaluation_result_screen');
                },
                child: Container(
                  padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
                  margin: EdgeInsets.only(bottom: AppSizes.customSizeHeight(context, 0.02)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assessment,
                            size: AppSizes.customSizeHeight(context, 0.03),
                          ),
                          SizedBox(width: AppSizes.customSizeWidth(context,0.02)),
                          Text(
                            'Ver Resultados',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
