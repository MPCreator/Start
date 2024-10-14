import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/providers/answer_provider.dart';
import 'package:start/providers/theme_provider.dart';
import 'package:start/screens/quizzez/clasification_quizz.dart';
import 'package:start/screens/quizzez/external_factors_screen.dart';
import 'package:start/screens/results/answers_summary_screen.dart';
import 'package:start/screens/results/classification_result_screen.dart';
import 'package:start/screens/factor_selector_screen.dart';
import 'package:start/screens/home_screen.dart';
import 'package:start/screens/quizzez/internal_factors_screen.dart';
import 'package:start/screens/results/evaluation_results_screen.dart';


void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AnswerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/classification_questions':
            return MaterialPageRoute(builder: (context) => const ClassificationQuizScreen());
          case '/classification_result':
            final String quizId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ClassificationResultScreen(quizId: quizId),
            );
          case '/factor_selector':
            return MaterialPageRoute(builder: (context) => const FactorSelectorScreen());
          case '/external_factors_questions':
            return MaterialPageRoute(builder: (context) => const ExternalFactorQuizScreen());
          case '/internal_factors_questions':
            return MaterialPageRoute(builder: (context) => const InternalFactorQuizScreen());
          case '/answers_summary':
            final String quizId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => AnswerSummaryScreen(quizId: quizId),
            );
          case '/evaluation_result_screen':
            return MaterialPageRoute(
              builder: (context) => const EvaluationResultScreen(),
            );
          default:
            return null;
        }
      },
    );
  }
}
