import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_history.dart';
import 'historial_detalle_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("No se ha autenticado ningún usuario"));
    }

    // Referencia al documento del usuario en lugar de una colección anidada
    final userDocument = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Cuestionarios"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userDocument.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No hay historial disponible"));
          }

          // Extraer el campo `historial_cuestionarios` como una lista
          final List<dynamic> historialData = snapshot.data!.get('historial_cuestionarios') ?? [];

          if (historialData.isEmpty) {
            return const Center(child: Text("No hay historial disponible"));
          }

          // Mapear cada entrada de la lista a un objeto `HistorialCuestionarios`
          final List<HistorialCuestionarios> historialList = historialData
              .map((data) => HistorialCuestionarios.fromMap(data as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: historialList.length,
            itemBuilder: (context, index) {
              final historial = historialList[index];
              return Card(
                child: ListTile(
                  title: Text("Evaluación: ${historial.evaluacion}"),
                  subtitle: Text("Fecha: ${historial.fecha}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistorialDetalleScreen(historial: historial),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
