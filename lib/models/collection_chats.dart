import 'package:mongo_dart/mongo_dart.dart';

class Chat {
  ObjectId id;
  ObjectId customerId; // Referencia a customers
  ObjectId adminId;    // Referencia a admins
  String message;
  DateTime timestamp;

  Chat({
    required this.id,
    required this.customerId,
    required this.adminId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'customer_id': customerId,
      'admin_id': adminId,
      'message': message,
      'timestamp': timestamp.toUtc(),
    };
  }

  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      id: map['_id'],
      customerId: map['customer_id'],
      adminId: map['admin_id'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
