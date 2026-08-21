import 'package:cloud_firestore/cloud_firestore.dart';

class Inventario {
  final String id;
  final String nombre;
  final String categoria;
  final String? descripcion;
  final String? marca;
  final String? modelo;
  final String? unidad;
  final double cantidad;
  final double stockMinimo;
  final double? precio;
  final String? ubicacion;
  final String? proveedor;
  final String? codigo;
  final String? notas;
  final bool activo;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  Inventario({
    required this.id,
    required this.nombre,
    required this.categoria,
    this.descripcion,
    this.marca,
    this.modelo,
    this.unidad,
    required this.cantidad,
    required this.stockMinimo,
    this.precio,
    this.ubicacion,
    this.proveedor,
    this.codigo,
    this.notas,
    required this.activo,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  // ================================================================
  // FIRESTORE -> MODELO
  // ================================================================

  factory Inventario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return Inventario(
      id: doc.id,
      nombre: data['nombre']?.toString() ?? '',
      categoria: data['categoria']?.toString() ?? '',
      descripcion: data['descripcion']?.toString(),
      marca: data['marca']?.toString(),
      modelo: data['modelo']?.toString(),
      unidad: data['unidad']?.toString(),
      cantidad: _toDouble(data['cantidad']),
      stockMinimo: _toDouble(data['stockMinimo']),
      precio: _toNullableDouble(data['precio']),
      ubicacion: data['ubicacion']?.toString(),
      proveedor: data['proveedor']?.toString(),
      codigo: data['codigo']?.toString(),
      notas: data['notas']?.toString(),
      activo: data['activo'] ?? true,
      fechaCreacion: _toDateTime(data['fechaCreacion']),
      fechaActualizacion: _toDateTime(data['fechaActualizacion']),
    );
  }

  // ================================================================
  // MODELO -> FIRESTORE
  // ================================================================

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'categoria': categoria,
      'descripcion': descripcion,
      'marca': marca,
      'modelo': modelo,
      'unidad': unidad,
      'cantidad': cantidad,
      'stockMinimo': stockMinimo,
      'precio': precio,
      'ubicacion': ubicacion,
      'proveedor': proveedor,
      'codigo': codigo,
      'notas': notas,
      'activo': activo,
      'fechaCreacion': fechaCreacion != null
          ? Timestamp.fromDate(fechaCreacion!)
          : null,
      'fechaActualizacion': fechaActualizacion != null
          ? Timestamp.fromDate(fechaActualizacion!)
          : null,
    };
  }

  // ================================================================
  // CONVERSORES
  // ================================================================

  static double _toDouble(dynamic valor) {
    if (valor == null) return 0;

    if (valor is num) {
      return valor.toDouble();
    }

    return double.tryParse(valor.toString()) ?? 0;
  }

  static double? _toNullableDouble(dynamic valor) {
    if (valor == null) return null;

    if (valor is num) {
      return valor.toDouble();
    }

    return double.tryParse(valor.toString());
  }

  static DateTime? _toDateTime(dynamic valor) {
    if (valor == null) return null;

    if (valor is Timestamp) {
      return valor.toDate();
    }

    if (valor is DateTime) {
      return valor;
    }

    return null;
  }

  // ================================================================
  // COPIA
  // ================================================================

  Inventario copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? descripcion,
    String? marca,
    String? modelo,
    String? unidad,
    double? cantidad,
    double? stockMinimo,
    double? precio,
    String? ubicacion,
    String? proveedor,
    String? codigo,
    String? notas,
    bool? activo,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Inventario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      unidad: unidad ?? this.unidad,
      cantidad: cantidad ?? this.cantidad,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      precio: precio ?? this.precio,
      ubicacion: ubicacion ?? this.ubicacion,
      proveedor: proveedor ?? this.proveedor,
      codigo: codigo ?? this.codigo,
      notas: notas ?? this.notas,
      activo: activo ?? this.activo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion:
          fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}