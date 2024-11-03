
import '../models/answers.dart';

class ClassificationEvaluationService {
  String determinarFase(List<Answer> answers) {
    double totalScore = 0.0;

    // Evaluar las respuestas
    for (var answer in answers) {

      final question = answer.question;
      final response = answer.answer;

      switch (question) {
        case "¿La startup cuenta con un producto o servicio mínimamente viable (MVP)?":
          totalScore += (response == 'Sí') ? 3 : 0;
          break;
        case "¿Su startup ha comenzado a comercializar el producto o servicio en el mercado?":
          totalScore += (response == 'Sí') ? 2 : 0;
          break;
        case "¿La empresa ha generado ingresos?":
          totalScore += (response == 'Sí') ? 4 : 0;
          break;
        case "¿Cuál es el nivel de recurrencia de los ingresos?":
          if (response == 'Recurrente con ingresos altos') {
            totalScore += 5;
          } else if (response == 'Recurrente con ingresos moderados') totalScore += 3;
          else if (response == 'Recurrente con ingresos bajos') totalScore += 2;
          else totalScore += 0;
          break;
        case "¿Cuántos empleados tiene actualmente la startup?":
          if (response == 'Más de 50') {
            totalScore += 3;
          } else if (response == 'Entre 11 y 50') totalScore += 2;
          else totalScore += 1;
          break;
        case "¿La empresa ha validado su producto o servicio en el mercado con pruebas de concepto?":
          totalScore += (response == 'Sí') ? 3 : 0;
          break;
        case "¿Cuál es el mayor tipo de financiación que ha recibido la empresa hasta ahora?":
          if (response == 'Salida a bolsa') {
            totalScore += 4;
          } else if (response == 'Inversores Profesionales') totalScore += 3;
          else if (response == 'Inversores Privados') totalScore += 2;
          else totalScore += 1;
          break;
        case "¿Está la empresa en proceso de escalar su producto o servicio en nuevos mercados o segmentos?":
          totalScore += (response == 'Sí') ? 4 : 0;
          break;
        case "¿Cuenta la empresa con una base de clientes estable y en crecimiento?":
          totalScore += (response == 'Sí') ? 5 : 0;
          break;
        case "¿Está en proceso de una salida a bolsa para captar financiación?":
          totalScore += (response == 'Sí') ? 5 : 0;
          break;
        default:
          break;
      }
    }

    // Determinar la fase con el conteo máximo
    if (totalScore < 10) {
      return "Semilla";
    } else if (totalScore <= 19) {
      return "Temprana";
    } else if (totalScore < 29) {
      return "Crecimiento";
    } else {
      return "Expansión";
    }
  }
}
