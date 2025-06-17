import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoggedCustomerPage extends StatelessWidget {
  const LoggedCustomerPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E1A47),
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'S.ESE.ART - logged in CUSTOMER',
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
          )

          // _buildMenuItem(context, 'Home', const LoggedInPage()),
          // _buildMenuItem(context, 'My Orders', const OrdersPage()),
          // _buildMenuItem(context, 'Messages', const MessagesPage()),
          // _buildMenuItem(context, 'Profile', const ProfilePage()),
          // _buildLogoutButton(context),
  // const SizedBox(width: 24),
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
                        // Image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/banner.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Text container
                        Positioned(
                          left: 24,
                          top: 30,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            color: Colors.black.withOpacity(0.5),
                            child: const Text(
                              'Discover Unique Artworks',
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
                  // About Us
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left-side image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/about_us.jpg',
                          width: 500,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right-side text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'About us!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Página realizada por estudiantes del Centro Profesional Joyfe en el último curso de Desarrollo de Aplicaciones Multiplataforma (DAM). '
                              'Este proyecto es nuestro Trabajo de Fin de Grado (TFG), que refleja todo lo que hemos aprendido durante los dos cursos.\n\n'
                              'S.ESE.ART nace de querer unir la tecnología y la creatividad dando como resultado una plataforma sencilla y elegante, '
                              'donde todos pueden ver y seleccionar obras de arte realizadas por una de las alumnas del equipo.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Product cards
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'All Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    // itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemBuilder: (context, index) {
                      // return ProductCard(product: products[index]);
                    },
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              width: double.infinity,
              color: const Color(0xFF2E1A47),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meet the Team
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
                                color: Colors.white70,
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
                      // Legal and Technology
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

  // Widget _buildMenuItem(BuildContext context, String title, Widget page) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8),
  //     child: GestureDetector(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => page),
  //         );
  //       },
  //       child: Center(
  //         child: Text(
  //           title,
  //           style: const TextStyle(color: Colors.white, fontSize: 16),
  //         ),
  //       ),
  //     ),
  //   );
  // }

// Widget _buildLogoutButton(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8),
//     child: GestureDetector(
//       onTap: () async {
//         final confirmLogout = await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Cerrar sesión'),
//             content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancelar'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 child: const Text('Cerrar sesión'),
//               ),
//             ],
//           ),
//         );

//         if (confirmLogout == true) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.remove('auth_token');
//           Navigator.pushReplacementNamed(context, '/');
//         }
//       },
//       child: const Center(
//         child: Text(
//           'Logout',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ),
//     ),
//   );
// }
}
