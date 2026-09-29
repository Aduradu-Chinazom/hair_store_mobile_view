import 'package:flutter/material.dart';

import '../screens/checkout/cart_shipping_screen.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.shopping_cart_outlined, 'Cart'),
    (Icons.favorite_border, 'Wishlist'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black26, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () {
              if (i == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartShippingScreen(),
                  ),
                );
              } else {
                onTap(i);
              }
            },
            child: Container(
              width: 66,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_items[i].$1, size: 22, color: Colors.black),
                  const SizedBox(height: 2),
                  Text(
                    _items[i].$2,
                    style: const TextStyle(fontSize: 9, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}