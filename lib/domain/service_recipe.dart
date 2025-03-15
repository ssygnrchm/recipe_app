import 'dart:convert';
import 'package:food_delivery_app/data/recipe_per_category_model.dart';
import 'package:food_delivery_app/domain/repo_recipe_category.dart';
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

Future<Meal> fetchRandomRecipe() async {
  final response = await fetchRandomRecipeAPI();

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Meal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Random Recipe');
  }
}
