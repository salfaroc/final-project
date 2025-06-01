import 'package:mongo_dart/mongo_dart.dart';

class Review {
  ObjectId? id;
  ObjectId productId; // Referencia al producto reseñado
  ObjectId customerId; // Referencia al cliente que dejó la reseña
  int rating; // Calificación del producto (de 1 a 5)
  String reviewText; // Comentarios adicionales de la reseña
  DateTime reviewDate; // Fecha en que se dejó la reseña

  Review({
    this.id,
    required this.productId,
    required this.customerId,
    required this.rating,
    required this.reviewText,
    required this.reviewDate,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_id': productId,
      'customer_id': customerId,
      'rating': rating,
      'review_text': reviewText,
      'review_date': reviewDate.toUtc(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> map) {
    return Review(
      id: map['_id'],
      productId: map['product_id'],
      customerId: map['customer_id'],
      rating: map['rating'],
      reviewText: map['review_text'],
      reviewDate: DateTime.parse(map['review_date']),
    );
  }
}
