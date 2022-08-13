// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remer_cookbook/recipe_book_loader.dart';

import '../recipe.dart';

class RecipePage extends StatelessWidget {
  static const String routeName = "/recipe";
  final String? recipeName;
  const RecipePage({this.recipeName, Key? key}) : super(key: key);

  static Uri getRecipePageUri(BuildContext context, String recipeName) {
    return Uri(path: routeName, queryParameters: {
      "name": recipeName,
    });
  }

  static Future navigateTo(BuildContext context, String recipeName) {
    Uri uri = getRecipePageUri(context, recipeName);

    if (kIsWeb) {
      // Change the url without navigating to the page, for easy link sharing
      window.history.pushState('recipePage', recipeName, uri.toString());
    }
    
    return Navigator.pushNamed(context, uri.toString());
  }

  static Widget? buildRecipePageFromUri(Uri uri) {
    if (uri.path != routeName) {
      return null;
    }
    return RecipePage(
      recipeName: uri.queryParameters["name"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RecipeBookLoader(
        builder: (context, recipeBook) {
          Recipe? recipe = recipeBook.nameRecipeMap[recipeName];
          if (recipe == null) {
            return buildErrorWidget(
              context,
              "Recipe for $recipeName not found",
            );
          }

          return Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double sidePadding =
                      max(constraints.maxWidth - 640, 0) / 2 + 16;

                  return ListView(
                    padding: EdgeInsets.only(
                        left: sidePadding,
                        right: sidePadding,
                        bottom: 128,
                        top: 48),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            buildSubtitle(context, recipe),
                          ],
                        ),
                      ),
                      buildImage(context, recipe),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Ingredients",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ...recipe.ingredients.map((ingredient) => buildBullet(
                          context,
                          const SizedBox(
                              width: 24,
                              height: 24,
                              child: Text(
                                "•",
                                textAlign: TextAlign.center,
                              )),
                          Text(ingredient))),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Directions",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ...buildDirections(context, recipe),
                      buildNotes(context, recipe),
                    ],
                  );
                },
              ),
              const StylizedFloatingBackButton()
            ],
          );
        },
      ),
    );
  }

  Widget buildErrorWidget(BuildContext context, String message) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(message),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            margin: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                iconSize: 24,
                splashRadius: 20,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildDirections(BuildContext context, Recipe recipe) {
    return List.generate(recipe.directions.length, (index) {
      String direction = recipe.directions[index];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: buildBullet(
          context,
          Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: Center(
                child: Text(
              (index + 1).toString(),
              style: const TextStyle(color: Colors.white),
            )),
          ),
          Text(direction),
        ),
      );
    });
  }

  Widget buildBullet(BuildContext context, Widget bullet, Widget content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: bullet,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: content,
          ),
        ),
      ],
    );
  }

  Widget buildImage(BuildContext context, Recipe recipe) {
    String? imageUrl = recipe.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          height: 240,
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
        ),
      ),
    );
  }

  Widget buildSubtitle(BuildContext context, Recipe recipe) {
    String? yields = recipe.yields;
    String? originalAuthor = recipe.originalAuthor;

    if (yields == null && originalAuthor == null) {
      return const SizedBox.shrink();
    }

    String subtitle = "";

    if (yields != null) {
      subtitle += "Yields: $yields";
    }

    if (yields != null && originalAuthor != null) {
      subtitle += " | ";
    }

    if (originalAuthor != null) {
      subtitle += "Author: $originalAuthor";
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        subtitle,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  Widget buildNotes(BuildContext context, Recipe recipe) {
    String notes = recipe.notes;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        notes,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}

class StylizedFloatingBackButton extends StatelessWidget {
  const StylizedFloatingBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange,
      ),
      margin: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          iconSize: 24,
          splashRadius: 20,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
