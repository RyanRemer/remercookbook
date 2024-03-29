import 'dart:convert';
import 'dart:developer';

class Recipe {
  String name;
  List<String> ingredients;
  List<String> directions;
  String notes;
  String? yields;
  String? category;
  String? originalAuthor;
  String? imageUrl;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.directions,
    required this.notes,
    this.yields,
    this.category,
    this.originalAuthor,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients,
      'directions': directions,
      'notes': notes,
      'yields': yields,
      'category': category,
      'original_author': originalAuthor,
      'imageUrl': imageUrl,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    try {
      return Recipe(
        name: map['name'] ?? "",
        ingredients: (map['ingredients'] as String).split("\n"),
        directions: (map['directions'] as String).split("\n"),
        notes: map['notes'] ?? "",
        yields: map['yields'],
        category: map['category'],
        originalAuthor: map['original_author'],
        imageUrl: map['imageUrl'],
      );
    } catch (error) {
      log("Error parsing: $map");
      rethrow;
    }
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));
}
