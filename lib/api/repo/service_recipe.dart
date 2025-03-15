import 'dart:convert';
import 'package:food_delivery_app/api/data/model/api_recipe_model.dart';
import 'package:food_delivery_app/api/data/model/recipe_per_category_model.dart';
import 'package:food_delivery_app/api/repo/repo_recipe_category.dart';
// import 'package:http/http.dart' as http;

Future<RecipePerCategory> fetchRecipePerCategory(String category) async {
  final _category = category;
  final response = await fetchRecipePerCategoryAPI(_category);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RecipePerCategory.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Recipe Per Category');
  }
}

Future<SingleRecipe> fetchRandomRecipe() async {
  final response = await fetchRandomRecipeAPI();

  if (response.statusCode == 200) {
    // Parse the JSON
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

    // Extract the first recipe from the "meals" array
    if (jsonData.containsKey('meals') &&
        jsonData['meals'] is List &&
        (jsonData['meals'] as List).isNotEmpty) {
      return SingleRecipe.fromJson(jsonData['meals'][0]);
    } else {
      throw Exception('No recipe found in response');
    }
  } else {
    throw Exception('Failed to load Random Recipe');
  }
}

// Added method to load multiple random recipes
Future<List<SingleRecipe>> loadRandomRecipes(int count) async {
  List<SingleRecipe> recipes = []; //create a list with singlerecipes object
  for (int i = 0; i < count; i++) {
    try {
      SingleRecipe recipe = await fetchRandomRecipe();
      recipes.add(recipe);
      print(recipes);
    } catch (e) {
      print('Error fetching random recipe: $e');
    }
  }
  return recipes;
}

Future<SingleRecipe> fetchRecipeById(String id) async {
  final response = await fetchRecipeByIdAPI(id);
  if (response.statusCode == 200) {
    // Parse the JSON
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

    // Extract the recipe from the "meals" array
    if (jsonData.containsKey('meals') &&
        jsonData['meals'] is List &&
        (jsonData['meals'] as List).isNotEmpty) {
      return SingleRecipe.fromJson(jsonData['meals'][0]);
    } else {
      throw Exception('No recipe found with ID: $id');
    }
  } else {
    throw Exception('Failed to load Recipe with ID: $id');
  }
}
