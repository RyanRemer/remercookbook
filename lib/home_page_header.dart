import 'package:flutter/material.dart';
import 'package:remer_cookbook/category_selector_wrap.dart';
import 'package:remer_cookbook/home_page_search.dart';
import 'package:remer_cookbook/recipe_book.dart';

class HomePageHeader extends StatefulWidget {
  final RecipeBook recipeBook;
  final ValueChanged<CategorySelection>? onCategorySelection;

  const HomePageHeader({
    required this.recipeBook,
    this.onCategorySelection,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageHeader> createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  @override
  Widget build(BuildContext context) {
    List<String?> alphabeticalCategories = getSortedCategories();

    return Column(
      children: [
        const HomePageSearch(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CategorySelectorWrap(
            categories: alphabeticalCategories,
            onSelect: widget.onCategorySelection,
          ),
        ),
      ],
    );
  }

  List<String?> getSortedCategories() {
    List<String?> alphabeticalCategories =
        widget.recipeBook.categories.toList();

    alphabeticalCategories.sort(
      ((a, b) {
        if (a == null) {
          return 1;
        } else if (b == null) {
          return -1;
        } else {
          return a.compareTo(b);
        }
      }),
    );

    return alphabeticalCategories;
  }
}
