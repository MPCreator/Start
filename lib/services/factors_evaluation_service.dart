import '../providers/answer_provider.dart';
import 'gemini_service.dart';

class FactorsEvaluationService {

  final AnswerProvider answerProvider;

  FactorsEvaluationService({required this.answerProvider});

  // Método para determinar la fase basado en una lista de respuestas
  Future<String> determinarExito(String quizId) async {
    final answers = answerProvider.getAnswers(quizId);
    int score = 0;

    for (var answer in answers!) {
      final question = answer.question;
      final response = answer.answer;

      switch (question) {
      // Externos (60 pts)
        case "¿Tiene alguna métrica de medición de satisfacción del cliente en su startup?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          }
          else{
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "¿Según su métrica de satisfacción del cliente, cuán satisfecho está su cliente?":
          switch (response) {
            case 'Nada satisfecho':
              score += 0;
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            case 'Poco satisfecho':
              score += 1;
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            case 'Neutro':
              score += 2;
              answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
              break;
            case 'Satisfecho':
              score += 3;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Muy Satisfecho':
              score += 5;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            default:
              break;
          }
          break;

        case "¿Su startup tiene financiamiento (Propia/externa)?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "Seleccione en qué categoría de financiación se encuentra su startup.":
          switch (response) {
            case 'Ahorros':
              score += 1;
              answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
              break;
            case 'Inversores privados':
              score += 2;
              answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
              break;
            case 'Inversores profesionales':
              score += 4;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Salida a bolsa':
              score += 5;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            default:
              break;
          }
          break;

        case "¿Está siendo incubado en alguna incubadora de empresas?":
          if (response == 'Sí') {
            score += 10;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "¿Ha recibido o está recibiendo apoyo gubernamental (Económico, Tutoría, etc)?":
          if (response == 'Sí') {
            score += 10;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "¿En dónde se encuentra ubicada tu start up?":
          if (response == 'Nacional') {
            score += 10;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
          }
          break;

        case "¿Qué tanto influyen las políticas estatales científicas y tecnológicas en tu start up?":
          print(question);
          switch (response) {
            case 'Casi nada de influencia':
              score += 10;
              print('Score incrementado en 10 por la pregunta: "$question"');
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Muy poca influencia':
              score += 8;
              print('Score incrementado en 8 por la pregunta: "$question"');
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Influencia media':
              score += 5;
              print('Score incrementado en 5 por la pregunta: "$question"');
              answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
              break;
            case 'Elevada influencia':
              score += 2;
              print('Score incrementado en 2 por la pregunta: "$question"');
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            case 'Dependencia':
              score += 0;
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            default:
              break;
          }
          break;

      // Internos (120 pts)
        case "¿El ecosistema actual de su start up presenta factores de innovación y emprendimiento que hayan sido útiles para su desarrollo?":
          if (response == 'Sí') {
            score += 10;
            print('Score incrementado en 10 por la pregunta: "$question"');
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;
        case "¿Su start up ha sido capaz de adecuarse a los cambios? Mencione un ejemplo.":

          final prompt1 =
              'La pregunta fue: "$question"; y su respuesta fue: "$response". Evalúa si la respuesta cumple con la pregunta. Las respuestas que puedes darme son únicamente, \'Sí\' o \'No\'';

          final geminiResponse1 = await fetchGeminiResponse(prompt1);
          print ("Respuesta 1: $geminiResponse1");
          if (geminiResponse1 == "Sí") {
            score += 10;
             answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }

          break;

        case "¿Su start up busca la innovación?":
          if (response == 'Sí') {
            score += 10;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "¿Tiene experiencia en el sector?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;
        case "¿Tiene experiencia en creación de empresas?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;
        case "¿Cuenta con habilidades técnicas y empresariales?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;
        case "¿Tiene experiencia en Investigación & Desarrollo?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "¿Tiene experiencia en la gestión empresarial?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;
        case "¿Cuánta?":
          switch (response) {
            case 'Muy baja':
              score += 1;
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            case 'Baja':
              score += 2;
              answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
              break;
            case 'Aceptable':
              score += 3;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Considerable':
              score += 4;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Elevada':
              score += 5;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            default:
              break;
          }
          break;


        case "¿Su start up presenta liderazgo empresarial? Mencione un ejemplo.":

          final prompt =
              'La pregunta fue: "$question"; y su respuesta fue: "$response". Evalúa si la respuesta cumple con la pregunta. Las respuestas que puedes darme son únicamente, \'Sí\' o \'No\'';
          final geminiResponse2 = await fetchGeminiResponse(prompt);
          print ("Respuesta 2: $geminiResponse2");
          if (geminiResponse2 == "Sí") {
            score += 10;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }

          break;

        case "¿Qué tanta motivación tenía al crear su start up?":
          switch (response) {
            case 'Sin motivación':
              score += 1;
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            case 'Poca motivación':
              score += 2;
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            case 'Motivación moderada':
              score += 3;
              answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
              break;
            case 'Considerable motivación':
              score += 4;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Elevada motivación':
              score += 5;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            default:
              break;
          }
          break;

        case "¿Los productos/servicios que están planteando son innovadores?":
          if (response == 'Sí') {
            score += 5;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "Defina en qué radica su diferenciación.":
          final prompt3 =
              'La pregunta fue: "¿Los productos/servicios que están planteando son innovadores?" "$question"; y su respuesta fue: "$response". Evalúa si la respuesta cumple con la pregunta. Las respuestas que puedes darme son únicamente, \'Sí\' o \'No\'';

          final geminiResponse3 = await fetchGeminiResponse(prompt3);
          print ("Respuesta 3: $geminiResponse3");
          if (geminiResponse3 == "Sí") {
            score += 10;
            answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
          } else {
            answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
          }
          break;

        case "¿Qué tanta cultura empresarial hay en su start up?":
          switch (response) {
            case 'Nada de cultura':
              score += 0;
              answerProvider.updateEvaluation(quizId, answer.id, 'Negativa');
              break;
            case 'Baja cultura':
              score += 2;
              answerProvider.updateEvaluation(quizId, answer.id, 'Neutra');
              break;
            case 'Intermedia cultura':
              score += 5;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Considerable cultura':
              score += 8;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            case 'Alta cultura':
              score += 10;
              answerProvider.updateEvaluation(quizId, answer.id, 'Positiva');
              break;
            default:
              break;
          }
          break;

        default:
          break;
      }
    }

    print("Evaluación terminada: $score");
    if (score >= 144) return "Éxito Alto";
    if (score >= 108) return "Éxito Moderado";
    if (score >= 72) return "Éxito Bajo";
    if (score >= 36) return "Éxito muy bajo";
    return "Éxito nulo";
  }
}
