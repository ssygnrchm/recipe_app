import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/assets.dart';
import 'package:food_delivery_app/presentation/pages/food_category_screen.dart';
import 'package:food_delivery_app/presentation/pages/recipe_list_screen.dart';
import 'package:food_delivery_app/presentation/pages/recipe_screen.dart';
import 'package:food_delivery_app/presentation/widgets/category_card.dart';
import 'package:food_delivery_app/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';
import 'package:food_delivery_app/presentation/widgets/full_width_card.dart';
import 'package:food_delivery_app/presentation/widgets/restaurant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // bottomNavigationBar: const CustomBottomNavigationBar(),
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
                Row(
                  children: [
                    CategoryCard(
                      icon: Assets.pizzaIcon,
                      color: Color(0xFFFFE6D4),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (contex) => RecipesListScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    CategoryCard(
                      icon: Assets.saladIcon,
                      color: Color(0xFFFFF0CE),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (contex) => FoodCategoryScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    CategoryCard(
                      icon: Assets.burgerIcon,
                      color: Color(0xFFD2F4E8),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Special Menu Section
                CustomText.h1(context, "Today's special recipes!"),

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
                        image: Assets.tacosImage,
                        backgroundColor: const Color(0xFFFFE6D4),
                      ),
                      const SizedBox(width: 16),
                      RestaurantCard(
                        restaurantName: "The Burger Club",
                        rating: 5.0,
                        priceLevel: "\$\$\$",
                        cuisine: "American",
                        image: Assets.riceBoxImage,
                        backgroundColor: const Color(0xFFE2DDFF),
                        rightSideImage: true,
                      ),
                      const SizedBox(width: 16),
                      RestaurantCard(
                        restaurantName: "The Burger Club",
                        rating: 5.0,
                        priceLevel: "\$\$\$",
                        cuisine: "American",
                        image: Assets.chickenImage,
                        backgroundColor: const Color(0xFFE2DDFF),
                        rightSideImage: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Featured Restaurants Section
                CustomText.h1(context, "Featured recipe"),

                const SizedBox(height: 16),

                // Featured Restaurant Card
                FullWidthCard(
                  image: Assets.chickenImage,
                  title: "Five guys",
                  subtitle: "mexican",
                ),

                const SizedBox(height: 16),

                FullWidthCard(
                  image: Assets.chickenImage,
                  title: "Five guys",
                  subtitle: "mexican",
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeScreen()),
          );
        },
        elevation: 5,
        icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        label: Text("Add recipe"),
      ),
    );
  }
}

// Reusable Widgets
