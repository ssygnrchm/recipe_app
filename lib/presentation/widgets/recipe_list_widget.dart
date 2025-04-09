import 'package:flutter/material.dart';
import 'package:food_delivery_app/database/data/firestore_recipe_model.dart';
import 'package:food_delivery_app/features/add_recipe/presentation/recipe_screen.dart';

class RecipeListWidget extends StatelessWidget {
  final List<FirestoreRecipe> recipes;
  final Axis scrollDirection;
  final Function(FirestoreRecipe recipe)? onEdit;
  final Function(FirestoreRecipe recipe)? onDelete;
  final bool showActions;

  const RecipeListWidget({
    super.key,
    required this.recipes,
    this.scrollDirection = Axis.vertical,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return scrollDirection == Axis.vertical
        ? ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder:
              (context, index) => _buildRecipeCard(context, recipes[index]),
        )
        : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                recipes
                    .map(
                      (recipe) => Container(
                        margin: const EdgeInsets.only(right: 16),
                        width: 280, // Fixed width for horizontal cards
                        child: _buildRecipeCard(context, recipe),
                      ),
                    )
                    .toList(),
          ),
        );
  }

  Widget _buildRecipeCard(BuildContext context, FirestoreRecipe recipe) {
    return Card(
      margin:
          scrollDirection == Axis.vertical
              ? const EdgeInsets.only(bottom: 16)
              : EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe image
          _buildRecipeImage(recipe, context),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe name
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                if (recipe.description != null &&
                    recipe.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      recipe.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Recipe details
                Row(
                  children: [
                    if (recipe.cookTime != null && recipe.cookTime! > 0)
                      Chip(
                        avatar: const Icon(Icons.timer_outlined, size: 16),
                        label: Text('${recipe.cookTime} min'),
                      ),
                    const SizedBox(width: 8),
                    if (recipe.servings != null && recipe.servings! > 0)
                      Chip(
                        avatar: const Icon(Icons.people_outlined, size: 16),
                        label: Text('${recipe.servings} servings'),
                      ),
                  ],
                ),

                // Recipe actions
                if (showActions && (onEdit != null || onDelete != null))
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (onEdit != null)
                        TextButton.icon(
                          onPressed: () => onEdit!(recipe),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('EDIT'),
                        ),
                      if (onDelete != null && recipe.id != null)
                        TextButton.icon(
                          onPressed: () => onDelete!(recipe),
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.red,
                          ),
                          label: const Text('DELETE'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeImage(FirestoreRecipe recipe, BuildContext context) {
    // Check if the recipe has a valid image path
    if (recipe.imagePath != null) {
      // Check if it's a default image (from assets) or a custom image (from network)
      if (recipe.imageIndex >= 0) {
        // Default/asset image
        return Image.asset(
          recipe.imagePath!,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => _buildErrorPlaceholder(context),
        );
      } else {
        // Network image (custom image from Firestore)
        return Image.network(
          recipe.imagePath!,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 150,
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
          },
          errorBuilder:
              (context, error, stackTrace) => _buildErrorPlaceholder(context),
        );
      }
    } else {
      // No image, show placeholder
      return _buildErrorPlaceholder(context);
    }
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
