import 'package:mongo_dart/mongo_dart.dart';

class Offer {
  ObjectId? id;
  ObjectId productId; // Referencia al producto que tiene la oferta
  double discountPercentage; // Porcentaje de descuento
  DateTime startDate; // Fecha de inicio de la oferta
  DateTime endDate; // Fecha de finalización de la oferta

  Offer({
    this.id,
    required this.productId,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_id': productId,
      'discount_percentage': discountPercentage,
      'start_date': startDate.toUtc(),
      'end_date': endDate.toUtc(),
    };
  }

  factory Offer.fromJson(Map<String, dynamic> map) {
    return Offer(
      id: map['_id'],
      productId: map['product_id'],
      discountPercentage: map['discount_percentage'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
    );
  }
}
