import 'package:flutter/material.dart';

import '../models/cliente.dart';
import '../services/cliente_service.dart';
import 'cliente_form_screen.dart';

import '../models/domicilio.dart';
import '../services/domicilio_service.dart';
import 'domicilio_form_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ClienteService _clienteService = ClienteService();

  final TextEditingController _busquedaController =
      TextEditingController();

  final DomicilioService _domicilioService =
    DomicilioService();

  String _busqueda = '';

  @override
  void initState() {
    super.initState();

    _busquedaController.addListener(() {
      setState(() {
        _busqueda = _busquedaController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Cliente> _filtrarClientes(List<Cliente> clientes) {
    if (_busqueda.isEmpty) {
      return clientes;
    }

    return clientes.where((cliente) {
      final nombre = cliente.nombre.toLowerCase();
      final contacto =
          cliente.contactoPrincipal.toLowerCase();
      final email = cliente.email.toLowerCase();
      final telefono = cliente.telefono.toString();

      return nombre.contains(_busqueda) ||
          contacto.contains(_busqueda) ||
          email.contains(_busqueda) ||
          telefono.contains(_busqueda);
    }).toList();
  }

  Future<void> _nuevoCliente() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ClienteFormScreen(),
      ),
    );

    if (resultado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente creado correctamente'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _editarCliente(Cliente cliente) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ClienteFormScreen(
          cliente: cliente,
        ),
      ),
    );

    if (resultado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente actualizado correctamente'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _desactivarCliente(Cliente cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Desactivar cliente'),
          content: Text(
            '¿Deseas desactivar a "${cliente.nombre}"?\n\n'
            'El cliente no se eliminará de la base de datos. '
            'Simplemente dejará de aparecer en la lista de clientes activos.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Desactivar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {
      await _clienteService.desactivarCliente(
        cliente.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente desactivado correctamente'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo desactivar el cliente: $e',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

 void _verCliente(Cliente cliente) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 750,
            maxHeight: 750,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =========================================
                // ENCABEZADO
                // =========================================

                Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor:
                          const Color(0xFFE3F2FD),
                      child: const Icon(
                        Icons.business_outlined,
                        color: Color(0xFF1976D2),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            cliente.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xFF172033),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Información del cliente',
                            style: TextStyle(
                              color:
                                  Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 30),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // =====================================
                        // INFORMACIÓN GENERAL
                        // =====================================

                        const Text(
                          'Información general',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        _DetalleDato(
                          titulo:
                              'Contacto principal',
                          valor: cliente
                                  .contactoPrincipal
                                  .isEmpty
                              ? 'No registrado'
                              : cliente
                                  .contactoPrincipal,
                        ),

                        _DetalleDato(
                          titulo: 'Teléfono',
                          valor: cliente.telefono ==
                                  0
                              ? 'No registrado'
                              : cliente.telefono
                                  .toString(),
                        ),

                        _DetalleDato(
                          titulo: 'Teléfono 2',
                          valor: cliente.telefono2 ==
                                  0
                              ? 'No registrado'
                              : cliente.telefono2
                                  .toString(),
                        ),

                        _DetalleDato(
                          titulo:
                              'Correo electrónico',
                          valor: cliente.email
                                  .isEmpty
                              ? 'No registrado'
                              : cliente.email,
                        ),

                        const Divider(
                          height: 30,
                        ),

                        // =====================================
                        // DATOS FISCALES
                        // =====================================

                        const Text(
                          'Datos fiscales',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        _DetalleDato(
                          titulo: 'RFC',
                          valor: cliente.rfc.isEmpty
                              ? 'No registrado'
                              : cliente.rfc,
                        ),

                        _DetalleDato(
                          titulo:
                              'Razón social',
                          valor: cliente
                                  .razonSocial
                                  .isEmpty
                              ? 'No registrada'
                              : cliente
                                  .razonSocial,
                        ),

                        _DetalleDato(
                          titulo:
                              'Régimen fiscal',
                          valor: cliente
                                  .regimenFiscal
                                  .isEmpty
                              ? 'No registrado'
                              : cliente
                                  .regimenFiscal,
                        ),

                        const Divider(
                          height: 30,
                        ),

                        // =====================================
                        // DOMICILIOS
                        // =====================================

                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    'Domicilios',
                                    style:
                                        TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Ubicaciones del cliente',
                                    style:
                                        TextStyle(
                                      fontSize: 12,
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            FilledButton.icon(
                              onPressed: () async {
                                final resultado =
                                    await Navigator
                                        .push<
                                            bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DomicilioFormScreen(
                                      clienteId:
                                          cliente.id,
                                    ),
                                  ),
                                );

                                if (resultado ==
                                        true &&
                                    context.mounted) {
                                  ScaffoldMessenger
                                      .of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Domicilio agregado correctamente',
                                      ),
                                      behavior:
                                          SnackBarBehavior
                                              .floating,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons
                                    .add_location_alt_outlined,
                              ),
                              label: const Text(
                                'Agregar',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        StreamBuilder<
                            List<Domicilio>>(
                          stream:
                              _domicilioService
                                  .obtenerDomicilios(
                            cliente.id,
                          ),
                          builder:
                              (context, snapshot) {
                            if (snapshot
                                .connectionState ==
                                ConnectionState
                                    .waiting) {
                              return const Padding(
                                padding:
                                    EdgeInsets.all(
                                  30,
                                ),
                                child: Center(
                                  child:
                                      CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return _CajaMensaje(
                                icon: Icons
                                    .error_outline,
                                mensaje:
                                    'No se pudieron cargar los domicilios.',
                                color: Colors.red,
                              );
                            }

                            final domicilios =
                                snapshot.data ?? [];

                            if (domicilios
                                .isEmpty) {
                              return _CajaMensaje(
                                icon: Icons
                                    .location_off_outlined,
                                mensaje:
                                    'Este cliente aún no tiene domicilios registrados.',
                                color: Colors.grey,
                              );
                            }

                            return Column(
                              children:
                                  domicilios.map(
                                (domicilio) {
                                  return _DomicilioCard(
                                    domicilio:
                                        domicilio,
                                    onEditar:
                                        () async {
                                      final resultado =
                                          await Navigator
                                              .push<
                                                  bool>(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  DomicilioFormScreen(
                                            clienteId:
                                                cliente
                                                    .id,
                                            domicilio:
                                                domicilio,
                                          ),
                                        ),
                                      );

                                      if (resultado ==
                                              true &&
                                          context
                                              .mounted) {
                                        ScaffoldMessenger
                                            .of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text(
                                              'Domicilio actualizado correctamente',
                                            ),
                                            behavior:
                                                SnackBarBehavior
                                                    .floating,
                                          ),
                                        );
                                      }
                                    },
                                    onEliminar:
                                        () async {
                                      final confirmar =
                                          await showDialog<
                                              bool>(
                                        context:
                                            context,
                                        builder:
                                            (_) =>
                                                AlertDialog(
                                          title:
                                              const Text(
                                            'Desactivar domicilio',
                                          ),
                                          content:
                                              const Text(
                                            '¿Deseas desactivar este domicilio?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(
                                                context,
                                                false,
                                              ),
                                              child:
                                                  const Text(
                                                'Cancelar',
                                              ),
                                            ),
                                            FilledButton(
                                              style:
                                                  FilledButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                              ),
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(
                                                context,
                                                true,
                                              ),
                                              child:
                                                  const Text(
                                                'Desactivar',
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmar !=
                                          true) {
                                        return;
                                      }

                                      try {
                                        await _domicilioService
                                            .desactivarDomicilio(
                                          clienteId:
                                              cliente
                                                  .id,
                                          domicilioId:
                                              domicilio
                                                  .id,
                                        );

                                        if (!context
                                            .mounted) {
                                          return;
                                        }

                                        ScaffoldMessenger
                                            .of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text(
                                              'Domicilio desactivado',
                                            ),
                                            behavior:
                                                SnackBarBehavior
                                                    .floating,
                                          ),
                                        );
                                      } catch (e) {
                                        if (!context
                                            .mounted) {
                                          return;
                                        }

                                        ScaffoldMessenger
                                            .of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content:
                                                Text(
                                              'Error: $e',
                                            ),
                                            backgroundColor:
                                                Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),

                        if (cliente.notas.isNotEmpty) ...[
                          const Divider(
                            height: 30,
                          ),
                          const Text(
                            'Notas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(cliente.notas),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Align(
                  alignment:
                      Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _editarCliente(cliente);
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    label: const Text('Editar cliente'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        elevation: 0,

        title: const Text(
          'Clientes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevoCliente,
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Nuevo cliente'),
      ),

      body: StreamBuilder<List<Cliente>>(
        stream: _clienteService.obtenerClientes(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorView(
              mensaje:
                  'No se pudieron cargar los clientes.',
              detalle: snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final clientes = snapshot.data ?? [];
          final clientesFiltrados =
              _filtrarClientes(clientes);

          return LayoutBuilder(
            builder: (context, constraints) {
              final esDesktop =
                  constraints.maxWidth >= 900;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: esDesktop ? 40 : 20,
                  vertical: 28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxWidth: 1400,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Administración de clientes',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172033),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Consulta, registra y administra '
                          'los clientes de DS Climas.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 25),

                        _ResumenClientes(
                          total: clientes.length,
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding:
                              const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(18),
                            border: Border.all(
                              color:
                                  const Color(0xFFE5EAF0),
                            ),
                          ),
                          child: TextField(
                            controller:
                                _busquedaController,
                            decoration:
                                InputDecoration(
                              hintText:
                                  'Buscar por nombre, contacto, teléfono o correo...',
                              prefixIcon:
                                  const Icon(
                                Icons.search_rounded,
                              ),
                              suffixIcon:
                                  _busqueda.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            _busquedaController
                                                .clear();
                                          },
                                          icon: const Icon(
                                            Icons
                                                .close_rounded,
                                          ),
                                        )
                                      : null,
                              filled: true,
                              fillColor:
                                  const Color(0xFFF4F7FB),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (clientesFiltrados.isEmpty)
                          _EmptyClientes(
                            buscando:
                                _busqueda.isNotEmpty,
                            onNuevoCliente:
                                _nuevoCliente,
                          )
                        else
                          _ListaClientes(
                            clientes:
                                clientesFiltrados,
                            onVer: _verCliente,
                            onEditar:
                                _editarCliente,
                            onDesactivar:
                                _desactivarCliente,
                          ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ======================================================
// RESUMEN
// ======================================================

class _ResumenClientes extends StatelessWidget {
  final int total;

  const _ResumenClientes({
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.people_outline,
              color: Color(0xFF1976D2),
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Clientes activos',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// LISTA
// ======================================================

class _ListaClientes extends StatelessWidget {
  final List<Cliente> clientes;
  final Function(Cliente) onVer;
  final Function(Cliente) onEditar;
  final Function(Cliente) onDesactivar;

  const _ListaClientes({
    required this.clientes,
    required this.onVer,
    required this.onEditar,
    required this.onDesactivar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: clientes.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1),
        itemBuilder: (context, index) {
          final cliente = clientes[index];

          return _ClienteTile(
            cliente: cliente,
            onVer: () => onVer(cliente),
            onEditar: () => onEditar(cliente),
            onDesactivar:
                () => onDesactivar(cliente),
          );
        },
      ),
    );
  }
}

// ======================================================
// CLIENTE
// ======================================================

class _ClienteTile extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onVer;
  final VoidCallback onEditar;
  final VoidCallback onDesactivar;

  const _ClienteTile({
    required this.cliente,
    required this.onVer,
    required this.onEditar,
    required this.onDesactivar,
  });

  String _formatearTelefono(int telefono) {
    final texto = telefono.toString();

    if (texto.length == 10) {
      return '${texto.substring(0, 3)} '
          '${texto.substring(3, 6)} '
          '${texto.substring(6)}';
    }

    return texto;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onVer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor:
                  const Color(0xFFE3F2FD),
              child: const Icon(
                Icons.business_outlined,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          cliente.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172033),
                          ),
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green
                              .withOpacity(0.10),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Activo',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  if (cliente.contactoPrincipal
                      .isNotEmpty)
                    Text(
                      cliente.contactoPrincipal,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),

                  const SizedBox(height: 7),

                  Wrap(
                    spacing: 16,
                    runSpacing: 5,
                    children: [
                      if (cliente.telefono != 0)
                        Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 15,
                              color:
                                  Colors.grey.shade600,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _formatearTelefono(
                                cliente.telefono,
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                      if (cliente.email.isNotEmpty)
                        Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              Icons
                                  .email_outlined,
                              size: 15,
                              color:
                                  Colors.grey.shade600,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              cliente.email,
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    Colors.grey.shade600,
                              ),
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'ver':
                    onVer();
                    break;

                  case 'editar':
                    onEditar();
                    break;

                  case 'desactivar':
                    onDesactivar();
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'ver',
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                      ),
                      SizedBox(width: 10),
                      Text('Ver cliente'),
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'editar',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                      ),
                      SizedBox(width: 10),
                      Text('Editar'),
                    ],
                  ),
                ),

                PopupMenuDivider(),

                PopupMenuItem(
                  value: 'desactivar',
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .person_off_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Desactivar',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// DETALLE
// ======================================================

class _DetalleDato extends StatelessWidget {
  final String titulo;
  final String valor;

  const _DetalleDato({
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DomicilioCard extends StatelessWidget {
  final Domicilio domicilio;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _DomicilioCard({
    required this.domicilio,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final direccion =
        '${domicilio.calle} ${domicilio.numeroExterior}'
        '${domicilio.numeroInterior.isNotEmpty ? ' Int. ${domicilio.numeroInterior}' : ''}';

    final ubicacion =
        '${domicilio.colonia}, '
        '${domicilio.codigoPostal}, '
        '${domicilio.ciudad}, '
        '${domicilio.estado}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF1976D2),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        domicilio.tipo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF172033),
                        ),
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green
                            .withOpacity(.10),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Activo',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  direccion,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  ubicacion,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),

                if (domicilio.contacto.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 15,
                        color:
                            Colors.grey.shade600,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        domicilio.contacto,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],

                if (domicilio.telefono != 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 15,
                        color:
                            Colors.grey.shade600,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        domicilio.telefono
                            .toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],

                if (domicilio.referencias
                    .isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    'Referencia: ${domicilio.referencias}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'editar') {
                onEditar();
              }

              if (value == 'eliminar') {
                onEliminar();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                    ),
                    SizedBox(width: 10),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Desactivar',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CajaMensaje extends StatelessWidget {
  final IconData icon;
  final String mensaje;
  final Color color;

  const _CajaMensaje({
    required this.icon,
    required this.mensaje,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 42,
            color: color,
          ),

          const SizedBox(height: 10),

          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
// ======================================================
// SIN CLIENTES
// ======================================================

class _EmptyClientes extends StatelessWidget {
  final bool buscando;
  final VoidCallback onNuevoCliente;

  const _EmptyClientes({
    required this.buscando,
    required this.onNuevoCliente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 25,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            buscando
                ? Icons.search_off_rounded
                : Icons.people_outline,
            size: 55,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          Text(
            buscando
                ? 'No encontramos clientes'
                : 'Aún no tienes clientes',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            buscando
                ? 'Intenta con otro nombre, teléfono o correo.'
                : 'Comienza registrando tu primer cliente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          if (!buscando) ...[
            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onNuevoCliente,
              icon: const Icon(
                Icons.person_add_alt_1,
              ),
              label: const Text(
                'Registrar cliente',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ======================================================
// ERROR
// ======================================================

class _ErrorView extends StatelessWidget {
  final String mensaje;
  final String detalle;

  const _ErrorView({
    required this.mensaje,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 55,
              color: Colors.red,
            ),

            const SizedBox(height: 15),

            Text(
              mensaje,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              detalle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}