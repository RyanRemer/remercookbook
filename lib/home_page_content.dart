import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remer_cookbook/category_selector_wrap.dart';
import 'package:remer_cookbook/home_page_header.dart';
import 'package:remer_cookbook/recipe.dart';
import 'package:remer_cookbook/recipe_book.dart';
import 'package:remer_cookbook/recipe_card.dart';
import 'package:remer_cookbook/recipe_page.dart';

class HomePageContent extends StatefulWidget {
  final RecipeBook recipeBook;

  const HomePageContent({
    required this.recipeBook,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List<Recipe>? recipes;

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = this.recipes ?? widget.recipeBook.recipes;

    return LayoutBuilder(builder: (context, constraints) {
      double recipeMinWidth = 320;
      int recipesPerRow = (constraints.maxWidth / recipeMinWidth).floor();
      int recipeCount = recipes.length;

      int rowCount = (recipeCount / recipesPerRow).ceil();

      return ListView.builder(
        itemCount: rowCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return HomePageHeader(
              recipeBook: widget.recipeBook,
              onCategorySelection: onCategorySelect,
            );
          } else {
            int rowIndex = index - 1;
            int recipeStartIndex = rowIndex * recipesPerRow;
            int recipeEndIndex = recipeStartIndex + recipesPerRow;
            recipeEndIndex = min(recipeEndIndex, recipeCount - 1);

            return SizedBox(
              height: 320,
              child: buildRecipeCardRow(
                context,
                recipes.getRange(recipeStartIndex, recipeEndIndex),
                recipesPerRow,
              ),
            );
          }
        },
      );
    });
  }

  void onCategorySelect(CategorySelection categorySelection) {
    List<Recipe> recipes = getRecipesbyCategorySelection(categorySelection);
    setState(() {
      this.recipes = recipes;
    });
  }

  List<Recipe> getRecipesbyCategorySelection(
    CategorySelection categorySelection,
  ) {
    List<Recipe> allRecipes = widget.recipeBook.recipes;

    if (categorySelection is CategoryValueSelection) {
      String? category = categorySelection.value;
      List<Recipe>? recipes = widget.recipeBook.recipeMap[category];
      return recipes ?? allRecipes;
    } else {
      return allRecipes;
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
}

void openRecipe(BuildContext context, Recipe recipe) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return RecipePage(recipe: recipe);
  }));
}
