import 'package:flutter/material.dart';
import '../../models/collection_shoppingCart.dart';
import '../../services/api_service.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<ShoppingCartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final items = await ApiService.fetchCartItems();
      setState(() {
        cartItems = items;
      });
    } catch (e) {
      print('Error al cargar el carrito: $e');
    }
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index].quantity += 1;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        backgroundColor: const Color.fromRGBO(37, 112, 130, 1),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Tu carrito está vacío"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product = item.product!;
                      final qty = item.quantity;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.network(product.image, width: 80),
                          title: Text(product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.description),
                              Text('Tamaño: ${product.width} x ${product.length} cm'),
                              Text('Precio unitario: \$${product.price.toStringAsFixed(2)}'),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _decrementQuantity(index),
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text('$qty'),
                                  IconButton(
                                    onPressed: () => _incrementQuantity(index),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                              Text('Total: \$${item.totalPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica de checkout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(37, 112, 130, 1),
                        ),
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
