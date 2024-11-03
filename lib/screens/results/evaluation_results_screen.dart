import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/utils/sizes.dart';
import '../../models/answers.dart';
import '../../providers/answer_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/classification_evaluation_service.dart';
import '../../services/factors_evaluation_service.dart';
import '../../services/gemini_service.dart';

class EvaluationResultScreen extends StatefulWidget {
  const EvaluationResultScreen({super.key});

  @override
  _EvaluationResultScreenState createState() => _EvaluationResultScreenState();
}

class _EvaluationResultScreenState extends State<EvaluationResultScreen> {
  String evaluationResult = '';
  String phaseResult = '';
  List<Answer>? answers;
  Future<String>? futureEvaluationResult;
  late Future<String?> futureInterpretation;
  late List<dynamic> updatedJsonList;
  String? cachedInterpretation;

  @override
  void initState() {
    super.initState();

    // Ejecutamos la lógica después de que el widget se haya inicializado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final answerProvider = Provider.of<AnswerProvider>(context, listen: false);

      // Obtener respuestas de los quizzes
      String jsonAnswersExternal = answerProvider.getAnswersAsJson('external_factors_quiz');
      String jsonAnswersInternal = answerProvider.getAnswersAsJson('internal_factors_quiz');

      // Combinar ambas respuestas en un solo JSON
      String combinedJson = '${jsonAnswersExternal.substring(0, jsonAnswersExternal.length - 1)},${jsonAnswersInternal.substring(1)}';
      List<dynamic> jsonList = json.decode(combinedJson);
      const quizId = "RespuestasTotales";

      // Limpiar las respuestas previas en el provider para este quizId
      answerProvider.clearAnswers(quizId);

      // Iterar sobre el jsonList y agregar las respuestas al AnswerProvider
      for (var json in jsonList) {
        String id = json['id'];
        String questionText = json['question'];
        String? answer = json['answer'];
        String? parentId = json['parentQuestionId'];

        // Agregar las respuestas al provider usando addAnswers
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

      // Crear la instancia del servicio de evaluación con el provider
      final FactorsEvaluationService evaluationService = FactorsEvaluationService(answerProvider: answerProvider);
      final ClassificationEvaluationService classificationService = ClassificationEvaluationService();


      // Evaluar las respuestas de manera asíncrona y actualizar el estado
      futureEvaluationResult = evaluationService.determinarExito(quizId);
      futureEvaluationResult!.then((result) {
        setState(() {
          evaluationResult = result;
          answers = answerProvider.getAnswers(quizId);
          phaseResult = classificationService.determinarFase(answers!);
          // Obtener las respuestas actualizadas en formato JSON
          String updatedAnswersJson = answerProvider.getAnswersAsJson(quizId);
          updatedJsonList = json.decode(updatedAnswersJson);

          // Ahora pasa el jsonList actualizado a fetchGeminiInterpretations
          futureInterpretation = fetchGeminiInterpretations(updatedJsonList);
          futureInterpretation.then((interpretation) {
            setState(() {
              cachedInterpretation = interpretation;
            });
          });
        });
      });
    });
  }


  // Función que construye el prompt y obtiene la interpretación de Gemini
  Future<String?> fetchGeminiInterpretations(List<dynamic> answers) async {

    log(jsonEncode(answers));

    final prompt1 = '''
    Por favor, interpreta brevemente las respuestas proporcionadas para las respuestas positivas y negativas en 1 párrafo corto cada una: $answers.
    ''';

    final prompt2 = '''En base a las respuestas negativas brindadas por una startup: $answers. Dame una recomendación de mejora para ellas; además, considera que para las siguientes preguntas debes añadir estas métricas en tus respuestas.
    Si la pregunta es ¿Tiene alguna métrica de medición de satisfacción del cliente en su startup? debes recomendarle que es recomendable tener indicadores de rendimiento que permitan conocer la satisfacción del cliente, además de indicadores como el ingreso promedio por usuario, la tasa de abandono de clientes y el valor de vida del cliente.
    Si la pregunta es ¿Su startup tiene financiamiento (Propia/externa)? debes recomendarlo este sitio oficial del estado peruano en el que se listan todos los concursos de financiamiento existentes en el Perú https://calendario.proinnovate.gob.pe/
    Si la pregunta es ¿Está siendo incubado en alguna incubadora de empresas? debes recomendarle este directorio de todas las incubadoras del Perú https://startup.proinnovate.gob.pe/wp-content/uploads/2021/12/20122021-Directorio-Incubadoras-y-Aceleradoras-Red-ProInnovate-2021.pdf
    Si la pregunta es ¿El ecosistema actual de su startup presenta factores de innovación y emprendimiento que hayan sido útiles para su desarrollo? debes recomendable incluir los siguientes factores de innovación Conciencia Empresarial y Motivación, Educación y Formación, Necesidad de Logro, Decisiones Empresariales, Capacidades de Innovación Estratégica, Dinámicas de Innovación y Emprendimiento en el Ámbito Académico
    Si la pregunta es ¿Tiene experiencia en creación de empresas? recomendarle los siguientes cursos gratuitos del estado https://mtpe.trabajo.gob.pe/capacitacionlaboral/como-emprender/ https://www.gob.pe/tuempresa

    Si la pregunta es ¿Cuenta con habilidades técnicas y empresariales? recomendarle tener en cuenta los siguientes tipos de habilidades empresariales: personales, interpersonales y grupales

    Si la pregunta es ¿Tiene experiencia en la gestión empresarial? recomendarle los siguientes cursos https://www.udemy.com/es/courses/business/management/ 
    https://usil.edu.pe/posgrado/educacion-ejecutiva/gestion-y-emprendimiento/administracion-y-gestion-de-empresas 
    https://www.esan.edu.pe/pee/empresarial/gestion-y-finanzas-para-startups-emprendedores/308
    Si la pregunta es ¿Ha recibido o está recibiendo apoyo gubernamental (Económico, Tutoría, etc)? recomendar los siguientes concursos de apoyo al emprendedor  https://startup.proinnovate.gob.pe/ 

    https://www.cofide.com.pe/apoyo_mipyme.php

    Si la pregunta es ¿Los productos/servicios que están planteando son innovadores? recomendar tomar en cuenta las siguientes Clases de innovación:
    -de producto
    -de proceso
    -de organización
    -de marketing

    Tipos:
    -Radical
    -incremental
    -arquitectural
    -conceptual

    Si la pregunta es ¿Qué tanto influyen las políticas estatales científicas y tecnológicas en tu start up? recomendar el enlace a la ley del joven emprendedor https://busquedas.elperuano.pe/dispositivo/NL/2195233-1

    Solo dame las recomendaciones de las respuestas negativas, si la respuesta es positiva no
    Para las preguntas que no especifiqué, usa tu criterio para recomendar''';

    final geminiResponse1 = await fetchGeminiResponse(prompt1);
    final geminiResponse2 = await fetchGeminiResponse(prompt2);
    final combinedResponse = '$geminiResponse1\n$geminiResponse2';
    print(combinedResponse);

    return combinedResponse;
  }

  Future<void> _saveEvaluationResults(String phase, String evaluation, List<Answer> combinedAnswers, String recommendations) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("Usuario no autenticado");
      return;
    }

    // Formatear las respuestas y recomendaciones en el formato Firestore
    List<Map<String, dynamic>> answersList = combinedAnswers.map((answer) => answer.toMap()).toList();

    // Crea un nuevo mapa para el cuestionario con la fecha obtenida localmente
    Map<String, dynamic> newQuestionnaire = {
      'fase': phase,
      'respuestas': answersList,
      'evaluacion': evaluation,
      'recomendaciones': recommendations,
      'fecha': DateTime.now(),
    };

    try {
      // Agrega el nuevo cuestionario al historial usando arrayUnion
      await FirebaseFirestore.instance.collection('usuarios').doc(currentUser.uid).update({
        'historial_cuestionarios': FieldValue.arrayUnion([newQuestionnaire]),
      });
      print("Cuestionario agregado al historial exitosamente.");
    } catch (e) {
      print("Error al guardar los resultados de la evaluación: $e");
    }
  }





  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Resultado de Evaluación")),
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
            Center(
              child: FutureBuilder<String>(
                future: futureEvaluationResult,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Evaluación de la Startup: ${snapshot.data}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSizes.mediumSpace(context)),
                          FutureBuilder<String?>(
                            future: futureInterpretation,
                            builder: (context, interpretationSnapshot) {
                              if (interpretationSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (interpretationSnapshot.hasError) {
                                return Text('Error: ${interpretationSnapshot.error}');
                              } else if (interpretationSnapshot.hasData && interpretationSnapshot.data != null) {
                                return Text(
                                  interpretationSnapshot.data!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                );
                              } else {
                                return const Text('No se pudo obtener la interpretación.');
                              }
                            },
                          ),
                          SizedBox(height: AppSizes.customSizeHeight(context, 0.02)),
                          ElevatedButton(
                            onPressed: () async {
                              String? recommendations = cachedInterpretation ?? await fetchGeminiInterpretations(updatedJsonList);
                              await _saveEvaluationResults(phaseResult ,evaluationResult, answers!, recommendations!);
                              Navigator.pushNamed(context, '/factor_selector');
                            },
                            child: const Text("Finalizar"),
                          ),

                        ],
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
