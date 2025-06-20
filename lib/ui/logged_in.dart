import 'package:flutter/material.dart';
import 'package:seseart/models/collection_customerAdress.dart';
import 'package:seseart/models/collection_customers.dart';
import 'package:seseart/models/collection_products.dart';
import '../models/collection_admins.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';



class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});
  
  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Map<String, dynamic>? customerData;
  Map<String, dynamic>? productData;

  // Control de vista
  bool _showCustomerFields = true;
  List<CustomerWithAddress> _customerList = [];
  List<Product> _productList = [];

  // Controladores de texto opcion 2
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
  final TextEditingController _searchEmailController = TextEditingController();

   // Controladores de texto opcion 3
  final TextEditingController _searchNameController = TextEditingController();
  final _namepController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  final _createdAtController = TextEditingController();
  final _widthController = TextEditingController();
  final _lengthController = TextEditingController();



Widget _buildLabeledTextField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}
@override
  void dispose() {
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

    _namepController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _stockQuantityController.dispose();
    _createdAtController.dispose();
    _widthController.dispose();
    _lengthController.dispose();
    super.dispose();
  }



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


// ----------------------------------------------------------------------------
  // --------------  BOTONES PARA CUSTOMER  ---------------------
  void getCustomerByEmail() async {
  try {
    final data = await ApiService.getCustomerByEmail(_searchEmailController.text.trim());
    setState(() {
      // Aquí asignas los datos a tus TextEditingControllers
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

  void _updateCustomer() async {
  try {
    // Construir el Map con los datos actuales de los campos
    final updates = {
      "email": _emailController.text,
      "name": _nameController.text,
      "first_surname": _firstSurnameController.text,
      "second_surname": _secondSurnameController.text,
      "phone": _phoneController.text,
      "pais": _paisController.text,
      "ciudad": _ciudadController.text,
      "provincia": _provinciaController.text,
      "codigo_postal": _codigoPostalController.text,
      "gender": _genderController.text,
      "fecha_nacimiento": _fechaNacimientoController.text,
    };
    await ApiService.updateCustomerByEmail(_emailController.text, updates);

    _showSnackBar("Cliente actualizado correctamente");
  } catch (e) {
    _showSnackBar("Error al actualizar: $e");
  }
}

void _deactivateCustomer() async {
  if (_emailController.text.isEmpty) {
    _showSnackBar("Por favor, ingresa el email del cliente");
    return;
  }

  try {
    await ApiService.deactivateCustomer(_emailController.text);
    _showSnackBar("Cliente desactivado correctamente");

    // Limpiamos la info actual
    setState(() {
      customerData = null;
      _emailController.clear();
      _nameController.clear();
      _firstSurnameController.clear();
      _secondSurnameController.clear();
      _phoneController.clear();
      _paisController.clear();
      _ciudadController.clear();
      _provinciaController.clear();
      _codigoPostalController.clear();
      _genderController.clear();
      _fechaNacimientoController.clear();
      _showCustomerFields = true;
    });

  } catch (e) {
    _showSnackBar("Error al desactivar cliente: $e");
  }
}


  // void _reactivateCustomer() async {
  //   try {
  //     await ApiService.reactivateCustomer(_emailController.text);
  //     _showSnackBar("Cliente reactivado");
  //   } catch (e) {
  //     _showSnackBar("Error: $e");
  //   }
  // }

  // void _listActiveCustomers() async {
  //   try {
  //     final result = await ApiService.getActiveCustomers();
  //     _showSnackBar("Activos: ${result.length}");
  //   } catch (e) {
  //     _showSnackBar("Error: $e");
  //   }
  // }

  // void _listDeactivatedCustomers() async {
  //   try {
  //     final result = await ApiService.getDeactivatedCustomers();
  //     _showSnackBar("Desactivados: ${result.length}");
  //   } catch (e) {
  //     _showSnackBar("Error: $e");
  //   }
  // }

  // void _getAllCustomers() async {
  //   try {
  //     final result = await ApiService.getAllCustomers();
  //     _showSnackBar("Total clientes: ${result.length}");
  //   } catch (e) {
  //     _showSnackBar("Error: $e");
  //   }
  // }

// ------- BOTONES PARA PRODUCTO
// Obtener producto por name
void getProductByName() async {
  if (_searchNameController.text.trim().isEmpty) {
  _showSnackBar("Por favor, ingresa el nombre del producto a buscar");
  return;
}
  try {
    final data = await ApiService.getProductByName(_searchNameController.text.trim());
    setState(() {
      // Asignar a controllers
      _namepController.text = data['name'] ?? '';
      _imageController.text = data['image'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _priceController.text = data['price']?.toString() ?? '';
      _categoryController.text = data['category'] ?? '';
      _stockQuantityController.text = data['stock_quantity']?.toString() ?? '';
      _createdAtController.text = data['created_at'] ?? '';
      _widthController.text = data['width']?.toString() ?? '';
      _lengthController.text = data['length']?.toString() ?? '';
   
    });
  } catch (e) {
    _showSnackBar("Error: $e");
    _clearProductFields();
  }
}

void _clearProductFields() {
  setState(() {
    _namepController.clear();
    _imageController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _categoryController.clear();
    _stockQuantityController.clear();
    _createdAtController.clear();
    _widthController.clear();
    _lengthController.clear();
  });
}


// Cear producto por name
void _createProduct() async {
  if (_namepController.text.isEmpty) {
    _showSnackBar("Por favor, ingresa el nombre del producto");
    return;
  }

  final productData = {
    "name": _namepController.text.trim(),
    "image": _imageController.text.trim(),
    "description": _descriptionController.text.trim(),
    "price": double.tryParse(_priceController.text) ?? 0,
    "category": _categoryController.text.trim(),
    "stock_quantity": int.tryParse(_stockQuantityController.text) ?? 0,
    "created_at": DateTime.now().toUtc().toIso8601String(),
    "width": int.tryParse(_widthController.text) ?? 0,
    "length": int.tryParse(_lengthController.text) ?? 0,
  };

  print("Creando producto con datos: $productData");

  try {
    await ApiService.createProduct(productData);
    _showSnackBar("Producto creado correctamente");
    _clearProductFields();

  } catch (e) {
    _showSnackBar("Error al crear producto: $e");
  }
}



// Actualizar producto (usa productData? para obtener el id)
void _updateProduct() async {
  try {
    final updates = {
      "name": _namepController.text,
      "image": _imageController.text,
      "description": _descriptionController.text,
      "price": double.tryParse(_priceController.text) ?? 0,
      "category": _categoryController.text,
      "stock_quantity": int.tryParse(_stockQuantityController.text) ?? 0,
      "created_at": _createdAtController.text,
      "width": int.tryParse(_widthController.text) ?? 0,
      "length": int.tryParse(_lengthController.text) ?? 0,
    };
    await ApiService.updateProduct(_namepController.text, updates);
    _showSnackBar("Producto actualizado correctamente");
  } catch (e) {
    _showSnackBar("Error al actualizar producto: $e");
  }
}
// Eliminar producto
void _deleteProduct() async {

  if (_namepController.text.isEmpty) {
    _showSnackBar("Por favor, ingresa el Nombre de prodcuto");
    return;
  }
  try {
    await ApiService.deleteProduct(_namepController.text);
    _showSnackBar("Producto eliminado correctamente");
    _clearProductFields();

  } catch (e) {
    _showSnackBar("Error al eliminar producto: $e");
  }
}


// --------- ESTILO DISEÑO -------------- 
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(String label, {TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

   Widget _formButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 11, 113, 176),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget _formButtonRow(Map<String, VoidCallback> actions) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.entries
          .map((e) => _formButton(e.key, e.value))
          .toList(),
    );
  }


// ---------- ESTILO PARTE CUSTOMER -------- 
void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
  // Widget principal
  Widget _buildCustomerSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IZQUIERDA
          Expanded(
            child: _showCustomerFields
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabeledTextField("Email", _emailController),
                        _buildLabeledTextField("Nombre", _nameController),
                        _buildLabeledTextField("Primer Apellido", _firstSurnameController),
                        _buildLabeledTextField("Segundo Apellido", _secondSurnameController),
                        _buildLabeledTextField("Teléfono", _phoneController),
                        _buildLabeledTextField("País", _paisController),
                        _buildLabeledTextField("Ciudad", _ciudadController),
                        _buildLabeledTextField("Provincia", _provinciaController),
                        _buildLabeledTextField("Código Postal", _codigoPostalController),
                        _buildLabeledTextField("Género", _genderController),
                        _buildLabeledTextField("Fecha de Nacimiento", _fechaNacimientoController),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: _customerList.map((customerData) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nombre: ${customerData.customer.name}"),
                                Text("Email: ${customerData.customer.email}"),
                                Text("Teléfono: ${customerData.customer.phone}"),
                                Text( "Ubicación: ${customerData.address.ciudad}, ${customerData.address.provincia}, ${customerData.address.pais}"),
                                Text("Código Postal: ${customerData.address.codigoPostal}"),
                                Text("Género: ${customerData.address.gender}"),
                                Text("Nacimiento: ${customerData.address.fechaNacimiento.toLocal().toString().split(' ')[0]}"),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),

          const SizedBox(width: 24),

          // DERECHA
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
              //   _formButton("Ver todos los clientes", () async{
              //     setState(() {
              //       _showCustomerFields = false;
              //       List<dynamic> _customerList = [];  // Lista para todos los clientes
              //       dynamic? _selectedCustomer;        // Cliente seleccionado para reactivar
              //     });
              //     _getAllCustomers();
              //   }),
                _formButton("Buscar cliente", () async  {
                  getCustomerByEmail();
                }),
                _formButton("Actualizar cliente", () async{
                  _updateCustomer();
                }),
                _formButton("Desactivar cliente", () async {
                  _deactivateCustomer();
                }),
              //   _formButton("Reactivar cliente", () async {
              //     _reactivateCustomer();
              //   }),
              //   _formButton("Lista clientes Activos", () {
              //     setState(() {
              //       _showCustomerFields = false;
              //     });
              //     _listActiveCustomers();
              //   }),
              //   _formButton("Lista clientes Desactivos", () {
              //     setState(() {
              //       _showCustomerFields = false;
              //     });
              //     _listDeactivatedCustomers();
              //   }),
              ],
            ),
          ),
        ],
      ),
    );
  }


Widget _buildCustomerProductos() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IZQUIERDA
          Expanded(
            child: _showCustomerFields
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabeledTextField("Nombre", _namepController),
                        _buildLabeledTextField("Image", _imageController),
                        _buildLabeledTextField("description" , _descriptionController),
                        _buildLabeledTextField("price", _priceController),
                        _buildLabeledTextField("category", _categoryController),
                        _buildLabeledTextField("stockQuantity", _stockQuantityController),
                        _buildLabeledTextField("createdAt", _createdAtController),
                        _buildLabeledTextField("width", _widthController),
                        _buildLabeledTextField("length", _lengthController),

                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children:_productList.map((product)  {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nombre: ${product.name}"),
                                Text("Descripcion: ${product.description}"),
                                Text("Price: ${product.price}"),
                                Text( "Category: ${product.category}"), 
				                        Text( "stockQuantity: ${product.stockQuantity}"), 
				                        Text( "createdAt: ${product.createdAt}"),
                                Text("Width: ${product.width}"),
                                Text("Legnth: ${product.length}"),

                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),

          const SizedBox(width: 24),

          // DERECHA
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                 _formButton("Buscar prodcuto", () async  {
                 getProductByName();
                }),
                _formButton("Crear producto", () async{
                  _createProduct();
                }),
		            _formButton("Actualizar producto", () async{
                  _updateProduct();
                }),
		            _formButton("Eliminar producto", () async{
                  _deleteProduct();
                }),

              ],
            ),
          ),
        ],
      ),
    );
  }




//  --------------- RESTO DISEÑO PAGINA --------------
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
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection("1. Gestión de Administradores", [
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
                ]),
                // SECCION 2 CUSTOMER
                _buildSection("2. Customer", [
                  _textField("Email del customer", controller: _searchEmailController),
                  _buildCustomerSection(),
                ]),
                // SECCION 3 PRODUCTOS
                _buildSection("3. Productos", [
                  _textField("Nombre del producto" , controller: _searchNameController),
                  _buildCustomerProductos(),
                  
                ]),
                _buildSection("4. Pedidos", [
                  _textField("ID del pedido"),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _formButton("Ver detalles", () {/* acción aquí */}),
                      _formButton("Actualizar estado", () {/* acción aquí */}),
                    ],
                  ),
                ]),
                const SizedBox(height: 40),
                _buildFooter(), 
              ],
            ),
          ),
        ),
      ),
    ); 
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
}
