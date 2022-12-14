// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remer_cookbook/home/category_selector_wrap.dart';
import 'package:remer_cookbook/home/home_page_header.dart';
import 'package:remer_cookbook/recipe.dart';
import 'package:remer_cookbook/recipe_book.dart';
import 'package:remer_cookbook/home/recipe_card.dart';
import 'package:remer_cookbook/recipe_page/recipe_page.dart';

class HomePageContent extends StatefulWidget {
  static const String route = "/home";

  final RecipeBook recipeBook;
  final CategorySelection? initalSelection;
  final String? initalQuery;

  const HomePageContent({
    required this.recipeBook,
    this.initalSelection,
    this.initalQuery,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  TextEditingController searchTextController = TextEditingController();
  CategorySelection? categorySelection;
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    CategorySelection categorySelection = this.categorySelection ??
        widget.initalSelection ??
        CategoryAllSelection();
    String searchQuery = this.searchQuery ?? widget.initalQuery ?? "";

    List<Recipe> recipes = getRecipesByFilters(
      categorySelection,
      searchQuery,
    );

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
              searchTextController: searchTextController,
              recipeBook: widget.recipeBook,
              categorySelection: categorySelection,
              onCategorySelection: onCategorySelect,
              onSearchQueryChanged: onSearchQueryChanged,
            );
          } else {
            int rowIndex = index - 1;
            int recipeStartIndex = rowIndex * recipesPerRow;
            int recipeEndIndex = recipeStartIndex + recipesPerRow;
            recipeEndIndex = min(recipeEndIndex, recipeCount);

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

  void onSearchQueryChanged(String searchQuery) {
    setState(() {
      this.searchQuery = searchQuery;
    });
  }

  void onCategorySelect(CategorySelection categorySelection) {
    setState(() {
      this.categorySelection = categorySelection;
    });
  }

  List<Recipe> getRecipesByFilters(
      CategorySelection categorySelection, String searchQuery) {
    List<Recipe> recipesByCategory =
        getRecipesbyCategorySelection(categorySelection);

    if (searchQuery.isEmpty) {
      return recipesByCategory;
    }

    return recipesByCategory
        .where((recipe) => recipeContainsQuery(recipe, searchQuery))
        .toList();
  }

  bool recipeContainsQuery(Recipe recipe, String query) {
    String lowercaseQuery = query.toLowerCase();
    return recipe.name.toLowerCase().contains(lowercaseQuery);
  }

  List<Recipe> getRecipesbyCategorySelection(
    CategorySelection categorySelection,
  ) {
    List<Recipe> allRecipes = widget.recipeBook.recipes;

    if (categorySelection is CategoryValueSelection) {
      String? category = categorySelection.value;
      List<Recipe>? recipes = widget.recipeBook.categoryRecipeMap[category];
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

  Future<void> openRecipe(BuildContext context, Recipe recipe) async {
    await RecipePage.navigateTo(context, recipe.name);

    if (kIsWeb) {
      window.history.replaceState("recipePage", "Home", "/");
    }
  }
}
