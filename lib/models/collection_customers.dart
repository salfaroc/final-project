import 'package:mongo_dart/mongo_dart.dart';

class Customer {
  ObjectId? id;
  String name;
  String email;
  String phone;
  ObjectId addressId; 
  DateTime createdAt;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.addressId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address_id': addressId,
      'created_at': createdAt.toUtc(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> map) {
    return Customer(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      addressId: map['address_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
