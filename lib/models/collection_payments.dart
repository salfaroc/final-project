import 'package:mongo_dart/mongo_dart.dart';

class Payment {
  ObjectId? id;
  ObjectId orderId; // Referencia a la orden de la que se realizó el pago
  double amount;
  String paymentMethod;
  String paymentStatus;
  DateTime paymentDate;

  Payment({
    this.id,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'order_id': orderId,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'payment_date': paymentDate.toUtc(),
    };
  }

  factory Payment.fromJson(Map<String, dynamic> map) {
    return Payment(
      id: map['_id'],
      orderId: map['order_id'],
      amount: map['amount'],
      paymentMethod: map['payment_method'],
      paymentStatus: map['payment_status'],
      paymentDate: DateTime.parse(map['payment_date']),
    );
  }
}
