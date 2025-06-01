import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/collection_addresses.dart';
import '../models/collection_admins.dart';
import '../models/collection_chats.dart';
import '../models/collection_customerBackup.dart';
import '../models/collection_customers.dart';
import '../models/collection_offers.dart';
import '../models/collection_orders.dart';
import '../models/collection_payments.dart';
import '../models/collection_permissions.dart';
import '../models/collection_products.dart';
import '../models/collection_reviews.dart';
import '../models/collection_shoppingCart.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000'; // Android emulator local

  // -------------------- Obtener productos (GET /products) --------------------
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/productos_data'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  // -------------------- Registrar administrador (POST /adminRegister) --------------------
  static Future<Map<String, dynamic>> registerAdmin({
    required String name,
    required String email,
    required String password,
    required String phone,
    required List<String> permisos,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/adminRegister');
    final body = json.encode({
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "permisos": permisos,
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar admin: ${response.body}');
    }
  }

  // -------------------- Iniciar Sesion Admin (POST /loginAdmin) --------------------
  
  static Future<String> loginAdmin({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/loginAdmin');
    final body = json.encode({
      "email": email,
      "password": password,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Error en login Admin: ${response.body}');
    }
  }


  // -------------------- Obtener todos los admins (GET /admin) --------------------
  static Future<List<Admin>> fetchAdmins(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Admin.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar admins');
    }
  }

  // -------------------- 4. Obtener admin por ID (GET /admin/<id>) --------------------
  static Future<Admin> fetchAdminById(String adminId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/$adminId'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return Admin.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar admin por ID');
    }
  }

  // -------------------- 5. Actualizar admin (PUT /admin/<id>) --------------------
  static Future<void> updateAdmin({
    required String adminId,
    required Map<String, dynamic> updateData,
    required String token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/$adminId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(updateData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar admin: ${response.body}');
    }
  }

  // -------------------- 6. Eliminar admin (DELETE /admin/<id>) --------------------
  static Future<void> deleteAdmin(String adminId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/$adminId'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar admin');
    }
  }

  // -------------------- 7. Registrar cliente (POST /registerCustomer) --------------------
  static Future<Map<String, dynamic>> registerCustomer({
    required String name,
    required String email,
    required String password,
    // Otros campos que tengas en el modelo cliente
  }) async {
    final url = Uri.parse('$baseUrl/registerCustomer');
    final body = json.encode({
      "name": name,
      "email": email,
      "password": password,
      // Añadir más campos si aplican
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar cliente: ${response.body}');
    }
  }

  // -------------------- 8. Login cliente (POST /loginCustomer) --------------------
  static Future<String> loginCustomer({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/loginCustomer');
    final body = json.encode({
      "email": email,
      "password": password,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Error en login: ${response.body}');
    }
  }

  // -------------------- 9. Obtener cliente por ID (GET /customer/<id>) --------------------
  static Future<Customer> fetchCustomerById(String customerId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customer/$customerId'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener cliente');
    }
  }

  // -------------------- 10. Actualizar cliente (PUT /customer/<id>) --------------------
  static Future<void> updateCustomer({
    required String customerId,
    required Map<String, dynamic> updateData,
    required String token,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/customer/$customerId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(updateData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar cliente: ${response.body}');
    }
  }

  // -------------------- 11. Obtener todos clientes activos (GET /customers) --------------------
  static Future<List<Customer>> fetchActiveCustomers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener clientes activos');
    }
  }

  // -------------------- 12. Obtener clientes desactivados (GET /customers/deactivated) --------------------
  static Future<List<Customer>> fetchDeactivatedCustomers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers/deactivated'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener clientes desactivados');
    }
  }

  // -------------------- 13. Desactivar cliente (DELETE /deactivateCustomer/<id>) --------------------
  static Future<void> deactivateCustomer(String customerId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/deactivateCustomer/$customerId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al desactivar cliente');
    }
  }

  // -------------------- 14. Reactivar cliente (POST /reactivateCustomer/<id>) --------------------
  static Future<void> reactivateCustomer(String customerId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reactivateCustomer/$customerId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al reactivar cliente');
    }
  }

  // -------------------- 15. Obtener historial de chat (GET /chat/chatHistory/<user_id>) --------------------
  static Future<List<Chat>> fetchChatHistory(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chat/chatHistory/$userId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Chat.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener historial de chat');
    }
  }

  // -------------------- 16. Crear chat (POST /chat) --------------------
  static Future<void> createChatMessage(Map<String, dynamic> chatData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(chatData),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear mensaje de chat');
    }
  }

  // -------------------- 17. Eliminar chat (DELETE /chat/<chat_id>) --------------------
  static Future<void> deleteChat(String chatId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/chat/$chatId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar chat');
    }
  }
}

