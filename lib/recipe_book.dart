import 'package:flutter/foundation.dart';
import 'package:remer_cookbook/recipe.dart';

class RecipeBook {
  final List<Recipe> recipes = [];
  final Set<String?> categories = {};
  final Map<String?, List<Recipe>> recipeMap = {};

  void add(Recipe recipe) {
    recipes.add(recipe);
    categories.add(recipe.category);
    recipeMap.putIfAbsent(recipe.category, () => []).add(recipe);
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
