import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'products.dart';
import 'messages.dart';
import 'profile.dart';

class LoggedIn extends StatelessWidget {
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
                  buildNavItem(context, 'Home', null),
                  buildNavItem(context, 'Products', Products()),
                  buildNavItem(context, 'Messages', Messages()),
                  buildNavItem(context, 'Profile', Profile()),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        // Banner
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                width:
                    MediaQuery.of(context).size.width *
                    0.85, // Adds some space on the sides
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.075,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    // Hero Section
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // Image
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/banner.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Text
                          Positioned(
                            left: 20,
                            top: 30,
                            right: MediaQuery.of(context).size.width * 0.5,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
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
                  ],
                ),
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
