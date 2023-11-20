import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remer_cookbook/recipe_page/recipe_page.dart';
import 'home/home_page.dart';
import 'package:url_strategy/url_strategy.dart';

typedef UriRouteParser = Widget? Function(Uri uri);

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<UriRouteParser> routeParsers = [RecipePage.buildRecipePageFromUri];
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.orange,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remer Cookbook',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      onGenerateRoute: (RouteSettings settings) {
        Uri uri = Uri.parse(settings.name!);

        for (UriRouteParser routeParser in routeParsers) {
          Widget? widget = routeParser(uri);
          if (widget != null) {
            return MaterialPageRoute(builder: (context) => widget);
          }
        }

        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      },
    );
  }
}
