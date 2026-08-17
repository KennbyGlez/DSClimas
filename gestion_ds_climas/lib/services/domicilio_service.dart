import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/domicilio.dart';

class DomicilioService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      _domicilios(String clienteId) {
    return _firestore
        .collection('Clientes')
        .doc(clienteId)
        .collection('domicilios');
  }

  // ==========================================
  // OBTENER DOMICILIOS
  // ==========================================

  Stream<List<Domicilio>> obtenerDomicilios(
    String clienteId,
  ) {
    return _domicilios(clienteId)
        .where('activo', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Domicilio.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  // ==========================================
  // OBTENER UN DOMICILIO
  // ==========================================

  Future<Domicilio?> obtenerDomicilio({
    required String clienteId,
    required String domicilioId,
  }) async {
    final doc = await _domicilios(clienteId)
        .doc(domicilioId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return Domicilio.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }

  // ==========================================
  // CREAR DOMICILIO
  // ==========================================

  Future<String> crearDomicilio({
    required String clienteId,
    required String tipo,
    required String nombre,
    required String calle,
    required String numeroExterior,
    required String numeroInterior,
    required String colonia,
    required String codigoPostal,
    required String ciudad,
    required String estado,
    required String referencias,
    required String contacto,
    required int telefono,
  }) async {
    final ahora = Timestamp.now();

    final referencia =
        await _domicilios(clienteId).add({
      'tipo': tipo,
      'nombre': nombre,
      'calle': calle,
      'numeroExterior': numeroExterior,
      'numeroInterior': numeroInterior,
      'colonia': colonia,
      'codigoPostal': codigoPostal,
      'ciudad': ciudad,
      'estado': estado,
      'referencias': referencias,
      'contacto': contacto,
      'telefono': telefono,
      'activo': true,
      'FechaCreacion': ahora,
      'FechaActualizacion': ahora,
    });

    return referencia.id;
  }

  // ==========================================
  // ACTUALIZAR DOMICILIO
  // ==========================================

  Future<void> actualizarDomicilio({
    required String clienteId,
    required String domicilioId,
    required String tipo,
    required String nombre,
    required String calle,
    required String numeroExterior,
    required String numeroInterior,
    required String colonia,
    required String codigoPostal,
    required String ciudad,
    required String estado,
    required String referencias,
    required String contacto,
    required int telefono,
  }) async {
    await _domicilios(clienteId)
        .doc(domicilioId)
        .update({
      'tipo': tipo,
      'nombre': nombre,
      'calle': calle,
      'numeroExterior': numeroExterior,
      'numeroInterior': numeroInterior,
      'colonia': colonia,
      'codigoPostal': codigoPostal,
      'ciudad': ciudad,
      'estado': estado,
      'referencias': referencias,
      'contacto': contacto,
      'telefono': telefono,
      'FechaActualizacion': Timestamp.now(),
    });
  }

  // ==========================================
  // DESACTIVAR
  // ==========================================

  Future<void> desactivarDomicilio({
    required String clienteId,
    required String domicilioId,
  }) async {
    await _domicilios(clienteId)
        .doc(domicilioId)
        .update({
      'activo': false,
      'FechaActualizacion': Timestamp.now(),
    });
  }

  // ==========================================
  // REACTIVAR
  // ==========================================

  Future<void> reactivarDomicilio({
    required String clienteId,
    required String domicilioId,
  }) async {
    await _domicilios(clienteId)
        .doc(domicilioId)
        .update({
      'activo': true,
      'FechaActualizacion': Timestamp.now(),
    });
  }
}