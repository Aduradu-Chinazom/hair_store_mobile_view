import 'package:flutter/material.dart';

class CheckoutHeader extends StatelessWidget {
  const CheckoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF654039),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.eco_outlined, size: 16, color: Colors.white),
                  SizedBox(width: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hair',
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Haven',
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.person_outline, size: 17, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.shopping_cart_outlined,
                      size: 17, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.language, size: 17, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}