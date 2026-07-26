// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rfcMeta = const VerificationMeta('rfc');
  @override
  late final GeneratedColumn<String> rfc = GeneratedColumn<String>(
    'rfc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correoMeta = const VerificationMeta('correo');
  @override
  late final GeneratedColumn<String> correo = GeneratedColumn<String>(
    'correo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ciudadMeta = const VerificationMeta('ciudad');
  @override
  late final GeneratedColumn<String> ciudad = GeneratedColumn<String>(
    'ciudad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codigoPostalMeta = const VerificationMeta(
    'codigoPostal',
  );
  @override
  late final GeneratedColumn<String> codigoPostal = GeneratedColumn<String>(
    'codigo_postal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _fechaRegistroMeta = const VerificationMeta(
    'fechaRegistro',
  );
  @override
  late final GeneratedColumn<DateTime> fechaRegistro =
      GeneratedColumn<DateTime>(
        'fecha_registro',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<DateTime> fechaActualizacion =
      GeneratedColumn<DateTime>(
        'fecha_actualizacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    nombre,
    rfc,
    telefono,
    correo,
    direccion,
    ciudad,
    estado,
    codigoPostal,
    activo,
    fechaRegistro,
    fechaActualizacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('rfc')) {
      context.handle(
        _rfcMeta,
        rfc.isAcceptableOrUnknown(data['rfc']!, _rfcMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('correo')) {
      context.handle(
        _correoMeta,
        correo.isAcceptableOrUnknown(data['correo']!, _correoMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('ciudad')) {
      context.handle(
        _ciudadMeta,
        ciudad.isAcceptableOrUnknown(data['ciudad']!, _ciudadMeta),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('codigo_postal')) {
      context.handle(
        _codigoPostalMeta,
        codigoPostal.isAcceptableOrUnknown(
          data['codigo_postal']!,
          _codigoPostalMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('fecha_registro')) {
      context.handle(
        _fechaRegistroMeta,
        fechaRegistro.isAcceptableOrUnknown(
          data['fecha_registro']!,
          _fechaRegistroMeta,
        ),
      );
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
        _fechaActualizacionMeta,
        fechaActualizacion.isAcceptableOrUnknown(
          data['fecha_actualizacion']!,
          _fechaActualizacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      rfc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rfc'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      correo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correo'],
      ),
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      ),
      ciudad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ciudad'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      ),
      codigoPostal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_postal'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      fechaRegistro: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_registro'],
      )!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_actualizacion'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String uuid;
  final String nombre;
  final String? rfc;
  final String? telefono;
  final String? correo;
  final String? direccion;
  final String? ciudad;
  final String? estado;
  final String? codigoPostal;
  final bool activo;
  final DateTime fechaRegistro;
  final DateTime fechaActualizacion;
  const Cliente({
    required this.id,
    required this.uuid,
    required this.nombre,
    this.rfc,
    this.telefono,
    this.correo,
    this.direccion,
    this.ciudad,
    this.estado,
    this.codigoPostal,
    required this.activo,
    required this.fechaRegistro,
    required this.fechaActualizacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || rfc != null) {
      map['rfc'] = Variable<String>(rfc);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || correo != null) {
      map['correo'] = Variable<String>(correo);
    }
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || ciudad != null) {
      map['ciudad'] = Variable<String>(ciudad);
    }
    if (!nullToAbsent || estado != null) {
      map['estado'] = Variable<String>(estado);
    }
    if (!nullToAbsent || codigoPostal != null) {
      map['codigo_postal'] = Variable<String>(codigoPostal);
    }
    map['activo'] = Variable<bool>(activo);
    map['fecha_registro'] = Variable<DateTime>(fechaRegistro);
    map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      nombre: Value(nombre),
      rfc: rfc == null && nullToAbsent ? const Value.absent() : Value(rfc),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      correo: correo == null && nullToAbsent
          ? const Value.absent()
          : Value(correo),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      ciudad: ciudad == null && nullToAbsent
          ? const Value.absent()
          : Value(ciudad),
      estado: estado == null && nullToAbsent
          ? const Value.absent()
          : Value(estado),
      codigoPostal: codigoPostal == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoPostal),
      activo: Value(activo),
      fechaRegistro: Value(fechaRegistro),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nombre: serializer.fromJson<String>(json['nombre']),
      rfc: serializer.fromJson<String?>(json['rfc']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      correo: serializer.fromJson<String?>(json['correo']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      ciudad: serializer.fromJson<String?>(json['ciudad']),
      estado: serializer.fromJson<String?>(json['estado']),
      codigoPostal: serializer.fromJson<String?>(json['codigoPostal']),
      activo: serializer.fromJson<bool>(json['activo']),
      fechaRegistro: serializer.fromJson<DateTime>(json['fechaRegistro']),
      fechaActualizacion: serializer.fromJson<DateTime>(
        json['fechaActualizacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'nombre': serializer.toJson<String>(nombre),
      'rfc': serializer.toJson<String?>(rfc),
      'telefono': serializer.toJson<String?>(telefono),
      'correo': serializer.toJson<String?>(correo),
      'direccion': serializer.toJson<String?>(direccion),
      'ciudad': serializer.toJson<String?>(ciudad),
      'estado': serializer.toJson<String?>(estado),
      'codigoPostal': serializer.toJson<String?>(codigoPostal),
      'activo': serializer.toJson<bool>(activo),
      'fechaRegistro': serializer.toJson<DateTime>(fechaRegistro),
      'fechaActualizacion': serializer.toJson<DateTime>(fechaActualizacion),
    };
  }

  Cliente copyWith({
    int? id,
    String? uuid,
    String? nombre,
    Value<String?> rfc = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    Value<String?> correo = const Value.absent(),
    Value<String?> direccion = const Value.absent(),
    Value<String?> ciudad = const Value.absent(),
    Value<String?> estado = const Value.absent(),
    Value<String?> codigoPostal = const Value.absent(),
    bool? activo,
    DateTime? fechaRegistro,
    DateTime? fechaActualizacion,
  }) => Cliente(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    nombre: nombre ?? this.nombre,
    rfc: rfc.present ? rfc.value : this.rfc,
    telefono: telefono.present ? telefono.value : this.telefono,
    correo: correo.present ? correo.value : this.correo,
    direccion: direccion.present ? direccion.value : this.direccion,
    ciudad: ciudad.present ? ciudad.value : this.ciudad,
    estado: estado.present ? estado.value : this.estado,
    codigoPostal: codigoPostal.present ? codigoPostal.value : this.codigoPostal,
    activo: activo ?? this.activo,
    fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      rfc: data.rfc.present ? data.rfc.value : this.rfc,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      correo: data.correo.present ? data.correo.value : this.correo,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      ciudad: data.ciudad.present ? data.ciudad.value : this.ciudad,
      estado: data.estado.present ? data.estado.value : this.estado,
      codigoPostal: data.codigoPostal.present
          ? data.codigoPostal.value
          : this.codigoPostal,
      activo: data.activo.present ? data.activo.value : this.activo,
      fechaRegistro: data.fechaRegistro.present
          ? data.fechaRegistro.value
          : this.fechaRegistro,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('rfc: $rfc, ')
          ..write('telefono: $telefono, ')
          ..write('correo: $correo, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('estado: $estado, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('activo: $activo, ')
          ..write('fechaRegistro: $fechaRegistro, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    nombre,
    rfc,
    telefono,
    correo,
    direccion,
    ciudad,
    estado,
    codigoPostal,
    activo,
    fechaRegistro,
    fechaActualizacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.nombre == this.nombre &&
          other.rfc == this.rfc &&
          other.telefono == this.telefono &&
          other.correo == this.correo &&
          other.direccion == this.direccion &&
          other.ciudad == this.ciudad &&
          other.estado == this.estado &&
          other.codigoPostal == this.codigoPostal &&
          other.activo == this.activo &&
          other.fechaRegistro == this.fechaRegistro &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> nombre;
  final Value<String?> rfc;
  final Value<String?> telefono;
  final Value<String?> correo;
  final Value<String?> direccion;
  final Value<String?> ciudad;
  final Value<String?> estado;
  final Value<String?> codigoPostal;
  final Value<bool> activo;
  final Value<DateTime> fechaRegistro;
  final Value<DateTime> fechaActualizacion;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nombre = const Value.absent(),
    this.rfc = const Value.absent(),
    this.telefono = const Value.absent(),
    this.correo = const Value.absent(),
    this.direccion = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.estado = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaRegistro = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String nombre,
    this.rfc = const Value.absent(),
    this.telefono = const Value.absent(),
    this.correo = const Value.absent(),
    this.direccion = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.estado = const Value.absent(),
    this.codigoPostal = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaRegistro = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  }) : uuid = Value(uuid),
       nombre = Value(nombre);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? nombre,
    Expression<String>? rfc,
    Expression<String>? telefono,
    Expression<String>? correo,
    Expression<String>? direccion,
    Expression<String>? ciudad,
    Expression<String>? estado,
    Expression<String>? codigoPostal,
    Expression<bool>? activo,
    Expression<DateTime>? fechaRegistro,
    Expression<DateTime>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (nombre != null) 'nombre': nombre,
      if (rfc != null) 'rfc': rfc,
      if (telefono != null) 'telefono': telefono,
      if (correo != null) 'correo': correo,
      if (direccion != null) 'direccion': direccion,
      if (ciudad != null) 'ciudad': ciudad,
      if (estado != null) 'estado': estado,
      if (codigoPostal != null) 'codigo_postal': codigoPostal,
      if (activo != null) 'activo': activo,
      if (fechaRegistro != null) 'fecha_registro': fechaRegistro,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? nombre,
    Value<String?>? rfc,
    Value<String?>? telefono,
    Value<String?>? correo,
    Value<String?>? direccion,
    Value<String?>? ciudad,
    Value<String?>? estado,
    Value<String?>? codigoPostal,
    Value<bool>? activo,
    Value<DateTime>? fechaRegistro,
    Value<DateTime>? fechaActualizacion,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nombre: nombre ?? this.nombre,
      rfc: rfc ?? this.rfc,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      estado: estado ?? this.estado,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      activo: activo ?? this.activo,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (rfc.present) {
      map['rfc'] = Variable<String>(rfc.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (correo.present) {
      map['correo'] = Variable<String>(correo.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (ciudad.present) {
      map['ciudad'] = Variable<String>(ciudad.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (codigoPostal.present) {
      map['codigo_postal'] = Variable<String>(codigoPostal.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (fechaRegistro.present) {
      map['fecha_registro'] = Variable<DateTime>(fechaRegistro.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<DateTime>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('rfc: $rfc, ')
          ..write('telefono: $telefono, ')
          ..write('correo: $correo, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('estado: $estado, ')
          ..write('codigoPostal: $codigoPostal, ')
          ..write('activo: $activo, ')
          ..write('fechaRegistro: $fechaRegistro, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final ClienteDao clienteDao = ClienteDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [clientes];
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      required String uuid,
      required String nombre,
      Value<String?> rfc,
      Value<String?> telefono,
      Value<String?> correo,
      Value<String?> direccion,
      Value<String?> ciudad,
      Value<String?> estado,
      Value<String?> codigoPostal,
      Value<bool> activo,
      Value<DateTime> fechaRegistro,
      Value<DateTime> fechaActualizacion,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> nombre,
      Value<String?> rfc,
      Value<String?> telefono,
      Value<String?> correo,
      Value<String?> direccion,
      Value<String?> ciudad,
      Value<String?> estado,
      Value<String?> codigoPostal,
      Value<bool> activo,
      Value<DateTime> fechaRegistro,
      Value<DateTime> fechaActualizacion,
    });

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rfc => $composableBuilder(
    column: $table.rfc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rfc => $composableBuilder(
    column: $table.rfc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get rfc =>
      $composableBuilder(column: $table.rfc, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get correo =>
      $composableBuilder(column: $table.correo, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get ciudad =>
      $composableBuilder(column: $table.ciudad, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get codigoPostal => $composableBuilder(
    column: $table.codigoPostal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaActualizacion => $composableBuilder(
    column: $table.fechaActualizacion,
    builder: (column) => column,
  );
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
          Cliente,
          PrefetchHooks Function()
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> rfc = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> correo = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> ciudad = const Value.absent(),
                Value<String?> estado = const Value.absent(),
                Value<String?> codigoPostal = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> fechaRegistro = const Value.absent(),
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                uuid: uuid,
                nombre: nombre,
                rfc: rfc,
                telefono: telefono,
                correo: correo,
                direccion: direccion,
                ciudad: ciudad,
                estado: estado,
                codigoPostal: codigoPostal,
                activo: activo,
                fechaRegistro: fechaRegistro,
                fechaActualizacion: fechaActualizacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String nombre,
                Value<String?> rfc = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> correo = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> ciudad = const Value.absent(),
                Value<String?> estado = const Value.absent(),
                Value<String?> codigoPostal = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> fechaRegistro = const Value.absent(),
                Value<DateTime> fechaActualizacion = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                uuid: uuid,
                nombre: nombre,
                rfc: rfc,
                telefono: telefono,
                correo: correo,
                direccion: direccion,
                ciudad: ciudad,
                estado: estado,
                codigoPostal: codigoPostal,
                activo: activo,
                fechaRegistro: fechaRegistro,
                fechaActualizacion: fechaActualizacion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
      Cliente,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
}
