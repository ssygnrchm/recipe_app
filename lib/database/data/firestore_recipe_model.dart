// lib/database/data/firestore_recipe_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRecipe {
  final String? id;
  final String name;
  final String? description;
  final int? cookTime;
  final int? servings;
  final int imageIndex;
  final String? imagePath;
  final List<FirestoreIngredient> ingredients;
  final Timestamp createdAt;
  final String userId; // Added userId field
  final String? category; // New field for category
  final String? area; // New field for area/country

  FirestoreRecipe({
    this.id,
    required this.name,
    this.description,
    this.cookTime,
    this.servings,
    required this.imageIndex,
    this.imagePath,
    required this.ingredients,
    required this.userId, // Make userId required
    this.category, // Added category parameter
    this.area, // Added area parameter
    Timestamp? createdAt,
  }) : this.createdAt = createdAt ?? Timestamp.now();

  // Update toMap to include userId
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'cookTime': cookTime,
      'servings': servings,
      'imageIndex': imageIndex,
      'imagePath': imagePath,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'createdAt': createdAt,
      'userId': userId, // Include userId in the map
      'category': category, // Include category in the map
      'area': area, // Include area in the map
    };
  }

  // Update fromFirestore to extract userId
  factory FirestoreRecipe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Handle ingredients
    List<FirestoreIngredient> ingredientsList = [];
    if (data['ingredients'] != null) {
      final ingredients = data['ingredients'] as List;
      ingredientsList =
          ingredients
              .map(
                (i) => FirestoreIngredient.fromMap(i as Map<String, dynamic>),
              )
              .toList();
    }

    return FirestoreRecipe(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      cookTime: data['cookTime'],
      servings: data['servings'],
      imageIndex: data['imageIndex'] ?? 0,
      imagePath: data['imagePath'],
      ingredients: ingredientsList,
      userId: data['userId'] ?? '', // Extract userId with empty string fallback
      category: data['category'], // Extract category with null fallback
      area: data['area'], // Extract area with null fallback
      createdAt: data['createdAt'] as Timestamp,
    );
  }
}

class FirestoreIngredient {
  final String name;
  final String? amount;
  final String? unit;

  FirestoreIngredient({required this.name, this.amount, this.unit});

  // Convert to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'amount': amount, 'unit': unit};
  }

  // Create an Ingredient from a Firestore map
  factory FirestoreIngredient.fromMap(Map<String, dynamic> map) {
    return FirestoreIngredient(
      name: map['name'] ?? '',
      amount: map['amount'],
      unit: map['unit'],
    );
  }
}
