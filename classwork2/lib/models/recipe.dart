class Recipe {
  final String name;
  final String imagePath;
  final List<String> ingredients;
  final String instructions;

  const Recipe({
    required this.name,
    required this.imagePath,
    required this.ingredients,
    required this.instructions,
  });
}
