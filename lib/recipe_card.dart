import 'package:flutter/material.dart';

import 'recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  static const EdgeInsets cardPadding = EdgeInsets.all(8.0);
  static const BorderRadius cardBorderRadius =
      BorderRadius.all(Radius.circular(16.0));

  const RecipeCard({required this.recipe, Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl = recipe.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return buildRecipeCardWithoutImage(context, recipe);
    }

    return Padding(
      padding: cardPadding,
      child: ClipRRect(
        borderRadius: cardBorderRadius,
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Image.network(
                  imageUrl,
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  fit: BoxFit.cover,
                );
              },
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
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildRecipeCardWithoutImage(BuildContext context, Recipe recipe) {
    return Padding(
      padding: cardPadding,
      child: ClipRRect(
        borderRadius: cardBorderRadius,
        child: Stack(
          children: [
            Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.restaurant),
              ),
            ),
            buildText(recipe, context),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align buildText(Recipe recipe, BuildContext context) {
    return Align(
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
          );
  }
}
