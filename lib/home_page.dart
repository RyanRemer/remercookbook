import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remer_cookbook/home_page_header.dart';
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
              List<String?> categories = recipeBook.getAlphabetizedCategories();

              //todo this will not work for "Other"
              selectedCategory ??= categories.first;

              return LayoutBuilder(builder: (context, constraints) {
                double recipeMinWidth = 320;
                int recipesPerRow =
                    (constraints.maxWidth / recipeMinWidth).floor();
                int recipeCount = recipeBook.recipes.length;

                int rowCount = (recipeCount / recipesPerRow).ceil();

                return ListView.builder(
                  itemCount: rowCount + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return HomePageHeader(recipeBook: recipeBook);
                    } else {
                      int rowIndex = index - 1;
                      int recipeStartIndex = rowIndex * recipesPerRow;
                      int recipeEndIndex = recipeStartIndex + recipesPerRow;
                      recipeEndIndex = min(recipeEndIndex, recipeCount - 1);

                      return SizedBox(
                        height: 320,
                        child: buildRecipeCardRow(
                          context,
                          recipeBook.recipes
                              .getRange(recipeStartIndex, recipeEndIndex),
                          recipesPerRow,
                        ),
                      );
                    }
                  },
                );
              });
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

  Widget buildRecipeCardRow(
    BuildContext context,
    Iterable<Recipe> recipes,
    int recipesPerRow,
  ) {
    List<Widget> recipeCards = recipes
        .map((recipe) => Expanded(
              child: RecipeCard(
                recipe: recipe,
                onTap: () => openRecipe(context, recipe),
              ),
            ))
        .toList();

    List<Widget> trimSpacing = List.filled(
        recipesPerRow - recipes.length, const Expanded(child: SizedBox()));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [...recipeCards, ...trimSpacing],
      ),
    );
  }

  void openRecipe(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RecipePage(recipe: recipe);
    }));
  }
}
