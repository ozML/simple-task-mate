import 'package:flutter/material.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class ContextMenuItem {
  ContextMenuItem({
    this.title,
    this.iconBuilder,
    this.onPressed,
    this.key,
  }) : assert(title != null || iconBuilder != null);

  final Key? key;
  final String? title;
  final IconBuilder? iconBuilder;
  final VoidCallback? onPressed;
}

class ContextMenuButton extends StatelessWidget {
  const ContextMenuButton({
    required this.items,
    this.icon,
    super.key,
  });

  final List<ContextMenuItem> items;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: icon,
      tooltip: '',
      position: PopupMenuPosition.under,
      color: surfaceColorFrom(context),
      iconColor: primaryColorFrom(context),
      itemBuilder: (context) => items.map(
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
      ).toList(),
    );
  }
}
