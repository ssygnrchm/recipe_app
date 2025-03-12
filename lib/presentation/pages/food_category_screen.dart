import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/colors.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';
import 'package:food_delivery_app/theme/app_theme.dart';

class FoodCategoryScreen extends StatelessWidget {
  const FoodCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Orange circle background
          Positioned(
            top: -100,
            left: -120,
            child: Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary, // Using primary from theme
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar with back button and category tabs
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.iconTheme.color,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () => Navigator.pop(context),
                      ),

                      // Category selection row
                      Row(
                        children: [
                          CustomText(
                            title: "Restaurants",
                            style: AppTextStyles.paragraphLarge,
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: theme.colorScheme.onPrimary
                                .withOpacity(0.4),
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            title: "Takeaway",
                            style: AppTextStyles.paragraphLarge,
                          ),
                        ],
                      ),

                      // Fast Food title
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: CustomText(
                          title: "Fast Food",
                          style: AppTextStyles.display1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Illustration
                SizedBox(
                  height: 180,
                  child: Center(
                    child: Image.asset(
                      'assets/images/fast_food_illustration.png',
                      // Fallback if image not available
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.fastfood,
                            size: 100,
                            color: theme.colorScheme.secondary,
                          ),
                    ),
                  ),
                ),

                // Grid of food categories
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                      children: [
                        FoodCategoryCard(
                          title: "Pizza",
                          price: "\$6",
                          iconData: Icons.local_pizza,
                          backgroundColor: const Color(0xFFFFE6D4),
                        ),
                        FoodCategoryCard(
                          title: "Taco",
                          price: "\$12",
                          iconData: Icons.lunch_dining,
                          backgroundColor: const Color(0xFFFFF0CE),
                        ),
                        FoodCategoryCard(
                          title: "Chinese",
                          price: "\$9",
                          iconData: Icons.ramen_dining,
                          backgroundColor: const Color(0xFFD2F4E8),
                        ),
                        FoodCategoryCard(
                          title: "Chicken",
                          price: "\$10",
                          iconData: Icons.set_meal,
                          backgroundColor: const Color(0xFFE2DDFF),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodCategoryCard extends StatelessWidget {
  final String title;
  final String price;
  final IconData iconData;
  final Color backgroundColor;

  const FoodCategoryCard({
    super.key,
    required this.title,
    required this.price,
    required this.iconData,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and price
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.h2(context, title),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText.bodySmall(context, price),
                ),
              ],
            ),
          ),

          // Food icon
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FoodIcon(iconData: iconData),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodIcon extends StatelessWidget {
  final IconData iconData;

  const FoodIcon({super.key, required this.iconData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Custom styling for each food icon
    switch (iconData) {
      case Icons.local_pizza:
        return Icon(
          Icons.local_pizza,
          size: 60,
          color:
              theme.brightness == Brightness.light
                  ? Colors.deepOrange
                  : primaryColor,
        );
      case Icons.lunch_dining:
        return Icon(Icons.lunch_dining, size: 60, color: primaryColor);
      case Icons.ramen_dining:
        return Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.ramen_dining,
                  size: 30,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.dinner_dining,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        );
      case Icons.set_meal:
        return Transform.rotate(
          angle: 0.5,
          child: Icon(Icons.escalator_warning, size: 60, color: primaryColor),
        );
      default:
        return Icon(iconData, size: 60, color: primaryColor);
    }
  }
}
