import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remer_cookbook/recipe.dart';
import 'package:remer_cookbook/recipe_book.dart';

typedef RecipeBookBuilder = Widget Function(
    BuildContext context, RecipeBook recipeBook);

class RecipeBookLoader extends StatefulWidget {
  final RecipeBookBuilder builder;

  const RecipeBookLoader({
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeBookLoader> createState() => _RecipeBookLoaderState();
}

class _RecipeBookLoaderState extends State<RecipeBookLoader> {
  Future<RecipeBook>? recipeBookFuture;

  @override
  Widget build(BuildContext context) {
    recipeBookFuture ??= loadRecipeBook();

    return FutureBuilder<RecipeBook>(
      future: recipeBookFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error?.toString() ?? "Unknown Error"),
          );
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            RecipeBook recipeBook = snapshot.data!;
            return widget.builder(context, recipeBook);
        }
      },
    );
  }

  Future<RecipeBook> loadRecipeBook() async {
    List<Recipe> recipes = await loadRecipes();

      RecipeBook recipeBook = RecipeBook();
      for (Recipe recipe in recipes) {
        recipeBook.add(recipe);
      }
      return recipeBook;
  }

  Future<List<Recipe>> loadRecipes() async {
    try {
      String serializedJson =
          await rootBundle.loadString('assets/recipes.json');
      var json = jsonDecode(serializedJson);

      if (json is! List) {
        throw "json is invalid for recipes: $json";
      }

      return List.generate(json.length, (index) {
        return Recipe.fromMap(json[index]);
      });
    } catch (error, stack) {
      FlutterError.onError?.call(FlutterErrorDetails(
          exception: "Error Loading Recipes: " + error.toString(),
          stack: stack));
      rethrow;
    }
  }
}
