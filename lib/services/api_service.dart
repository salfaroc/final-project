// import '../models/collection_addresses.dart';
// import '../models/collection_customerBackup.dart';
// import '../models/collection_customers.dart';
// import '../models/collection_offers.dart';
// import '../models/collection_orders.dart';
// import '../models/collection_payments.dart';
// import '../models/collection_permissions.dart';
// import '../models/collection_reviews.dart';
// import '../models/collection_shoppingCart.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seseart/models/collection_shoppingCart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/collection_products.dart';
import '../models/collection_admins.dart';
import '../models/collection_chats.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  // ---------- Helper: Obtener token guardado ----------
  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('User not logged in');
    }
    return token;
  }

// ---------- Autenticación ----------

  // Login común (admin o customer)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role, // 'admin' o 'customer'
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userRole = data['role'];

      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['user_id'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_role', userRole);
      await prefs.setString('user_id', userId);

      return {
        'token': token,
        'role': userRole,
        'user_id': userId,
      };
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Login fallido';
      throw Exception(error);
    }
  }

// ---------- Admins ----------

  // Obtener todos los admins
  static Future<List<Admin>> fetchAdmins() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin'),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Admin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load admins: ${response.body}');
    }
  }

  // Obtener admin por email
  static Future<Admin> fetchAdminById(String email) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/$email'),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // return Admin.fromJson(json.decode(response.body));
      final data = json.decode(response.body);
      return Admin.fromJson(data);
    } else {
      throw Exception('Failed to load admin: ${response.body}');
    }
  }

  // Actualizar admin por email
  static Future<bool> updateAdmin({
    required String adminId,
    required Map<String, dynamic> updateData,
  }) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/admin/$adminId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      return true;  // Éxito
    } else {
      // Puedes lanzar excepción o solo devolver false
      // throw Exception('Failed to update admin: ${response.body}');
      return false;  // Falló la actualización
    }
  }

  // Eliminar admin por email
  static Future<bool> deleteAdmin(String adminId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/$adminId'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete admin: ${response.body}');
    }
  }

  // ---------- Customers ----------

  // Ver cliente por emmail
  static Future<Map<String, dynamic>> getCustomerByEmail(String email) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/customer/$email');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al obtener datos del cliente');
    }
  }

 // Obtener todos los clientes
  static Future<List<dynamic>> getAllCustomers() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/customer');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al obtener todos los clientes');
    }
  }


  // Actualizar cliente por emmail
  static Future<void> updateCustomerByEmail(String email, Map<String, dynamic> updates) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/customer/$email');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al actualizar cliente');
    }
  }

  // Desactivar cliente por emmail
  static Future<void> deactivateCustomer(String email) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/deactivateCustomer/$email');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al desactivar cuenta');
    }
  }

  // Reactivar cliente por emmail
  static Future<void> reactivateCustomer(String email) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/reactivateCustomer/$email');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al reactivar cuenta');
    }
  }

  // Listar clientes activos por emmail
  static Future<List<dynamic>> getActiveCustomers() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/customers');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al obtener clientes activos');
    }
  }

  // Listar clientes desactivados por emmail
  static Future<List<dynamic>> getDeactivatedCustomers() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/customers/deactivated');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al obtener clientes desactivados');
    }
  }


  // ---------- Productos ----------
  // Obtener producto por nombre
static Future<Map<String, dynamic>> getProductByName(String productName) async {
  final token = await _getToken();
  final url = Uri.parse('$baseUrl/products/$productName');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final error = jsonDecode(response.body)['error'] ?? 'Error al obtener producto';
    throw Exception(error);
  }
}

  // Obtener todos los productos
  static Future<List<Product>> fetchProducts() async {
  final url = Uri.parse('$baseUrl/products');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_data': 'public'}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<Product> products =
        (data['products'] as List).map((item) => Product.fromJson(item)).toList();
    return products;
  } else {
    throw Exception('Error loading products: ${response.statusCode}');
  }
}


  // Crear producto
  static Future<void> createProduct(Map<String, dynamic> productData) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(productData),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear producto: ${response.body}');
    }
  }

  // Actualizar producto
  static Future<void> updateProduct(String productId, Map<String, dynamic> updateData) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto: ${response.body}');
    }
  }

  // Eliminar producto
  static Future<void> deleteProduct(String productId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto');
    }
  }



  // ---------- Ordenes ----------

  // Ver detalles de orden
  static Future<Map<String, dynamic>> viewOrderDetails(String orderId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener detalles de la orden');
    }
  }

  // Actualizar estado de orden
  static Future<void> updateOrderStatus(String orderId, Map<String, dynamic> statusData) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$orderId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(statusData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar estado de orden');
    }
  }




//  ----- CUSTOMER -------------------------------------

 // ---------- Carrito ----------

  // Obtener productos del carrito del usuario logueado
  static Future<List<ShoppingCartItem>> fetchCartItems() async {
    final token = await _getToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null) {
      throw Exception('User ID no encontrado');
    }

    final url = Uri.parse('$baseUrl/cart');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> cartJson = jsonDecode(response.body);
      return cartJson.map((json) => ShoppingCartItem.fromJson(json)).toList();
    } else {
      throw Exception('Error cargando el carrito: ${response.body}');
    }
  }

  // Añadir producto al carrito
  static Future<void> addToCart(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al añadir al carrito: ${response.body}');
    }
  }

  
  // ---------- Registro (admin o customer)
  static Future<String> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error desconocido');
    }
  }



// Crear orden
  static Future<void> createOrder(Map<String, dynamic> orderData) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear orden: ${response.body}');
    }
  }

  
}