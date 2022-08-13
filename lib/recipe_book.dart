import 'package:remer_cookbook/recipe.dart';

class RecipeBook {
  final List<Recipe> recipes = [];
  final Set<String?> categories = {};
  final Map<String?, List<Recipe>> categoryRecipeMap = {};
  final Map<String, Recipe> nameRecipeMap = {};

  void add(Recipe recipe) {
    recipes.add(recipe);
    categories.add(recipe.category);
    categoryRecipeMap.putIfAbsent(recipe.category, () => []).add(recipe);
    nameRecipeMap[recipe.name] = recipe;
  }

  List<String?> getAlphabetizedCategories() {
    List<String?> alphabetized = categories.toList();

    alphabetized.sort((String? a, String? b) {
      if (a == null && b == null) {
        return 0;
      } else if (a == null) {
        return 1;
      } else if (b == null) {
        return -1;
      } else {
        return a.compareTo(b);
      }
    });

    return alphabetized;
  }
}
