class Equipo {
  final String id;
  final String tipo;
  final String nombre;
  final String marca;
  final String modelo;
  final String numeroSerie;

  final double? voltajeL1;
  final double? voltajeL2;
  final double? voltajeL3;

  final double? amperajeL1;
  final double? amperajeL2;
  final double? amperajeL3;

  final String? tipoAire;
  final double? capacidad;
  final String? refrigerante;

  final String? tipoCamara;
  final double? largo;
  final double? ancho;
  final double? alto;
  final double? temperaturaOperacion;

  final String? tipoMaquina;
  final double? produccionHielo;
  final double? capacidadAlmacenamiento;
  final String? tipoHielo;

  final bool activo;
  final String observaciones;

  Equipo({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    this.voltajeL1,
    this.voltajeL2,
    this.voltajeL3,
    this.amperajeL1,
    this.amperajeL2,
    this.amperajeL3,
    this.tipoAire,
    this.capacidad,
    this.refrigerante,
    this.tipoCamara,
    this.largo,
    this.ancho,
    this.alto,
    this.temperaturaOperacion,
    this.tipoMaquina,
    this.produccionHielo,
    this.capacidadAlmacenamiento,
    this.tipoHielo,
    required this.activo,
    required this.observaciones,
  });

  factory Equipo.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return Equipo(
      id: id,
      tipo: data['tipo'] ?? '',
      nombre: data['nombre'] ?? '',
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      numeroSerie: data['numeroSerie'] ?? '',

      voltajeL1: (data['voltajeL1'] as num?)?.toDouble(),
      voltajeL2: (data['voltajeL2'] as num?)?.toDouble(),
      voltajeL3: (data['voltajeL3'] as num?)?.toDouble(),

      amperajeL1: (data['amperajeL1'] as num?)?.toDouble(),
      amperajeL2: (data['amperageL2'] as num?)?.toDouble(),
      amperajeL3: (data['amperageL3'] as num?)?.toDouble(),

      tipoAire: data['tipoAire'],
      capacidad: (data['capacidad'] as num?)?.toDouble(),
      refrigerante: data['refrigerante'],

      tipoCamara: data['tipoCamara'],
      largo: (data['largo'] as num?)?.toDouble(),
      ancho: (data['ancho'] as num?)?.toDouble(),
      alto: (data['alto'] as num?)?.toDouble(),
      temperaturaOperacion:
          (data['temperaturaOperacion'] as num?)?.toDouble(),

      tipoMaquina: data['tipoMaquina'],
      produccionHielo:
          (data['produccionHielo'] as num?)?.toDouble(),
      capacidadAlmacenamiento:
          (data['capacidadAlmacenamiento'] as num?)?.toDouble(),
      tipoHielo: data['tipoHielo'],

      activo: data['activo'] ?? true,
      observaciones: data['observaciones'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'nombre': nombre,
      'marca': marca,
      'modelo': modelo,
      'numeroSerie': numeroSerie,

      'voltajeL1': voltajeL1,
      'voltajeL2': voltajeL2,
      'voltajeL3': voltajeL3,

      'amperajeL1': amperajeL1,
      'amperageL2': amperajeL2,
      'amperageL3': amperajeL3,

      'tipoAire': tipoAire,
      'capacidad': capacidad,
      'refrigerante': refrigerante,

      'tipoCamara': tipoCamara,
      'largo': largo,
      'ancho': ancho,
      'alto': alto,
      'temperaturaOperacion': temperaturaOperacion,

      'tipoMaquina': tipoMaquina,
      'produccionHielo': produccionHielo,
      'capacidadAlmacenamiento': capacidadAlmacenamiento,
      'tipoHielo': tipoHielo,

      'activo': activo,
      'observaciones': observaciones,
    };
  }
}