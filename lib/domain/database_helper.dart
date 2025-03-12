import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'recipes.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create Recipes table
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        cookTime INTEGER,
        servings INTEGER,
        imageIndex INTEGER,
        imagePath TEXT
      )
    ''');

    // Create Ingredients table with foreign key to Recipes
    await db.execute('''
      CREATE TABLE ingredients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId INTEGER,
        name TEXT NOT NULL,
        amount TEXT,
        unit TEXT,
        FOREIGN KEY (recipeId) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');
  }

  // Recipe CRUD operations
  Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    final ingredients = recipe['ingredients'];
    recipe.remove('ingredients'); // Remove ingredients before inserting recipe

    // Insert recipe and get the auto-generated id
    final recipeId = await db.insert('recipes', recipe);

    // Insert ingredients with the recipe id
    if (ingredients != null) {
      for (var ingredient in ingredients) {
        ingredient['recipeId'] = recipeId;
        await db.insert('ingredients', ingredient);
      }
    }

    return recipeId;
  }

  Future<int> updateRecipe(int id, Map<String, dynamic> recipe) async {
    final db = await database;
    final ingredients = recipe['ingredients'];
    recipe.remove('ingredients'); // Remove ingredients before updating recipe

    // Update recipe
    await db.update('recipes', recipe, where: 'id = ?', whereArgs: [id]);

    // Delete previous ingredients and insert new ones
    await db.delete('ingredients', where: 'recipeId = ?', whereArgs: [id]);

    if (ingredients != null) {
      for (var ingredient in ingredients) {
        ingredient['recipeId'] = id;
        await db.insert('ingredients', ingredient);
      }
    }

    return id;
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getRecipe(int id) async {
    final db = await database;

    // Get recipe
    final recipes = await db.query('recipes', where: 'id = ?', whereArgs: [id]);

    if (recipes.isEmpty) {
      return null;
    }

    final recipe = recipes.first;

    // Get ingredients for this recipe
    final ingredients = await db.query(
      'ingredients',
      where: 'recipeId = ?',
      whereArgs: [id],
    );

    recipe['ingredients'] = ingredients;

    return recipe;
  }

  Future<List<Map<String, dynamic>>> getAllRecipes() async {
    final db = await database;

    // Get all recipes
    final recipes = await db.query('recipes');
    final recipesList = <Map<String, dynamic>>[];

    // For each recipe, get its ingredients
    for (var recipe in recipes) {
      final recipeId = recipe['id'] as int;
      final ingredients = await db.query(
        'ingredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      );

      final recipeWithIngredients = Map<String, dynamic>.from(recipe);
      recipeWithIngredients['ingredients'] = ingredients;

      recipesList.add(recipeWithIngredients);
    }

    return recipesList;
  }
}
