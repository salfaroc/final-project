import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // flutter pub add google_fonts
import 'package:seseart/models/collection_products.dart';
import 'package:seseart/models/collection_shoppingCart.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/signup.dart';
import 'ui/logged_in.dart';
import 'ui/logged_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/product_card.dart';
import 'ui/shopping_cart.dart';  
import 'ui/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  runApp(MyApp(isLoggedIn: token != null));
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S.ESE.ART - main',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/logged_in': (context) => const LoggedInPage(),          // admin
        '/logged_customer': (context) => const LoggedCustomer(),  // cliente
        '/product_detail': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return ProductCard(product: product);
        },
        '/shopping_cart': (context) => const ShoppingCartPage(),   
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}