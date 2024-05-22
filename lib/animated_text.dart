import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  const AnimatedText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.2, end: 1.0).animate(animation),
          child: child,
        );
      },
      child: Text(
        text,
        key: ValueKey(text),
      ),
    );
    ;
  }
}
