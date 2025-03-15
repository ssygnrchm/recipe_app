import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/api_recipe_model.dart';

class RandomRecipeCard extends StatelessWidget {
  final SingleRecipe recipe;

  const RandomRecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                // recipe.strrecipeThumb.isNotEmpty ? recipe.strrecipeThumb : throw Exception("error loading tumbnail"),
                recipe.strMealThumb,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),

            // Recipe Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.strMeal,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.restaurant, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        recipe.strCategory,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.place, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        recipe.strArea,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
