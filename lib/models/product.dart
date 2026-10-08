class Product {
  final String id;
  final String title;
  final String price; // e.g. "$27.89" or "27.89"
  final String imageUrl;
  final List<String> images;
  final String size;
  final String description;
  final String brand;
  final String category;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final bool isWishlisted;

  const Product({
    this.id = '',
    required this.title,
    required this.price,
    this.imageUrl = '',
    this.images = const [],
    this.size = '',
    this.description = '',
    this.brand = '',
    this.category = '',
    this.rating = 5.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.isWishlisted = false,
  });

  /// Extracts numeric price value for calculation.
  double get numericPrice {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Ensures price string formatted with currency symbol.
  String get formattedPrice {
    if (price.startsWith('\$')) return price;
    final val = numericPrice;
    return '\$${val.toStringAsFixed(2)}';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    final imgList = rawImages?.map((e) => e.toString()).toList() ?? [];

    return Product(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '\$0.00',
      imageUrl: json['imageUrl']?.toString() ??
          json['image_url']?.toString() ??
          (imgList.isNotEmpty ? imgList.first : ''),
      images: imgList,
      size: json['size']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: json['reviewCount'] as int? ?? json['review_count'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isWishlisted: json['isWishlisted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'size': size,
      'description': description,
      'brand': brand,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'isWishlisted': isWishlisted,
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? price,
    String? imageUrl,
    List<String>? images,
    String? size,
    String? description,
    String? brand,
    String? category,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    bool? isWishlisted,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      size: size ?? this.size,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }
}
