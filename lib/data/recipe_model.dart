class Recipe {
  final int? id;
  final String name;
  final String? description;
  final int? cookTime;
  final int? servings;
  final int imageIndex;
  final String? imagePath;
  final List<Ingredient> ingredients;

  Recipe({
    this.id,
    required this.name,
    this.description,
    this.cookTime,
    this.servings,
    required this.imageIndex,
    this.imagePath,
    required this.ingredients,
  });

  // Convert Recipe object to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cookTime': cookTime,
      'servings': servings,
      'imageIndex': imageIndex,
      'imagePath': imagePath,
    };
  }

  // Include ingredients in the map (for full recipe data)
  Map<String, dynamic> toFullMap() {
    final map = toMap();
    map['ingredients'] = ingredients.map((i) => i.toMap()).toList();
    return map;
  }

  // Create a Recipe from a database map
  factory Recipe.fromMap(Map<String, dynamic> map) {
    List<Ingredient> ingredientsList = [];

    if (map['ingredients'] != null) {
      final ingredients = map['ingredients'] as List;
      ingredientsList = ingredients.map((i) => Ingredient.fromMap(i)).toList();
    }

    return Recipe(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      cookTime: map['cookTime'] as int?,
      servings: map['servings'] as int?,
      imageIndex: map['imageIndex'] as int,
      imagePath: map['imagePath'] as String?,
      ingredients: ingredientsList,
    );
  }
}

class Ingredient {
  final int? id;
  final int? recipeId;
  final String name;
  final String? amount;
  final String? unit;

  Ingredient({
    this.id,
    this.recipeId,
    required this.name,
    this.amount,
    this.unit,
  });

  // Convert Ingredient object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeId': recipeId,
      'name': name,
      'amount': amount,
      'unit': unit,
    };
  }

  // Create an Ingredient from a database map
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] as int?,
      recipeId: map['recipeId'] as int?,
      name: map['name'] as String,
      amount: map['amount'] as String?,
      unit: map['unit'] as String?,
    );
  }
}
