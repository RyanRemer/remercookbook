import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:remer_cookbook/header_stamp.dart';
import 'package:remer_cookbook/recipe.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:remer_cookbook/recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String?> categories = {};
  Map<String?, List<Recipe>> recipeMap = {};
  Future<void>? recipeFuture;

  @override
  Widget build(BuildContext context) {
    recipeFuture ??= loadRecipes();

    return Scaffold(
      body: FutureBuilder(
        future: recipeFuture,
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
              return buildCategories(context, categories.toList());
          }
        },
      ),
    );
  }

  Future<void> loadRecipes() async {
    try {
      String serialized = await rootBundle.loadString('assets/recipes.json');
      var json = jsonDecode(serialized);

      Set<String?> categories = {};
      Map<String?, List<Recipe>> recipeMap = {};

      for (var jsonItem in json) {
        Recipe recipe = Recipe.fromMap(jsonItem);

        recipeMap.putIfAbsent(recipe.category, () => []).add(recipe);
        categories.add(recipe.category);
      }

      this.categories = categories;
      this.recipeMap = recipeMap;
    } catch (error, stack) {
      FlutterError.onError
          ?.call(FlutterErrorDetails(exception: error, stack: stack));
      rethrow;
    }
  }

  Widget buildCategories(BuildContext context, List<String?> categories) {
    categories.sort(((a, b) {
      if (a == null) return 1;
      if (b == null) return -1;
      return a.compareTo(b);
    }));

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            leading: Icon(Icons.restaurant),
            title: RichText(
              text: TextSpan(
                text: 'remer',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.orange,fontWeight: FontWeight.bold, fontSize: 24),
                children: <TextSpan>[
                  TextSpan(
                      text: 'cookbook',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                ],
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],
          );
        }

        return buildCategory(context, categories[index - 1]);
      },
    );
  }

  Widget buildCategory(BuildContext context, String? category) {
    List<Recipe>? recipes = recipeMap[category];

    if (recipes == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 24, bottom: 8, right: 16),
          child: HeaderStamp(
            child: Text(
              category ?? "Other",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 8),
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return buildRecipeCard(context, recipes[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildRecipeCard(BuildContext context, Recipe recipe) {
    String? imageUrl = recipe.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return buildRecipeCardWithoutImage(context, recipe);
    }

    return SizedBox(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                height: 320,
                width: 224,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0xAA000000),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    recipe.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => openRecipe(context, recipe),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecipeCardWithoutImage(BuildContext context, Recipe recipe) {
    return SizedBox(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: [
              Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.restaurant),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    recipe.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey.shade800),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => openRecipe(context, recipe),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openRecipe(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RecipePage(recipe: recipe);
    }));
  }
}
