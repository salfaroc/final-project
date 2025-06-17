class Admin {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final List<String> permisos;
  final String role;
  final DateTime createdAt;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.permisos,
    required this.role,
    required this.createdAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      permisos: List<String>.from(json['permisos'] ?? []),
      role: json['role'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'permisos': permisos,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
