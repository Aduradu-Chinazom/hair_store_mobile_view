class CartItem {
  final String id;
  final String productId;
  final String title;
  final String seller;
  final double price;
  final String imageUrl;
  final String size;
  int quantity;

  CartItem({
    this.id = '',
    this.productId = '',
    required this.title,
    required this.seller,
    required this.price,
    this.imageUrl = '',
    this.size = '',
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? json['product_id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      seller: json['seller']?.toString() ?? 'Hair Haven',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? json['image_url']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'seller': seller,
      'price': price,
      'imageUrl': imageUrl,
      'size': size,
      'quantity': quantity,
    };
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? title,
    String? seller,
    double? price,
    String? imageUrl,
    String? size,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      seller: seller ?? this.seller,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}
