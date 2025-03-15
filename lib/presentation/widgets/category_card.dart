// Update your CategoryCard widget in widgets/category_card.dart

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final dynamic icon; // Can be String (asset path) or Icon widget
  final Color color;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child:
              icon is String
                  ? Image.asset(icon, width: 32, height: 32)
                  : icon, // Use the Icon widget directly
        ),
      ),
    );
  }
}
