import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black26, width: 0.8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Colors.black38),
          const SizedBox(width: 6),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const Icon(Icons.photo_camera_outlined,
              size: 20, color: Colors.black38),
        ],
      ),
    );
  }
}