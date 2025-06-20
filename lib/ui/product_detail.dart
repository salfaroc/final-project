import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/collection_products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/api_service.dart';


class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetail();
}

class _ProductDetail extends State<ProductDetail> {
  int quantity = 1;
  String selectedSize = 'A5';
  double unitPrice = 5.0;

  final Map<String, double> sizePrices = {
    'A5': 5.0,
    'A4': 10.0,
    'A3': 15.0,
    'A2': 20.0,
  };

  void _launchInstagram() async {
    const url = 'https://www.instagram.com/s.ese.art';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo abrir $url';
    }
  }

Future<void> _handleAddToCart() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inicio de sesión requerido'),
        content: const Text(
          'Para realizar una compra necesitas iniciar sesión.\n\n'
          'Si quieres continuar sin registrarte, ponte en contacto conmigo a través del botón de contacto.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Ir a iniciar sesión'),
          ),
        ],
      ),
    );
    return;
  }

try {
  await ApiService.addToCart({
    'product_id': widget.product.id!.oid, 
    'quantity': quantity,
  });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Añadido al carrito!'),
        content: const Text('El producto se ha añadido correctamente a tu carrito.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Seguir comprando'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shopping_cart');
            },
            child: const Text('Ver carrito'),
          ),
        ],
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al añadir al carrito: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * unitPrice;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E1A47),
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'S.ESE.ART - ProductoDetail',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.product.image,
                      width: 150,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '€${unitPrice.toStringAsFixed(2)} por unidad',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                            ),
                            Text(
                              '$quantity unidad${quantity > 1 ? 'es' : ''}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => quantity++),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: €${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          widget.product.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Categoría: ${widget.product.category}',
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value: selectedSize,
                          decoration: const InputDecoration(
                            labelText: 'Tamaño',
                            border: OutlineInputBorder(),
                          ),
                          items: sizePrices.keys
                              .map((size) => DropdownMenuItem(
                                    value: size,
                                    child: Text(size),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedSize = value;
                                unitPrice = sizePrices[value]!;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E1A47),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _handleAddToCart,
                          child: const Text('AÑADIR AL CARRITO'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[100],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _launchInstagram,
                          child: const Text('Contacto (Instagram)'),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer fijo
          SafeArea(
            child: _buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF2E1A47),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
}
