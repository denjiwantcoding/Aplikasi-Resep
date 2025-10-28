import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  final String category;

  const RecipeListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        final filteredRecipes = provider.recipesByCategory(category);

        if (filteredRecipes.isEmpty) {
          return Center(
            child: Text('Belum ada resep untuk kategori "$category".'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            final recipe = filteredRecipes[index];
            final isFavorite = provider.isFavorite(recipe);
            return RecipeCard(
              recipe: recipe,
              isFavorite: isFavorite,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
              onFavoriteToggle: () => provider.toggleFavorite(recipe),
            );
          },
        );
      },
    );
  }
}
