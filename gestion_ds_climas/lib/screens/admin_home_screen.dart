import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'clientes_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

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
                Icons.ac_unit,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'DS Climas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

       actions: [
  IconButton(
    tooltip: 'Notificaciones',
    onPressed: () {},
    icon: const Icon(
      Icons.notifications_none_rounded,
    ),
  ),

  const SizedBox(width: 8),

  Padding(
    padding: const EdgeInsets.only(right: 16),
    child: PopupMenuButton<String>(
      tooltip: 'Cuenta',
      offset: const Offset(0, 55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (value) async {
        if (value == 'logout') {
          await _logout(context);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          enabled: false,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(
                  Icons.person_outline,
                  color: Color(0xFF1976D2),
                ),
              ),

              SizedBox(width: 12),

              Text(
                'Administrador',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.red,
              ),

              SizedBox(width: 12),

              Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
      child: const CircleAvatar(
        backgroundColor: Color(0xFF1976D2),
        child: Icon(
          Icons.person_outline,
          color: Colors.white,
        ),
      ),
    ),
  ),
],
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

                    // ENCABEZADO
                    const Text(
                      'Panel principal',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Bienvenido al sistema de gestión de DS Climas.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // RESUMEN
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : 2,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8,
                      children: const [
                        _SummaryCard(
                          icon: Icons.people_outline,
                          title: 'Clientes',
                          value: '0',
                          subtitle: 'Registrados',
                        ),

                        _SummaryCard(
                          icon: Icons.ac_unit,
                          title: 'Equipos',
                          value: '0',
                          subtitle: 'Registrados',
                        ),

                        _SummaryCard(
                          icon: Icons.assignment_outlined,
                          title: 'Servicios',
                          value: '0',
                          subtitle: 'Este mes',
                        ),

                        _SummaryCard(
                          icon: Icons.engineering_outlined,
                          title: 'Técnicos',
                          value: '0',
                          subtitle: 'Activos',
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      'Gestión',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : 2,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.15,
                      children: [
                        _ManagementCard(
  icon: Icons.people_outline,
  title: 'Clientes',
  description: 'Administrar clientes',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ClientesScreen(),
      ),
    );
  },
),

                        _ManagementCard(
                          icon: Icons.ac_unit,
                          title: 'Equipos',
                          description:
                              'Gestionar equipos',
                          onTap: () {},
                        ),

                        _ManagementCard(
                          icon: Icons.assignment_outlined,
                          title: 'Servicios',
                          description:
                              'Control de servicios',
                          onTap: () {},
                        ),

                        _ManagementCard(
                          icon: Icons.engineering_outlined,
                          title: 'Técnicos',
                          description:
                              'Administrar técnicos',
                          onTap: () {},
                        ),

                        _ManagementCard(
                          icon: Icons.description_outlined,
                          title: 'Reportes',
                          description:
                              'Consultar reportes',
                          onTap: () {},
                        ),

                        _ManagementCard(
                          icon: Icons.calendar_month_outlined,
                          title: 'Agenda',
                          description:
                              'Programar servicios',
                          onTap: () {},
                        ),

                        _ManagementCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'Inventario',
                          description:
                              'Material y refacciones',
                          onTap: () {},
                        ),

                        _ManagementCard(
                          icon: Icons.settings_outlined,
                          title: 'Configuración',
                          description:
                              'Configuración del sistema',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    // ACTIVIDAD RECIENTE
                    const Text(
                      'Actividad reciente',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
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
                            Icons.inbox_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'No hay actividad reciente',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1976D2),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1976D2),
                  size: 27,
                ),
              ),

              const Spacer(),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  if (!context.mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    ),
    (route) => false,
  );
}