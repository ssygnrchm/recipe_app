import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/colors.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';
import 'package:food_delivery_app/presentation/pages/food_category_screen.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Search Bar with Avatar
                Row(
                  children: [
                    const CircleAvatar(
                      maxRadius: 16,
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SearchBar(
                        hintText: "Dishes, restaurants or cuisines",
                        leading: const Icon(Icons.search),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Popular Categories Section
                CustomText.h1(context, "Popular Categories"),

                const SizedBox(height: 16),

                // Categories Cards
                const Row(
                  children: [
                    CategoryCard(
                      icon: Icons.local_pizza,
                      color: Color(0xFFFFE6D4),
                    ),
                    SizedBox(width: 12),
                    CategoryCard(
                      icon: Icons.ramen_dining,
                      color: Color(0xFFFFF0CE),
                    ),
                    SizedBox(width: 12),
                    CategoryCard(
                      icon: Icons.lunch_dining,
                      color: Color(0xFFD2F4E8),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Special Menu Section
                CustomText.h1(context, "Today's special menu"),

                const SizedBox(height: 16),

                // Special Menu Cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      RestaurantCard(
                        restaurantName: "The Taco Company",
                        rating: 4.8,
                        priceLevel: "\$\$\$",
                        cuisine: "Mexican",
                        image: Icons.fastfood,
                        backgroundColor: const Color(0xFFFFE6D4),
                      ),
                      const SizedBox(width: 16),
                      RestaurantCard(
                        restaurantName: "The Burger Club",
                        rating: 5.0,
                        priceLevel: "\$\$\$",
                        cuisine: "American",
                        image: Icons.lunch_dining,
                        backgroundColor: const Color(0xFFE2DDFF),
                        rightSideImage: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Featured Restaurants Section
                CustomText.h1(context, "Featured restaurants"),

                const SizedBox(height: 16),

                // Featured Restaurant Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child:
                              Container(), // Empty space to position the chicken image
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Transform.scale(
                            scale: 1.5,
                            alignment: Alignment.bottomRight,
                            child: const Icon(
                              Icons.lunch_dining,
                              size: 80,
                              color: Color(0xFFFF8A00),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Widgets

class CategoryCard extends StatelessWidget {
  final IconData icon;
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
            child: Center(child: Icon(icon, size: 32, color: Colors.black87)),
          ),
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String restaurantName;
  final double rating;
  final String priceLevel;
  final String cuisine;
  final IconData image;
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
      width: 220,
      height: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image
          Row(
            children: [
              if (!rightSideImage) Icon(image, size: 60, color: Colors.orange),
              if (!rightSideImage) const Spacer(),
              if (rightSideImage) const Spacer(),
              if (rightSideImage) Icon(image, size: 60, color: Colors.orange),
            ],
          ),

          const Spacer(),

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

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavItem(icon: Icons.home, label: "Home", isSelected: true),
          BottomNavItem(icon: Icons.receipt, label: "Orders"),
          BottomNavItem(icon: Icons.person, label: "Profile"),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.active : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
