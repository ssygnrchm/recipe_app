import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/assets.dart';
import 'package:food_delivery_app/core/constants/colors.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';
import 'package:food_delivery_app/database/data/recipe_model.dart';
import 'package:food_delivery_app/database/domain/database_helper.dart';
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:io'; // Add this import for File

class RecipeScreen extends StatefulWidget {
  final Recipe? existingRecipe;

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
  bool _isSaving = false;

  // For image handling
  File? _imageFile;
  String? _existingImagePath;
  final ImagePicker _picker = ImagePicker();

  // Default images as fallback
  final List<String> _defaultImages = [
    Assets.burgerImage,
    Assets.chickenImage,
    Assets.riceBoxImage,
    Assets.tacosImage,
  ];
  int _selectedDefaultImageIndex = 0;
  bool _useDefaultImage = true;

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

      // Handle existing image
      _existingImagePath = widget.existingRecipe!.imagePath;
      _useDefaultImage =
          !(_existingImagePath != null &&
              !_defaultImages.contains(_existingImagePath));
      if (!_useDefaultImage) {
        // If has custom image path
        // In a real app, you might need to handle loading from local storage
      } else if (_existingImagePath != null) {
        // If using a default image
        _selectedDefaultImageIndex =
            _defaultImages.indexOf(_existingImagePath!) >= 0
                ? _defaultImages.indexOf(_existingImagePath!)
                : 0;
      }
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

  // Image picking functions
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _useDefaultImage = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Use Default Images'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _useDefaultImage = true;
                      _imageFile = null;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        // Handle image path
        String imagePath;
        if (_useDefaultImage) {
          // Use default image
          imagePath = _defaultImages[_selectedDefaultImageIndex];
        } else if (_imageFile != null) {
          // Handle custom image storage
          // In a real app, you would:
          // 1. Generate a unique filename
          // 2. Copy the image to app storage
          // 3. Save the path to the database

          // For now, we'll just use the temporary path
          imagePath = _imageFile!.path;

          // In a production app, implement proper storage:
          // final appDir = await getApplicationDocumentsDirectory();
          // final fileName = path.basename(_imageFile!.path);
          // final savedImage = await _imageFile!.copy('${appDir.path}/$fileName');
          // imagePath = savedImage.path;
        } else if (_existingImagePath != null &&
            !_defaultImages.contains(_existingImagePath)) {
          // Keep existing custom image
          imagePath = _existingImagePath!;
        } else {
          // Fallback to first default image
          imagePath = _defaultImages[0];
        }

        // Create recipe object
        final recipeData = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'cookTime': int.tryParse(_cookTimeController.text) ?? 0,
          'servings': int.tryParse(_servingsController.text) ?? 1,
          'ingredients': _ingredients,
          'imageIndex':
              _useDefaultImage
                  ? _selectedDefaultImageIndex
                  : -1, // -1 indicates custom image
          'imagePath': imagePath,
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

            // Recipe image selection section - MODIFIED
            Text('Recipe Image', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            // Image preview and upload button
            Center(
              child: Column(
                children: [
                  // Image preview
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImageWidget(theme),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Upload button
                  ElevatedButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.photo_camera),
                    label: Text(
                      _imageFile != null ||
                              (_existingImagePath != null &&
                                  !_defaultImages.contains(_existingImagePath))
                          ? 'Change Image'
                          : 'Upload Image',
                    ),
                  ),

                  // Show default images option if using defaults
                  if (_useDefaultImage) ...[
                    const SizedBox(height: 16),
                    const Text('Or select a default image:'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _defaultImages.length,
                        itemBuilder: (context, index) {
                          final isSelected =
                              index == _selectedDefaultImageIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDefaultImageIndex = index;
                                _useDefaultImage = true;
                              });
                            },
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    isSelected
                                        ? Border.all(
                                          color: theme.colorScheme.primary,
                                          width: 3,
                                        )
                                        : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  _defaultImages[index],
                                  fit: BoxFit.contain,
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
                  ],
                ],
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

            Text('Details', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                hintText:
                    'Briefly describe your recipe and explain recipe instruction',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(ThemeData theme) {
    if (_imageFile != null) {
      // Show selected image from device
      return Image.file(
        _imageFile!,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorPlaceholder(theme),
      );
    } else if (_existingImagePath != null &&
        !_defaultImages.contains(_existingImagePath)) {
      // Show existing custom image
      return Image.file(
        File(_existingImagePath!),
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorPlaceholder(theme),
      );
    } else if (_useDefaultImage) {
      // Show selected default image
      return Image.asset(
        _defaultImages[_selectedDefaultImageIndex],
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => _buildErrorPlaceholder(theme),
      );
    } else {
      // Show placeholder
      return _buildErrorPlaceholder(theme);
    }
  }

  Widget _buildErrorPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to add image',
              style: TextStyle(color: theme.colorScheme.primary),
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
