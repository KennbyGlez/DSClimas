import 'package:cloud_firestore/cloud_firestore.dart';

class EquiposService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ================================================================
  // REFERENCIA A EQUIPOS
  // ================================================================

  CollectionReference<Map<String, dynamic>> _equipos({
    required String clienteId,
    required String domicilioId,
    required String areaId,
  }) {
    return _firestore
        .collection('Clientes')
        .doc(clienteId)
        .collection('domicilios')
        .doc(domicilioId)
        .collection('areas')
        .doc(areaId)
        .collection('equipos');
  }

  // ================================================================
  // OBTENER EQUIPOS ACTIVOS
  // ================================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> obtenerEquipos({
    required String clienteId,
    required String domicilioId,
    required String areaId,
  }) {
    return _equipos(
      clienteId: clienteId,
      domicilioId: domicilioId,
      areaId: areaId,
    )
        .where('activo', isEqualTo: true)
        .orderBy('nombre')
        .snapshots();
  }

  // ================================================================
  // OBTENER TODOS LOS EQUIPOS
  // ================================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> obtenerTodosLosEquipos({
    required String clienteId,
    required String domicilioId,
    required String areaId,
  }) {
    return _equipos(
      clienteId: clienteId,
      domicilioId: domicilioId,
      areaId: areaId,
    )
        .orderBy('nombre')
        .snapshots();
  }

  // ================================================================
  // CREAR EQUIPO
  // ================================================================

  Future<void> crearEquipo({
    required String clienteId,
    required String domicilioId,
    required String areaId,
    required Map<String, dynamic> datos,
  }) async {
    final ahora = Timestamp.now();

    await _equipos(
      clienteId: clienteId,
      domicilioId: domicilioId,
      areaId: areaId,
    ).add({
      ...datos,

      // Todo equipo nuevo inicia activo
      'activo': datos['activo'] ?? true,

      'fechaCreacion': ahora,
      'fechaActualizacion': ahora,
    });
  }

  // ================================================================
  // ACTUALIZAR EQUIPO
  // ================================================================

  Future<void> actualizarEquipo({
    required String clienteId,
    required String domicilioId,
    required String areaId,
    required String equipoId,
    required Map<String, dynamic> datos,
  }) async {
    await _equipos(
      clienteId: clienteId,
      domicilioId: domicilioId,
      areaId: areaId,
    ).doc(equipoId).update({
      ...datos,
      'fechaActualizacion': Timestamp.now(),
    });
  }

  // ================================================================
  // CAMBIAR ESTADO DEL EQUIPO
  // ================================================================

  Future<void> cambiarEstadoEquipo({
    required String clienteId,
    required String domicilioId,
    required String areaId,
    required String equipoId,
    required bool activo,
  }) async {
    await _equipos(
      clienteId: clienteId,
      domicilioId: domicilioId,
      areaId: areaId,
    ).doc(equipoId).update({
      'activo': activo,
      'fechaActualizacion': Timestamp.now(),
    });
  }

  // ================================================================
  // DESACTIVAR EQUIPO
  // ================================================================

  // ================================================================
// DESACTIVAR EQUIPO
// ================================================================

Future<void> desactivarEquipo({
  required String clienteId,
  required String domicilioId,
  required String areaId,
  required String equipoId,
}) async {
  await _equipos(
    clienteId: clienteId,
    domicilioId: domicilioId,
    areaId: areaId,
  ).doc(equipoId).update({
    'activo': false,
    'fechaActualizacion': Timestamp.now(),
  });
}

  // ================================================================
  // ACTIVAR EQUIPO
  // ================================================================

  Future<void> activarEquipo({
    required String clienteId,
    required String domicilioId,
    required String areaId,
    required String equipoId,
  }) async {
    await cambiarEstadoEquipo(
      clienteId: clienteId,
      domicilioId: domicilioId,
      areaId: areaId,
      equipoId: equipoId,
      activo: true,
    );
  }
}