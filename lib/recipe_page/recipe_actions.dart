import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remer_cookbook/recipe_page/recipe_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../recipe.dart';

// Adds some buttons for different actions on the recipe page
class RecipeActions extends StatefulWidget {
  final Recipe recipe;
  const RecipeActions({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeActions> createState() => _RecipeActionsState();
}

class _RecipeActionsState extends State<RecipeActions> {
  Future<bool?>? isFavoriteFuture;

  @override
  Widget build(BuildContext context) {
    isFavoriteFuture ??= fetchFavorite();

    return ButtonBar(
      children: [
        Tooltip(
          message: "Copy",
          child: MaterialButton(
            onPressed: () => copyRecipe(context),
            color: Colors.orange,
            textColor: Colors.white,
            child: const Icon(
              Icons.copy,
              size: 24,
            ),
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
          ),
        ),
        Tooltip(
          message: "Share",
          child: MaterialButton(
            onPressed: () => shareRecipe(),
            color: Colors.orange,
            textColor: Colors.white,
            child: const Icon(
              Icons.share,
              size: 24,
            ),
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
          ),
        ),
        FutureBuilder<bool?>(
          future: isFavoriteFuture,
          builder: (context, snapshot) {
            bool isFavorite = false;

            if (snapshot.hasData) {
              isFavorite = snapshot.data ?? false;
            }

            return Tooltip(
              message: "Favorite",
              child: MaterialButton(
                onPressed: () => favoriteRecipe(isFavorite),
                color: Colors.orange,
                textColor: Colors.white,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 24,
                ),
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
              ),
            );
          },
        )
      ],
    );
  }

  void copyRecipe(BuildContext context) async {
    String output = widget.recipe.name + "\n";
    output += "\nIngredients:\n";
    for (int i = 0; i < widget.recipe.ingredients.length; i++) {
      output += "• ${widget.recipe.ingredients[i]}\n";
    }
    output += "\nDirections:\n";
    for (int i = 0; i < widget.recipe.directions.length; i++) {
      output += "${i + 1}. ${widget.recipe.directions[i]}\n";
    }
    output += "\nNotes:\n" + widget.recipe.notes;
    Clipboard.setData(ClipboardData(text: output));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Copied Recipe!")));
  }

  void shareRecipe() {
    Share.share(RecipePage.getFullRecipeUrl(widget.recipe.name).toString());
  }

  void favoriteRecipe(bool isCurrentlyFavoirte) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
        "remercookbok:" + widget.recipe.name, !isCurrentlyFavoirte);
    setState(() {
      isFavoriteFuture = fetchFavorite();
    });
  }

  Future<bool?> fetchFavorite() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("remercookbok:" + widget.recipe.name);
  }
}
