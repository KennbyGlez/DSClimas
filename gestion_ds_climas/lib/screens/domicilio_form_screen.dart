import 'package:flutter/material.dart';

import '../models/domicilio.dart';
import '../services/domicilio_service.dart';

class DomicilioFormScreen extends StatefulWidget {
  final String clienteId;
  final Domicilio? domicilio;

  const DomicilioFormScreen({
    super.key,
    required this.clienteId,
    this.domicilio,
  });

  bool get esEdicion => domicilio != null;

  @override
  State<DomicilioFormScreen> createState() =>
      _DomicilioFormScreenState();
}

class _DomicilioFormScreenState
    extends State<DomicilioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final DomicilioService _domicilioService =
      DomicilioService();

  final _calleController = TextEditingController();
  final _numeroExteriorController = TextEditingController();
  final _numeroInteriorController = TextEditingController();
  final _coloniaController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _estadoController = TextEditingController();
  final _referenciasController = TextEditingController();
  final _contactoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _nombreController = TextEditingController();

  String _tipo = 'Servicio';
  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    final domicilio = widget.domicilio;

    if (domicilio != null) {
      _tipo = domicilio.tipo;

      _calleController.text = domicilio.calle;
      _nombreController.text = domicilio.nombre;
      _numeroExteriorController.text =
          domicilio.numeroExterior;
      _numeroInteriorController.text =
          domicilio.numeroInterior;
      _coloniaController.text = domicilio.colonia;
      _codigoPostalController.text =
          domicilio.codigoPostal;
      _ciudadController.text = domicilio.ciudad;
      _estadoController.text = domicilio.estado;
      _referenciasController.text =
          domicilio.referencias;
      _contactoController.text =
          domicilio.contacto;

      if (domicilio.telefono != 0) {
        _telefonoController.text =
            domicilio.telefono.toString();
      }
    }
  }

  @override
  void dispose() {
    _calleController.dispose();
    _nombreController.dispose();
    _numeroExteriorController.dispose();
    _numeroInteriorController.dispose();
    _coloniaController.dispose();
    _codigoPostalController.dispose();
    _ciudadController.dispose();
    _estadoController.dispose();
    _referenciasController.dispose();
    _contactoController.dispose();
    _telefonoController.dispose();

    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      final telefono =
          int.tryParse(
                _telefonoController.text.trim(),
              ) ??
              0;

      if (widget.esEdicion) {
        await _domicilioService.actualizarDomicilio(
          clienteId: widget.clienteId,
          domicilioId: widget.domicilio!.id,
          tipo: _tipo,
          calle: _calleController.text.trim(),
          nombre: _nombreController.text.trim(),
          numeroExterior:
              _numeroExteriorController.text.trim(),
          numeroInterior:
              _numeroInteriorController.text.trim(),
          colonia: _coloniaController.text.trim(),
          codigoPostal:
              _codigoPostalController.text.trim(),
          ciudad: _ciudadController.text.trim(),
          estado: _estadoController.text.trim(),
          referencias:
              _referenciasController.text.trim(),
          contacto:
              _contactoController.text.trim(),
          telefono: telefono,
        );
      } else {
        await _domicilioService.crearDomicilio(
          clienteId: widget.clienteId,
          tipo: _tipo,
          calle: _calleController.text.trim(),
          nombre: _nombreController.text.trim(),
          numeroExterior:
              _numeroExteriorController.text.trim(),
          numeroInterior:
              _numeroInteriorController.text.trim(),
          colonia: _coloniaController.text.trim(),
          codigoPostal:
              _codigoPostalController.text.trim(),
          ciudad: _ciudadController.text.trim(),
          estado: _estadoController.text.trim(),
          referencias:
              _referenciasController.text.trim(),
          contacto:
              _contactoController.text.trim(),
          telefono: telefono,
        );
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo guardar el domicilio.\n$e',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.esEdicion;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        elevation: 0,
        title: Text(
          esEdicion
              ? 'Editar domicilio'
              : 'Nuevo domicilio',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final esDesktop =
              constraints.maxWidth >= 900;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: esDesktop ? 40 : 20,
              vertical: 30,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        esEdicion
                            ? 'Editar domicilio'
                            : 'Registrar domicilio',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Registra la ubicación donde se realizan '
                        'los servicios del cliente.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 28),

                      _SeccionDomicilio(
                        icon: Icons.location_on_outlined,
                        titulo: 'Información del domicilio',
                        subtitulo:
                            'Datos principales de la ubicación',
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _tipo,
                              decoration:
                                  _decoracion(
                                'Tipo de domicilio',
                                Icons.home_work_outlined,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Hotel',
                                  child:
                                      Text('Hotel'),
                                ),
                                DropdownMenuItem(
                                  value: 'Casa',
                                  child:
                                      Text('Casa'),
                                ),
                                DropdownMenuItem(
                                  value: 'Oficina',
                                  child:
                                      Text('Oficina'),
                                ),
                                DropdownMenuItem(
                                  value: 'Almacén',
                                  child:
                                      Text('Almacén'),
                                ),
                                DropdownMenuItem(
                                  value: 'Coto',
                                  child:
                                      Text('Coto'),
                                ),
                                DropdownMenuItem(
                                  value: 'Servicio',
                                  child:
                                      Text('Servicio'),
                                ),
                                DropdownMenuItem(
                                  value: 'Otro',
                                  child: Text('Otro'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _tipo = value;
                                  });
                                }
                              },
                            ),

                            const SizedBox(height: 18),

                             _Campo(
                              controller:
                                  _nombreController,
                              label: 'Nombre',
                              hint: 'Ej. Hotel X',
                              icon: Icons
                                  .signpost_outlined,
                              obligatorio: true,
                            ),

                            const SizedBox(height: 18),

                            _Campo(
                              controller:
                                  _calleController,
                              label: 'Calle',
                              hint: 'Ej. Av. México',
                              icon: Icons
                                  .signpost_outlined,
                              obligatorio: true,
                            ),

                            const SizedBox(height: 18),

                            Row(
                              children: [
                                Expanded(
                                  child: _Campo(
                                    controller:
                                        _numeroExteriorController,
                                    label:
                                        'Número exterior',
                                    hint: 'Ej. 125',
                                    icon: Icons
                                        .numbers_outlined,
                                    obligatorio: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _Campo(
                                    controller:
                                        _numeroInteriorController,
                                    label:
                                        'Número interior',
                                    hint: 'Opcional',
                                    icon: Icons
                                        .meeting_room_outlined,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            _Campo(
                              controller:
                                  _coloniaController,
                              label: 'Colonia',
                              hint: 'Ej. Centro',
                              icon: Icons
                                  .location_city_outlined,
                              obligatorio: true,
                            ),

                            const SizedBox(height: 18),

                            Row(
                              children: [
                                Expanded(
                                  child: _Campo(
                                    controller:
                                        _codigoPostalController,
                                    label:
                                        'Código postal',
                                    hint: 'Ej. 49000',
                                    icon: Icons
                                        .markunread_mailbox_outlined,
                                    obligatorio: true,
                                    keyboardType:
                                        TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _Campo(
                                    controller:
                                        _ciudadController,
                                    label: 'Ciudad',
                                    hint:
                                        'Ej. Ciudad Guzmán',
                                    icon: Icons
                                        .location_city_outlined,
                                    obligatorio: true,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            _Campo(
                              controller:
                                  _estadoController,
                              label: 'Estado',
                              hint: 'Ej. Jalisco',
                              icon: Icons.map_outlined,
                              obligatorio: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      _SeccionDomicilio(
                        icon: Icons.person_pin_outlined,
                        titulo: 'Contacto en el domicilio',
                        subtitulo:
                            'Persona responsable en esta ubicación',
                        child: Column(
                          children: [
                            _Campo(
                              controller:
                                  _contactoController,
                              label: 'Contacto',
                              hint:
                                  'Ej. Juan Pérez',
                              icon:
                                  Icons.person_outline,
                            ),

                            const SizedBox(height: 18),

                            _Campo(
                              controller:
                                  _telefonoController,
                              label: 'Teléfono',
                              hint: '10 dígitos',
                              icon:
                                  Icons.phone_outlined,
                              keyboardType:
                                  TextInputType.phone,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return null;
                                }

                                if (!RegExp(
                                  r'^\d{10}$',
                                ).hasMatch(
                                  value.trim(),
                                )) {
                                  return 'Debe tener 10 dígitos';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      _SeccionDomicilio(
                        icon: Icons.notes_outlined,
                        titulo: 'Referencias',
                        subtitulo:
                            'Información útil para localizar el domicilio',
                        child: _Campo(
                          controller:
                              _referenciasController,
                          label: 'Referencias',
                          hint:
                              'Ej. Portón negro, frente al parque...',
                          icon:
                              Icons.directions_outlined,
                          maxLines: 4,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: _guardando
                                ? null
                                : () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                            style: OutlinedButton
                                .styleFrom(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 25,
                                vertical: 16,
                              ),
                            ),
                            child:
                                const Text('Cancelar'),
                          ),

                          const SizedBox(width: 14),

                          FilledButton.icon(
                            onPressed: _guardando
                                ? null
                                : _guardar,
                            style: FilledButton
                                .styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFF1976D2,
                              ),
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 28,
                                vertical: 16,
                              ),
                            ),
                            icon: _guardando
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons
                                        .save_outlined,
                                  ),
                            label: Text(
                              _guardando
                                  ? 'Guardando...'
                                  : esEdicion
                                      ? 'Guardar cambios'
                                      : 'Agregar domicilio',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ======================================================
// SECCIÓN
// ======================================================

class _SeccionDomicilio
    extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final Widget child;

  const _SeccionDomicilio({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFE3F2FD),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color:
                      const Color(0xFF1976D2),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          child,
        ],
      ),
    );
  }
}

// ======================================================
// CAMPO
// ======================================================

class _Campo extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obligatorio;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Campo({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obligatorio = false,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator ??
          (value) {
            if (obligatorio &&
                (value == null ||
                    value.trim().isEmpty)) {
              return 'Este campo es obligatorio';
            }

            return null;
          },
      decoration:
          _decoracion(label, icon).copyWith(
        hintText: hint,
        labelText: obligatorio
            ? '$label *'
            : label,
      ),
    );
  }
}

// ======================================================
// DECORACIÓN
// ======================================================

InputDecoration _decoracion(
  String label,
  IconData icon,
) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE2E8F0),
      ),
    ),
    enabledBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE2E8F0),
      ),
    ),
    focusedBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF1976D2),
        width: 2,
      ),
    ),
    errorBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
  );
}