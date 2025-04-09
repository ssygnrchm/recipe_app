import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/authentication/service/firebase_auth_service.dart';
import 'package:food_delivery_app/features/authentication/presentation/pages/login_screen.dart';
import 'package:food_delivery_app/core/constants/assets.dart';
import 'package:food_delivery_app/api/data/model/api_recipe_model.dart';
import 'package:food_delivery_app/api/repo/service_recipe.dart';
import 'package:food_delivery_app/presentation/pages/food_category_screen.dart';
import 'package:food_delivery_app/features/add%20recipe/presentation/recipe_screen.dart';
import 'package:food_delivery_app/presentation/widgets/category_card.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';
import 'package:food_delivery_app/presentation/widgets/random_recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _showProfileDialog() {
    final currentUserEmail = _authService.currentUser?.email ?? 'User';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(Assets.userIcon),
                ),
                const SizedBox(height: 16),
                CustomText(title: currentUserEmail, fweight: FontWeight.w500),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Close the dialog
                      Navigator.of(context).pop();
                      // Perform logout
                      await _authService.signOut();
                      // Navigate to login screen
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  List<Widget> _buildCategoryList(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        "name": "Beef",
        "icon": Icons.kebab_dining,
        "color": Colors.redAccent.shade100,
      },
      {
        "name": "Chicken",
        "icon": Icons.egg_alt,
        "color": Colors.orangeAccent.shade100,
      },
      {
        "name": "Dessert",
        "icon": Icons.cake,
        "color": const Color.fromARGB(255, 224, 125, 158),
      },
      {
        "name": "Lamb",
        "icon": Icons.kebab_dining,
        "color": Colors.deepPurpleAccent.shade100,
      },
      {
        "name": "Pasta",
        "icon": Icons.ramen_dining,
        "color": const Color.fromARGB(255, 255, 174, 127),
      },
      {
        "name": "Seafood",
        "icon": Icons.set_meal_rounded,
        "color": Colors.blueAccent.shade100,
      },
      {
        "name": "Breakfast",
        "icon": Icons.free_breakfast,
        "color": Colors.tealAccent.shade100,
      },
      {
        "name": "Vegetarian",
        "icon": Icons.grass,
        "color": const Color.fromARGB(255, 123, 196, 143),
      },
    ];

    List<Widget> categoryWidgets = [];

    for (int i = 0; i < categories.length; i++) {
      categoryWidgets.add(
        Padding(
          padding: EdgeInsets.only(right: i == categories.length - 1 ? 0 : 12),
          child: Column(
            children: [
              CategoryCard(
                icon: Icon(
                  categories[i]["icon"],
                  size: 32,
                  color: Colors.white,
                ),
                color: categories[i]["color"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => FoodCategoryScreen(
                            categoryName: categories[i]["name"],
                          ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              CustomText(
                title: categories[i]["name"],
                fsize: 12,
                fweight: FontWeight.w500,
              ),
            ],
          ),
        ),
      );
    }

    return categoryWidgets;
  }

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
                    GestureDetector(
                      onTap: _showProfileDialog,
                      child: const CircleAvatar(
                        maxRadius: 16,
                        backgroundImage: AssetImage(Assets.userIcon),
                      ),
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
                CustomText.h1(context, "All Categories"),

                const SizedBox(height: 16),

                // Categories Cards - Horizontally scrollable list
                SizedBox(
                  height: 100, // Set a fixed height for the list
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: _buildCategoryList(context)),
                  ),
                ),

                const SizedBox(height: 24),

                // Special Menu Section
                CustomText.h1(context, "Today's special recipes!"),

                const SizedBox(height: 16),

                // Special Menu Cards
                SizedBox(
                  height: 180,
                  child: FutureBuilder<List<SingleRecipe>>(
                    future: loadRandomRecipes(5), // Load 5 random recipes
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading recipes: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No recipes found'));
                      } else {
                        final recipes = snapshot.data!;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                recipes.map((recipe) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: RandomRecipeCard(recipe: recipe),
                                  );
                                }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Featured Recipe Section
                CustomText.h1(context, "Featured recipe"),

                const SizedBox(height: 16),

                // Featured Recipe Card
                SizedBox(
                  height: 180,
                  child: FutureBuilder<List<SingleRecipe>>(
                    future: loadRandomRecipes(1), // Load 1 random recipe
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading recipes: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No recipes found'));
                      } else {
                        final recipes = snapshot.data!;
                        return Column(
                          children:
                              recipes.map((recipe) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: RandomRecipeCard(recipe: recipe),
                                    ),
                                  ],
                                );
                              }).toList(),
                        );
                      }
                    },
                  ),
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
