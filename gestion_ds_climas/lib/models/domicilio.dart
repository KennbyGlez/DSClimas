import 'package:cloud_firestore/cloud_firestore.dart';

class Domicilio {
  final String id;
  final String tipo;
  final String calle;
  final String numeroExterior;
  final String numeroInterior;
  final String colonia;
  final String codigoPostal;
  final String ciudad;
  final String estado;
  final String referencias;
  final String contacto;
  final int telefono;
  final bool activo;
  final Timestamp? fechaCreacion;
  final Timestamp? fechaActualizacion;

  Domicilio({
    required this.id,
    required this.tipo,
    required this.calle,
    required this.numeroExterior,
    required this.numeroInterior,
    required this.colonia,
    required this.codigoPostal,
    required this.ciudad,
    required this.estado,
    required this.referencias,
    required this.contacto,
    required this.telefono,
    required this.activo,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory Domicilio.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return Domicilio(
      id: id,
      tipo: data['tipo'] ?? '',
      calle: data['calle'] ?? '',
      numeroExterior: data['numeroExterior'] ?? '',
      numeroInterior: data['numeroInterior'] ?? '',
      colonia: data['colonia'] ?? '',
      codigoPostal: data['codigoPostal'] ?? '',
      ciudad: data['ciudad'] ?? '',
      estado: data['estado'] ?? '',
      referencias: data['referencias'] ?? '',
      contacto: data['contacto'] ?? '',
      telefono: data['telefono'] ?? 0,
      activo: data['activo'] ?? true,
      fechaCreacion: data['FechaCreacion'],
      fechaActualizacion: data['FechaActualizacion'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tipo': tipo,
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
      'activo': activo,
      'FechaCreacion': fechaCreacion,
      'FechaActualizacion': fechaActualizacion,
    };
  }
}