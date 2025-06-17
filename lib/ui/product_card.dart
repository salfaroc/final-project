import 'package:flutter/material.dart';
import '../../models/collection_products.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product_detail',
          arguments: product,
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen desde URL
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                'https://drive.google.com/uc?export=view&id=${product.image}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
            ),

            const SizedBox(height: 8),

            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4),

            // Precio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 8),

            // Descripción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
