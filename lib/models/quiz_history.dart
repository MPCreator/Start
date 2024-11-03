import 'package:cloud_firestore/cloud_firestore.dart';

import 'answers.dart';

class HistorialCuestionarios {
  final String evaluacion;
  final String fase;
  final DateTime fecha;
  final String recomendaciones;
  final List<Answer> respuestas;

  HistorialCuestionarios({
    required this.evaluacion,
    required this.fase,
    required this.fecha,
    required this.recomendaciones,
    required this.respuestas,
  });

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'evaluacion': evaluacion,
      'fase': fase,
      'fecha': fecha,
      'recomendaciones': recomendaciones,
      'respuestas': respuestas.map((r) => r.toMap()).toList(),
    };
  }

  factory HistorialCuestionarios.fromMap(Map<String, dynamic> map) {

    final Timestamp fechaTimestamp = map['fecha'] as Timestamp;
    final DateTime fecha = fechaTimestamp.toDate();

    final List<Answer> respuestasList = (map['respuestas'] as List<dynamic>?)
        ?.whereType<Map<String, dynamic>>()
        .map((item) => Answer.fromMap(item))
        .toList() ?? [];

    return HistorialCuestionarios(
      evaluacion: map['evaluacion'] ?? '',
      fase: map['fase'] ?? '',
      fecha: fecha,
      recomendaciones: map['recomendaciones'] ?? '',
      respuestas: respuestasList,
    );
  }


}
