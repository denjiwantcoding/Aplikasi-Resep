import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../data/local_storage.dart';
import '../models/recipe_model.dart';

class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _allRecipes = dummyRecipes;
  List<Recipe> _favorites = [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<Recipe> get favorites => List.unmodifiable(_favorites);
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<String> get categories {
    final categorySet = _allRecipes.map((recipe) => recipe.category).toSet();
    return ['Semua', ...categorySet.toList()..sort()];
  }

  List<Recipe> get filteredRecipes {
    return _allRecipes.where((recipe) {
      final matchCategory =
          _selectedCategory == 'Semua' || recipe.category == _selectedCategory;
      final matchSearch =
          _searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  List<Recipe> get popularRecipes {
    final sorted = [..._allRecipes];
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  List<Recipe> recipesByCategory(String category) {
    if (category == 'Semua') {
      return [..._allRecipes];
    }
    return _allRecipes.where((recipe) => recipe.category == category).toList();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  List<Recipe> search(String query) {
    return _allRecipes
        .where(
          (recipe) => recipe.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void toggleFavorite(Recipe recipe) {
    final exists = _favorites.any((item) => item.id == recipe.id);
    if (exists) {
      _favorites.removeWhere((item) => item.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
    LocalStorage.saveFavorites(_favorites);
    notifyListeners();
  }

  bool isFavorite(Recipe recipe) {
    return _favorites.any((item) => item.id == recipe.id);
  }

  Future<void> loadFavorites() async {
    final stored = await LocalStorage.loadFavorites();
    final storedIds = stored.map((recipe) => recipe.id).toSet();
    _favorites = _allRecipes
        .where((recipe) => storedIds.contains(recipe.id))
        .toList();
    notifyListeners();
  }
}
