import 'dart:convert';

RecipePerCategory RecipePerCategoryFromJson(String str) =>
    RecipePerCategory.fromJson(json.decode(str));

String RecipePerCategoryToJson(RecipePerCategory data) =>
    json.encode(data.toJson());

class RecipePerCategory {
  final List<Meal>? meals;

  RecipePerCategory({this.meals});

  factory RecipePerCategory.fromJson(Map<String, dynamic> json) =>
      RecipePerCategory(
        meals:
            json["meals"] == null
                ? []
                : List<Meal>.from(json["meals"]!.map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "meals":
        meals == null ? [] : List<dynamic>.from(meals!.map((x) => x.toJson())),
  };
}

class Meal {
  final String? strMeal;
  final String? strMealThumb;
  final String? idMeal;

  Meal({this.strMeal, this.strMealThumb, this.idMeal});

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    strMeal: json["strMeal"],
    strMealThumb: json["strMealThumb"],
    idMeal: json["idMeal"],
  );

  Map<String, dynamic> toJson() => {
    "strMeal": strMeal,
    "strMealThumb": strMealThumb,
    "idMeal": idMeal,
  };
}
