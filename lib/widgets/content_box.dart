import 'package:flutter/material.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

enum TitleStyle {
  none,
  header,
  floating,
}

class ContentBox extends StatelessWidget {
  const ContentBox({
    required this.title,
    required this.child,
    this.titleStyle = TitleStyle.header,
    super.key,
  });

  final String title;
  final Widget child;
  final TitleStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final inversePrimaryColor = inversePrimaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);

    return Column(
      children: [
        if (titleStyle == TitleStyle.floating)
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: primaryTextStyle?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (titleStyle == TitleStyle.header)
                  Container(
                    decoration: BoxDecoration(
                      border: const Border(
                        left: BorderSide(width: 0.5),
                        top: BorderSide(width: 0.5),
                        right: BorderSide(width: 0.5),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      color: inversePrimaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: primaryTextStyle?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
