// lib/features/recipes/presentation/recipe_list_screen.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_app/database/data/firestore_recipe_model.dart';
import 'package:food_delivery_app/database/domain/firestore_recipe_repository.dart';
import 'package:food_delivery_app/features/add_recipe/presentation/recipe_screen.dart';
import 'package:food_delivery_app/presentation/widgets/recipe_list_widget.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final FirestoreRecipeRepository _recipeRepository =
      FirestoreRecipeRepository();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddRecipe,
            tooltip: 'Add Recipe',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<FirestoreRecipe>>(
              stream: _recipeRepository.getAllRecipes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading recipes: ${snapshot.error}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                final recipes = snapshot.data ?? [];
                if (recipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No recipes yet',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first recipe by tapping the + button',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _navigateToAddRecipe,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Recipe'),
                        ),
                      ],
                    ),
                  );
                }

                return RecipeListWidget(
                  recipes: recipes,
                  onEdit: _navigateToEditRecipe,
                  onDelete: _showDeleteConfirmation,
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              height: 4,
              width: double.infinity,
              child: const LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecipeScreen()),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe added successfully')),
      );
    }
  }

  Future<void> _navigateToEditRecipe(FirestoreRecipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeScreen(existingRecipe: recipe),
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe updated successfully')),
      );
    }
  }

  Future<void> _showDeleteConfirmation(FirestoreRecipe recipe) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "${recipe.name}"?'),
                const SizedBox(height: 8),
                const Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('DELETE'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteRecipe(recipe);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecipe(FirestoreRecipe recipe) async {
    if (recipe.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error: Recipe has no ID')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _recipeRepository.deleteRecipe(recipe.id!);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Recipe deleted')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting recipe: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
