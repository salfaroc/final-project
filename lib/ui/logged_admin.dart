import 'package:flutter/material.dart';
import '../models/collection_admins.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';


// Aquí inicias la clase principal
class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  String output = '';
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Map<String, dynamic>? customerData;
  
  List<Admin> _admins = [];
  Admin? _foundAdmin;
  String _statusMessage = '';

// ---------- SALIDA ---------------
  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

// --------------  BOTONES PARA ADMINS  ---------------------
  //------ Ver todos los admins-----
  Future<void> _fetchAdmins() async {
    setState(() {
      _statusMessage = 'Cargando admins...';
      _foundAdmin = null;
    });
    try {
      final admins = await ApiService.fetchAdmins();
      setState(() {
        _admins = admins;
        _statusMessage = 'Admins cargados: ${admins.length}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error al cargar admins: $e';
      });
    }
  }

  // ---- Buscar admin por email -------------
  Future<void> _fetchAdminById() async {
    final email = _adminIdController.text.trim();
  if (email.isEmpty) {
    setState(() {
      _statusMessage = 'Por favor, ingresa un email de admin';
      _foundAdmin = null;
    });
    return;
  }
  setState(() {
    _statusMessage = 'Buscando admin por email...';
    _foundAdmin = null;
  });
  try {
    final admin = await ApiService.fetchAdminById(email);
    setState(() {
      _foundAdmin = admin;
      _statusMessage = 'Admin encontrado: ${admin.name}';
    });
  } catch (e) {
    setState(() {
      _statusMessage = 'Error: $e';
      _foundAdmin = null;
    });
  }
  }

  //  ---------  Actualizar admin --------------------
  Future<void> _updateAdmin() async {
    final id = _adminIdController.text.trim();
    if (id.isEmpty) {
      setState(() {
        _statusMessage = 'Por favor, ingresa un EMAIL de admin para actualizar';
      });
      return;
    }
    try {
      bool success = await ApiService.updateAdmin(
        adminId: id,
        updateData: {
          'email': _adminIdController.text.trim(),
        },
      );
      setState(() {
        _statusMessage = success ? 'Admin actualizado correctamente' : 'No se pudo actualizar';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error al actualizar: $e';
      });
    }
  }

  // --------------  Eliminar admin  ---------------------
  Future<void> _deleteAdmin() async {
    final id = _adminIdController.text.trim();
    if (id.isEmpty) {
      setState(() {
        _statusMessage = 'Por favor, ingresa un EMAIL de admin para eliminar';
      });
      return;
    }
    try {
      bool success = await ApiService.deleteAdmin(id);
      setState(() {
        _statusMessage = success ? 'Admin eliminado correctamente' : 'No se pudo eliminar';
        if (success) {
          _foundAdmin = null;
          _admins.removeWhere((a) => a.email == id);
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error al eliminar: $e';
      });
    }
  }

  // --------------  BOTONES PARA CUSTOMER  ---------------------
  void _fetchCustomer() async {
    try {
      final data = await ApiService.getCustomerByEmail(_emailController.text);
      setState(() => customerData = data);
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _deactivateCustomer() async {
    try {
      await ApiService.deactivateCustomer(_emailController.text);
      _showSnackBar("Cliente desactivado");
      setState(() => customerData = null);
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _reactivateCustomer() async {
    try {
      await ApiService.reactivateCustomer(_emailController.text);
      _showSnackBar("Cliente reactivado");
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _listActiveCustomers() async {
    try {
      final result = await ApiService.getActiveCustomers();
      _showSnackBar("Activos: ${result.length}");
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _listDeactivatedCustomers() async {
    try {
      final result = await ApiService.getDeactivatedCustomers();
      _showSnackBar("Desactivados: ${result.length}");
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _getAllCustomers() async {
    try {
      final result = await ApiService.getAllCustomers();
      _showSnackBar("Total clientes: ${result.length}");
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _updateCustomer() async {
  try {
    final updated = await ApiService.updateCustomerByEmail(_emailController.text, {
      'telefono': 'nuevo telefono', 
      'pais': 'nuevo pais',
    });
    _showSnackBar("Cliente actualizado");
  } catch (e) {
    _showSnackBar("Error al actualizar: $e");
  }
}

void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _formButton(String text, VoidCallback action) {
    return ElevatedButton(onPressed: action, child: Text(text));
  }

  Widget _formButtonRow(Map<String, VoidCallback> actions) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: actions.entries
          .map((e) => _formButton(e.key, e.value))
          .toList(),
    );
  }

  Widget _textField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }  

  Widget _infoField(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value ?? "-")),
      ],
    );
  }

  Widget _buildCustomerSection() {
    return _buildSection("2. Gestión de Clientes", _customerForm(), [
      _formButton("Buscar Cliente", _fetchCustomer),
      _formButton("Actualizar Cliente", _updateCustomer),
      _formButton("Desactivar Cliente", _deactivateCustomer),
      _formButton("Reactivar Cliente", _reactivateCustomer),
      _formButton("Listar Activos", _listActiveCustomers),
      _formButton("Listar Desactivados", _listDeactivatedCustomers),
      _formButton("Listar Todos", _getAllCustomers),
    ]);
  }

  // ------------------ Controladores generales ------------------
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adminIdController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();

  // ------------------ Controladores específicos ------------------

  // Admin
  final adminNameController = TextEditingController();
  final adminEmailController = TextEditingController();
  final adminPasswordController = TextEditingController();
  final adminPhoneController = TextEditingController();
  final adminRoleController = TextEditingController();
  final adminPermisosController = TextEditingController();

  // Customer
  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final customerAddressIdController = TextEditingController();

  // Product
  final productImageController = TextEditingController();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productCategoryController = TextEditingController();
  final productStockController = TextEditingController();
  final productWidthController = TextEditingController();
  final productLengthController = TextEditingController();

  // Order
  final orderCustomerIdController = TextEditingController();
  final orderStatusController = TextEditingController();
  final orderProductIdsController = TextEditingController();
  final orderAddressIdController = TextEditingController();
  final orderTotalAmountController = TextEditingController();
  final orderPaymentStatusController = TextEditingController();

  // ------------------ Formularios ------------------

  Widget _adminForm() => Column(children: [
        TextField(controller: adminNameController, decoration: const InputDecoration(labelText: 'Nombre')),
        TextField(controller: adminEmailController, decoration: const InputDecoration(labelText: 'Email')),
        TextField(controller: adminPasswordController, decoration: const InputDecoration(labelText: 'Contraseña')),
        TextField(controller: adminPhoneController, decoration: const InputDecoration(labelText: 'Teléfono')),
        TextField(controller: adminRoleController, decoration: const InputDecoration(labelText: 'Rol')),
        TextField(controller: adminPermisosController, decoration: const InputDecoration(labelText: 'Permisos (coma separados)')),
      ]);

  Widget _customerForm() => Column(children: [
        TextField(controller: customerNameController, decoration: const InputDecoration(labelText: 'Nombre')),
        TextField(controller: customerEmailController, decoration: const InputDecoration(labelText: 'Email')),
        TextField(controller: customerPhoneController, decoration: const InputDecoration(labelText: 'Teléfono')),
        TextField(controller: customerAddressIdController, decoration: const InputDecoration(labelText: 'ID Dirección')),
      ]);

  Widget _productForm() => Column(children: [
        TextField(controller: productImageController, decoration: const InputDecoration(labelText: 'Imagen URL')),
        TextField(controller: productNameController, decoration: const InputDecoration(labelText: 'Nombre')),
        TextField(controller: productDescriptionController, decoration: const InputDecoration(labelText: 'Descripción')),
        TextField(controller: productPriceController, decoration: const InputDecoration(labelText: 'Precio')),
        TextField(controller: productCategoryController, decoration: const InputDecoration(labelText: 'Categoría')),
        TextField(controller: productStockController, decoration: const InputDecoration(labelText: 'Stock')),
        TextField(controller: productWidthController, decoration: const InputDecoration(labelText: 'Ancho')),
        TextField(controller: productLengthController, decoration: const InputDecoration(labelText: 'Largo')),
      ]);

  Widget _orderForm() => Column(children: [
        TextField(controller: orderCustomerIdController, decoration: const InputDecoration(labelText: 'ID Cliente')),
        TextField(controller: orderStatusController, decoration: const InputDecoration(labelText: 'Estado')),
        TextField(controller: orderProductIdsController, decoration: const InputDecoration(labelText: 'IDs Productos (coma separados)')),
        TextField(controller: orderAddressIdController, decoration: const InputDecoration(labelText: 'ID Dirección')),
        TextField(controller: orderTotalAmountController, decoration: const InputDecoration(labelText: 'Total (€)')),
        TextField(controller: orderPaymentStatusController, decoration: const InputDecoration(labelText: 'Estado de Pago')),
      ]);

  // ------------------ Sección de UI ------------------

  Widget _buildSection(String title, Widget form, List<Widget> actions) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              
            ),
          )
        ],
      ),
    );
  }


  // ------------------ Build ------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 113, 176),
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'S.ESE.ART - logged in',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection("1. Gestión de Administradores", Column(children: [
                  TextField(
                    controller: _adminIdController,
                    decoration: const InputDecoration(
                      labelText: "EMAIL del admin",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _formButtonRow({
                    "Ver todos los Admin": _fetchAdmins,
                    "Buscar Admin": _fetchAdminById,
                    "Actualizar Admin": _updateAdmin,
                    "Eliminar Admin": _deleteAdmin,
                  }),
                  const SizedBox(height: 12),

                  if (_statusMessage.isNotEmpty)
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.blueAccent),
                    ),

                  const SizedBox(height: 12),

                  if (_foundAdmin != null)
                    Card(
                      color: Colors.grey.shade100,
                      child: ListTile(
                        title: Text(_foundAdmin!.name),
                        subtitle: Text('Email: ${_foundAdmin!.email}\nRol: ${_foundAdmin!.role}'),
                      ),
                    ),

                  if (_admins.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Admins:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ..._admins.map((admin) => ListTile(
                              title: Text(admin.name),
                              subtitle: Text(admin.email),
                            )),
                      ],
                    ),
                ]), []),
                // SECCION 2 CUSTOMER
                 _buildCustomerSection(),
            _buildSection("3. Productos", Column(children: [
              _textField("Nombre del producto"),
              _textField("Precio"),
            ]), [
              _formButton("Ver todos los productos", () {}),
              _formButton("Crear producto", () {}),
              _formButton("Actualizar producto", () {}),
              _formButton("Eliminar producto", () {}),
            ]),
            _buildSection("4. Pedidos", Column(children: [
              _textField("ID del pedido"),
            ]), [
              _formButton("Ver detalles", () {}),
              _formButton("Actualizar estado", () {}),
            ]),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }
}

  // --------------- FOOTER ---------------------
  Widget _buildFooter() {
  return Container(
    width: double.infinity,
    color: const Color(0xFF2E1A47),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // menos alto
    child: Center(
      child: FittedBox(
        alignment: Alignment.topLeft,
        fit: BoxFit.scaleDown,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Meet the Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Sara Alfaro Carrillo',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'GitHub: github.com/salfaroc',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Gwyneth Mendoza Castro',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'GitHub: github.com/9u-bit',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 160,
              color: Colors.white24,
              margin: const EdgeInsets.symmetric(horizontal: 32),
            ),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Legal & Technology',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '© 2025 S.ESE.ART — All rights reserved.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Built with:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Python',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '• MongoDB',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '• Flutter',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 300),
          ],
        ),
      ),
    ),
  );
}

