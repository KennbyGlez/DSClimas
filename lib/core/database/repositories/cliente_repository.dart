import 'package:drift/drift.dart';

import '../app_database.dart';
import '../dao/cliente_dao.dart';
import '../tables/clientes.dart';

class ClienteRepository {

  final ClienteDao dao;


  ClienteRepository(this.dao);



  Future<List<Cliente>> obtenerClientes() {

    return dao.obtenerClientes();

  }



  Future<int> crearCliente({
    required String uuid,
    required String nombre,
    String? telefono,
    String? correo,
    String? direccion,
  }) {


    final cliente = ClientesCompanion.insert(

      uuid: uuid,

      nombre: nombre,

      telefono: Value(telefono),

      correo: Value(correo),

      direccion: Value(direccion),

    );


    return dao.insertarCliente(cliente);

  }




  Future<bool> actualizarCliente(
      ClientesCompanion cliente) {

    return dao.actualizarCliente(cliente);

  }



  Future<int> eliminarCliente(int id){

    return dao.eliminarCliente(id);

  }


}