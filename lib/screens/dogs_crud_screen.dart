import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/perro_model.dart';
import '../services/firestore_service.dart';

class DogsCrudScreen extends StatefulWidget {
  const DogsCrudScreen({super.key});

  @override
  State<DogsCrudScreen> createState() => _DogsCrudScreenState();
}

class _DogsCrudScreenState extends State<DogsCrudScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _nombreController = TextEditingController();
  final _razaController = TextEditingController();
  final _edadController = TextEditingController();
  final _observacionesController = TextEditingController();
  String _nivelObediencia = 'Básico';

  static const Color azulMarino = Color(0xFF002366);
  static const Color dorado = Color(0xFFC5A021);
  static const Color fondoCrema = Color(0xFFF8F9FA);

  void _showDogForm({PerroModel? dog}) {
    if (dog != null) {
      _nombreController.text = dog.nombre;
      _razaController.text = dog.raza;
      _edadController.text = dog.edad;
      _observacionesController.text = dog.observacionesConducta;
      _nivelObediencia = dog.nivelObediencia;
    } else {
      _nombreController.clear();
      _razaController.clear();
      _edadController.clear();
      _observacionesController.clear();
      _nivelObediencia = 'Básico';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                dog == null ? 'Nuevo Alumno Canino' : 'Editar Información',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: azulMarino,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                _nombreController,
                'Nombre del Perro',
                Icons.pets,
              ),
              const SizedBox(height: 16),
              _buildTextField(_razaController, 'Raza', Icons.category),
              const SizedBox(height: 16),
              _buildTextField(_edadController, 'Edad', Icons.cake),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _nivelObediencia,
                decoration: _inputDecoration(
                  'Nivel de Obediencia',
                  Icons.school,
                ),
                items: ['Básico', 'Intermedio', 'Avanzado', 'Experto']
                    .map(
                      (nivel) =>
                          DropdownMenuItem(value: nivel, child: Text(nivel)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _nivelObediencia = val!),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _observacionesController,
                'Observaciones',
                Icons.notes,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    final newDog = PerroModel(
                      id: dog?.id,
                      nombre: _nombreController.text,
                      raza: _razaController.text,
                      edad: _edadController.text,
                      nivelObediencia: _nivelObediencia,
                      observacionesConducta: _observacionesController.text,
                    );

                    if (dog == null) {
                      await _firestoreService.addPerro(newDog);
                    } else {
                      await _firestoreService.updatePerro(dog.id!, newDog);
                    }
                    if (mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulMarino,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    dog == null ? 'Registrar Perro' : 'Guardar Cambios',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(label, icon),
      style: GoogleFonts.montserrat(),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: dorado),
      filled: true,
      fillColor: fondoCrema,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: dorado, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoCrema,
      appBar: AppBar(
        title: Text(
          'Gestión de Alumnos',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: azulMarino,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<PerroModel>>(
        stream: _firestoreService.getPerros(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: dorado),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final dogs = snapshot.data ?? [];
          if (dogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    size: 80,
                    color: azulMarino.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay alumnos registrados',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: azulMarino.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dogs.length,
            itemBuilder: (context, index) {
              final dog = dogs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shadowColor: azulMarino.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: dorado.withValues(alpha: 0.1),
                    child: const Icon(Icons.pets, color: dorado),
                  ),
                  title: Text(
                    dog.nombre,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: azulMarino,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    '${dog.raza} • ${dog.nivelObediencia}',
                    style: GoogleFonts.montserrat(
                      color: azulMarino.withValues(alpha: 0.6),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _detailRow(Icons.cake, 'Edad', dog.edad),
                          const SizedBox(height: 8),
                          _detailRow(
                            Icons.notes,
                            'Observaciones',
                            dog.observacionesConducta,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.edit, color: azulMarino),
                                label: const Text(
                                  'Editar',
                                  style: TextStyle(color: azulMarino),
                                ),
                                onPressed: () => _showDogForm(dog: dog),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Eliminar',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('¿Eliminar registro?'),
                                      content: Text(
                                        '¿Estás seguro de que deseas eliminar a ${dog.nombre}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await _firestoreService.deletePerro(
                                      dog.id!,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDogForm(),
        backgroundColor: dorado,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: dorado),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: azulMarino,
          ),
        ),
        Expanded(
          child: Text(value, style: GoogleFonts.montserrat(color: azulMarino)),
        ),
      ],
    );
  }
}
