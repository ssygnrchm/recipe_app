import 'package:food_delivery_app/data/recipe_model.dart';
import 'package:food_delivery_app/domain/database_helper.dart';

class RecipeRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    final recipeMaps = await _dbHelper.getAllRecipes();
    return recipeMaps.map((map) => Recipe.fromMap(map)).toList();
  }

  // Get recipe by id
  Future<Recipe?> getRecipe(int id) async {
    final recipeMap = await _dbHelper.getRecipe(id);
    if (recipeMap == null) {
      return null;
    }
    return Recipe.fromMap(recipeMap);
  }

  // Save a new recipe
  Future<int> saveRecipe(Recipe recipe) async {
    return await _dbHelper.insertRecipe(recipe.toFullMap());
  }

  // Update an existing recipe
  Future<int> updateRecipe(Recipe recipe) async {
    if (recipe.id == null) {
      throw Exception('Cannot update a recipe without an ID');
    }
    return await _dbHelper.updateRecipe(recipe.id!, recipe.toFullMap());
  }

  // Delete a recipe
  Future<int> deleteRecipe(int id) async {
    return await _dbHelper.deleteRecipe(id);
  }
}
