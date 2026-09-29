import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _link('Condition of Use'),
            const SizedBox(width: 24),
            _link('Privacy Notice'),
            const SizedBox(width: 24),
            _link('Help'),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '@2026, HairHaven.com Inc',
          style: TextStyle(
            fontSize: 11,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _link(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF1A73E8),
        ),
      ),
    );
  }
}