import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String title;
  final String price;

  ProductDetails({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/banner.jpg', width: 250, height: 250),
            SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(price, style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}