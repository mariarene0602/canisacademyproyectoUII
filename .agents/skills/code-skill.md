# 💻 Skill de Código - Canis Academia

Estándares técnicos para la gestión de perros en entrenamiento.

## Arquitectura

- **Models**: `PerroModel` con los campos:
  - `nombre`: Nombre del perro.
  - `raza`: Raza o mezcla.
  - `edad`: En años o meses.
  - `nivel_obediencia`: (Básico, Intermedio, Avanzado).
  - `observaciones_conducta`: Notas sobre comportamiento o agresividad.
- **Services**: `FirestoreService` gestionando la colección `perros`.

## Operaciones CRUD

- ✅ **CREATE**: Alta de nuevos perros al iniciar un programa de entrenamiento.
- ✅ **READ**: Listado de alumnos con filtros por nivel de obediencia.
- ✅ **UPDATE**: Actualización del progreso conductual y cambio de nivel.
- ✅ **DELETE**: Baja de registros (graduación o retiro).

## Reglas de Implementación

- El campo `nivel_obediencia` debe ser un valor seleccionado de una lista cerrada.
- Las `observaciones_conducta` deben permitir texto largo (multiline).
