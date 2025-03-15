import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/colors.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';
import 'package:food_delivery_app/api/data/model/api_recipe_model.dart';
import 'package:food_delivery_app/api/repo/service_recipe.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailsScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<SingleRecipe>(
        future: fetchRecipeById(recipeId),
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
          } else if (!snapshot.hasData) {
            return Center(
              child: CustomText(
                title: "No recipe details found",
                style: AppTextStyles.paragraphMedium,
              ),
            );
          }

          final recipe = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // App Bar with image
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'recipe_image_${recipe.idMeal}',
                    child:
                        recipe.strMealThumb.isNotEmpty
                            ? Image.network(
                              recipe.strMealThumb,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: theme.colorScheme.primaryContainer,
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 80,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            )
                            : Container(
                              color: theme.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.restaurant,
                                size: 80,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to favorites!')),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              // Recipe content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and category info
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: recipe.strMeal,
                                  style: AppTextStyles.display2,
                                  fcolor: theme.colorScheme.onSurface,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4),
                                          CustomText(
                                            title: recipe.strCategory,
                                            fcolor: Colors.white,
                                            fweight: FontWeight.w600,
                                            fsize: 14,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.active,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.place,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4),
                                          CustomText(
                                            title: recipe.strArea,
                                            fcolor: Colors.white,
                                            fweight: FontWeight.w600,
                                            fsize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Recipe video link if available
                          if (recipe.hasVideo)
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              onPressed: () async {
                                final Uri url = Uri.parse(
                                  recipe.strYoutube ?? '',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Could not open video link',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Tags section if available
                      if (recipe.tagsList.isNotEmpty) ...[
                        CustomText(
                          title: "Tags",
                          style: AppTextStyles.paragraphLargeBold,
                          fcolor: theme.colorScheme.onSurface,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              recipe.tagsList.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.inkDark,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CustomText(
                                    title: tag,
                                    fsize: 12,
                                    fweight: FontWeight.w500,
                                    fcolor: Colors.white,
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Ingredients section
                      CustomText(
                        title: "Ingredients",
                        style: AppTextStyles.paragraphLargeBold,
                        fcolor: theme.colorScheme.onSurface,
                      ),
                      // const SizedBox(height: 16),

                      // Ingredients list
                      ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipe.ingredients.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomText(
                                    title:
                                        "${recipe.measures[index]} ${recipe.ingredients[index]}",
                                    style: AppTextStyles.paragraphMedium,
                                    fcolor: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // const SizedBox(height: 24),

                      // Instructions section
                      CustomText(
                        title: "Instructions",
                        style: AppTextStyles.paragraphLargeBold,
                        fcolor: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(height: 16),

                      // Format and display instructions
                      ...formatInstructions(recipe.strInstructions).map((
                        instruction,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomText(
                                  title: instruction,
                                  style: AppTextStyles.paragraphMedium,
                                  fcolor: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 24),

                      // Source link if available
                      if (recipe.strSource != null &&
                          recipe.strSource!.isNotEmpty) ...[
                        CustomText(
                          title: "Source",
                          style: AppTextStyles.paragraphLargeBold,
                          fcolor: theme.colorScheme.onSurface,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(recipe.strSource ?? '');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not open source link'),
                                ),
                              );
                            }
                          },
                          child: CustomText(
                            title: recipe.strSource!,
                            fcolor: theme.colorScheme.onSurface,
                            fweight: FontWeight.w500,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to format instructions into a list
  List<String> formatInstructions(String instructions) {
    // Split by newlines first
    var steps =
        instructions
            .split('\r\n')
            .where((step) => step.trim().isNotEmpty)
            .toList();

    // If there's only one step, try to split by periods
    if (steps.length == 1) {
      steps =
          instructions
              .split('.')
              .where((step) => step.trim().isNotEmpty)
              .map((step) => step.trim() + '.')
              .toList();

      // Remove last element if it's just a period
      if (steps.isNotEmpty && steps.last == '.') {
        steps.removeLast();
      }
    }

    return steps;
  }
}
