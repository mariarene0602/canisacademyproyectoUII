import 'package:cloud_firestore/cloud_firestore.dart';

class PerroModel {
  final String? id;
  final String nombre;
  final String raza;
  final String edad;
  final String nivelObediencia;
  final String observacionesConducta;

  PerroModel({
    this.id,
    required this.nombre,
    required this.raza,
    required this.edad,
    required this.nivelObediencia,
    required this.observacionesConducta,
  });

  factory PerroModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PerroModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      raza: data['raza'] ?? '',
      edad: data['edad'] ?? '',
      nivelObediencia: data['nivel_obediencia'] ?? 'Básico',
      observacionesConducta: data['observaciones_conducta'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'raza': raza,
      'edad': edad,
      'nivel_obediencia': nivelObediencia,
      'observaciones_conducta': observacionesConducta,
    };
  }
}
