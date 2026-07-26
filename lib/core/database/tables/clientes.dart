import 'package:drift/drift.dart';

class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid => text().unique()();

  TextColumn get nombre => text()();

  TextColumn get rfc => text().nullable()();

  TextColumn get telefono => text().nullable()();

  TextColumn get correo => text().nullable()();

  TextColumn get direccion => text().nullable()();

  TextColumn get ciudad => text().nullable()();

  TextColumn get estado => text().nullable()();

  TextColumn get codigoPostal => text().nullable()();

  BoolColumn get activo =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get fechaRegistro =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaActualizacion =>
      dateTime().withDefault(currentDateAndTime)();
}