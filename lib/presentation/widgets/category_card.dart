import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/pages/food_category_screen.dart';

class CategoryCard extends StatelessWidget {
  final String icon;
  final Color color;

  const CategoryCard({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.2,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (contex) => FoodCategoryScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(icon, width: 32, color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
