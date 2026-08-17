import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/areas_service.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SERVICIO DE ÁREAS
  final AreasService _areasService = AreasService();

  String? _clienteId;
  String? _domicilioId;

  Map<String, dynamic>? _clienteSeleccionado;
  Map<String, dynamic>? _domicilioSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Servicios',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 20,
              vertical: 25,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1400,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gestión de servicios',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Selecciona un cliente y un domicilio para administrar sus áreas.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildSeleccionCard(isDesktop),

                    const SizedBox(height: 25),

                    if (_clienteId != null && _domicilioId != null)
                      _buildAreasCard()
                    else
                      _buildEmptyState(),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton:
          (_clienteId != null && _domicilioId != null)
              ? FloatingActionButton.extended(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    _mostrarFormularioArea();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva área'),
                )
              : null,
    );
  }

  // ================================================================
  // SELECCIÓN
  // ================================================================

  Widget _buildSeleccionCard(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildClienteDropdown(),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: _buildDomicilioDropdown(),
                ),
              ],
            )
          : Column(
              children: [
                _buildClienteDropdown(),

                const SizedBox(height: 20),

                _buildDomicilioDropdown(),
              ],
            ),
    );
  }

  // ================================================================
  // CLIENTES
  // ================================================================

  Widget _buildClienteDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Clientes')
          .orderBy('Nombre')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget(
            'Error al cargar los clientes',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _dropdownLoading(
            'Cargando clientes...',
          );
        }

        final clientes = snapshot.data?.docs ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cliente',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _clienteId,

              decoration: InputDecoration(
                hintText: 'Selecciona un cliente',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF1976D2),
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5EAF0),
                  ),
                ),
              ),

              items: clientes.map((doc) {
                final data =
                    doc.data() as Map<String, dynamic>;

                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text(
                    data['Nombre']?.toString() ??
                        'Sin nombre',
                  ),
                );
              }).toList(),

              onChanged: (value) {
                if (value == null) return;

                final doc = clientes.firstWhere(
                  (element) => element.id == value,
                );

                setState(() {
                  _clienteId = value;

                  _clienteSeleccionado =
                      doc.data()
                          as Map<String, dynamic>;

                  _domicilioId = null;
                  _domicilioSeleccionado = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // DOMICILIOS
  // ================================================================

  Widget _buildDomicilioDropdown() {
    if (_clienteId == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Domicilio',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),

                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(width: 12),

                Text(
                  'Primero selecciona un cliente',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Clientes')
          .doc(_clienteId)
          .collection('domicilios')
          .orderBy('nombre')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget(
            'Error al cargar los domicilios',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _dropdownLoading(
            'Cargando domicilios...',
          );
        }

        final domicilios =
            snapshot.data?.docs ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Domicilio',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _domicilioId,

              decoration: InputDecoration(
                hintText: domicilios.isEmpty
                    ? 'Este cliente no tiene domicilios'
                    : 'Selecciona un domicilio',

                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF1976D2),
                ),

                filled: true,
                fillColor: const Color(0xFFF8FAFC),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5EAF0),
                  ),
                ),
              ),

              items: domicilios.map((doc) {
                final data =
                    doc.data() as Map<String, dynamic>;

                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text(
                    data['nombre']?.toString() ??
                        'Sin nombre',
                  ),
                );
              }).toList(),

              onChanged: domicilios.isEmpty
                  ? null
                  : (value) {
                      if (value == null) return;

                      final doc =
                          domicilios.firstWhere(
                        (element) =>
                            element.id == value,
                      );

                      setState(() {
                        _domicilioId = value;

                        _domicilioSeleccionado =
                            doc.data()
                                as Map<String, dynamic>;
                      });
                    },
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // ÁREAS
  // ================================================================

  Widget _buildAreasCard() {
    final clienteNombre =
        _clienteSeleccionado?['nombre']
                ?.toString() ??
            'Cliente';

    final domicilioNombre =
        _domicilioSeleccionado?['nombre']
                ?.toString() ??
            'Domicilio';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.meeting_room_outlined,
                  color: Color(0xFF1976D2),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Áreas del domicilio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '$clienteNombre • $domicilioNombre',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'Nueva área',
                onPressed: () {
                  _mostrarFormularioArea();
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ==========================================================
          // AQUÍ USAMOS AreasService
          // ==========================================================

          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _areasService.obtenerAreas(
              clienteId: _clienteId!,
              domicilioId: _domicilioId!,
            ),

            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _errorWidget(
                  'Error al cargar las áreas: ${snapshot.error}',
                );
              }

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final areas =
                  snapshot.data?.docs ?? [];

              if (areas.isEmpty) {
                return _areasEmptyState();
              }

              return Column(
                children: areas.map((doc) {
                  final data = doc.data();

                  return _areaTile(
                    doc.id,
                    data,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ITEM ÁREA
  // ================================================================

  Widget _areaTile(
    String areaId,
    Map<String, dynamic> data,
  ) {
    final nombre =
        data['nombre']?.toString() ??
            'Sin nombre';

    final descripcion =
        data['descripcion']?.toString() ?? '';

    final activo =
        data['activo'] ?? true;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),

        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.room_outlined,
            color: Color(0xFF1976D2),
          ),
        ),

        title: Text(
          nombre,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            if (descripcion.isNotEmpty)
              Text(descripcion),

            Text(
              activo
                  ? 'Área activa'
                  : 'Área inactiva',
              style: TextStyle(
                color: activo
                    ? Colors.green
                    : Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ACTIVAR / DESACTIVAR
            Switch(
              value: activo,
              activeColor:
                  const Color(0xFF1976D2),
              onChanged: (value) {
                _cambiarEstadoArea(
                  areaId,
                  value,
                );
              },
            ),

            // EDITAR
            IconButton(
              tooltip: 'Editar',
              onPressed: () {
                _mostrarFormularioArea(
                  areaId: areaId,
                  nombreActual: nombre,
                  descripcionActual:
                      descripcion,
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF1976D2),
              ),
            ),

            // ELIMINAR
            IconButton(
              tooltip: 'Eliminar',
              onPressed: () {
                _confirmarEliminarArea(
                  areaId,
                  nombre,
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CREAR / EDITAR
  // ================================================================

  Future<void> _mostrarFormularioArea({
    String? areaId,
    String? nombreActual,
    String? descripcionActual,
  }) async {
    final nombreController =
        TextEditingController(
      text: nombreActual ?? '',
    );

    final descripcionController =
        TextEditingController(
      text: descripcionActual ?? '',
    );

    final esEdicion = areaId != null;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: Text(
            esEdicion
                ? 'Editar área'
                : 'Nueva área',
          ),

          content: SizedBox(
            width: 450,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  autofocus: true,

                  decoration: InputDecoration(
                    labelText: 'Nombre del área',
                    hintText:
                        'Ej. Recámara principal',
                    prefixIcon: const Icon(
                      Icons.meeting_room_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller:
                      descripcionController,

                  maxLines: 3,

                  decoration: InputDecoration(
                    labelText:
                        'Descripción',
                    hintText:
                        'Descripción del área (opcional)',
                    prefixIcon: const Icon(
                      Icons.description_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancelar',
              ),
            ),

            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1976D2),
                foregroundColor:
                    Colors.white,
              ),

              onPressed: () {
                _guardarArea(
                  dialogContext,
                  nombreController,
                  descripcionController,
                  areaId,
                );
              },

              icon: Icon(
                esEdicion
                    ? Icons.save_outlined
                    : Icons.add,
              ),

              label: Text(
                esEdicion
                    ? 'Guardar cambios'
                    : 'Crear área',
              ),
            ),
          ],
        );
      },
    );

    nombreController.dispose();
    descripcionController.dispose();
  }

  // ================================================================
  // GUARDAR ÁREA USANDO AreasService
  // ================================================================

  Future<void> _guardarArea(
    BuildContext dialogContext,
    TextEditingController nombreController,
    TextEditingController descripcionController,
    String? areaId,
  ) async {
    final nombre =
        nombreController.text.trim();

    final descripcion =
        descripcionController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(dialogContext)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Escribe el nombre del área.',
          ),
        ),
      );

      return;
    }

    if (_clienteId == null ||
        _domicilioId == null) {
      return;
    }

    try {
      // ==========================================================
      // CREAR
      // ==========================================================

      if (areaId == null) {
        await _areasService.crearArea(
          clienteId: _clienteId!,
          domicilioId: _domicilioId!,
          nombre: nombre,
          descripcion: descripcion,
        );
      }

      // ==========================================================
      // EDITAR
      // ==========================================================

      else {
        await _areasService.actualizarArea(
          clienteId: _clienteId!,
          domicilioId: _domicilioId!,
          areaId: areaId,
          nombre: nombre,
          descripcion: descripcion,
        );
      }

      if (!dialogContext.mounted) {
        return;
      }

      Navigator.pop(dialogContext);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            areaId == null
                ? 'Área creada correctamente.'
                : 'Área actualizada correctamente.',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!dialogContext.mounted) {
        return;
      }

      ScaffoldMessenger.of(dialogContext)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error al guardar el área: $e',
          ),
        ),
      );
    }
  }

  // ================================================================
  // CAMBIAR ESTADO
  // ================================================================

  Future<void> _cambiarEstadoArea(
    String areaId,
    bool activo,
  ) async {
    if (_clienteId == null ||
        _domicilioId == null) {
      return;
    }

    try {
      await _areasService.cambiarEstadoArea(
        clienteId: _clienteId!,
        domicilioId: _domicilioId!,
        areaId: areaId,
        activo: activo,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            activo
                ? 'Área activada.'
                : 'Área desactivada.',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error al cambiar el estado: $e',
          ),
        ),
      );
    }
  }

  // ================================================================
  // CONFIRMAR ELIMINACIÓN
  // ================================================================

  Future<void> _confirmarEliminarArea(
    String areaId,
    String nombre,
  ) async {
    final confirmar =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: const Text(
            'Eliminar área',
          ),

          content: Text(
            '¿Seguro que deseas eliminar "$nombre"?\n\n'
            'Esta acción no se puede deshacer.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),

            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor:
                    Colors.white,
              ),

              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },

              icon: const Icon(
                Icons.delete_outline,
              ),

              label: const Text(
                'Eliminar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    await _eliminarArea(areaId);
  }

  // ================================================================
  // ELIMINAR USANDO AreasService
  // ================================================================

  Future<void> _eliminarArea(
    String areaId,
  ) async {
    if (_clienteId == null ||
        _domicilioId == null) {
      return;
    }

    try {
      await _areasService.eliminarArea(
        clienteId: _clienteId!,
        domicilioId: _domicilioId!,
        areaId: areaId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Área eliminada correctamente.',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el área: $e',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ================================================================
  // ESTADO VACÍO
  // ================================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_searching_outlined,
            size: 55,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          const Text(
            'Selecciona un cliente y un domicilio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Aquí aparecerán las áreas del domicilio.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SIN ÁREAS
  // ================================================================

  Widget _areasEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.meeting_room_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          const Text(
            'No hay áreas registradas',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Agrega la primera área de este domicilio.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 18),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF1976D2),
              foregroundColor:
                  Colors.white,
            ),

            onPressed: () {
              _mostrarFormularioArea();
            },

            icon: const Icon(Icons.add),

            label: const Text(
              'Agregar área',
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // LOADING
  // ================================================================

  Widget _dropdownLoading(String texto) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Cargando',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          height: 56,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                texto,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================================================================
  // ERROR
  // ================================================================

  Widget _errorWidget(String mensaje) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              mensaje,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}