import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cliente.dart';

class ClienteService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _clientes =>
          _firestore.collection('Clientes');

  // ==============================
  // OBTENER CLIENTES
  // ==============================

  Stream<List<Cliente>> obtenerClientes({
  bool incluirInactivos = false,
}) {
  final usuario = FirebaseAuth.instance.currentUser;

/*   print('====================================');
  print('PRUEBA FIREBASE');
  print('Email: ${usuario?.email}');
  print('UID: ${usuario?.uid}');
  print('===================================='); */

  return _clientes.snapshots().map(
    (snapshot) {
      //print('CLIENTES ENCONTRADOS: ${snapshot.docs.length}');

      for (final doc in snapshot.docs) {
       // print('ID: ${doc.id}');
       // print('DATOS: ${doc.data()}');
      }

      return snapshot.docs.map(
        (doc) {
          return Cliente.fromFirestore(
            doc.id,
            doc.data(),
          );
        },
      ).toList();
    },
  );
}
  // ==============================
  // OBTENER UN CLIENTE
  // ==============================

  Future<Cliente?> obtenerCliente(
    String id,
  ) async {
    final doc = await _clientes.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return Cliente.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }

  // ==============================
  // CREAR CLIENTE
  // ==============================

  Future<String> crearCliente({
    required String nombre,
    required String contactoPrincipal,
    required int telefono,
    required int telefono2,
    required String email,
    required String notas,
    required String rfc,
    required String razonSocial,
    required String regimenFiscal,
  }) async {
    final ahora = Timestamp.now();

    final referencia = await _clientes.add({
      'Nombre': nombre,
      'contactoPrincipal': contactoPrincipal,
      'Telefono': telefono,
      'Telefono2': telefono2,
      'Email': email,
      'activo': true,
      'notas': notas,

      'DatosFiscales': {
        'RFC': rfc,
        'RazonSocial': razonSocial,
        'RegimenFiscal': regimenFiscal,
      },

      'FechaCreacion': ahora,
      'FechaActualizacion': ahora,
    });

    return referencia.id;
  }

  // ==============================
  // ACTUALIZAR CLIENTE
  // ==============================

  Future<void> actualizarCliente({
    required String id,
    required String nombre,
    required String contactoPrincipal,
    required int telefono,
    required int telefono2,
    required String email,
    required String notas,
    required String rfc,
    required String razonSocial,
    required String regimenFiscal,
  }) async {
    await _clientes.doc(id).update({
      'Nombre': nombre,
      'contactoPrincipal': contactoPrincipal,
      'Telefono': telefono,
      'Telefono2': telefono2,
      'Email': email,
      'notas': notas,

      'DatosFiscales': {
        'RFC': rfc,
        'RazonSocial': razonSocial,
        'RegimenFiscal': regimenFiscal,
      },

      'FechaActualizacion':
          Timestamp.now(),
    });
  }

  // ==============================
  // DESACTIVAR CLIENTE
  // ==============================

  Future<void> desactivarCliente(
    String id,
  ) async {
    await _clientes.doc(id).update({
      'activo': false,
      'FechaActualizacion':
          Timestamp.now(),
    });
  }

  // ==============================
  // REACTIVAR CLIENTE
  // ==============================

  Future<void> reactivarCliente(
    String id,
  ) async {
    await _clientes.doc(id).update({
      'activo': true,
      'FechaActualizacion':
          Timestamp.now(),
    });
  }
}