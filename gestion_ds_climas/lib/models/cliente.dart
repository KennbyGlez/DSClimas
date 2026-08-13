class Cliente {
  final String id;
  final String nombre;
  final String contactoPrincipal;
  final int telefono;
  final int telefono2;
  final String email;
  final bool activo;
  final String notas;
  final String rfc;
  final String razonSocial;
  final String regimenFiscal;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  Cliente({
    required this.id,
    required this.nombre,
    required this.contactoPrincipal,
    required this.telefono,
    required this.telefono2,
    required this.email,
    required this.activo,
    required this.notas,
    required this.rfc,
    required this.razonSocial,
    required this.regimenFiscal,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory Cliente.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final datosFiscales =
        data['DatosFiscales'] as Map<String, dynamic>? ?? {};

    return Cliente(
      id: id,
      nombre: data['Nombre'] ?? '',
      contactoPrincipal:
          data['contactoPrincipal'] ?? '',
      telefono: _toInt(data['Telefono']),
      telefono2: _toInt(data['Telefono2']),
      email: data['Email'] ?? '',
      activo: data['activo'] ?? true,
      notas: data['notas'] ?? '',
      rfc: datosFiscales['RFC'] ?? '',
      razonSocial:
          datosFiscales['RazonSocial'] ?? '',
      regimenFiscal:
          datosFiscales['RegimenFiscal'] ?? '',
      fechaCreacion:
          (data['FechaCreacion'] as dynamic)?.toDate(),
      fechaActualizacion:
          (data['FechaActualizacion'] as dynamic)?.toDate(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}