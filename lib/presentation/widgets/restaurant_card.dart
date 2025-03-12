import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';

class RestaurantCard extends StatelessWidget {
  final String restaurantName;
  final double rating;
  final String priceLevel;
  final String cuisine;
  final String image;
  final Color backgroundColor;
  final bool rightSideImage;

  const RestaurantCard({
    super.key,
    required this.restaurantName,
    required this.rating,
    required this.priceLevel,
    required this.cuisine,
    required this.image,
    required this.backgroundColor,
    this.rightSideImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 220, minHeight: 220),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image
          Center(child: Image.asset(image, width: 109)),

          const SizedBox(height: 8),

          // Restaurant Info
          Text(restaurantName, style: AppTextStyles.paragraphMediumBold),

          const SizedBox(height: 8),

          // Rating and Price Row
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(rating.toString(), style: AppTextStyles.paragraphSmall),
              const SizedBox(width: 12),
              Text(priceLevel, style: AppTextStyles.paragraphSmall),
            ],
          ),

          const SizedBox(height: 8),

          // Category Tags
          Row(
            children: [
              RestaurantTag(text: "Restaurants"),
              const SizedBox(width: 8),
              RestaurantTag(text: cuisine),
            ],
          ),
        ],
      ),
    );
  }
}

class RestaurantTag extends StatelessWidget {
  final String text;

  const RestaurantTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: AppTextStyles.paragraphSmall),
    );
  }
}
