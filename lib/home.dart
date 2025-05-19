import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart'; // flutter pub add auto_size_text
//import 'home.dart';
import 'orders.dart';
import 'messages.dart';
import 'login_signup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E1A47),
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'S.ESE.ART',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          _buildMenuItem(context, 'Home', const HomePage()), // home.dart
          _buildMenuItem(
            context,
            'My Orders',
            const OrdersPage(),
          ), // orders.dart
          _buildMenuItem(
            context,
            'Messages',
            const MessagesPage(),
          ), // messages.dart
          _buildMenuItem(
            context,
            'Login / Signup',
            const LoginSignupPage(),
          ), // login_signup.dart
          const SizedBox(width: 24),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(150, 30, 150, 50),
        // Banner
        child: Container(
          height: 250,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/banner.jpg', fit: BoxFit.cover),
                ),
              ),
              // Dark overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
              // Text container
              Positioned(
                left: 24,
                top: 30,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black.withOpacity(0.5),
                  child: const Text(
                    'Discover Unique Artworks',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // About Us
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
