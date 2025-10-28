import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../utils/image_helpers.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          Consumer<RecipeProvider>(
            builder: (context, provider, _) {
              final isFavorite = provider.isFavorite(recipe);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () => provider.toggleFavorite(recipe),
                tooltip: isFavorite
                    ? 'Hapus dari favorit'
                    : 'Tambah ke favorit',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: buildRecipeImage(
                recipe.imageUrl,
                height: 220,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bahan-bahan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...recipe.ingredients.map((b) => Text('- $b')),
            const SizedBox(height: 16),
            const Text(
              'Cara Membuat:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(recipe.instructions),
          ],
        ),
      ),
    );
  }
}
