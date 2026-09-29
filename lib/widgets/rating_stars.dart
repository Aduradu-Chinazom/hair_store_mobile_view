import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int stars;
  final double size;

  const RatingStars({super.key, this.stars = 5, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (i) => Icon(
          i < stars ? Icons.star : Icons.star_border,
          size: size,
          color: const Color(0xFFF5A623),
        ),
      ),
    );
  }
}