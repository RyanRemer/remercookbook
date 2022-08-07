import 'package:flutter/material.dart';

class CategorySelectorWrap extends StatefulWidget {
  final Iterable<String?> categories;
  final CategorySelection? defaultSelection;
  final ValueChanged<CategorySelection>? onSelect;

  const CategorySelectorWrap({
    required this.categories,
    this.defaultSelection,
    Key? key,
    this.onSelect,
  }) : super(key: key);

  @override
  State<CategorySelectorWrap> createState() => _CategorySelectorWrapState();
}

class _CategorySelectorWrapState extends State<CategorySelectorWrap> {
  CategorySelection? selection;

  @override
  Widget build(BuildContext context) {
    selection ??= widget.defaultSelection ?? CategoryAllSelection();

    List<ChoiceChip> choices = [];
    choices.add(ChoiceChip(
        selectedColor: Colors.orangeAccent,
        backgroundColor: Colors.grey.shade200,
        selected: selection is CategoryAllSelection,
        label: const Text(
          "All",
        ),
        onSelected: (value) {
          setState(() {
            CategorySelection allSelection = CategoryAllSelection();
            selection = allSelection;
            widget.onSelect?.call(allSelection);
          });
        }));

    for (String? category in widget.categories) {
      choices.add(ChoiceChip(
          selectedColor: Colors.orangeAccent,
          backgroundColor: Colors.grey.shade200,
          selected: isCategorySelected(category),
          label: Text(
            category ?? "Other",
          ),
          onSelected: (value) {
            setState(() {
              CategorySelection valueSelection =
                  CategoryValueSelection(category);
              selection = valueSelection;
              widget.onSelect?.call(valueSelection);
            });
          }));
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0,
      runSpacing: 4.0,
      children: choices,
    );
  }

  bool isCategorySelected(String? category) {
    CategorySelection? selection = this.selection;

    return selection != null &&
        selection is CategoryValueSelection &&
        selection.value == category;
  }
}

class CategorySelection {}

class CategoryAllSelection extends CategorySelection {}

class CategoryValueSelection extends CategorySelection {
  String? value;
  CategoryValueSelection(this.value);
}
