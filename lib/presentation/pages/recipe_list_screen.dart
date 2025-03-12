import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/recipe_model.dart';
import 'package:food_delivery_app/domain/recipe_repository.dart';
import 'package:food_delivery_app/presentation/pages/recipe_screen.dart';

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
    // final theme = Theme.of(context);
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
              : listRecipe(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrEditRecipe(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView listRecipe() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image
              if (recipe.imagePath != null)
                Image.asset(
                  recipe.imagePath!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

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
                    OverflowBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => _createOrEditRecipe(recipe),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('EDIT'),
                        ),
                        TextButton.icon(
                          onPressed: () => _deleteRecipe(recipe),
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
      },
    );
  }
}
