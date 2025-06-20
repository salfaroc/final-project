import 'package:mongo_dart/mongo_dart.dart';
import 'package:seseart/models/collection_products.dart';

class ShoppingCartItem {
  ObjectId? id;
  ObjectId productId;
  int quantity;
  Product? product;  // objeto producto embebido

  ShoppingCartItem({
    this.id,
    required this.productId,
    required this.quantity,
    this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_id': productId,
      'quantity': quantity,
      'product': product != null ? {
        '_id': product!.id,
        'name': product!.name,
        'image': product!.image,
        'description': product!.description,
        'price': product!.price,
        'width': product!.width,
        'length': product!.length,
      } : null,
    };
  }

  factory ShoppingCartItem.fromJson(Map<String, dynamic> map) {
    return ShoppingCartItem(
      id: map['_id'] is String ? ObjectId.fromHexString(map['_id']) : map['_id'],
      productId: map['product_id'] is String ? ObjectId.fromHexString(map['product_id']) : map['product_id'],
      quantity: map['quantity'] ?? 1,
      product: map['product'] != null ? Product.fromJson(map['product']) : null,
    );
  }

  double get totalPrice => (product?.price ?? 0) * quantity;
}

