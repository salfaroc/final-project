import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:seseart/main.dart';
import 'messages.dart';
import 'login_signup.dart';
import 'product_details.dart';

class Products extends StatelessWidget {
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
                  buildNavItem(context, 'Home', HomePage()),
                  buildNavItem(context, 'Products', Products()),
                  buildNavItem(context, 'Messages', Messages()),
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
              controller: _scrollController,
              child: Container(
                width:
                    MediaQuery.of(context).size.width *
                    0.85, // Adds space on the sides
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.075,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    // Featured Products
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Featured Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    buildProductGrid(context, 8, isFeatured: true),

                    SizedBox(height: 40),
                    // All Products
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    buildProductGrid(context, 16, isFeatured: false),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          buildFooter(),
        ],
      ),
    );
  }

  // Navigation
  Widget buildNavItem(BuildContext context, String title, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (title == "Products" &&
            ModalRoute.of(context)?.settings.name == "/products") {
          // If already on Products, scroll to the top
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else if (title == "Home") {
          // Navigate to the HomePage (main.dart) and remove all previous routes
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (page != null) {
          // Navigate to other pages (e.g., Products, Messages, etc.)
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

  // Product grid
  Widget buildProductGrid(
    BuildContext context,
    int count, {
    bool isFeatured = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: count,
        itemBuilder: (context, index) {
          final title =
              isFeatured ? 'Featured ${index + 1}' : 'Product ${index + 1}';
          final price = '${(index + 1) * 50}€';
          final isOffer = !isFeatured && index < 4;
          return buildProductCard(context, title, price, isOffer: isOffer);
        },
      ),
    );
  }

  // Product card
  Widget buildProductCard(
    BuildContext context,
    String title,
    String price, {
    bool isOffer = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(title: title, price: price),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    'assets/banner.jpg',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isOffer)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Offer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Ensure text aligns left
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(price, style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
