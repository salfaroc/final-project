import 'package:mongo_dart/mongo_dart.dart';

class Permission {
  ObjectId? id;
  String role; // El rol del usuario, por ejemplo: 'admin', 'customer'
  List<String> allowedActions; // Acciones que este rol puede realizar

  Permission({
    this.id,
    required this.role,
    required this.allowedActions,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'role': role,
      'allowed_actions': allowedActions,
    };
  }

  factory Permission.fromJson(Map<String, dynamic> map) {
    return Permission(
      id: map['_id'],
      role: map['role'],
      allowedActions: List<String>.from(map['allowed_actions']),
    );
  }
}
