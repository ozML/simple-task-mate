import 'package:flutter/material.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class ContextMenuItem {
  ContextMenuItem({this.title, this.iconBuilder, this.onPressed, this.key})
      : assert(title != null || iconBuilder != null);

  final Key? key;
  final String? title;
  final IconBuilder? iconBuilder;
  final VoidCallback? onPressed;
}

class ContextMenuButton extends StatelessWidget {
  ContextMenuButton({required this.items, this.label, this.icon, super.key})
      : assert(label != null || icon != null),
        text = null;

  ContextMenuButton.labelText({
    required this.items,
    this.text,
    this.icon,
    super.key,
  })  : assert(text != null || icon != null),
        label = null;

  final List<ContextMenuItem> items;
  final String? text;
  final Widget? label;
  final Widget? icon;

  final anchorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final secondaryTextStyle = secondaryTextStyleFrom(context);

    final text = this.text;
    final label = this.label;
    final icon = this.icon;

    final entries = items.map(
      (e) {
        final icon = e.iconBuilder?.call(context, size: 20);
        final title = e.title;

        return PopupMenuItem(
          key: e.key,
          onTap: e.onPressed,
          child: Row(
            children: [
              if (icon != null) icon,
              if (icon != null && title != null) const SizedBox(width: 10),
              if (title != null)
                Text(title, style: secondaryTextStyleFrom(context)),
            ],
          ),
        );
      },
    ).toList();

    void openPopup() {
      if (anchorKey.currentContext?.findRenderObject()
          case final RenderBox box) {
        final offset = box.localToGlobal(Offset.zero);
        final bounds = box.paintBounds.translate(offset.dx, offset.dy);

        showMenu(
          context: context,
          color: surfaceColorFrom(context),
          position: RelativeRect.fromSize(
            Rect.fromLTRB(bounds.left, bounds.bottom, 1, 1),
            MediaQuery.of(context).size,
          ),
          items: entries,
        );
      }
    }

    final Widget? labelWidget;
    if (label != null) {
      labelWidget = label;
    } else if (text != null) {
      labelWidget = Text(text, style: secondaryTextStyle);
    } else {
      labelWidget = null;
    }

    if (icon != null && labelWidget != null) {
      return TextButton.icon(
        key: anchorKey,
        label: labelWidget,
        icon: icon,
        onPressed: openPopup,
      );
    } else {
      return TextButton(
        key: anchorKey,
        onPressed: openPopup,
        child: labelWidget ?? icon ?? Container(),
      );
    }
  }
}
