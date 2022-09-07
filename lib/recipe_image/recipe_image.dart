import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  static const List<String> imageFileNames = [
    "assets/plates/Multi-colored plates_Green.png",
    "assets/plates/Multi-colored plates_Maroon.png",
    "assets/plates/Multi-colored plates_Orange.png",
    "assets/plates/Multi-colored plates_Pink.png",
    "assets/plates/Multi-colored plates_Purple.png",
    "assets/plates/Multi-colored plates_Teal.png",
    "assets/plates/Multi-colored plates_White.png",
  ];

  final String? imageUrl;
  final String recipeId;

  const RecipeImage({
    required this.imageUrl,
    required this.recipeId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl = this.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return buildDefaultImage(recipeId);
    }

    return Hero(
      tag: ObjectKey(recipeId),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Image.network(
            imageUrl,
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            fit: BoxFit.cover,
            errorBuilder: (context, _obeject, stacktrace) {
              dev.log("ImageRenderError");
              dev.log(stacktrace?.toString() ?? "");
              return Center(
                child: SelectableText(imageUrl),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildDefaultImage(String recipeId) {
    Random random = Random(recipeId.hashCode);
    int index = random.nextInt(imageFileNames.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Image.asset(
          imageFileNames[index],
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
