
import 'package:seseart/models/collection_customers.dart';
import 'package:seseart/models/collection_addresses.dart';

class CustomerWithAddress {
  final Customer customer;
  final Address address;

  CustomerWithAddress({
    required this.customer,
    required this.address,
  });
}
