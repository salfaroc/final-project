import 'package:mongo_dart/mongo_dart.dart';

class CustomerBackup {
  ObjectId? id;
  String name;
  String email;
  String phone;
  ObjectId addressId;
  DateTime createdAt;
  DateTime backupDate;

  CustomerBackup({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.addressId,
    required this.createdAt,
    required this.backupDate,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address_id': addressId,
      'created_at': createdAt.toUtc(),
      'backup_date': backupDate.toUtc(),
    };
  }

  factory CustomerBackup.fromJson(Map<String, dynamic> map) {
    return CustomerBackup(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      addressId: map['address_id'],
      createdAt: DateTime.parse(map['created_at']),
      backupDate: DateTime.parse(map['backup_date']),
    );
  }
}
