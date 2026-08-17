import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/areas.dart';

class AreasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _areasRef({
    required String clienteId,
    required String domicilioId,
  }) {
    return _db
        .collection('Clientes')
        .doc(clienteId)
        .collection('domicilios')
        .doc(domicilioId)
        .collection('areas');
  }

  // CREAR
  Future<String> crearArea({
    required String clienteId,
    required String domicilioId,
    required String nombre,
    String descripcion = '',
  }) async {
    try {
      final areaRef = _areasRef(
        clienteId: clienteId,
        domicilioId: domicilioId,
      ).doc();

      await areaRef.set({
        'nombre': nombre.trim(),
        'descripcion': descripcion.trim(),
        'activo': true,
        'fechaCreacion': FieldValue.serverTimestamp(),
        'fechaActualizacion': FieldValue.serverTimestamp(),
      });

      return areaRef.id;
    } catch (e) {
      throw Exception('Error al crear el área: $e');
    }
  }

  // OBTENER EN TIEMPO REAL
  Stream<QuerySnapshot<Map<String, dynamic>>> obtenerAreas({
    required String clienteId,
    required String domicilioId,
  }) {
    return _areasRef(
      clienteId: clienteId,
      domicilioId: domicilioId,
    ).orderBy('nombre').snapshots();
  }

  // OBTENER UNA
  Future<DocumentSnapshot<Map<String, dynamic>>> obtenerArea({
    required String clienteId,
    required String domicilioId,
    required String areaId,
  }) async {
    try {
      return await _areasRef(
        clienteId: clienteId,
        domicilioId: domicilioId,
      ).doc(areaId).get();
    } catch (e) {
      throw Exception('Error al obtener el área: $e');
    }
  }

  // ACTUALIZAR
  Future<void> actualizarArea({
    required String clienteId,
    required String domicilioId,
    required String areaId,
    required String nombre,
    String descripcion = '',
    bool? activo,
  }) async {
    try {
      final Map<String, dynamic> datos = {
        'nombre': nombre.trim(),
        'descripcion': descripcion.trim(),
        'fechaActualizacion': FieldValue.serverTimestamp(),
      };

      if (activo != null) {
        datos['activo'] = activo;
      }

      await _areasRef(
        clienteId: clienteId,
        domicilioId: domicilioId,
      ).doc(areaId).update(datos);
    } catch (e) {
      throw Exception('Error al actualizar el área: $e');
    }
  }

  // ELIMINAR
  Future<void> eliminarArea({
    required String clienteId,
    required String domicilioId,
    required String areaId,
  }) async {
    try {
      await _areasRef(
        clienteId: clienteId,
        domicilioId: domicilioId,
      ).doc(areaId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el área: $e');
    }
  }

  // ACTIVAR / DESACTIVAR
  Future<void> cambiarEstadoArea({
    required String clienteId,
    required String domicilioId,
    required String areaId,
    required bool activo,
  }) async {
    try {
      await _areasRef(
        clienteId: clienteId,
        domicilioId: domicilioId,
      ).doc(areaId).update({
        'activo': activo,
        'fechaActualizacion': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al cambiar el estado del área: $e');
    }
  }
}