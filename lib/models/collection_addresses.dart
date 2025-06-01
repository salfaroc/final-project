// Este es un ejemplo base de modelo en Dart para MongoDB usando mongo_dart

import 'package:mongo_dart/mongo_dart.dart';

// Modelo: Address
class Address {
  ObjectId id;
  String streetType;
  String streetName;
  int number;
  String portal;
  String city;
  String province;
  int postalCode;
  String country;

  Address({
    required this.id,
    required this.streetType,
    required this.streetName,
    required this.number,
    required this.portal,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toMap() => {
        '_id': id,
        'street_type': streetType,
        'street_name': streetName,
        'number': number,
        'portal': portal,
        'city': city,
        'province': province,
        'postal_code': postalCode,
        'country': country,
      };

  factory Address.fromJson(Map<String, dynamic> map) => Address(
        id: map['_id'],
        streetType: map['street_type'],
        streetName: map['street_name'],
        number: map['number'],
        portal: map['portal'],
        city: map['city'],
        province: map['province'],
        postalCode: map['postal_code'],
        country: map['country'],
      );
}
