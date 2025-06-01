import 'package:mongo_dart/mongo_dart.dart';

class ShoppingCartItem {
  ObjectId? id;
  ObjectId productId; // Referencia al producto en el carrito
  int quantity; // Cantidad del producto que el cliente quiere comprar

  ShoppingCartItem({
    this.id,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory ShoppingCartItem.fromJson(Map<String, dynamic> map) {
    return ShoppingCartItem(
      id: map['_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
    );
  }
}

class ShoppingCart {
  ObjectId? id;
  ObjectId customerId; // Referencia al cliente propietario del carrito
  List<ShoppingCartItem> items; // Lista de productos en el carrito

  ShoppingCart({
    this.id,
    required this.customerId,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'customer_id': customerId,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory ShoppingCart.fromMap(Map<String, dynamic> map) {
    var itemsList = List<Map<String, dynamic>>.from(map['items']);
    List<ShoppingCartItem> items = itemsList.map((item) => ShoppingCartItem.fromJson(item)).toList();

    return ShoppingCart(
      id: map['_id'],
      customerId: map['customer_id'],
      items: items,
    );
  }
}
