import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'products.dart';
import 'offers.dart';
import 'messages.dart';
import 'profile.dart';
import 'login_signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      // Header
      appBar: AppBar(
        backgroundColor: Color(0xFF2E1A47),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Text(
                'S.ESE.ART',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  // Menu
                  buildNavItem(context, 'Home', null),
                  buildNavItem(context, 'Products', Products()),
                  buildNavItem(context, 'Offers', Offers()),
                  buildNavItem(context, 'Messages', Messages()),
                  buildNavItem(context, 'Profile', Profile()),
                  buildNavItem(context, 'Login / Signup', LoginSignup()),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [Container(height: 800, color: Colors.transparent)],
              ),
            ),
          ),
          buildFooter(),
        ],
      ),
    );
  }

  // Navigation
  Widget buildNavItem(BuildContext context, String title, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (title == "Home") {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  // Footer
  Widget buildFooter() {
    return Container(
      color: Color(0xFF2E1A47),
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '© 2025 S.ESE.ART - All Rights Reserved',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            'Sara Alfaro Carrillo & Gwyneth Mendoza Castro',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'Proyecto Final - Centro Profesional JOYFE',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
