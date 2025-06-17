import 'package:flutter/material.dart';
import '../../models/collection_products.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E1A47), // mismo color que la appbar home
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen grande del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://drive.google.com/uc?export=view&id=${product.image}',
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 24),

            // Nombre del producto
            Text(
              product.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E1A47)),
            ),

            const SizedBox(height: 12),

            // Precio
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, color: Color(0xFF673AB7), fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            // Descripción completa
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2E1A47),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, -2)),
          ],
        ),
        child: const Text(
          '© 2025 S.ESE.ART - Todos los derechos reservados',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }
}
