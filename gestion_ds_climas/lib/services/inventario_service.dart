import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/inventario.dart';

class InventarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================================================================
  // REFERENCIA
  // ================================================================

  CollectionReference<Map<String, dynamic>> get _inventario =>
      _firestore.collection('Inventario');

  // ================================================================
  // OBTENER INVENTARIO ACTIVO
  // ================================================================

 Stream<List<Inventario>> obtenerInventario() {
  return _inventario
      .where('activo', isEqualTo: true)
      .snapshots()
      .map(
        (snapshot) {
          final lista = snapshot.docs
              .map((doc) => Inventario.fromFirestore(doc))
              .toList();

          lista.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(
                  b.nombre.toLowerCase(),
                ),
          );

          return lista;
        },
      );
}
  // ================================================================
  // OBTENER TODO EL INVENTARIO
  // ================================================================

  Stream<List<Inventario>> obtenerTodoElInventario() {
  return _inventario
      .snapshots()
      .map(
        (snapshot) {
          final lista = snapshot.docs
              .map((doc) => Inventario.fromFirestore(doc))
              .toList();

          lista.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(
                  b.nombre.toLowerCase(),
                ),
          );

          return lista;
        },
      );
}

  // ================================================================
  // OBTENER UN PRODUCTO
  // ================================================================

  Future<Inventario?> obtenerPorId(String id) async {
    final doc = await _inventario.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return Inventario.fromFirestore(doc);
  }

  // ================================================================
  // CREAR
  // ================================================================

  Future<String> crearInventario({
    required String nombre,
    required String categoria,
    String? descripcion,
    String? marca,
    String? modelo,
    String? unidad,
    required double cantidad,
    required double stockMinimo,
    double? precio,
    String? ubicacion,
    String? proveedor,
    String? codigo,
    String? notas,
  }) async {
    final ahora = Timestamp.now();

    final doc = await _inventario.add({
      'nombre': nombre.trim(),
      'categoria': categoria,
      'descripcion': _textoOpcional(descripcion),
      'marca': _textoOpcional(marca),
      'modelo': _textoOpcional(modelo),
      'unidad': _textoOpcional(unidad),
      'cantidad': cantidad,
      'stockMinimo': stockMinimo,
      'precio': precio,
      'ubicacion': _textoOpcional(ubicacion),
      'proveedor': _textoOpcional(proveedor),
      'codigo': _textoOpcional(codigo),
      'notas': _textoOpcional(notas),
      'activo': true,
      'fechaCreacion': ahora,
      'fechaActualizacion': ahora,
    });

    return doc.id;
  }

  // ================================================================
  // ACTUALIZAR
  // ================================================================

  Future<void> actualizarInventario({
    required String id,
    required String nombre,
    required String categoria,
    String? descripcion,
    String? marca,
    String? modelo,
    String? unidad,
    required double cantidad,
    required double stockMinimo,
    double? precio,
    String? ubicacion,
    String? proveedor,
    String? codigo,
    String? notas,
  }) async {
    await _inventario.doc(id).update({
      'nombre': nombre.trim(),
      'categoria': categoria,
      'descripcion': _textoOpcional(descripcion),
      'marca': _textoOpcional(marca),
      'modelo': _textoOpcional(modelo),
      'unidad': _textoOpcional(unidad),
      'cantidad': cantidad,
      'stockMinimo': stockMinimo,
      'precio': precio,
      'ubicacion': _textoOpcional(ubicacion),
      'proveedor': _textoOpcional(proveedor),
      'codigo': _textoOpcional(codigo),
      'notas': _textoOpcional(notas),
      'fechaActualizacion': Timestamp.now(),
    });
  }

  // ================================================================
  // CAMBIAR ESTADO
  // ================================================================

  Future<void> cambiarEstadoInventario({
    required String id,
    required bool activo,
  }) async {
    await _inventario.doc(id).update({
      'activo': activo,
      'fechaActualizacion': Timestamp.now(),
    });
  }

  // ================================================================
  // DESACTIVAR
  // ================================================================

  Future<void> desactivarInventario(String id) async {
    await cambiarEstadoInventario(
      id: id,
      activo: false,
    );
  }

  // ================================================================
  // ACTIVAR
  // ================================================================

  Future<void> activarInventario(String id) async {
    await cambiarEstadoInventario(
      id: id,
      activo: true,
    );
  }

  // ================================================================
  // ENTRADA DE INVENTARIO
  // ================================================================

  Future<void> agregarExistencia({
    required String id,
    required double cantidad,
  }) async {
    if (cantidad <= 0) {
      throw Exception('La cantidad debe ser mayor a 0.');
    }

    await _firestore.runTransaction((transaction) async {
      final ref = _inventario.doc(id);

      final snapshot = await transaction.get(ref);

      if (!snapshot.exists) {
        throw Exception('El producto no existe.');
      }

      final data = snapshot.data() ?? {};

      final existenciaActual =
          (data['cantidad'] as num?)?.toDouble() ?? 0;

      transaction.update(ref, {
        'cantidad': existenciaActual + cantidad,
        'fechaActualizacion': Timestamp.now(),
      });
    });
  }

  // ================================================================
  // SALIDA DE INVENTARIO
  // ================================================================

  Future<void> retirarExistencia({
    required String id,
    required double cantidad,
  }) async {
    if (cantidad <= 0) {
      throw Exception('La cantidad debe ser mayor a 0.');
    }

    await _firestore.runTransaction((transaction) async {
      final ref = _inventario.doc(id);

      final snapshot = await transaction.get(ref);

      if (!snapshot.exists) {
        throw Exception('El producto no existe.');
      }

      final data = snapshot.data() ?? {};

      final existenciaActual =
          (data['cantidad'] as num?)?.toDouble() ?? 0;

      if (cantidad > existenciaActual) {
        throw Exception(
          'No hay suficiente existencia disponible.',
        );
      }

      transaction.update(ref, {
        'cantidad': existenciaActual - cantidad,
        'fechaActualizacion': Timestamp.now(),
      });
    });
  }

  // ================================================================
  // PRODUCTOS CON STOCK BAJO
  // ================================================================

  Stream<List<Inventario>> obtenerStockBajo() {
    return obtenerInventario().map(
      (inventarios) => inventarios
          .where(
            (item) => item.cantidad <= item.stockMinimo,
          )
          .toList(),
    );
  }

  // ================================================================
  // BUSCAR
  // ================================================================

  Stream<List<Inventario>> buscarInventario(String texto) {
    final busqueda = texto.trim().toLowerCase();

    return obtenerInventario().map(
      (inventarios) => inventarios.where((item) {
        return item.nombre.toLowerCase().contains(busqueda) ||
            item.categoria.toLowerCase().contains(busqueda) ||
            (item.marca?.toLowerCase().contains(busqueda) ?? false) ||
            (item.modelo?.toLowerCase().contains(busqueda) ?? false) ||
            (item.codigo?.toLowerCase().contains(busqueda) ?? false);
      }).toList(),
    );
  }

  // ================================================================
  // UTILIDAD
  // ================================================================

  String? _textoOpcional(String? valor) {
    if (valor == null) {
      return null;
    }

    final texto = valor.trim();

    if (texto.isEmpty) {
      return null;
    }

    return texto;
  }
}