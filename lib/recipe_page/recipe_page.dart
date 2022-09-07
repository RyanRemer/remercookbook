// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remer_cookbook/home/home_page.dart';
import 'package:remer_cookbook/recipe_book_loader.dart';
import 'package:remer_cookbook/recipe_image/recipe_image.dart';

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

  static void navigateHome(BuildContext context) async {
    if (kIsWeb) {
      // Change the url without navigating to the page, for easy link sharing
      window.history.pushState('recipePage', 'Remer Cookbook', '/');
    }

    Colors.orange.shade500;

    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, HomePage.route);
    }
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
                        top: 64),
                    children: [
                      buildResponsiveSection(context, recipe, constraints),
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
              StylizedFloatingBackButton(
                onPressed: () => navigateHome(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildResponsiveSection(
      BuildContext context, Recipe recipe, BoxConstraints constraints) {
    if (constraints.maxWidth > 500) {
      return buildImageOnRight(context, recipe, constraints);
    } else {
      return buildImageInColumn(context, recipe, constraints);
    }
  }

  Widget buildImageInColumn(
      BuildContext context, Recipe recipe, BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(recipe, context),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: buildImage(context, recipe),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Ingredients",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...buildIngredients(recipe, context)
      ],
    );
  }

  Widget buildImageOnRight(
    BuildContext context,
    Recipe recipe,
    BoxConstraints constraints,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: buildTitle(recipe, context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Ingredients",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ...buildIngredients(recipe, context),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: buildImage(context, recipe),
            ),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> buildIngredients(Recipe recipe, BuildContext context) {
    return recipe.ingredients.map((ingredient) => buildBullet(
        context,
        const SizedBox(
            width: 24,
            height: 24,
            child: Text(
              "•",
              textAlign: TextAlign.center,
            )),
        Text(ingredient)));
  }

  Column buildTitle(Recipe recipe, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        buildSubtitle(context, recipe),
      ],
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

  Widget buildImage(
    BuildContext context,
    Recipe recipe,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 240,
                maxHeight: 240,
              ),
              child: RecipeImage(
                imageUrl: recipe.imageUrl,
                recipeId: recipe.name,
              ));
        },
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
  final VoidCallback onPressed;

  const StylizedFloatingBackButton({
    required this.onPressed,
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
          onPressed: onPressed,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
