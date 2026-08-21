import 'package:flutter/material.dart';

import '../models/inventario.dart';
import '../services/inventario_service.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final InventarioService _inventarioService = InventarioService();

  final TextEditingController _busquedaController =
      TextEditingController();

  String _busqueda = '';

  bool _mostrarInactivos = false;

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
                Icons.inventory_2_outlined,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Inventario',
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
                      'Gestión de inventario',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Administra materiales, refacciones, consumibles y existencias.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 25),

                    _buildResumen(),

                    const SizedBox(height: 20),

                    _buildHerramientas(),

                    const SizedBox(height: 20),

                    _buildInventario(),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,

        onPressed: () {
          _mostrarFormulario();
        },

        icon: const Icon(Icons.add),

        label: const Text('Nuevo producto'),
      ),
    );
  }

  // ================================================================
  // RESUMEN
  // ================================================================

  Widget _buildResumen() {
    return StreamBuilder<List<Inventario>>(
      stream: _inventarioService.obtenerInventario(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _resumenLoading();
        }

        if (snapshot.hasError) {
          return _errorWidget(
            'Error al cargar el inventario: ${snapshot.error}',
          );
        }

        final inventario = snapshot.data ?? [];

        final stockBajo = inventario
            .where(
              (item) => item.cantidad <= item.stockMinimo,
            )
            .length;

        final categorias = inventario
            .map((item) => item.categoria)
            .where((categoria) => categoria.isNotEmpty)
            .toSet()
            .length;

        return LayoutBuilder(
          builder: (context, constraints) {
            final ancho = constraints.maxWidth;

            if (ancho < 700) {
              return Column(
                children: [
                  _tarjetaResumen(
                    'Productos activos',
                    '${inventario.length}',
                    Icons.inventory_2_outlined,
                    const Color(0xFF1976D2),
                  ),

                  const SizedBox(height: 12),

                  _tarjetaResumen(
                    'Stock bajo',
                    '$stockBajo',
                    Icons.warning_amber_outlined,
                    Colors.orange,
                  ),

                  const SizedBox(height: 12),

                  _tarjetaResumen(
                    'Categorías',
                    '$categorias',
                    Icons.category_outlined,
                    Colors.green,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _tarjetaResumen(
                    'Productos activos',
                    '${inventario.length}',
                    Icons.inventory_2_outlined,
                    const Color(0xFF1976D2),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _tarjetaResumen(
                    'Stock bajo',
                    '$stockBajo',
                    Icons.warning_amber_outlined,
                    Colors.orange,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _tarjetaResumen(
                    'Categorías',
                    '$categorias',
                    Icons.category_outlined,
                    Colors.green,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _tarjetaResumen(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(
              icono,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumenLoading() {
    return Row(
      children: [
        Expanded(
          child: _tarjetaResumen(
            'Productos activos',
            '...',
            Icons.inventory_2_outlined,
            const Color(0xFF1976D2),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _tarjetaResumen(
            'Stock bajo',
            '...',
            Icons.warning_amber_outlined,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _tarjetaResumen(
            'Categorías',
            '...',
            Icons.category_outlined,
            Colors.green,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // HERRAMIENTAS
  // ================================================================

  Widget _buildHerramientas() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final vertical = constraints.maxWidth < 650;

          if (vertical) {
            return Column(
              children: [
                _campoBusqueda(),

                const SizedBox(height: 15),

                _botonEstado(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _campoBusqueda(),
              ),

              const SizedBox(width: 15),

              _botonEstado(),
            ],
          );
        },
      ),
    );
  }

  Widget _campoBusqueda() {
    return TextField(
      controller: _busquedaController,

      decoration: InputDecoration(
        hintText: 'Buscar por nombre, categoría, marca, modelo o código...',

        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF1976D2),
        ),

        suffixIcon: _busquedaController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _busquedaController.clear();
                },
                icon: const Icon(Icons.clear),
              )
            : null,

        filled: true,

        fillColor: const Color(0xFFF8FAFC),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5EAF0),
          ),
        ),
      ),
    );
  }

  Widget _botonEstado() {
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _mostrarInactivos = !_mostrarInactivos;
        });
      },

      icon: Icon(
        _mostrarInactivos
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
      ),

      label: Text(
        _mostrarInactivos
            ? 'Mostrar activos'
            : 'Mostrar inactivos',
      ),

      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1976D2),
        side: const BorderSide(
          color: Color(0xFF1976D2),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ================================================================
  // LISTA
  // ================================================================

  Widget _buildInventario() {
    return StreamBuilder<List<Inventario>>(
      stream: _mostrarInactivos
          ? _inventarioService.obtenerTodoElInventario()
          : _inventarioService.obtenerInventario(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorWidget(
            'Error al cargar el inventario: ${snapshot.error}',
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: CircularProgressIndicator(),
            ),
          );
        }

        List<Inventario> inventario = snapshot.data ?? [];

        // ============================================================
        // BUSQUEDA
        // ============================================================

        if (_busqueda.isNotEmpty) {
          inventario = inventario.where((item) {
            return item.nombre.toLowerCase().contains(_busqueda) ||
                item.categoria.toLowerCase().contains(_busqueda) ||
                (item.marca?.toLowerCase().contains(_busqueda) ??
                    false) ||
                (item.modelo?.toLowerCase().contains(_busqueda) ??
                    false) ||
                (item.codigo?.toLowerCase().contains(_busqueda) ??
                    false);
          }).toList();
        }

        if (inventario.isEmpty) {
          return _inventarioEmpty();
        }

        return Container(
          padding: const EdgeInsets.all(20),

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
                  const Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF1976D2),
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'Productos registrados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),
                  ),

                  Text(
                    '${inventario.length}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ...inventario.map(
                (item) => _inventarioTile(item),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // ITEM
  // ================================================================

  Widget _inventarioTile(Inventario item) {
    final stockBajo = item.cantidad <= item.stockMinimo;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: item.activo
            ? const Color(0xFFF8FAFC)
            : Colors.grey.shade100,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: stockBajo && item.activo
              ? Colors.orange.shade200
              : const Color(0xFFE5EAF0),
        ),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 7,
        ),

        leading: Container(
          width: 45,
          height: 45,

          decoration: BoxDecoration(
            color: item.activo
                ? const Color(0xFFE3F2FD)
                : Colors.grey.shade200,

            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(
            Icons.inventory_2_outlined,
            color: item.activo
                ? const Color(0xFF1976D2)
                : Colors.grey,
          ),
        ),

        title: Row(
          children: [
            Expanded(
              child: Text(
                item.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172033),
                ),
              ),
            ),

            if (stockBajo && item.activo)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Text(
                  'Stock bajo',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              item.categoria,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 3),

            if (item.marca != null ||
                item.modelo != null)
              Text(
                '${item.marca ?? ''}'
                '${item.modelo != null ? ' • ${item.modelo}' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

            const SizedBox(height: 3),

            Text(
              'Existencia: ${_formatearNumero(item.cantidad)}'
              '${item.unidad != null ? ' ${item.unidad}' : ''}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: stockBajo && item.activo
                    ? Colors.orange.shade800
                    : Colors.grey.shade700,
              ),
            ),

            if (!item.activo)
              const Text(
                'Producto inactivo',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (opcion) {
            switch (opcion) {
              case 'ver':
                _mostrarDetalle(item);
                break;

              case 'editar':
                _mostrarFormulario(item: item);
                break;

              case 'entrada':
                _mostrarMovimiento(
                  item: item,
                  esEntrada: true,
                );
                break;

              case 'salida':
                _mostrarMovimiento(
                  item: item,
                  esEntrada: false,
                );
                break;

              case 'estado':
                _cambiarEstado(item);
                break;
            }
          },

          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'ver',
              child: Row(
                children: [
                  Icon(Icons.visibility_outlined),
                  SizedBox(width: 10),
                  Text('Ver detalles'),
                ],
              ),
            ),

            const PopupMenuItem(
              value: 'editar',
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF1976D2),
                  ),
                  SizedBox(width: 10),
                  Text('Editar'),
                ],
              ),
            ),

            if (item.activo) ...[
              const PopupMenuDivider(),

              const PopupMenuItem(
                value: 'entrada',
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text('Agregar existencia'),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: 'salida',
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 10),
                    Text('Retirar existencia'),
                  ],
                ),
              ),

              const PopupMenuDivider(),

              const PopupMenuItem(
                value: 'estado',
                child: Row(
                  children: [
                    Icon(
                      Icons.toggle_off_outlined,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 10),
                    Text('Desactivar'),
                  ],
                ),
              ),
            ] else
              const PopupMenuItem(
                value: 'estado',
                child: Row(
                  children: [
                    Icon(
                      Icons.toggle_on_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text('Activar'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // FORMULARIO
  // ================================================================

  Future<void> _mostrarFormulario({
    Inventario? item,
  }) async {
    final esEdicion = item != null;

    final nombreController = TextEditingController(
      text: item?.nombre ?? '',
    );

    final descripcionController = TextEditingController(
      text: item?.descripcion ?? '',
    );

    final marcaController = TextEditingController(
      text: item?.marca ?? '',
    );

    final modeloController = TextEditingController(
      text: item?.modelo ?? '',
    );

    final cantidadController = TextEditingController(
      text: item != null
          ? _formatearNumero(item.cantidad)
          : '',
    );

    final stockMinimoController = TextEditingController(
      text: item != null
          ? _formatearNumero(item.stockMinimo)
          : '',
    );

    final precioController = TextEditingController(
      text: item?.precio != null
          ? _formatearNumero(item!.precio!)
          : '',
    );

    final ubicacionController = TextEditingController(
      text: item?.ubicacion ?? '',
    );

    final proveedorController = TextEditingController(
      text: item?.proveedor ?? '',
    );

    final codigoController = TextEditingController(
      text: item?.codigo ?? '',
    );

    final notasController = TextEditingController(
      text: item?.notas ?? '',
    );

    String categoria = item?.categoria ?? 'Refacción';

    String unidad = item?.unidad ?? 'Pieza';

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                esEdicion
                    ? 'Editar producto'
                    : 'Nuevo producto',
              ),

              content: SizedBox(
                width: 650,

                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        _tituloFormulario('Información general'),

                        const SizedBox(height: 12),

                        _campo(
                          controller: nombreController,
                          label: 'Nombre',
                          icon: Icons.inventory_2_outlined,
                          obligatorio: true,
                        ),

                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: categoria,

                          decoration: _decoracion(
                            'Categoría',
                            Icons.category_outlined,
                          ),

                          items: const [
                            DropdownMenuItem(
                              value: 'Refacción',
                              child: Text('Refacción'),
                            ),
                            DropdownMenuItem(
                              value: 'Material',
                              child: Text('Material'),
                            ),
                            DropdownMenuItem(
                              value: 'Consumible',
                              child: Text('Consumible'),
                            ),
                            DropdownMenuItem(
                              value: 'Herramienta',
                              child: Text('Herramienta'),
                            ),
                            DropdownMenuItem(
                              value: 'Refrigerante',
                              child: Text('Refrigerante'),
                            ),
                            DropdownMenuItem(
                              value: 'Eléctrico',
                              child: Text('Eléctrico'),
                            ),
                            DropdownMenuItem(
                              value: 'Otro',
                              child: Text('Otro'),
                            ),
                          ],

                          onChanged: (value) {
                            if (value == null) return;

                            setDialogState(() {
                              categoria = value;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        _campo(
                          controller: codigoController,
                          label: 'Código / SKU',
                          icon: Icons.qr_code_2_outlined,
                        ),

                        const SizedBox(height: 12),

                        _campo(
                          controller: descripcionController,
                          label: 'Descripción',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 20),

                        _tituloFormulario('Datos del producto'),

                        const SizedBox(height: 12),

                        _campo(
                          controller: marcaController,
                          label: 'Marca',
                          icon: Icons.business_outlined,
                        ),

                        const SizedBox(height: 12),

                        _campo(
                          controller: modeloController,
                          label: 'Modelo',
                          icon: Icons.inventory_outlined,
                        ),

                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: unidad,

                          decoration: _decoracion(
                            'Unidad de medida',
                            Icons.straighten_outlined,
                          ),

                          items: const [
                            DropdownMenuItem(
                              value: 'Pieza',
                              child: Text('Pieza'),
                            ),
                            DropdownMenuItem(
                              value: 'Litro',
                              child: Text('Litro'),
                            ),
                            DropdownMenuItem(
                              value: 'Kilogramo',
                              child: Text('Kilogramo'),
                            ),
                            DropdownMenuItem(
                              value: 'Metro',
                              child: Text('Metro'),
                            ),
                            DropdownMenuItem(
                              value: 'Caja',
                              child: Text('Caja'),
                            ),
                            DropdownMenuItem(
                              value: 'Juego',
                              child: Text('Juego'),
                            ),
                            DropdownMenuItem(
                              value: 'Otro',
                              child: Text('Otro'),
                            ),
                          ],

                          onChanged: (value) {
                            if (value == null) return;

                            setDialogState(() {
                              unidad = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        _tituloFormulario('Existencias'),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _campo(
                                controller:
                                    cantidadController,
                                label: 'Cantidad',
                                icon: Icons.inventory_2_outlined,
                                obligatorio: true,
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _campo(
                                controller:
                                    stockMinimoController,
                                label: 'Stock mínimo',
                                icon: Icons.warning_amber_outlined,
                                obligatorio: true,
                                tipoTeclado:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _campo(
                          controller: precioController,
                          label: 'Precio unitario',
                          icon: Icons.attach_money_outlined,
                          tipoTeclado:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _tituloFormulario('Ubicación y proveedor'),

                        const SizedBox(height: 12),

                        _campo(
                          controller: ubicacionController,
                          label: 'Ubicación',
                          icon: Icons.location_on_outlined,
                        ),

                        const SizedBox(height: 12),

                        _campo(
                          controller: proveedorController,
                          label: 'Proveedor',
                          icon: Icons.local_shipping_outlined,
                        ),

                        const SizedBox(height: 20),

                        _tituloFormulario('Notas'),

                        const SizedBox(height: 12),

                        _campo(
                          controller: notasController,
                          label: 'Notas',
                          icon: Icons.notes_outlined,
                          maxLines: 4,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    final cantidad = _parseNumero(
                      cantidadController.text,
                    );

                    final stockMinimo = _parseNumero(
                      stockMinimoController.text,
                    );

                    final precio = _parseNumeroOpcional(
                      precioController.text,
                    );

                    if (cantidad == null ||
                        stockMinimo == null) {
                      return;
                    }

                    if (cantidad < 0 ||
                        stockMinimo < 0) {
                      ScaffoldMessenger.of(
                        dialogContext,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Las cantidades no pueden ser negativas.',
                          ),
                        ),
                      );

                      return;
                    }

                    try {
                      if (esEdicion) {
                        await _inventarioService
                            .actualizarInventario(
                          id: item.id,
                          nombre:
                              nombreController.text,
                          categoria: categoria,
                          descripcion:
                              descripcionController.text,
                          marca: marcaController.text,
                          modelo: modeloController.text,
                          unidad: unidad,
                          cantidad: cantidad,
                          stockMinimo: stockMinimo,
                          precio: precio,
                          ubicacion:
                              ubicacionController.text,
                          proveedor:
                              proveedorController.text,
                          codigo:
                              codigoController.text,
                          notas: notasController.text,
                        );
                      } else {
                        await _inventarioService
                            .crearInventario(
                          nombre:
                              nombreController.text,
                          categoria: categoria,
                          descripcion:
                              descripcionController.text,
                          marca: marcaController.text,
                          modelo: modeloController.text,
                          unidad: unidad,
                          cantidad: cantidad,
                          stockMinimo: stockMinimo,
                          precio: precio,
                          ubicacion:
                              ubicacionController.text,
                          proveedor:
                              proveedorController.text,
                          codigo:
                              codigoController.text,
                          notas: notasController.text,
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
                            esEdicion
                                ? 'Producto actualizado correctamente'
                                : 'Producto agregado correctamente',
                          ),
                          behavior:
                              SnackBarBehavior.floating,
                        ),
                      );
                    } catch (e) {
                      if (!dialogContext.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(
                        dialogContext,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error al guardar: $e',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },

                  icon: const Icon(
                    Icons.save_outlined,
                  ),

                  label: Text(
                    esEdicion
                        ? 'Guardar cambios'
                        : 'Guardar producto',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nombreController.dispose();
    descripcionController.dispose();
    marcaController.dispose();
    modeloController.dispose();
    cantidadController.dispose();
    stockMinimoController.dispose();
    precioController.dispose();
    ubicacionController.dispose();
    proveedorController.dispose();
    codigoController.dispose();
    notasController.dispose();
  }

  // ================================================================
  // MOVIMIENTOS
  // ================================================================

  Future<void> _mostrarMovimiento({
    required Inventario item,
    required bool esEntrada,
  }) async {
    final controller = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final cantidad = await showDialog<double>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            esEntrada
                ? 'Agregar existencia'
                : 'Retirar existencia',
          ),

          content: Form(
            key: formKey,

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  item.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Existencia actual: '
                  '${_formatearNumero(item.cantidad)} '
                  '${item.unidad ?? ''}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: controller,

                  autofocus: true,

                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Ingresa una cantidad';
                    }

                    final numero =
                        _parseNumero(value);

                    if (numero == null ||
                        numero <= 0) {
                      return 'Ingresa una cantidad válida';
                    }

                    if (!esEntrada &&
                        numero > item.cantidad) {
                      return 'No hay suficiente existencia';
                    }

                    return null;
                  },

                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    suffixText: item.unidad,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
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
                backgroundColor: esEntrada
                    ? Colors.green
                    : Colors.orange,
                foregroundColor: Colors.white,
              ),

              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  _parseNumero(controller.text),
                );
              },

              icon: Icon(
                esEntrada
                    ? Icons.add
                    : Icons.remove,
              ),

              label: Text(
                esEntrada ? 'Agregar' : 'Retirar',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (cantidad == null) {
      return;
    }

    try {
      if (esEntrada) {
        await _inventarioService.agregarExistencia(
          id: item.id,
          cantidad: cantidad,
        );
      } else {
        await _inventarioService.retirarExistencia(
          id: item.id,
          cantidad: cantidad,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            esEntrada
                ? 'Existencia agregada correctamente'
                : 'Existencia retirada correctamente',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al actualizar existencia: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================================================================
  // DETALLES
  // ================================================================

  void _mostrarDetalle(Inventario item) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        final stockBajo =
            item.cantidad <= item.stockMinimo;

        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF1976D2),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(item.nombre),
              ),
            ],
          ),

          content: SizedBox(
            width: 550,

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  _detalle(
                    'Categoría',
                    item.categoria,
                  ),

                  _detalle(
                    'Código',
                    item.codigo,
                  ),

                  _detalle(
                    'Descripción',
                    item.descripcion,
                  ),

                  const Divider(),

                  _detalle(
                    'Marca',
                    item.marca,
                  ),

                  _detalle(
                    'Modelo',
                    item.modelo,
                  ),

                  _detalle(
                    'Unidad',
                    item.unidad,
                  ),

                  const Divider(),

                  _detalle(
                    'Existencia',
                    '${_formatearNumero(item.cantidad)} '
                    '${item.unidad ?? ''}',
                  ),

                  _detalle(
                    'Stock mínimo',
                    '${_formatearNumero(item.stockMinimo)} '
                    '${item.unidad ?? ''}',
                  ),

                  if (stockBajo)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Este producto tiene stock bajo.',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  _detalle(
                    'Precio unitario',
                    item.precio != null
                        ? '\$${item.precio!.toStringAsFixed(2)}'
                        : null,
                  ),

                  const Divider(),

                  _detalle(
                    'Ubicación',
                    item.ubicacion,
                  ),

                  _detalle(
                    'Proveedor',
                    item.proveedor,
                  ),

                  _detalle(
                    'Estado',
                    item.activo
                        ? 'Activo'
                        : 'Inactivo',
                  ),

                  if (item.notas != null &&
                      item.notas!.isNotEmpty) ...[
                    const Divider(),

                    _detalle(
                      'Notas',
                      item.notas,
                    ),
                  ],
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _detalle(
    String etiqueta,
    dynamic valor,
  ) {
    final texto = valor?.toString() ?? '';

    if (texto.isEmpty ||
        texto == 'null') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 9,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 145,

            child: Text(
              '$etiqueta:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(texto),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CAMBIAR ESTADO
  // ================================================================

  Future<void> _cambiarEstado(
    Inventario item,
  ) async {
    final nuevoEstado = !item.activo;

    final confirmar = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            nuevoEstado
                ? 'Activar producto'
                : 'Desactivar producto',
          ),

          content: Text(
            nuevoEstado
                ? '¿Deseas activar "${item.nombre}"?'
                : '¿Deseas desactivar "${item.nombre}"?\n\n'
                  'El producto permanecerá guardado, '
                  'pero dejará de aparecer entre los productos activos.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },

              child: const Text('Cancelar'),
            ),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    nuevoEstado
                        ? Colors.green
                        : Colors.orange,
                foregroundColor: Colors.white,
              ),

              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },

              icon: Icon(
                nuevoEstado
                    ? Icons.toggle_on_outlined
                    : Icons.toggle_off_outlined,
              ),

              label: Text(
                nuevoEstado
                    ? 'Activar'
                    : 'Desactivar',
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
      await _inventarioService
          .cambiarEstadoInventario(
        id: item.id,
        activo: nuevoEstado,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            nuevoEstado
                ? 'Producto activado correctamente'
                : 'Producto desactivado correctamente',
          ),
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================================================================
  // CAMPO
  // ================================================================

  Widget _campo({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obligatorio = false,
    TextInputType? tipoTeclado,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipoTeclado,
      maxLines: maxLines,

      validator: obligatorio
          ? (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }

              return null;
            }
          : null,

      decoration: _decoracion(
        label,
        icon,
      ),
    );
  }

  InputDecoration _decoracion(
    String label,
    IconData? icon,
  ) {
    return InputDecoration(
      labelText: label,

      prefixIcon: icon != null
          ? Icon(icon)
          : null,

      filled: true,

      fillColor: const Color(0xFFF8FAFC),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _tituloFormulario(
    String texto,
  ) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF172033),
      ),
    );
  }

  // ================================================================
  // EMPTY
  // ================================================================

  Widget _inventarioEmpty() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(50),

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
            Icons.inventory_2_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          Text(
            _busqueda.isNotEmpty
                ? 'No se encontraron productos'
                : _mostrarInactivos
                    ? 'No hay productos registrados'
                    : 'No hay productos activos',

            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _busqueda.isNotEmpty
                ? 'Intenta con otro término de búsqueda.'
                : 'Agrega el primer producto al inventario.',

            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ERROR
  // ================================================================

  Widget _errorWidget(
    String mensaje,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
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

  // ================================================================
  // NUMEROS
  // ================================================================

  double? _parseNumero(
    String texto,
  ) {
    final valor = texto.trim();

    if (valor.isEmpty) {
      return null;
    }

    return double.tryParse(
      valor.replaceAll(',', '.'),
    );
  }

  double? _parseNumeroOpcional(
    String texto,
  ) {
    if (texto.trim().isEmpty) {
      return null;
    }

    return _parseNumero(texto);
  }

  String _formatearNumero(
    double numero,
  ) {
    if (numero == numero.roundToDouble()) {
      return numero
          .toInt()
          .toString();
    }

    return numero.toString();
  }
}