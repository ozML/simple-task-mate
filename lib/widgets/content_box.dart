import 'package:flutter/material.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class ContentBoxHeader extends StatelessWidget {
  const ContentBoxHeader({required this.content, this.color, super.key})
      : title = null,
        subTitle = null;

  const ContentBoxHeader.title({
    required String this.title,
    this.subTitle,
    this.color,
    super.key,
  }) : content = null;

  final Widget? content;
  final String? title;
  final String? subTitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final inversePrimaryColor = inversePrimaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);

    final content = this.content;
    final title = this.title;
    final subTitle = this.subTitle;

    final Widget child;
    if (content != null) {
      child = content;
    } else {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: primaryTextStyle?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(
            subTitle ?? '',
            textAlign: TextAlign.center,
            style: secondaryTextStyle?.copyWith(
              color: primaryColor,
            ),
          )
        ],
      );
    }

    return Container(
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
        color: color ?? inversePrimaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

class ContentBox extends StatelessWidget {
  const ContentBox({required this.child, this.header, super.key});

  final ContentBoxHeader? header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final header = this.header;

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) header,
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
