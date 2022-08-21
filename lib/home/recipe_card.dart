import 'package:flutter/material.dart';
import 'package:remer_cookbook/recipe_image/recipe_image.dart';

import '../recipe.dart';

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
    return Padding(
      padding: cardPadding,
      child: ClipRRect(
        borderRadius: cardBorderRadius,
        child: Stack(
          children: [
            RecipeImage(imageUrl: recipe.imageUrl),
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
