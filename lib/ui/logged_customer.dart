import 'package:flutter/material.dart';
import '../../models/collection_products.dart';
import '../../services/api_service.dart';
import '../ui/product_card.dart'; 

class LoggedCustomer extends StatefulWidget {
  const LoggedCustomer({super.key});

  @override
  State<LoggedCustomer> createState() => _LoggedCustomer();
}

class _LoggedCustomer extends State<LoggedCustomer> {
  List<Product> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final loadedProducts = await ApiService.fetchProducts();
      print('Productos cargados: ${loadedProducts.length}');
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(37, 112, 130, 1),
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'S.ESE.ART - LoggedCustomer',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          _buildMenuItem(context, 'ShoppingCart', '/shopping_cart'),
          _buildMenuItem(context, 'Profile', '/profile'),
          const SizedBox(width: 24),
        ],
      ),
      body: Column(
        children: [
          // Contenido principal con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(150, 30, 150, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBanner(),
                    const SizedBox(height: 40),
                    _buildAbout(),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'All Products',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : error != null
                            ? Center(child: Text('Error: $error'))
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: products.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductCard(product: product),
                                        ),
                                      );
                                    },
                                    child: ProductCard(product: product),
                                  );
                                },
                              ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          // Footer fijo al final sin scroll
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _buildAbout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 800;

        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/about_us.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'About us!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'We are a passionate team of students from Centro Profesional JOYFE, currently in our final year of Desarrollo de Aplicaciones Multiplataforma (DAM). '
                'This project is our Trabajo de Fin de Grado (TFG), a milestone that reflects everything we’ve learned and achieved over the past two years.\n\n'
                'S.ESE.ART was born from our shared love for technology and creativity. We wanted to create a platform that’s both simple and elegant, '
                'where digital artworks can be discovered, appreciated, and shared by everyone.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/about_us.jpg',
                    height: 250,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'About us!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'We are a passionate team of students from Centro Profesional JOYFE, currently in our final year of Desarrollo de Aplicaciones Multiplataforma (DAM). '
                      'This project is our Trabajo de Fin de Grado (TFG), a milestone that reflects everything we’ve learned and achieved over the past two years.\n\n'
                      'S.ESE.ART was born from our shared love for technology and creativity. We wanted to create a platform that’s both simple and elegant, '
                      'where digital artworks can be discovered, appreciated, and shared by everyone.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

Widget _buildFooter() {
  return Container(
    width: double.infinity,
    color: const Color.fromRGBO(37, 112, 130, 1),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // menos alto
    child: Center(
      child: FittedBox(
        alignment: Alignment.topLeft,
        fit: BoxFit.scaleDown,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Meet the Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Sara Alfaro Carrillo',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'GitHub: github.com/salfaroc',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Gwyneth Mendoza Castro',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'GitHub: github.com/9u-bit',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 160,
              color: Colors.white24,
              margin: const EdgeInsets.symmetric(horizontal: 32),
            ),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Legal & Technology',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '© 2025 S.ESE.ART — All rights reserved.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Built with:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Python',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '• MongoDB',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '• Flutter',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
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
  );
}


  Widget _buildMenuItem(BuildContext context, String title, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
