import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/areas_service.dart';
import '../services/equipos_service.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SERVICIO DE ÁREAS
  final AreasService _areasService = AreasService();
  final EquiposService _equiposService = EquiposService();

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
              style: TextStyle(fontWeight: FontWeight.bold),
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
                constraints: const BoxConstraints(maxWidth: 1400),
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

      floatingActionButton: (_clienteId != null && _domicilioId != null)
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
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildClienteDropdown()),

                const SizedBox(width: 20),

                Expanded(child: _buildDomicilioDropdown()),
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
      stream: _firestore.collection('Clientes').orderBy('Nombre').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget('Error al cargar los clientes');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _dropdownLoading('Cargando clientes...');
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
                  borderSide: const BorderSide(color: Color(0xFFE5EAF0)),
                ),
              ),

              items: clientes.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text(data['Nombre']?.toString() ?? 'Sin nombre'),
                );
              }).toList(),

              onChanged: (value) {
                if (value == null) return;

                final doc = clientes.firstWhere(
                  (element) => element.id == value,
                );

                setState(() {
                  _clienteId = value;

                  _clienteSeleccionado = doc.data() as Map<String, dynamic>;

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

                Icon(Icons.location_on_outlined, color: Colors.grey.shade400),

                const SizedBox(width: 12),

                Text(
                  'Primero selecciona un cliente',
                  style: TextStyle(color: Colors.grey.shade500),
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
          return _errorWidget('Error al cargar los domicilios');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _dropdownLoading('Cargando domicilios...');
        }

        final domicilios = snapshot.data?.docs ?? [];

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
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5EAF0)),
                ),
              ),

              items: domicilios.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text(data['nombre']?.toString() ?? 'Sin nombre'),
                );
              }).toList(),

              onChanged: domicilios.isEmpty
                  ? null
                  : (value) {
                      if (value == null) return;

                      final doc = domicilios.firstWhere(
                        (element) => element.id == value,
                      );

                      setState(() {
                        _domicilioId = value;

                        _domicilioSeleccionado =
                            doc.data() as Map<String, dynamic>;
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
        _clienteSeleccionado?['nombre']?.toString() ?? 'Cliente';

    final domicilioNombre =
        _domicilioSeleccionado?['nombre']?.toString() ?? 'Domicilio';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF0)),
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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.meeting_room_outlined,
                  color: Color(0xFF1976D2),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final areas = snapshot.data?.docs ?? [];

              if (areas.isEmpty) {
                return _areasEmptyState();
              }

              return Column(
                children: areas.map((doc) {
                  final data = doc.data();

                  return _areaTile(doc.id, data);
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

  Widget _areaTile(String areaId, Map<String, dynamic> data) {
    final nombre = data['nombre']?.toString() ?? 'Sin nombre';

    final descripcion = data['descripcion']?.toString() ?? '';

    final activo = data['activo'] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),

      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),

          child: const Icon(Icons.room_outlined, color: Color(0xFF1976D2)),
        ),

        title: Text(
          nombre,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (descripcion.isNotEmpty) Text(descripcion),

            const SizedBox(height: 3),

            Text(
              activo ? 'Área activa' : 'Área inactiva',

              style: TextStyle(
                color: activo ? Colors.green : Colors.red,

                fontSize: 12,
              ),
            ),
          ],
        ),

        trailing: PopupMenuButton<String>(
          tooltip: 'Opciones',

          onSelected: (opcion) {
            if (opcion == 'editar') {
              _mostrarFormularioArea(
                areaId: areaId,
                nombreActual: nombre,
                descripcionActual: descripcion,
              );
            }

            if (opcion == 'estado') {
              _cambiarEstadoArea(areaId, !activo);
            }
          },

          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'editar',
              child: Row(
                children: const [
                  Icon(Icons.edit_outlined, color: Color(0xFF1976D2)),

                  SizedBox(width: 10),

                  Text('Editar área'),
                ],
              ),
            ),

            PopupMenuItem(
              value: 'estado',
              child: Row(
                children: [
                  Icon(
                    activo ? Icons.toggle_off : Icons.toggle_on,

                    color: activo ? Colors.orange : Colors.green,
                  ),

                  const SizedBox(width: 10),

                  Text(activo ? 'Desactivar área' : 'Activar área'),
                ],
              ),
            ),

            const PopupMenuDivider(),
          ],
        ),

        // ============================================================
        // EQUIPOS DEL ÁREA
        // ============================================================
        children: [_buildEquiposArea(areaId)],
      ),
    );
  }

  Widget _buildEquiposArea(String areaId) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _equiposService.obtenerEquipos(
        clienteId: _clienteId!,
        domicilioId: _domicilioId!,
        areaId: areaId,
      ),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget('Error al cargar los equipos: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final equipos = snapshot.data?.docs ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // ENCABEZADO
            // ==========================================================
            Row(
              children: [
                const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF1976D2),
                  size: 21,
                ),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    'Equipos del área',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172033),
                    ),
                  ),
                ),

                Text(
                  '${equipos.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ==========================================================
            // SIN EQUIPOS
            // ==========================================================
            if (equipos.isEmpty) _equiposEmptyState(),

            // ==========================================================
            // LISTA DE EQUIPOS
            // ==========================================================
            if (equipos.isNotEmpty)
              ...equipos.map((doc) {
                final data = doc.data();

                return _equipoTile(doc.id, data, areaId);
              }),

            const SizedBox(height: 12),

            // ==========================================================
            // AGREGAR EQUIPO
            // ==========================================================
            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: () {
                  _mostrarFormularioEquipo(areaId: areaId);
                },

                icon: const Icon(Icons.add),

                label: const Text('Agregar equipo'),

                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1976D2),

                  side: const BorderSide(color: Color(0xFF1976D2)),

                  padding: const EdgeInsets.symmetric(vertical: 13),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _equiposEmptyState() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),

      child: Column(
        children: [
          Icon(Icons.settings_outlined, size: 38, color: Colors.grey.shade400),

          const SizedBox(height: 8),

          Text(
            'No hay equipos registrados',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Agrega un equipo a esta área.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _mostrarFormularioEquipo({
    required String areaId,
    String? equipoId,
    Map<String, dynamic>? datosActuales,
  }) {
    final esEdicion = equipoId != null;

    String tipo = datosActuales?['tipo']?.toString() ?? 'AIRE_ACONDICIONADO';

    final nombreController = TextEditingController(
      text: datosActuales?['nombre']?.toString() ?? '',
    );

    final marcaController = TextEditingController(
      text: datosActuales?['marca']?.toString() ?? '',
    );

    final modeloController = TextEditingController(
      text: datosActuales?['modelo']?.toString() ?? '',
    );

    final serieController = TextEditingController(
      text: datosActuales?['numeroSerie']?.toString() ?? '',
    );

    final voltajeL1Controller = TextEditingController(
      text: datosActuales?['voltajeL1']?.toString() ?? '',
    );

    final voltajeL2Controller = TextEditingController(
      text: datosActuales?['voltajeL2']?.toString() ?? '',
    );

    final voltajeL3Controller = TextEditingController(
      text: datosActuales?['voltajeL3']?.toString() ?? '',
    );

    final amperajeL1Controller = TextEditingController(
      text: datosActuales?['amperajeL1']?.toString() ?? '',
    );

    final amperajeL2Controller = TextEditingController(
      text: datosActuales?['amperajeL2']?.toString() ?? '',
    );

    final amperajeL3Controller = TextEditingController(
      text: datosActuales?['amperajeL3']?.toString() ?? '',
    );

    // ------------------------------------------------------------
    // AIRE ACONDICIONADO
    // ------------------------------------------------------------

    final tipoAireController = TextEditingController(
      text: datosActuales?['tipoAire']?.toString() ?? '',
    );

    final capacidadController = TextEditingController(
      text: datosActuales?['capacidad']?.toString() ?? '',
    );

    final refrigeranteController = TextEditingController(
      text: datosActuales?['refrigerante']?.toString() ?? '',
    );

    // ------------------------------------------------------------
    // CÁMARA
    // ------------------------------------------------------------

    final tipoCamaraController = TextEditingController(
      text: datosActuales?['tipoCamara']?.toString() ?? '',
    );

    final largoController = TextEditingController(
      text: datosActuales?['largo']?.toString() ?? '',
    );

    final anchoController = TextEditingController(
      text: datosActuales?['ancho']?.toString() ?? '',
    );

    final altoController = TextEditingController(
      text: datosActuales?['alto']?.toString() ?? '',
    );

    final temperaturaController = TextEditingController(
      text: datosActuales?['temperaturaOperacion']?.toString() ?? '',
    );

    // ------------------------------------------------------------
    // MÁQUINA DE HIELO
    // ------------------------------------------------------------

    final tipoMaquinaController = TextEditingController(
      text: datosActuales?['tipoMaquina']?.toString() ?? '',
    );

    final produccionController = TextEditingController(
      text: datosActuales?['produccionHielo']?.toString() ?? '',
    );

    final almacenamientoController = TextEditingController(
      text: datosActuales?['capacidadAlmacenamiento']?.toString() ?? '',
    );

    final tipoHieloController = TextEditingController(
      text: datosActuales?['tipoHielo']?.toString() ?? '',
    );

    final observacionesController = TextEditingController(
      text: datosActuales?['observaciones']?.toString() ?? '',
    );

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(esEdicion ? 'Editar equipo' : 'Nuevo equipo'),

              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // TIPO DE EQUIPO
                        // ==================================================
                        const Text(
                          'Tipo de equipo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<String>(
                          value: tipo,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.category_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'AIRE_ACONDICIONADO',
                              child: Text('Aire acondicionado'),
                            ),
                            DropdownMenuItem(
                              value: 'CAMARA_REFRIGERACION',
                              child: Text('Cámara de refrigeración'),
                            ),
                            DropdownMenuItem(
                              value: 'MAQUINA_HIELO',
                              child: Text('Máquina de hielo'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setDialogState(() {
                              tipo = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // DATOS GENERALES
                        // ==================================================
                        _tituloFormulario('Datos generales'),

                        const SizedBox(height: 12),

                        _campoEquipo(
                          controller: nombreController,
                          label: 'Nombre / identificador',
                          icon: Icons.badge_outlined,
                          obligatorio: true,
                        ),

                        const SizedBox(height: 12),

                        _campoEquipo(
                          controller: marcaController,
                          label: 'Marca',
                          icon: Icons.business_outlined,
                        ),

                        const SizedBox(height: 12),

                        _campoEquipo(
                          controller: modeloController,
                          label: 'Modelo',
                          icon: Icons.inventory_2_outlined,
                        ),

                        const SizedBox(height: 12),

                        _campoEquipo(
                          controller: serieController,
                          label: 'Número de serie',
                          icon: Icons.qr_code_2_outlined,
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // CAMPOS ESPECÍFICOS
                        // ==================================================
                        _tituloFormulario(_nombreTipoEquipo(tipo)),

                        const SizedBox(height: 12),

                        if (tipo == 'AIRE_ACONDICIONADO') ...[
                          _campoEquipo(
                            controller: tipoAireController,
                            label: 'Tipo de aire acondicionado',
                            icon: Icons.ac_unit,
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: capacidadController,
                            label: 'Capacidad',
                            icon: Icons.speed_outlined,
                            tipoTeclado: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: refrigeranteController,
                            label: 'Refrigerante',
                            icon: Icons.science_outlined,
                          ),
                        ],

                        if (tipo == 'CAMARA_REFRIGERACION') ...[
                          _campoEquipo(
                            controller: tipoCamaraController,
                            label: 'Tipo de cámara',
                            icon: Icons.kitchen_outlined,
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: _campoEquipo(
                                  controller: largoController,
                                  label: 'Largo',
                                  icon: Icons.straighten,
                                  tipoTeclado: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: _campoEquipo(
                                  controller: anchoController,
                                  label: 'Ancho',
                                  icon: Icons.straighten,
                                  tipoTeclado: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: _campoEquipo(
                                  controller: altoController,
                                  label: 'Alto',
                                  icon: Icons.straighten,
                                  tipoTeclado: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: temperaturaController,
                            label: 'Temperatura de operación',
                            icon: Icons.thermostat_outlined,
                            tipoTeclado: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: refrigeranteController,
                            label: 'Refrigerante',
                            icon: Icons.science_outlined,
                          ),
                        ],

                        if (tipo == 'MAQUINA_HIELO') ...[
                          _campoEquipo(
                            controller: tipoMaquinaController,
                            label: 'Tipo de máquina',
                            icon: Icons.precision_manufacturing_outlined,
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: produccionController,
                            label: 'Producción de hielo',
                            icon: Icons.ac_unit,
                            tipoTeclado: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: almacenamientoController,
                            label: 'Capacidad de almacenamiento',
                            icon: Icons.inventory_outlined,
                            tipoTeclado: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: tipoHieloController,
                            label: 'Tipo de hielo',
                            icon: Icons.severe_cold_outlined,
                          ),

                          const SizedBox(height: 12),

                          _campoEquipo(
                            controller: refrigeranteController,
                            label: 'Refrigerante',
                            icon: Icons.science_outlined,
                          ),
                        ],

                        const SizedBox(height: 20),

                        // ==================================================
                        // MEDICIONES ELÉCTRICAS
                        // ==================================================
                        _tituloFormulario('Mediciones eléctricas'),

                        const SizedBox(height: 4),

                        Text(
                          'Todos estos campos son opcionales.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Text(
                          'Voltaje (V)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: _campoEquipo(
                                controller: voltajeL1Controller,
                                label: 'L1',
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _campoEquipo(
                                controller: voltajeL2Controller,
                                label: 'L2',
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _campoEquipo(
                                controller: voltajeL3Controller,
                                label: 'L3',
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Amperaje (A)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: _campoEquipo(
                                controller: amperajeL1Controller,
                                label: 'L1',
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _campoEquipo(
                                controller: amperajeL2Controller,
                                label: 'L2',
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _campoEquipo(
                                controller: amperajeL3Controller,
                                label: 'L3',
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // OBSERVACIONES
                        // ==================================================
                        _tituloFormulario('Observaciones'),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: observacionesController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Observaciones del equipo...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    final datos = <String, dynamic>{
                      'tipo': tipo,

                      'nombre': nombreController.text.trim(),

                      'marca': marcaController.text.trim(),

                      'modelo': modeloController.text.trim(),

                      'numeroSerie': serieController.text.trim(),

                      'voltajeL1': _numeroOpcional(voltajeL1Controller.text),

                      'voltajeL2': _numeroOpcional(voltajeL2Controller.text),

                      'voltajeL3': _numeroOpcional(voltajeL3Controller.text),

                      'amperajeL1': _numeroOpcional(amperajeL1Controller.text),

                      'amperajeL2': _numeroOpcional(amperajeL2Controller.text),

                      'amperajeL3': _numeroOpcional(amperajeL3Controller.text),

                      'tipoAire': tipo == 'AIRE_ACONDICIONADO'
                          ? _textoOpcional(tipoAireController.text)
                          : null,

                      'capacidad': tipo == 'AIRE_ACONDICIONADO'
                          ? _numeroOpcional(capacidadController.text)
                          : null,

                      'tipoCamara': tipo == 'CAMARA_REFRIGERACION'
                          ? _textoOpcional(tipoCamaraController.text)
                          : null,

                      'largo': tipo == 'CAMARA_REFRIGERACION'
                          ? _numeroOpcional(largoController.text)
                          : null,

                      'ancho': tipo == 'CAMARA_REFRIGERACION'
                          ? _numeroOpcional(anchoController.text)
                          : null,

                      'alto': tipo == 'CAMARA_REFRIGERACION'
                          ? _numeroOpcional(altoController.text)
                          : null,

                      'temperaturaOperacion': tipo == 'CAMARA_REFRIGERACION'
                          ? _numeroOpcional(temperaturaController.text)
                          : null,

                      'tipoMaquina': tipo == 'MAQUINA_HIELO'
                          ? _textoOpcional(tipoMaquinaController.text)
                          : null,

                      'produccionHielo': tipo == 'MAQUINA_HIELO'
                          ? _numeroOpcional(produccionController.text)
                          : null,

                      'capacidadAlmacenamiento': tipo == 'MAQUINA_HIELO'
                          ? _numeroOpcional(almacenamientoController.text)
                          : null,

                      'tipoHielo': tipo == 'MAQUINA_HIELO'
                          ? _textoOpcional(tipoHieloController.text)
                          : null,

                      'refrigerante': _textoOpcional(
                        refrigeranteController.text,
                      ),

                      'observaciones': observacionesController.text.trim(),
                    };

                    try {
                      if (esEdicion) {
                        await _equiposService.actualizarEquipo(
                          clienteId: _clienteId!,
                          domicilioId: _domicilioId!,
                          areaId: areaId,
                          equipoId: equipoId,
                          datos: datos,
                        );
                      } else {
                        await _equiposService.crearEquipo(
                          clienteId: _clienteId!,
                          domicilioId: _domicilioId!,
                          areaId: areaId,
                          datos: datos,
                        );
                      }

                      if (!mounted) return;

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            esEdicion
                                ? 'Equipo actualizado correctamente'
                                : 'Equipo agregado correctamente',
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar el equipo: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },

                  icon: const Icon(Icons.save_outlined),

                  label: Text(esEdicion ? 'Guardar cambios' : 'Guardar equipo'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _tituloFormulario(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF172033),
      ),
    );
  }

  Widget _campoEquipo({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obligatorio = false,
    TextInputType? tipoTeclado,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipoTeclado,
      validator: obligatorio
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }

              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  double? _numeroOpcional(String texto) {
    final valor = texto.trim();

    if (valor.isEmpty) {
      return null;
    }

    return double.tryParse(valor.replaceAll(',', '.'));
  }

  String? _textoOpcional(String texto) {
    final valor = texto.trim();

    if (valor.isEmpty) {
      return null;
    }

    return valor;
  }

  void _mostrarDetalleEquipo(Map<String, dynamic> data) {
    final tipo = data['tipo']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(_iconoTipoEquipo(tipo), color: _colorTipoEquipo(tipo)),
              const SizedBox(width: 10),
              Expanded(child: Text(data['nombre']?.toString() ?? 'Equipo')),
            ],
          ),

          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detalleEquipo('Tipo', _nombreTipoEquipo(tipo)),

                  _detalleEquipo('Marca', data['marca']),

                  _detalleEquipo('Modelo', data['modelo']),

                  _detalleEquipo('Número de serie', data['numeroSerie']),

                  const Divider(),

                  const Text(
                    'Mediciones eléctricas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  _detalleEquipo(
                    'Voltaje L1',
                    _valorMedicion(data['voltajeL1'], 'V'),
                  ),

                  _detalleEquipo(
                    'Voltaje L2',
                    _valorMedicion(data['voltajeL2'], 'V'),
                  ),

                  _detalleEquipo(
                    'Voltaje L3',
                    _valorMedicion(data['voltajeL3'], 'V'),
                  ),

                  _detalleEquipo(
                    'Amperaje L1',
                    _valorMedicion(data['amperajeL1'], 'A'),
                  ),

                  _detalleEquipo(
                    'Amperaje L2',
                    _valorMedicion(data['amperajeL2'], 'A'),
                  ),

                  _detalleEquipo(
                    'Amperaje L3',
                    _valorMedicion(data['amperajeL3'], 'A'),
                  ),

                  const Divider(),

                  if (tipo == 'AIRE_ACONDICIONADO') ...[
                    _detalleEquipo('Tipo de aire', data['tipoAire']),
                    _detalleEquipo('Capacidad', data['capacidad']),
                    _detalleEquipo('Refrigerante', data['refrigerante']),
                  ],

                  if (tipo == 'CAMARA_REFRIGERACION') ...[
                    _detalleEquipo('Tipo de cámara', data['tipoCamara']),
                    _detalleEquipo('Largo', data['largo']),
                    _detalleEquipo('Ancho', data['ancho']),
                    _detalleEquipo('Alto', data['alto']),
                    _detalleEquipo('Temperatura', data['temperaturaOperacion']),
                    _detalleEquipo('Refrigerante', data['refrigerante']),
                  ],

                  if (tipo == 'MAQUINA_HIELO') ...[
                    _detalleEquipo('Tipo de máquina', data['tipoMaquina']),
                    _detalleEquipo(
                      'Producción de hielo',
                      data['produccionHielo'],
                    ),
                    _detalleEquipo(
                      'Almacenamiento',
                      data['capacidadAlmacenamiento'],
                    ),
                    _detalleEquipo('Tipo de hielo', data['tipoHielo']),
                    _detalleEquipo('Refrigerante', data['refrigerante']),
                  ],

                  if ((data['observaciones']?.toString().isNotEmpty ??
                      false)) ...[
                    const Divider(),

                    _detalleEquipo('Observaciones', data['observaciones']),
                  ],
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _detalleEquipo(String etiqueta, dynamic valor) {
    final texto = valor?.toString() ?? '';

    if (texto.isEmpty || texto == 'null') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$etiqueta:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }

  String _valorMedicion(dynamic valor, String unidad) {
    if (valor == null) {
      return 'No registrada';
    }

    return '$valor $unidad';
  }

  Widget _equipoTile(
    String equipoId,
    Map<String, dynamic> data,
    String areaId,
  ) {
    final tipo = data['tipo']?.toString() ?? '';

    final nombre = data['nombre']?.toString() ?? 'Equipo sin nombre';

    final marca = data['marca']?.toString() ?? '';

    final modelo = data['modelo']?.toString() ?? '';

    final numeroSerie = data['numeroSerie']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),

        leading: Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: _colorTipoEquipo(tipo).withOpacity(0.10),

            borderRadius: BorderRadius.circular(11),
          ),

          child: Icon(_iconoTipoEquipo(tipo), color: _colorTipoEquipo(tipo)),
        ),

        title: Text(
          nombre,

          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 3),

            Text(
              _nombreTipoEquipo(tipo),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _colorTipoEquipo(tipo),
              ),
            ),

            if (marca.isNotEmpty || modelo.isNotEmpty)
              Text(
                '$marca ${modelo.isNotEmpty ? "• $modelo" : ""}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

            if (numeroSerie.isNotEmpty)
              Text(
                'Serie: $numeroSerie',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
          ],
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (opcion) {
            if (opcion == 'ver') {
              _mostrarDetalleEquipo(data);
            }

            if (opcion == 'editar') {
              _mostrarFormularioEquipo(
                areaId: areaId,
                equipoId: equipoId,
                datosActuales: data,
              );
            }

            if (opcion == 'desactivar') {
              _confirmarDesactivarEquipo(areaId, equipoId, nombre);
            }
          },

          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'ver',
              child: Row(
                children: [
                  Icon(Icons.visibility_outlined),
                  SizedBox(width: 10),
                  Text('Ver equipo'),
                ],
              ),
            ),

            const PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, color: Color(0xFF1976D2)),
                  SizedBox(width: 10),
                  Text('Editar equipo'),
                ],
              ),
            ),

            const PopupMenuDivider(),

            const PopupMenuItem(
              value: 'desactivar',
              child: Row(
                children: [
                  Icon(Icons.toggle_off_outlined, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Desactivar equipo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarDesactivarEquipo(
    String areaId,
    String equipoId,
    String nombre,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Desactivar equipo'),

          content: Text(
            '¿Deseas desactivar el equipo "$nombre"?\n\n'
            'El equipo no aparecerá en la lista de equipos activos, '
            'pero permanecerá guardado en el sistema.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, true);
              },

              icon: const Icon(Icons.toggle_off_outlined),

              label: const Text('Desactivar'),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {
      await _equiposService.desactivarEquipo(
        clienteId: _clienteId!,
        domicilioId: _domicilioId!,
        areaId: areaId,
        equipoId: equipoId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Equipo desactivado correctamente')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al desactivar el equipo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _nombreTipoEquipo(String tipo) {
    switch (tipo) {
      case 'AIRE_ACONDICIONADO':
        return 'Aire acondicionado';

      case 'CAMARA_REFRIGERACION':
        return 'Cámara de refrigeración';

      case 'MAQUINA_HIELO':
        return 'Máquina de hielo';

      default:
        return 'Equipo';
    }
  }

  IconData _iconoTipoEquipo(String tipo) {
    switch (tipo) {
      case 'AIRE_ACONDICIONADO':
        return Icons.ac_unit;

      case 'CAMARA_REFRIGERACION':
        return Icons.kitchen_outlined;

      case 'MAQUINA_HIELO':
        return Icons.severe_cold_outlined;

      default:
        return Icons.settings_outlined;
    }
  }

  Color _colorTipoEquipo(String tipo) {
    switch (tipo) {
      case 'AIRE_ACONDICIONADO':
        return const Color(0xFF1976D2);

      case 'CAMARA_REFRIGERACION':
        return const Color(0xFF00897B);

      case 'MAQUINA_HIELO':
        return const Color(0xFF5E35B1);

      default:
        return Colors.grey;
    }
  }

  // ================================================================
  // CREAR / EDITAR
  // ================================================================

  Future<void> _mostrarFormularioArea({
    String? areaId,
    String? nombreActual,
    String? descripcionActual,
  }) async {
    final nombreController = TextEditingController(text: nombreActual ?? '');

    final descripcionController = TextEditingController(
      text: descripcionActual ?? '',
    );

    final esEdicion = areaId != null;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: Text(esEdicion ? 'Editar área' : 'Nueva área'),

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
                    hintText: 'Ej. Recámara principal',
                    prefixIcon: const Icon(Icons.meeting_room_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: descripcionController,

                  maxLines: 3,

                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Descripción del área (opcional)',
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
              child: const Text('Cancelar'),
            ),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
              ),

              onPressed: () {
                _guardarArea(
                  dialogContext,
                  nombreController,
                  descripcionController,
                  areaId,
                );
              },

              icon: Icon(esEdicion ? Icons.save_outlined : Icons.add),

              label: Text(esEdicion ? 'Guardar cambios' : 'Crear área'),
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
    final nombre = nombreController.text.trim();

    final descripcion = descripcionController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('Escribe el nombre del área.')),
      );

      return;
    }

    if (_clienteId == null || _domicilioId == null) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            areaId == null
                ? 'Área creada correctamente.'
                : 'Área actualizada correctamente.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!dialogContext.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        dialogContext,
      ).showSnackBar(SnackBar(content: Text('Error al guardar el área: $e')));
    }
  }

  // ================================================================
  // CAMBIAR ESTADO
  // ================================================================

  Future<void> _cambiarEstadoArea(String areaId, bool activo) async {
    if (_clienteId == null || _domicilioId == null) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(activo ? 'Área activada.' : 'Área desactivada.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cambiar el estado: $e')));
    }
  }

  // ================================================================
  // CONFIRMAR ELIMINACIÓN
  // ================================================================

  Future<void> _confirmarEliminarArea(String areaId, String nombre) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Text('Eliminar área'),

          content: Text(
            '¿Seguro que deseas eliminar "$nombre"?\n\n'
            'Esta acción no se puede deshacer.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              onPressed: () {
                Navigator.pop(dialogContext, true);
              },

              icon: const Icon(Icons.delete_outline),

              label: const Text('Eliminar'),
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

  Future<void> _eliminarArea(String areaId) async {
    if (_clienteId == null || _domicilioId == null) {
      return;
    }

    try {
      await _areasService.eliminarArea(
        clienteId: _clienteId!,
        domicilioId: _domicilioId!,
        areaId: areaId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Área eliminada correctamente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el área: $e'),
          behavior: SnackBarBehavior.floating,
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF0)),
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
            style: TextStyle(color: Colors.grey.shade600),
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EAF0)),
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
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 18),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
            ),

            onPressed: () {
              _mostrarFormularioArea();
            },

            icon: const Icon(Icons.add),

            label: const Text('Agregar área'),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cargando',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),

              const SizedBox(width: 12),

              Text(texto, style: TextStyle(color: Colors.grey.shade600)),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),

          const SizedBox(width: 10),

          Expanded(
            child: Text(mensaje, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
