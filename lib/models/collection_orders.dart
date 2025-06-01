import 'package:mongo_dart/mongo_dart.dart';

class Order {
  ObjectId? id;
  ObjectId customerId; 
  String status;
  List<ObjectId> products; // Aquí estamos usando referencias a productos.
  ObjectId addressId;
  double totalAmount;
  String paymentStatus;
  DateTime orderDate;

  Order({
    this.id,
    required this.customerId,
    required this.status,
    required this.products,
    required this.addressId,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'customer_id': customerId,
      'status': status,
      'products': products,
      'address_id': addressId,
      'total_amount': totalAmount,
      'payment_status': paymentStatus,
      'order_date': orderDate.toUtc(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['_id'],
      customerId: map['customer_id'],
      status: map['status'],
      products: List<ObjectId>.from(map['products']),
      addressId: map['address_id'],
      totalAmount: map['total_amount'],
      paymentStatus: map['payment_status'],
      orderDate: DateTime.parse(map['order_date']),
    );
  }
}
