import 'package:flutter/material.dart';

class FlexHorizontalContainer extends StatelessWidget {
  const FlexHorizontalContainer({
    required this.child,
    this.fit = false,
    super.key,
  });

  final Widget child;
  final bool fit;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (fit) Flexible(child: child) else Expanded(child: child),
        ],
      );
}

class FlexVerticalContainer extends StatelessWidget {
  const FlexVerticalContainer({
    required this.child,
    this.fit = false,
    super.key,
  });

  final Widget child;
  final bool fit;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (fit) Flexible(child: child) else Expanded(child: child),
        ],
      );
}
