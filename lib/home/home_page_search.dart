import 'package:flutter/material.dart';

class HomePageSearch extends StatelessWidget {
  static const double imageSectionHeight = 400;
  final ValueChanged<String>? onSearchQueryChange;
  final TextEditingController textEditingController;

  const HomePageSearch({
    Key? key,
    required this.textEditingController,
    this.onSearchQueryChange,
  }) : super(key: key);

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
                height: 399,
                width: constraints.maxWidth,
                fit: BoxFit.cover,
              ),
              Container(
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
                children: [
                  const Center(
                    child: Text(
                      "Remer Cookbook",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            textEditingController.clear();
                            onSearchQueryChange?.call("");
                          },
                        ),
                      ),
                      onChanged: onSearchQueryChange,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
