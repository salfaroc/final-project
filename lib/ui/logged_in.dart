import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  // Función de logout (no tocar)
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Estado de visibilidad de formularios
  final Map<String, bool> _visibleSections = {};

  // Botones disponibles
  final Map<String, String> _buttons = {
    "addProduct": "Añadir Producto",
    "editProduct": "Modificar Producto",
    "deleteProduct": " Eliminar Producto",
    "editCustomer": " Modificar Datos Cliente",
    "toggleCustomer": "Activar/Desactivar Cliente",
    "viewCustomer": " Ver Datos Cliente",
    "createCustomer": " Crear Cliente",
    "listCustomers": "Ver Clientes",
    "orders": " Ver Pedidos",
    "offers": "Ver Ofertas",
    "payments": "Ver Pagos",
    "products": "Ver Productos",
    "reviews": "Ver Reseñas",
    "deleteReviews": "Borrar Reseñas",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 113, 176),
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'S.ESE.ART - logged in',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(150, 30, 150, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/banner.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          top: 30,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            color: Colors.black.withOpacity(0.5),
                            child: const Text(
                              'Admin Dashboard',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --------  ADMIN BOTONES - ACCIONES --------
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3.2,
                    children: _buttons.entries.map((entry) {
                      final key = entry.key;
                      final label = entry.value;
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _visibleSections[key] = !(_visibleSections[key] ?? false);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 98, 162, 191),
                        ),
                        child: Text(label),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // 🔽 FORMULARIOS VISIBLES
                  ..._visibleSections.entries.where((e) => e.value).map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Formulario: ${_buttons[e.key]}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Aquí va el formulario para "${_buttons[e.key]}"',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 0, 0, 0),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Team Info
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Meet the Team',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Sara Alfaro Carrillo',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'GitHub: github.com/salfaroc',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Gwyneth Mendoza Castro',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'GitHub: github.com/9u-bit',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      Container(
                        width: 1,
                        height: 160,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                      ),
                      // Legal Info
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Legal & Technology',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '© 2025 S.ESE.ART — All rights reserved.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Built with:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Python',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '• MongoDB',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '• Flutter',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 300),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
