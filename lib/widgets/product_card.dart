import 'package:flutter/material.dart';
import '../models/product.dart';
class ProductCard extends StatelessWidget {
  final Product product;
  final bool showHeart;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.showHeart = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8EEE6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox.expand(
                      child: _image(),
                    ),
                  ),
                  if (showHeart)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 8,
                  color: const Color(0xFFF4A585),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            if (product.size.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                product.size,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.black54,
                ),
              ),
            ],
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.price,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E9E4F),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black54,
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 9,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    final placeholder = Container(
      color: const Color(0xFFE3D3C8),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.white70,
      ),
    );
    if (product.imageUrl.isEmpty) return placeholder;

    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}