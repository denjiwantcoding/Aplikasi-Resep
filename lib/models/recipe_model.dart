class Recipe {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final double rating;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.rating = 4.5,
  });
}
