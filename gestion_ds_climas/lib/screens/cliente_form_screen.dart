import 'package:flutter/material.dart';

import '../models/cliente.dart';
import '../services/cliente_service.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormScreen({
    super.key,
    this.cliente,
  });

  bool get esEdicion => cliente != null;

  @override
  State<ClienteFormScreen> createState() =>
      _ClienteFormScreenState();
}

class _ClienteFormScreenState
    extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ClienteService _clienteService =
      ClienteService();

  // Información general
  final _nombreController = TextEditingController();
  final _contactoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _telefono2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _notasController = TextEditingController();

  // Datos fiscales
  final _rfcController = TextEditingController();
  final _razonSocialController = TextEditingController();
  final _regimenFiscalController =
      TextEditingController();

  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    _cargarDatos();
  }

  void _cargarDatos() {
    final cliente = widget.cliente;

    if (cliente == null) {
      return;
    }

    _nombreController.text = cliente.nombre;
    _contactoController.text =
        cliente.contactoPrincipal;

    if (cliente.telefono != 0) {
      _telefonoController.text =
          cliente.telefono.toString();
    }

    if (cliente.telefono2 != 0) {
      _telefono2Controller.text =
          cliente.telefono2.toString();
    }

    _emailController.text = cliente.email;
    _notasController.text = cliente.notas;

    _rfcController.text = cliente.rfc;
    _razonSocialController.text =
        cliente.razonSocial;
    _regimenFiscalController.text =
        cliente.regimenFiscal;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _contactoController.dispose();
    _telefonoController.dispose();
    _telefono2Controller.dispose();
    _emailController.dispose();
    _notasController.dispose();

    _rfcController.dispose();
    _razonSocialController.dispose();
    _regimenFiscalController.dispose();

    super.dispose();
  }

  // =====================================================
  // GUARDAR
  // =====================================================

  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      final nombre =
          _nombreController.text.trim();

      final contacto =
          _contactoController.text.trim();

      final telefono =
          int.tryParse(
                _telefonoController.text.trim(),
              ) ??
              0;

      final telefono2 =
          int.tryParse(
                _telefono2Controller.text.trim(),
              ) ??
              0;

      final email =
          _emailController.text.trim();

      final notas =
          _notasController.text.trim();

      final rfc =
          _rfcController.text
              .trim()
              .toUpperCase();

      final razonSocial =
          _razonSocialController.text.trim();

      final regimenFiscal =
          _regimenFiscalController.text.trim();

      // ================================================
      // EDITAR
      // ================================================

      if (widget.esEdicion) {
        await _clienteService.actualizarCliente(
          id: widget.cliente!.id,
          nombre: nombre,
          contactoPrincipal: contacto,
          telefono: telefono,
          telefono2: telefono2,
          email: email,
          notas: notas,
          rfc: rfc,
          razonSocial: razonSocial,
          regimenFiscal: regimenFiscal,
        );
      }

      // ================================================
      // CREAR
      // ================================================

      else {
        await _clienteService.crearCliente(
          nombre: nombre,
          contactoPrincipal: contacto,
          telefono: telefono,
          telefono2: telefono2,
          email: email,
          notas: notas,
          rfc: rfc,
          razonSocial: razonSocial,
          regimenFiscal: regimenFiscal,
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
            'No se pudo guardar el cliente.\n$e',
          ),
          backgroundColor: Colors.red,
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.esEdicion;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xFF172033),
        elevation: 0,

        title: Text(
          esEdicion
              ? 'Editar cliente'
              : 'Nuevo cliente',
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
              horizontal:
                  esDesktop ? 40 : 20,
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
                      // ==================================
                      // ENCABEZADO
                      // ==================================

                      Text(
                        esEdicion
                            ? 'Editar información'
                            : 'Registrar cliente',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF172033),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        esEdicion
                            ? 'Modifica la información del cliente.'
                            : 'Registra un nuevo cliente en DS Climas.',
                        style: TextStyle(
                          color:
                              Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ==================================
                      // INFORMACIÓN GENERAL
                      // ==================================

                      _SeccionFormulario(
                        icon: Icons
                            .business_outlined,
                        titulo:
                            'Información general',
                        subtitulo:
                            'Datos principales del cliente',
                        child: Column(
                          children: [
                            _CampoTexto(
                              controller:
                                  _nombreController,
                              label:
                                  'Nombre del cliente',
                              hint:
                                  'Ej. Hotel Delta',
                              icon: Icons
                                  .business_outlined,
                              obligatorio: true,
                              textCapitalization:
                                  TextCapitalization
                                      .words,
                              validator:
                                  (value) {
                                if (value == null ||
                                    value
                                        .trim()
                                        .isEmpty) {
                                  return 'Ingresa el nombre del cliente';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            _CampoTexto(
                              controller:
                                  _contactoController,
                              label:
                                  'Contacto principal',
                              hint:
                                  'Ej. Martin Lopez',
                              icon: Icons
                                  .person_outline,
                              textCapitalization:
                                  TextCapitalization
                                      .words,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child:
                                      _CampoTexto(
                                    controller:
                                        _telefonoController,
                                    label:
                                        'Teléfono',
                                    hint:
                                        '10 dígitos',
                                    icon: Icons
                                        .phone_outlined,
                                    obligatorio:
                                        true,
                                    keyboardType:
                                        TextInputType
                                            .phone,
                                    validator:
                                        (value) {
                                      if (value ==
                                              null ||
                                          value
                                              .trim()
                                              .isEmpty) {
                                        return 'Ingresa el teléfono';
                                      }

                                      final telefono =
                                          value
                                              .trim();

                                      if (!RegExp(
                                        r'^\d{10}$',
                                      ).hasMatch(
                                        telefono,
                                      )) {
                                        return 'Debe tener 10 dígitos';
                                      }

                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  width: 16,
                                ),

                                Expanded(
                                  child:
                                      _CampoTexto(
                                    controller:
                                        _telefono2Controller,
                                    label:
                                        'Teléfono 2',
                                    hint:
                                        'Opcional',
                                    icon: Icons
                                        .phone_in_talk_outlined,
                                    keyboardType:
                                        TextInputType
                                            .phone,
                                    validator:
                                        (value) {
                                      if (value ==
                                              null ||
                                          value
                                              .trim()
                                              .isEmpty) {
                                        return null;
                                      }

                                      if (!RegExp(
                                        r'^\d{10}$',
                                      ).hasMatch(
                                        value
                                            .trim(),
                                      )) {
                                        return 'Debe tener 10 dígitos';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            _CampoTexto(
                              controller:
                                  _emailController,
                              label:
                                  'Correo electrónico',
                              hint:
                                  'contacto@empresa.com',
                              icon: Icons
                                  .email_outlined,
                              keyboardType:
                                  TextInputType
                                      .emailAddress,
                              validator:
                                  (value) {
                                if (value == null ||
                                    value
                                        .trim()
                                        .isEmpty) {
                                  return null;
                                }

                                final email =
                                    value.trim();

                                if (!RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(
                                  email,
                                )) {
                                  return 'Ingresa un correo válido';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            _CampoTexto(
                              controller:
                                  _notasController,
                              label: 'Notas',
                              hint:
                                  'Información adicional del cliente...',
                              icon: Icons
                                  .notes_outlined,
                              maxLines: 4,
                              textCapitalization:
                                  TextCapitalization
                                      .sentences,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================
                      // DATOS FISCALES
                      // ==================================

                      _SeccionFormulario(
                        icon: Icons
                            .receipt_long_outlined,
                        titulo:
                            'Datos fiscales',
                        subtitulo:
                            'Información fiscal del cliente',
                        child: Column(
                          children: [
                            _CampoTexto(
                              controller:
                                  _rfcController,
                              label: 'RFC',
                              hint:
                                  'Ej. ABC010203AB1',
                              icon: Icons
                                  .badge_outlined,
                              textCapitalization:
                                  TextCapitalization
                                      .characters,
                              maxLength: 13,
                              validator:
                                  (value) {
                                if (value == null ||
                                    value
                                        .trim()
                                        .isEmpty) {
                                  return null;
                                }

                                final rfc =
                                    value
                                        .trim()
                                        .toUpperCase();

                                if (rfc.length <
                                        12 ||
                                    rfc.length >
                                        13) {
                                  return 'El RFC debe tener 12 o 13 caracteres';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            _CampoTexto(
                              controller:
                                  _razonSocialController,
                              label:
                                  'Razón social',
                              hint:
                                  'Ej. Hotel Delta S.A. de C.V.',
                              icon: Icons
                                  .corporate_fare_outlined,
                              textCapitalization:
                                  TextCapitalization
                                      .words,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            _CampoTexto(
                              controller:
                                  _regimenFiscalController,
                              label:
                                  'Régimen fiscal',
                              hint:
                                  'Ej. 601 - General de Ley Personas Morales',
                              icon: Icons
                                  .account_balance_outlined,
                              textCapitalization:
                                  TextCapitalization
                                      .sentences,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==================================
                      // BOTONES
                      // ==================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed:
                                _guardando
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
                                const Text(
                              'Cancelar',
                            ),
                          ),

                          const SizedBox(
                            width: 14,
                          ),

                          FilledButton.icon(
                            onPressed:
                                _guardando
                                    ? null
                                    : _guardarCliente,
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
                                      strokeWidth:
                                          2,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : Icon(
                                    esEdicion
                                        ? Icons
                                            .save_outlined
                                        : Icons
                                            .person_add_alt_1,
                                  ),
                            label: Text(
                              _guardando
                                  ? 'Guardando...'
                                  : esEdicion
                                      ? 'Guardar cambios'
                                      : 'Crear cliente',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 30,
                      ),
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

// =====================================================
// SECCIÓN
// =====================================================

class _SeccionFormulario
    extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final Widget child;

  const _SeccionFormulario({
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
                      style: const TextStyle(
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

// =====================================================
// CAMPO
// =====================================================

class _CampoTexto
    extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obligatorio;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  const _CampoTexto({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obligatorio = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.textCapitalization =
        TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization:
          textCapitalization,
      validator: validator,

      decoration: InputDecoration(
        labelText: obligatorio
            ? '$label *'
            : label,
        hintText: hint,
        prefixIcon: Icon(icon),

        filled: true,
        fillColor:
            const Color(0xFFF8FAFC),

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

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}