class CartItem {
  final String title;
  final String seller;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.title,
    required this.seller,
    required this.price,
    this.imageUrl = '',
    this.quantity = 1,
  });
}