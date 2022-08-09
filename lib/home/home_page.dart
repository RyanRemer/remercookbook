import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remer_cookbook/home/home_page_content.dart';
import 'package:remer_cookbook/home/home_page_header.dart';
import 'package:remer_cookbook/recipe.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:remer_cookbook/recipe_book.dart';
import 'package:remer_cookbook/recipe_card.dart';
import 'package:remer_cookbook/recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String?> categories = {};
  Map<String?, List<Recipe>> recipeMap = {};
  Future<RecipeBook>? recipeBookFuture;

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    recipeBookFuture ??= loadRecipeBook();

    return Scaffold(
      body: FutureBuilder<RecipeBook>(
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
              return HomePageContent(recipeBook: recipeBook);
          }
        },
      ),
    );
  }

  Future<RecipeBook> loadRecipeBook() async {
    try {
      String serializedJson =
          await rootBundle.loadString('assets/recipes.json');
      List<Recipe> recipes = loadRecipes(serializedJson);

      RecipeBook recipeBook = RecipeBook();
      for (Recipe recipe in recipes) {
        recipeBook.add(recipe);
      }
      return recipeBook;
    } catch (error, stack) {
      FlutterError.onError
          ?.call(FlutterErrorDetails(exception: error, stack: stack));
      rethrow;
    }
  }

  List<Recipe> loadRecipes(String serializedJson) {
    try {
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
