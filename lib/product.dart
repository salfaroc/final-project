class Product {
  final String name;
  final String description;
  final double price;
  final String category;
  final int stockQuantity;
  final DateTime createdAt;
  final String imageUrl;
  final bool isOffer;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stockQuantity,
    required this.createdAt,
    required this.imageUrl,
    required this.isOffer,
  });
}
