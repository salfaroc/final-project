import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/collection_addresses.dart';
import '../models/collection_admins.dart';
import '../models/collection_chats.dart';
// import '../models/collection_customerBackup.dart';
// import '../models/collection_customers.dart';
// import '../models/collection_offers.dart';
// import '../models/collection_orders.dart';
// import '../models/collection_payments.dart';
// import '../models/collection_permissions.dart';
import '../models/collection_products.dart';
// import '../models/collection_reviews.dart';
// import '../models/collection_shoppingCart.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000'; 

  // -------------------- Obtener productos (GET /products) --------------------
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

// ------------------------- LOGIN COMUN -------------
static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role, // 'admin' o 'customer'
  }) async {
    final url = Uri.parse('$baseUrl/comun/login');

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_role', userRole);

      return {
        'token': token,
        'role': userRole,
      };
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Login fallido';
      throw Exception(error);
    }
  }

  /// ---------------------  REGISTER COMÚN
  static Future<String> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/comun/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['message']; // Ej: "Admin registrado" o "Customer registrado"
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error desconocido');
    }
  }

  // // -------------------- Registrar administrador (POST /adminRegister) --------------------
  // static Future<Map<String, dynamic>> registerAdmin({
  //   required String name,
  //   required String email,
  //   required String password,
  //   required String phone,
  //   required List<String> permisos,
  //   required String token,
  // }) async {
  //   final url = Uri.parse('$baseUrl/adminRegister');
  //   final body = json.encode({
  //     "name": name,
  //     "email": email,
  //     "password": password,
  //     "phone": phone,
  //     "permisos": permisos,
  //   });

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //     body: body,
  //   );

  //   if (response.statusCode == 201) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Error al registrar admin: ${response.body}');
  //   }
  // }

//   // -------------------- Iniciar Sesion Admin (POST /loginAdmin) --------------------
  
// static Future<String> loginAdmin({
//   required String email,
//   required String password,
// }) async {
//   final url = Uri.parse('$baseUrl/admin/loginAdmin');

//   final response = await http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'email': email, 'password': password}),
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     return data['token'];
//   } else {
//     throw Exception('Login fallido: ${response.body}');
//   }
// }


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

  // // -------------------- 7. Registrar cliente (POST /registerCustomer) --------------------
  // static Future<Map<String, dynamic>> registerCustomer({
  //   required String name,
  //   required String email,
  //   required String password,
  //   // Otros campos que tengas en el modelo cliente
  // }) async {
  //   final url = Uri.parse('$baseUrl/registerCustomer');
  //   final body = json.encode({
  //     "name": name,
  //     "email": email,
  //     "password": password,
  //     // Añadir más campos si aplican
  //   });

  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: body,
  //   );

  //   if (response.statusCode == 201) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Error al registrar cliente: ${response.body}');
  //   }
  // }

  // // ------------------- LOGIN CUSTOMER -------------------
  // static Future<String> loginCustomer({required String email, required String password}) async {
  //   final url = Uri.parse('$baseUrl/loginCustomer');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final token = data['token'];
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('auth_token', token);
  //     return token;
  //   } else {
  //     throw Exception(jsonDecode(response.body)['error'] ?? 'Error al iniciar sesión');
  //   }
  // }


  // ------------------- VIEW CUSTOMER BY ID -------------------
  static Future<Map<String, dynamic>> viewCustomer(String id, String token) async {
    final url = Uri.parse('$baseUrl/view_customer/$id');
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

  // ------------------- UPDATE CUSTOMER -------------------
  static Future<void> updateCustomer(String id, Map<String, dynamic> updates, String token) async {
    final url = Uri.parse('$baseUrl/update_customer/$id');
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

  // ------------------- DEACTIVATE CUSTOMER -------------------
  static Future<void> deactivateCustomer(String id, String token) async {
    final url = Uri.parse('$baseUrl/deactivateCustomer/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al desactivar cuenta');
    }
  }

  // ------------------- REACTIVATE CUSTOMER -------------------
  static Future<void> reactivateCustomer(String id, String token) async {
    final url = Uri.parse('$baseUrl/reactivateCustomer/$id');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Error al reactivar cuenta');
    }
  }

  // ------------------- LIST ACTIVE CUSTOMERS -------------------
  static Future<List<dynamic>> getActiveCustomers(String token) async {
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

  // ------------------- LIST DEACTIVATED CUSTOMERS -------------------
  static Future<List<dynamic>> getDeactivatedCustomers(String token) async {
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
