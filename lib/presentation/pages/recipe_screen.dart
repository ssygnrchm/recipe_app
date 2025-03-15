import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/assets.dart';
import 'package:food_delivery_app/core/constants/colors.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';
import 'package:food_delivery_app/database/data/recipe_model.dart';
import 'package:food_delivery_app/database/domain/database_helper.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe? existingRecipe; // Modified to use Recipe model instead of Map

  const RecipeScreen({super.key, this.existingRecipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  List<Map<String, dynamic>> _ingredients = [];
  int _selectedImageIndex = 0;
  bool _isSaving = false;

  // Sample recipe images (in a real app, these would be loaded from assets or API)
  final List<String> _recipeImages = [
    Assets.burgerImage,
    Assets.chickenImage,
    Assets.riceBoxImage,
    Assets.tacosImage,
  ];

  @override
  void initState() {
    super.initState();

    // Populate form if editing an existing recipe
    if (widget.existingRecipe != null) {
      _nameController.text = widget.existingRecipe!.name;
      _descriptionController.text = widget.existingRecipe!.description ?? '';
      _cookTimeController.text =
          widget.existingRecipe!.cookTime?.toString() ?? '';
      _servingsController.text =
          widget.existingRecipe!.servings?.toString() ?? '';

      // Convert ingredients from model to map
      _ingredients =
          widget.existingRecipe!.ingredients
              .map(
                (ingredient) => {
                  'name': ingredient.name,
                  'amount': ingredient.amount ?? '',
                  'unit': ingredient.unit ?? 'g',
                },
              )
              .toList();

      _selectedImageIndex = widget.existingRecipe!.imageIndex;
    } else {
      // Add one empty ingredient for new recipes
      _ingredients.add({'name': '', 'amount': '', 'unit': 'g'});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({'name': '', 'amount': '', 'unit': 'g'});
    });
  }

  void _removeIngredient(int index) {
    if (_ingredients.length > 1) {
      setState(() {
        _ingredients.removeAt(index);
      });
    }
  }

  void _updateIngredient(int index, String field, dynamic value) {
    setState(() {
      _ingredients[index][field] = value;
    });
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        // Create recipe object
        final recipeData = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'cookTime': int.tryParse(_cookTimeController.text) ?? 0,
          'servings': int.tryParse(_servingsController.text) ?? 1,
          'ingredients': _ingredients,
          'imageIndex': _selectedImageIndex,
          'imagePath': _recipeImages[_selectedImageIndex],
        };

        final dbHelper = DatabaseHelper.instance;

        if (widget.existingRecipe != null) {
          // Update existing recipe
          await dbHelper.updateRecipe(widget.existingRecipe!.id!, recipeData);
        } else {
          // Insert new recipe
          await dbHelper.insertRecipe(recipeData);
        }

        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving recipe: $e')));
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingRecipe != null ? 'Edit Recipe' : 'Create Recipe',
        ),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _saveRecipe,
            icon:
                _isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.check),
            label: Text(_isSaving ? 'Saving...' : 'Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Recipe basic info section
            Text('Basic Information', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Recipe Name',
                hintText: 'Enter recipe name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Briefly describe your recipe',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Cooking time & servings row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cookTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Cooking Time (min)',
                      hintText: '30',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    decoration: const InputDecoration(
                      labelText: 'Servings',
                      hintText: '4',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recipe image selection section
            Text('Recipe Image', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recipeImages.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedImageIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            isSelected
                                ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 3,
                                )
                                : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          _recipeImages[index],
                          fit: BoxFit.contain,
                          // Fallback if image not available
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: theme.colorScheme.surfaceVariant,
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Ingredients section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ingredients', style: theme.textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _addIngredient,
                  tooltip: 'Add Ingredient',
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ingredient list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                return IngredientFormRow(
                  ingredient: _ingredients[index],
                  onUpdate:
                      (field, value) => _updateIngredient(index, field, value),
                  onDelete: () => _removeIngredient(index),
                  showDelete: _ingredients.length > 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientFormRow extends StatelessWidget {
  final Map<String, dynamic> ingredient;
  final Function(String field, dynamic value) onUpdate;
  final VoidCallback onDelete;
  final bool showDelete;

  const IngredientFormRow({
    super.key,
    required this.ingredient,
    required this.onUpdate,
    required this.onDelete,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ingredient name (wider)
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: ingredient['name'],
                decoration: const InputDecoration(
                  labelText: 'Ingredient',
                  hintText: 'e.g. Flour',
                ),
                onChanged: (value) => onUpdate('name', value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),

            // Amount input
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: ingredient['amount'],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '250',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => onUpdate('amount', value),
              ),
            ),
            const SizedBox(width: 8),

            // Unit dropdown
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: ingredient['unit'],
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: const [
                  DropdownMenuItem(value: 'g', child: Text('g')),
                  DropdownMenuItem(value: 'kg', child: Text('kg')),
                  DropdownMenuItem(value: 'ml', child: Text('ml')),
                  DropdownMenuItem(value: 'l', child: Text('L')),
                  DropdownMenuItem(value: 'cup', child: Text('cup')),
                  DropdownMenuItem(value: 'tbsp', child: Text('tbsp')),
                  DropdownMenuItem(value: 'tsp', child: Text('tsp')),
                  DropdownMenuItem(value: 'pcs', child: Text('pcs')),
                ],
                onChanged: (value) => onUpdate('unit', value),
              ),
            ),

            // Delete button
            if (showDelete)
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                onPressed: onDelete,
                tooltip: 'Remove Ingredient',
              ),
          ],
        ),
      ),
    );
  }
}
