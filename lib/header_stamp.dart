import 'package:flutter/material.dart';

class HeaderStamp extends StatelessWidget {
  final Widget child;
  const HeaderStamp({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: child,
            ),
          ),
        ],
    );
  }
}
