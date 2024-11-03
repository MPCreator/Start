import 'package:flutter/material.dart';

import '../models/quiz_history.dart';

class HistorialDetalleScreen extends StatelessWidget {
  final HistorialCuestionarios historial;

  const HistorialDetalleScreen({super.key, required this.historial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Historial"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Evaluación: ${historial.evaluacion}", style: const TextStyle(fontSize: 18)),
                Text("Fase: ${historial.fase}", style: const TextStyle(fontSize: 18)),
                Text("Fecha: ${historial.fecha}", style: const TextStyle(fontSize: 18)),
                const Divider(),
                Text("Recomendaciones: ${historial.recomendaciones}", style: const TextStyle(fontSize: 18)),
                const Divider(),
                const Text("Respuestas:", style: TextStyle(fontSize: 18)),
                ...historial.respuestas.map((resp) => Text(
                    "Pregunta: ${resp.question} - Respuesta: ${resp.answer} - Evaluación: ${resp.evaluation}"))
                    ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
