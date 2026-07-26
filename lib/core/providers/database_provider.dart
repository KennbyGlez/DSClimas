import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/dao/cliente_dao.dart';
import '../database/repositories/cliente_repository.dart';



final databaseProvider =
    Provider<AppDatabase>((ref){

  return AppDatabase();

});




final clienteDaoProvider =
    Provider<ClienteDao>((ref){

  final database =
      ref.watch(databaseProvider);


  return ClienteDao(database);

});




final clienteRepositoryProvider =
    Provider<ClienteRepository>((ref){

  final dao =
      ref.watch(clienteDaoProvider);


  return ClienteRepository(dao);

});