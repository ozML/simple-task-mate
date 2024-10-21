import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/widgets/content_box.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';

class TaskSummaryViewer extends StatelessWidget {
  const TaskSummaryViewer({
    required this.summaries,
    this.titleStyle = TitleStyle.header,
    this.searchText,
    this.onSelect,
    this.onDelete,
    this.onEdit,
    this.onSearchTextChanged,
    super.key,
  });

  static Key get keyItemTile => Key('$TaskSummaryViewer/itemTile');
  static Key get keyItemActionCopy => Key('$TaskSummaryViewer/itemActionCopy');
  static Key get keyItemActionDelete =>
      Key('$TaskSummaryViewer/itemActionDelete');
  static Key get keyItemActionEdit => Key('$TaskSummaryViewer/itemActionEdit');

  final List<TaskSummary> summaries;
  final TitleStyle titleStyle;
  final String? searchText;
  final void Function(TaskSummary summary)? onSelect;
  final void Function(TaskSummary summary)? onDelete;
  final void Function(TaskSummary summary)? onEdit;
  final void Function(String value)? onSearchTextChanged;

  @override
  Widget build(BuildContext context) {
    final onDelete = this.onDelete;
    final onEdit = this.onEdit;

    return ItemListViewer<TaskSummary>(
      items: summaries,
      title: context.texts.labelTasks,
      titleStyle: titleStyle,
      showSearchField: onSearchTextChanged != null,
      searchText: searchText,
      searchFieldHintText: context.texts.labelSearchPlaceholderTaskEntry,
      onSelect: onSelect,
      onSearchTextChanged: onSearchTextChanged,
      tileBuilder: (context, item, onSelect) {
        return ItemTile(
          key: keyItemTile,
          item: item,
          title: item.refId,
          subTitle: item.name,
          footNote: context.texts.labelDuration(item.time.asHHMM),
          onSelect: onSelect,
          actions: [
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
            if (onEdit != null)
              ItemTileAction(
                key: keyItemActionEdit,
                icon: IconUtils.edit(context),
                onPressed: onEdit,
              ),
          ],
        );
      },
    );
  }
}
