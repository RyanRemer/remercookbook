import 'package:flutter/material.dart';

class HomePageSearch extends StatelessWidget {
  static const double imageSectionHeight = 400;
  const HomePageSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Color canvasColor = Theme.of(context).canvasColor;

        return SizedBox(
          height: imageSectionHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: [
              Image.asset(
                "assets/SearchBackground.png",
                height: 400,
                width: constraints.maxWidth,
                fit: BoxFit.fitWidth,
              ),
              Container(
                height: imageSectionHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [canvasColor.withAlpha(0), canvasColor],
                      stops: const [0.5, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                      child: Text(
                    "Remer Cookbook",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
