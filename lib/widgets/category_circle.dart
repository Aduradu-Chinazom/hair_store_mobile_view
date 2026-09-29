import 'package:flutter/material.dart';

class CategoryCircle extends StatelessWidget {
  final String label;
  final String? imageUrl;

  const CategoryCircle({super.key, required this.label, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: imageUrl == null
                  ? null
                  : DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A2E28),
            ),
          ),
        ],
      ),
    );
  }
}