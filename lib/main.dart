import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/providers/answer_provider.dart';
import 'package:start/providers/theme_provider.dart';
import 'package:start/screens/auth/login_screen.dart';
import 'package:start/screens/auth/register_screen.dart';
import 'package:start/screens/historial_screen.dart';
import 'package:start/screens/main_screen.dart';
import 'package:start/screens/quizzez/clasification_quizz.dart';
import 'package:start/screens/quizzez/external_factors_screen.dart';
import 'package:start/screens/results/answers_summary_screen.dart';
import 'package:start/screens/results/classification_result_screen.dart';
import 'package:start/screens/factor_selector_screen.dart';
import 'package:start/screens/home_screen.dart';
import 'package:start/screens/quizzez/internal_factors_screen.dart';
import 'package:start/screens/results/evaluation_results_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AnswerProvider()),
      ],
      child: const MyApp(),
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
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => const RegisterScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/main':
            return MaterialPageRoute(builder: (context) => const MainScreen());
          case '/historial':
            return MaterialPageRoute(builder: (context) => const HistorialScreen());
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
