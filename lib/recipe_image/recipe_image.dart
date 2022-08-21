import 'dart:developer';

import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String? imageUrl;

  const RecipeImage({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl = this.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return emptyImage;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Image.network(
          imageUrl,
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          fit: BoxFit.cover,
          errorBuilder: (context, _obeject, _stacktrace) {
            log("NetworkImageError: $imageUrl");
            return emptyImage;
          },
        );
      },
    );
  }

  Widget get emptyImage => LayoutBuilder(
        builder: (context, constraints) {
          return Image.asset(
            "assets/default_image.jpg",
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.cover,
          );
        },
      );
}
