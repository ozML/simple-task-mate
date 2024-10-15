import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/content_box.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskViewer extends StatelessWidget {
  const TaskViewer({
    required this.tasks,
    this.titleStyle = TitleStyle.header,
    this.hideCopyButton = false,
    this.hideDurations = false,
    this.onSelect,
    this.onDelete,
    this.onAdd,
    this.onSearchTextChanged,
    super.key,
  });

  final List<Task> tasks;
  final TitleStyle titleStyle;
  final bool hideCopyButton;
  final bool hideDurations;
  final void Function(Task task)? onSelect;
  final void Function(Task task)? onDelete;
  final void Function(Task task)? onAdd;
  final void Function(String value)? onSearchTextChanged;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigModel>();

    final onDelete = this.onDelete;
    final onAdd = this.onAdd;

    return ItemListViewer<Task>(
      items: tasks,
      title: context.texts.labelTasks,
      titleStyle: titleStyle,
      showSearchField: onSearchTextChanged != null,
      searchFieldHintText: context.texts.labelSearchPlaceholderTaskEntry,
      onSelect: onSelect,
      onSearchTextChanged: onSearchTextChanged,
      tileBuilder: (context, item, onSelect) {
        bool isAutoRef = false;
        String? hRef;
        if (item.hRef != null) {
          hRef = item.hRef;
        } else if (item.refId case String refId) {
          if (config.getValue(settingAutoLinks)) {
            final map = config.getValue<Map<String, String>>(
              settingAutoLinkGroups,
            );

            for (final entry in map.entries) {
              if (refId.startsWith(entry.key)) {
                hRef = '${entry.value}$refId';
                isAutoRef = true;
                break;
              }
            }
          }
        }

        return ItemTile(
          item: item,
          title: item.refId,
          subTitle: item.name,
          footNote: hideDurations
              ? null
              : context.texts.labelDuration(item.time().asHHMM),
          infoIcon: item.info != null
              ? Tooltip(
                  message: item.info,
                  child: IconUtils.circleInfo(context,
                      color: inversePrimaryColorFrom(context), size: 20),
                )
              : null,
          linkIcon: hRef != null
              ? Tooltip(
                  message: hRef,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => launchUrl(Uri.parse(hRef ?? '')),
                      child: IconUtils.link(
                        context,
                        size: 16,
                        color: isAutoRef ? Colors.purple : null,
                      ),
                    ),
                  ),
                )
              : null,
          onSelect: onSelect,
          actions: [
            if (!hideCopyButton)
              ItemTileAction(
                icon: IconUtils.copy(context),
                onPressed: (_) {
                  Clipboard.setData(ClipboardData(text: item.fullName()));
                },
              ),
            if (onDelete != null)
              ItemTileAction(
                icon: IconUtils.trashCan(context),
                onPressed: onDelete,
              ),
            if (onAdd != null)
              ItemTileAction(
                icon: IconUtils.add(context),
                onPressed: onAdd,
              ),
          ],
        );
      },
    );
  }
}
