import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  final String id;
  final String clienteId;
  final String domicilioId;
  final String nombre;
  final String descripcion;
  final bool activo;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  Area({
    required this.id,
    required this.clienteId,
    required this.domicilioId,
    required this.nombre,
    this.descripcion = '',
    this.activo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Area.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Area(
      id: id,
      clienteId: map['clienteId'] ?? '',
      domicilioId: map['domicilioId'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      activo: map['activo'] ?? true,
      createdAt: map['createdAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'domicilioId': domicilioId,
      'nombre': nombre,
      'descripcion': descripcion,
      'activo': activo,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Area copyWith({
    String? id,
    String? clienteId,
    String? domicilioId,
    String? nombre,
    String? descripcion,
    bool? activo,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Area(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      domicilioId: domicilioId ?? this.domicilioId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}