import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/clientes.dart';


part 'cliente_dao.g.dart';


@DriftAccessor(
  tables: [
    Clientes,
  ],
)

class ClienteDao extends DatabaseAccessor<AppDatabase>
    with _$ClienteDaoMixin {

  ClienteDao(AppDatabase db) : super(db);


  Future<List<Cliente>> obtenerClientes() {
    return select(clientes).get();
  }


  Future<int> insertarCliente(
      ClientesCompanion cliente) {

    return into(clientes).insert(cliente);
  }


  Future<bool> actualizarCliente(
      ClientesCompanion cliente) {

    return update(clientes)
        .replace(cliente);
  }


  Future<int> eliminarCliente(
      int id) {

    return (delete(clientes)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

}