// lib/database/domain/firestore_recipe_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/database/data/firestore_recipe_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FirestoreRecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _recipesCollection;

  FirestoreRecipeRepository()
    : _recipesCollection = FirebaseFirestore.instance.collection(
        'madebysisy_recipes',
      );

  // Get all recipes
  Stream<List<FirestoreRecipe>> getAllRecipes({String? userId}) {
    var query = _recipesCollection.orderBy('createdAt', descending: true);

    // Add userId filter if provided
    if (userId != null && userId.isNotEmpty) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FirestoreRecipe.fromFirestore(doc))
          .toList();
    });
  }

  // Get recipe by id
  Future<FirestoreRecipe?> getRecipe(String id) async {
    final docSnapshot = await _recipesCollection.doc(id).get();
    if (!docSnapshot.exists) {
      return null;
    }
    return FirestoreRecipe.fromFirestore(docSnapshot);
  }

  // Save a new recipe
  Future<String> saveRecipe(FirestoreRecipe recipe, {File? imageFile}) async {
    // Upload image if provided
    String? imagePath = recipe.imagePath;
    if (imageFile != null) {
      imagePath = await _uploadImage(imageFile);
    }

    // Create updated recipe with new image path if needed
    final updatedRecipe = FirestoreRecipe(
      name: recipe.name,
      description: recipe.description,
      cookTime: recipe.cookTime,
      servings: recipe.servings,
      imageIndex: recipe.imageIndex,
      imagePath: imagePath,
      ingredients: recipe.ingredients,
      userId: recipe.userId,
      area: recipe.area,
      category: recipe.category,
    );

    // Add to Firestore
    final docRef = await _recipesCollection.add(updatedRecipe.toMap());
    return docRef.id;
  }

  // Update an existing recipe
  Future<void> updateRecipe(FirestoreRecipe recipe, {File? imageFile}) async {
    if (recipe.id == null) {
      throw Exception('Cannot update a recipe without an ID');
    }

    // Upload image if provided
    String? imagePath = recipe.imagePath;
    if (imageFile != null) {
      imagePath = await _uploadImage(imageFile);
    }

    // Create updated recipe with new image path if needed
    final updatedRecipe = FirestoreRecipe(
      name: recipe.name,
      description: recipe.description,
      cookTime: recipe.cookTime,
      servings: recipe.servings,
      imageIndex: recipe.imageIndex,
      imagePath: imagePath,
      ingredients: recipe.ingredients,
      userId: recipe.userId,
      area: recipe.area,
      category: recipe.category,
    );

    // Update in Firestore
    await _recipesCollection.doc(recipe.id).update(updatedRecipe.toMap());
  }

  // Delete a recipe
  Future<void> deleteRecipe(String id) async {
    // Get the recipe to check if it has a custom image
    final recipe = await getRecipe(id);

    // Delete the document from Firestore
    await _recipesCollection.doc(id).delete();

    // Delete any associated image from Storage if it's a custom image
    if (recipe != null && recipe.imagePath != null && recipe.imageIndex == -1) {
      try {
        // Extract the image reference from the path
        final imageRef = _storage.refFromURL(recipe.imagePath!);
        await imageRef.delete();
      } catch (e) {
        print('Error deleting image: $e');
        // Continue even if image deletion fails
      }
    }
  }

  // Upload an image to Firebase Storage
  Future<String> _uploadImage(File imageFile) async {
    // Generate a unique filename
    final uuid = Uuid();
    final filename = '${uuid.v4()}${path.extension(imageFile.path)}';

    // Create a reference to the file location
    final ref = _storage.ref().child('recipe_images/$filename');

    // Upload the file
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;

    // Get the download URL
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
