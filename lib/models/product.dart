class Product {
  final String title;
  final String price;
  final String imageUrl;
  final String size;

  const Product({
    required this.title,
    required this.price,
    this.imageUrl = '',
    this.size = '',
  });
}