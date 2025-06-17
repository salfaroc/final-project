import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seseart/services/api_service.dart';
import 'logged_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'admin';

  // Controllers comunes
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Controllers de customer
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstSurnameController = TextEditingController();
  final TextEditingController _secondSurnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _codigoPostalController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No estás autorizado para registrar')),
        );
        setState(() => _isLoading = false);
        return;
      }

      Map<String, dynamic> userData;

      if (_selectedRole == 'admin') {
        userData = {
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'role': 'admin',
        };
      } else {
        userData = {
          'name': _nameController.text.trim(),
          'first_surname': _firstSurnameController.text.trim(),
          'second_surname': _secondSurnameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'phone': _phoneController.text.trim(),
          'pais': _paisController.text.trim(),
          'ciudad': _ciudadController.text.trim(),
          'provincia': _provinciaController.text.trim(),
          'codigo_postal': _codigoPostalController.text.trim(),
          'gender': _genderController.text.trim(),
          'fecha_nacimiento': _fechaNacimientoController.text.trim(),
          'role': 'customer',
        };
      }

      await ApiService.register(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoggedInPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, VoidCallback? toggleObscure, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: toggleObscure,
              )
            : null,
      ),
    );
  }

  List<Widget> _buildCustomerFields() {
    return [
      _buildTextField(_nameController, 'Nombre'),
      const SizedBox(height: 12),
      _buildTextField(_firstSurnameController, 'Primer apellido'),
      const SizedBox(height: 12),
      _buildTextField(_secondSurnameController, 'Segundo apellido'),
      const SizedBox(height: 12),
      _buildTextField(_phoneController, 'Teléfono', keyboardType: TextInputType.phone),
      const SizedBox(height: 12),
      _buildTextField(_paisController, 'País'),
      const SizedBox(height: 12),
      _buildTextField(_ciudadController, 'Ciudad'),
      const SizedBox(height: 12),
      _buildTextField(_provinciaController, 'Provincia'),
      const SizedBox(height: 12),
      _buildTextField(_codigoPostalController, 'Código Postal'),
      const SizedBox(height: 12),
      _buildTextField(_genderController, 'Género (femenino/masculino/otro)'),
      const SizedBox(height: 12),
      _buildTextField(_fechaNacimientoController, 'Fecha de nacimiento (DD/MM/YYYY)'),
      const SizedBox(height: 12),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E1A47),
        title: const Text('Registro S.ESE.ART', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 50),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Registro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Dropdown para seleccionar el rol
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                      DropdownMenuItem(value: 'customer', child: Text('Cliente')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Rol',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_selectedRole == 'customer') ..._buildCustomerFields(),

                  _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _passwordController,
                    'Contraseña',
                    obscureText: _obscurePassword,
                    toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _confirmPasswordController,
                    'Confirmar contraseña',
                    obscureText: _obscureConfirmPassword,
                    toggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E1A47),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Registrar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
