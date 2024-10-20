import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/models/task_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/utils/tuple.dart';
import 'package:simple_task_mate/widgets/content_box.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskViewer extends StatelessWidget {
  const TaskViewer({
    required this.tasks,
    this.titleStyle = TitleStyle.header,
    this.hideCopyButton = false,
    this.hideDurations = false,
    this.autoLinkGroups,
    this.onSelect,
    this.onDelete,
    this.onAdd,
    this.onSearchTextChanged,
    super.key,
  });

  static Key get keyItemTile => Key('$TaskViewer/itemTile');
  static Key get keyItemInfoIcon => Key('$TaskViewer/itemInfoIcon');
  static Key get keyItemLinkIcon => Key('$TaskViewer/itemLinkIcon');
  static Key get keyItemActionCopy => Key('$TaskViewer/itemActionCopy');
  static Key get keyItemActionDelete => Key('$TaskViewer/itemActionDelete');
  static Key get keyItemActionAdd => Key('$TaskViewer/itemActionAdd');

  final List<Task> tasks;
  final TitleStyle titleStyle;
  final bool hideCopyButton;
  final bool hideDurations;
  final List<Tuple<String, String>>? autoLinkGroups;
  final void Function(Task task)? onSelect;
  final void Function(Task task)? onDelete;
  final void Function(Task task)? onAdd;
  final void Function(String value)? onSearchTextChanged;

  static Widget fromProvider({
    required BuildContext context,
    TitleStyle titleStyle = TitleStyle.header,
    bool hideCopyButton = false,
    bool hideDurations = false,
    List<Tuple<String, String>>? autoLinkGroups,
    void Function(Task task)? onSelect,
    void Function(Task task)? onDelete,
    void Function(Task task)? onAdd,
    void Function(String value)? onSearchTextChanged,
  }) {
    final config = context.watch<ConfigModel>();
    final autoLinksEnabled = config.getValue<bool>(settingAutoLinks);

    final tasks = context.watch<TaskModel>().tasks;

    return TaskViewer(
      tasks: tasks,
      titleStyle: titleStyle,
      hideCopyButton: hideCopyButton,
      hideDurations: hideDurations,
      autoLinkGroups: autoLinksEnabled
          ? config.getValue<List<Tuple<String, String>>>(settingAutoLinkGroups)
          : null,
      onSelect: onSelect,
      onDelete: onDelete,
      onAdd: onAdd,
      onSearchTextChanged: onSearchTextChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onDelete = this.onDelete;
    final onAdd = this.onAdd;

    final autoLinkGroups = this.autoLinkGroups;

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
          if (autoLinkGroups != null) {
            for (final group in autoLinkGroups) {
              if (refId.startsWith(group.value0)) {
                hRef = '${group.value1}$refId';
                isAutoRef = true;
                break;
              }
            }
          }
        }

        return ItemTile(
          key: keyItemTile,
          item: item,
          title: item.refId,
          subTitle: item.name,
          footNote: hideDurations
              ? null
              : context.texts.labelDuration(item.time().asHHMM),
          infoIcon: item.info != null
              ? Tooltip(
                  key: keyItemInfoIcon,
                  message: item.info,
                  child: IconUtils.circleInfo(context,
                      color: inversePrimaryColorFrom(context), size: 20),
                )
              : null,
          linkIcon: hRef != null
              ? Tooltip(
                  key: keyItemLinkIcon,
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
                key: keyItemActionCopy,
                icon: IconUtils.copy(context),
                onPressed: (_) {
                  Clipboard.setData(ClipboardData(text: item.fullName()));
                },
              ),
            if (onDelete != null)
              ItemTileAction(
                key: keyItemActionDelete,
                icon: IconUtils.trashCan(context),
                onPressed: onDelete,
              ),
            if (onAdd != null)
              ItemTileAction(
                key: keyItemActionAdd,
                icon: IconUtils.add(context),
                onPressed: onAdd,
              ),
          ],
        );
      },
    );
  }
}
