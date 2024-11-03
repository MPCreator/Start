class Recomendaciones {
  final String mensaje;

  Recomendaciones({
    required this.mensaje,
  });

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'mensaje': mensaje,
    };
  }

  // Crear instancia desde un Map
  factory Recomendaciones.fromMap(Map<String, dynamic> map) {
    return Recomendaciones(
      mensaje: map['mensaje'] ?? '',
    );
  }
}
