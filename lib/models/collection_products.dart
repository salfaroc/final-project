import 'package:mongo_dart/mongo_dart.dart';

class Product {
  ObjectId? id;
  String image; 
  String name; 
  String description; 
  double price; 
  String category; 
  int stockQuantity; 
  DateTime createdAt; 
  int width; 
  int length;

  Product({
    this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    required this.createdAt,
    required this.width,
    required this.length,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] != null ? ObjectId.fromHexString(json['_id']) : null,
      image: json['image'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      stockQuantity: json['stock_quantity'],
      createdAt: DateTime.parse(json['created_at']),
      width: json['width'],
      length: json['length'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id?.oid,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'category': category,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toUtc().toIso8601String(),
      'width' : width,
      'length' : length,
    };
  }


}
