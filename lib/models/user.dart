import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:start/models/quiz_history.dart';

class UserModel {
  final String id;
  final String nombre;
  final String email;
  final String password;
  final List<HistorialCuestionarios> historialCuestionarios;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.historialCuestionarios,
  });

  // Método para convertir un DocumentSnapshot de Firestore a UserModel
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;

    final List<HistorialCuestionarios> historialList = (data['historial_cuestionarios'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => HistorialCuestionarios.fromMap(item))
        .toList();

    return UserModel(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      historialCuestionarios: historialList,
    );
  }

  // Método para convertir el modelo a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'password': password,
      'historial_cuestionarios': historialCuestionarios.map((item) => item.toMap()).toList(),
    };
  }
}
