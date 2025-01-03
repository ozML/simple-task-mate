import 'package:flutter/material.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/context_menu_button.dart';
import 'package:simple_task_mate/widgets/flex_container.dart';
import 'package:simple_task_mate/widgets/size_builder.dart';

class CollapsableButton extends StatefulWidget {
  const CollapsableButton({this.icon, this.label, this.onPressed, super.key})
      : assert(icon != null || label != null),
        items = null;

  const CollapsableButton.contextMenu({
    required List<ContextMenuItem> this.items,
    this.icon,
    this.label,
    super.key,
  })  : assert(icon != null || label != null),
        onPressed = null;

  final String? label;
  final Widget? icon;
  final List<ContextMenuItem>? items;
  final VoidCallback? onPressed;

  @override
  State<CollapsableButton> createState() => _CollapsableButtonState();
}

class _CollapsableButtonState extends State<CollapsableButton> {
  @override
  Widget build(BuildContext context) => SizeBuilder(
        builder: (context, size) {
          final icon = widget.icon;
          final actualLabel = widget.label;
          final items = widget.items;

          final isCollapsed = size != null && size.width <= 100;

          final Widget? label;
          if (actualLabel != null && !isCollapsed) {
            final secondaryTextStyle = secondaryTextStyleFrom(context);

            label = Text(
              widget.label ?? '',
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: secondaryTextStyle,
            );
          } else {
            label = null;
          }

          final Widget button;
          if (items != null) {
            button = ContextMenuButton(
              items: items,
              label: label,
              icon: icon,
            );
          } else {
            button = TextButton.icon(
              label: label ?? icon ?? Container(),
              icon: label != null && icon != null ? icon : null,
              onPressed: widget.onPressed,
            );
          }

          final content = FlexHorizontalContainer(child: button);

          return isCollapsed
              ? Tooltip(message: actualLabel, child: content)
              : content;
        },
      );
}
