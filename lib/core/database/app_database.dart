import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/clientes.dart';
import 'dao/cliente_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Clientes,
  ],
  daos: [
    ClienteDao,
  ],
)
class AppDatabase extends _$AppDatabase {

  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}