// Este es un ejemplo base de modelo en Dart para MongoDB usando mongo_dart

import 'package:mongo_dart/mongo_dart.dart';

// Modelo: Address
class Address {
  ObjectId id;
  String pais;
  String ciudad;
  String provincia;
  String codigoPostal;
  String gender;
  DateTime fechaNacimiento;

  Address({
    required this.id,
    required this.pais,
    required this.ciudad,
    required this.provincia,
    required this.codigoPostal,
    required this.gender,
    required this.fechaNacimiento,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'],
      pais: json['pais'],
      ciudad: json['ciudad'],
      provincia: json['provincia'],
      codigoPostal: json['codigo_postal'],
      gender: json['gender'],
      fechaNacimiento: DateTime.parse(json['fecha_nacimiento']),
    );
  }
}
