import 'package:flutter/material.dart';
// import 'package:food_delivery_app/core/constants/colors.dart';
// import 'package:food_delivery_app/core/constants/text_styles.dart';

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
            right: -150,
            child: Container(
              height: 500,
              width: 500,
              decoration: const BoxDecoration(
                color: Color(0xFFFFAB4B),
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
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () => Navigator.pop(context),
                      ),

                      // Category selection row
                      const Row(
                        children: [
                          Text(
                            "Restaurants",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8),
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.black38,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Takeaway",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Fast Food title
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Fast Food",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
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
                          (context, error, stackTrace) => const Icon(
                            Icons.fastfood,
                            size: 100,
                            color: Colors.blue,
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
                      children: const [
                        FoodCategoryCard(
                          title: "Pizza",
                          price: "\$6",
                          iconData: Icons.local_pizza,
                          backgroundColor: Color(0xFFFFE6D4),
                        ),
                        FoodCategoryCard(
                          title: "Taco",
                          price: "\$12",
                          iconData: Icons.lunch_dining,
                          backgroundColor: Color(0xFFFFF0CE),
                        ),
                        FoodCategoryCard(
                          title: "Chinese",
                          price: "\$9",
                          iconData: Icons.ramen_dining,
                          backgroundColor: Color(0xFFD2F4E8),
                        ),
                        FoodCategoryCard(
                          title: "Chicken",
                          price: "\$10",
                          iconData: Icons.set_meal,
                          backgroundColor: Color(0xFFE2DDFF),
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
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
    // Custom styling for each food icon
    switch (iconData) {
      case Icons.local_pizza:
        return const Icon(
          Icons.local_pizza,
          size: 60,
          color: Colors.deepOrange,
        );
      case Icons.lunch_dining:
        return const Icon(Icons.lunch_dining, size: 60, color: Colors.orange);
      case Icons.ramen_dining:
        return Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.ramen_dining,
                  size: 30,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.dinner_dining, size: 20, color: Colors.brown),
            ),
          ],
        );
      case Icons.set_meal:
        return Transform.rotate(
          angle: 0.5,
          child: const Icon(
            Icons.escalator_warning,
            size: 60,
            color: Colors.orange,
          ),
        );
      default:
        return Icon(iconData, size: 60, color: Colors.orange);
    }
  }
}

// Custom SVG illustrations can be implemented here
// For proper implementation you'll need to add SVG images to your assets
// and use them like this:
//
// class FastFoodIllustration extends StatelessWidget {
//   const FastFoodIllustration({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SvgPicture.asset(
//       'assets/images/fast_food_illustration.svg',
//       height: 180,
//     );
//   }
// }
