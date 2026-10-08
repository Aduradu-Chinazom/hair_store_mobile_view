import 'package:flutter/material.dart';

import '../screens/checkout/cart_shipping_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';

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

  void _handleNavigation(BuildContext context, int index) {
    onTap(index);
    if (currentIndex == index) return;

    Widget targetScreen;
    switch (index) {
      case 0:
        targetScreen = const HomeScreen();
        break;
      case 1:
        targetScreen = const CartShippingScreen();
        break;
      case 2:
        targetScreen = const WishlistScreen();
        break;
      case 3:
        targetScreen = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black26, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () => _handleNavigation(context, i),
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
