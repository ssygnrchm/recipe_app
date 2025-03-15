// lib/presentation/pages/food_category_screen.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/colors.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';
import 'package:food_delivery_app/api/data/model/recipe_per_category_model.dart';
import 'package:food_delivery_app/api/repo/service_recipe.dart';
import 'package:food_delivery_app/presentation/pages/recipe_details.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class FoodCategoryScreen extends StatelessWidget {
  final String categoryName;

  const FoodCategoryScreen({super.key, required this.categoryName});

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

                      // Category title
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: CustomText(
                          title: categoryName,
                          style: AppTextStyles.display1,
                        ),
                      ),
                    ],
                  ),
                ),

                // API data loading and display
                Expanded(
                  child: FutureBuilder<RecipePerCategory>(
                    future: fetchRecipePerCategory(categoryName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: CustomText(
                            title: "Error: ${snapshot.error}",
                            fcolor: theme.colorScheme.error,
                          ),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data?.meals == null ||
                          snapshot.data!.meals!.isEmpty) {
                        return Center(
                          child: CustomText(
                            title: "No recipes found for $categoryName",
                            style: AppTextStyles.paragraphMedium,
                          ),
                        );
                      }

                      final recipes = snapshot.data!.meals!;

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return RecipeCard(
                              title: recipe.strMeal ?? "Unknown",
                              imageUrl: recipe.strMealThumb ?? "",
                              recipeId: recipe.idMeal ?? "",
                              // Generate a random color for each recipe card
                              backgroundColor: _getRandomColor(index),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to generate a random color based on index
  Color _getRandomColor(int index) {
    final colors = [
      const Color(0xFFFFE6D4),
      const Color(0xFFFFF0CE),
      const Color(0xFFD2F4E8),
      const Color(0xFFE2DDFF),
    ];
    return colors[index % colors.length];
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String recipeId;
  final Color backgroundColor;

  const RecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.recipeId,
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
          // Recipe image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    imageUrl.isNotEmpty
                        ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.restaurant,
                              size: 60,
                              color: theme.colorScheme.primary,
                            );
                          },
                        )
                        : Icon(
                          Icons.restaurant,
                          size: 60,
                          color: theme.colorScheme.primary,
                        ),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: title,
                  style: AppTextStyles.paragraphMediumBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                RecipeDetailsScreen(recipeId: recipeId),
                      ),
                    );
                    // TODO: Navigate to recipe details
                    // For now, just show the recipe ID
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Recipe ID: $recipeId')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomText.bodySmall(context, 'View Details'),
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
