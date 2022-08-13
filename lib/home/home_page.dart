import 'package:flutter/material.dart';
import 'package:remer_cookbook/home/home_page_content.dart';
import 'package:remer_cookbook/recipe_book_loader.dart';

class HomePage extends StatefulWidget {
  static const String route = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: RecipeBookLoader(
      builder: (context, recipeBook) {
        return HomePageContent(recipeBook: recipeBook);
      },
    ));
  }
}
