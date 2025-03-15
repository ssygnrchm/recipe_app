import 'package:flutter/material.dart';
import 'package:food_delivery_app/database/data/recipe_model.dart';
import 'package:food_delivery_app/database/domain/recipe_repository.dart';
import 'package:food_delivery_app/presentation/pages/recipe_screen.dart';
import 'package:food_delivery_app/presentation/widgets/recipe_list_widget.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({super.key});

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  final _recipeRepository = RecipeRepository();
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipes = await _recipeRepository.getAllRecipes();
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading recipes: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createOrEditRecipe(Recipe? recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeScreen(existingRecipe: recipe),
      ),
    );

    if (result == true) {
      _loadRecipes();
    }
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Recipe'),
            content: Text('Are you sure you want to delete "${recipe.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('DELETE'),
              ),
            ],
          ),
    );

    if (confirmed == true && recipe.id != null) {
      try {
        await _recipeRepository.deleteRecipe(recipe.id!);
        _loadRecipes();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting recipe: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Recipes')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _recipes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.restaurant, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No recipes yet',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _createOrEditRecipe(null),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Recipe'),
                    ),
                  ],
                ),
              )
              : RecipeListWidget(
                recipes: _recipes,
                onEdit: _createOrEditRecipe,
                onDelete: _deleteRecipe,
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrEditRecipe(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
