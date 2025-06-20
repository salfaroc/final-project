import 'package:flutter/material.dart';

import '../services/api_service.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  final _searchEmailController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _firstSurnameController = TextEditingController();
  final _secondSurnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _paisController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _genderController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();

  bool _showCustomerFields = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> getCustomerByEmail() async {
    final email = _searchEmailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar("Por favor ingresa un email para buscar");
      return;
    }
    try {
      final data = await ApiService.getCustomerByEmail(email);
      setState(() {
        _emailController.text = data['email'] ?? '';
        _nameController.text = data['name'] ?? '';
        _firstSurnameController.text = data['first_surname'] ?? '';
        _secondSurnameController.text = data['second_surname'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _paisController.text = data['pais'] ?? '';
        _ciudadController.text = data['ciudad'] ?? '';
        _provinciaController.text = data['provincia'] ?? '';
        _codigoPostalController.text = data['codigo_postal'] ?? '';
        _genderController.text = data['gender'] ?? '';
        _fechaNacimientoController.text = data['fecha_nacimiento'] ?? '';
        _showCustomerFields = true;
      });
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  @override
  void dispose() {
    _searchEmailController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _firstSurnameController.dispose();
    _secondSurnameController.dispose();
    _phoneController.dispose();
    _paisController.dispose();
    _ciudadController.dispose();
    _provinciaController.dispose();
    _codigoPostalController.dispose();
    _genderController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Admin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _searchEmailController,
              decoration: const InputDecoration(
                labelText: 'Buscar por Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: getCustomerByEmail,
              child: const Text('Ver mis datos Admin'),
            ),
            const SizedBox(height: 20),

            if (_showCustomerFields) ...[
              _buildTextField('Email', _emailController, enabled: false),
              _buildTextField('Nombre', _nameController, enabled: false),
              _buildTextField('Primer Apellido', _firstSurnameController, enabled: false),
              _buildTextField('Segundo Apellido', _secondSurnameController, enabled: false),
              _buildTextField('Teléfono', _phoneController, enabled: false),
              _buildTextField('País', _paisController, enabled: false),
              _buildTextField('Ciudad', _ciudadController, enabled: false),
              _buildTextField('Provincia', _provinciaController, enabled: false),
              _buildTextField('Código Postal', _codigoPostalController, enabled: false),
              _buildTextField('Género', _genderController, enabled: false),
              _buildTextField('Fecha de Nacimiento', _fechaNacimientoController, enabled: false),
            ],
          ],
        ),
      ),
    );
  }
}

// Nota: recuerda que ApiService.getCustomerByEmail debe devolver un Map<String, dynamic>
