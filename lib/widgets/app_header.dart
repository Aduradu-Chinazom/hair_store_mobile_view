import 'package:flutter/material.dart';
import 'package:hairstore/screens/checkout/cart_shipping_screen.dart';

import 'home_search_bar.dart';
import 'promo_ticker.dart';

class AppHeader extends StatelessWidget {
  final bool showTabs;
  final int selectedTab;
  final ValueChanged<int>? onTabChanged;

  const AppHeader({
    super.key,
    this.showTabs = true,
    this.selectedTab = 0,
    this.onTabChanged,
  });

  static const tabs = [
    'All Categories',
    'Hair Extensions',
    'Hair Tools',
    'Accessories',
    'Wigs',
    'Oils',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF654039),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PromoTicker(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.white, size: 22),
                  Row(
                    children: const [
                      Icon(Icons.eco_outlined, color: Colors.white, size: 18),
                      SizedBox(width: 3),
                      Text(
                        'Hair Haven',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.white, size: 21),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                             MaterialPageRoute(
                              builder: (context) => const CartShippingScreen(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.language, color: Colors.white, size: 21),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: HomeSearchBar(),
            ),
            if (showTabs)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final selected = i == selectedTab;
                    return GestureDetector(
                      onTap: () => onTabChanged?.call(i),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tabs[i],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: selected
                                  ? const Color(0xFF4A2E28)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}