class SingleRecipe {
  String idMeal;
  String strMeal;
  String? strMealAlternate;
  String strCategory;
  String strArea;
  String strInstructions;
  String strMealThumb;
  String? strTags;
  String? strYoutube;
  List<String> ingredients;
  List<String> measures;
  String? strSource;
  String? strImageSource;
  bool? strCreativeCommonsConfirmed;
  String? dateModified;

  SingleRecipe({
    required this.idMeal,
    required this.strMeal,
    this.strMealAlternate,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    this.strTags,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
    this.strSource,
    this.strImageSource,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
  });

  // Factory method to create an instance of Meal from JSON
  factory SingleRecipe.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    // Extract ingredients and measures (1-20)
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return SingleRecipe(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealAlternate: json['strMealAlternate'],
      strCategory: json['strCategory'] ?? '',
      strArea: json['strArea'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strTags: json['strTags'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
      strSource: json['strSource'],
      strImageSource: json['strImageSource'],
      strCreativeCommonsConfirmed: json['strCreativeCommonsConfirmed'],
      dateModified: json['dateModified'],
    );
  }

  // Method to convert the Meal object to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strMealAlternate': strMealAlternate,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'strSource': strSource,
      'strImageSource': strImageSource,
      'strCreativeCommonsConfirmed': strCreativeCommonsConfirmed,
      'dateModified': dateModified,
    };

    // Add ingredients and measures to JSON
    for (int i = 0; i < ingredients.length; i++) {
      data['strIngredient${i + 1}'] = ingredients[i];
      data['strMeasure${i + 1}'] = measures[i];
    }

    return data;
  }

  // Getter to get a formatted string of all ingredients with their measures
  String get ingredientsWithMeasures {
    String result = '';
    for (int i = 0; i < ingredients.length; i++) {
      result += '${ingredients[i]} - ${measures[i]}\n';
    }
    return result;
  }

  // Getter to get a full meal description including ingredients and instructions
  String get fullMealDescription {
    return '''
    Meal: $strMeal
    Category: $strCategory
    Area: $strArea
    Instructions: $strInstructions
    
    Ingredients:
    $ingredientsWithMeasures
    ''';
  }

  // Getter to check if the meal has video source
  bool get hasVideo {
    return strYoutube != null && strYoutube!.isNotEmpty;
  }

  // Getter to get a formatted list of tags
  List<String> get tagsList {
    return strTags?.split(',').map((tag) => tag.trim()).toList() ?? [];
  }

  // Getter to get the primary ingredient (just the first one in the list)
  String get primaryIngredient {
    return ingredients.isNotEmpty ? ingredients[0] : 'No ingredients available';
  }

  // Getter to check if the meal is vegetarian
  bool get isVegetarian {
    return strCategory.toLowerCase().contains('vegetarian');
  }
}
