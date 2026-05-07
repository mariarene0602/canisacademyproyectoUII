import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/perro_model.dart';

class FirestoreService {
  final CollectionReference _perrosCollection =
      FirebaseFirestore.instance.collection('perros');

  // CREATE - Alta de nuevos perros al iniciar un programa de entrenamiento
  Future<void> addPerro(PerroModel perro) async {
    await _perrosCollection.add(perro.toMap());
  }

  // READ - Listado de alumnos con filtros por nivel de obediencia
  Stream<List<PerroModel>> getPerros() {
    return _perrosCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PerroModel.fromFirestore(doc))
          .toList();
    });
  }

  // READ - Búsqueda por nombre de perro
  Stream<List<PerroModel>> searchPerros(String query) {
    return _perrosCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PerroModel.fromFirestore(doc))
          .where((perro) =>
              perro.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // UPDATE - Actualización del progreso conductual y cambio de nivel
  Future<void> updatePerro(String id, PerroModel perro) async {
    await _perrosCollection.doc(id).update(perro.toMap());
  }

  // DELETE - Baja de registros (graduación o retiro)
  Future<void> deletePerro(String id) async {
    await _perrosCollection.doc(id).delete();
  }
}
