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
    this.onTapItem,
    this.onDeleteItem,
    this.onEditItem,
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
  final void Function(ItemRef<TaskSummary> ref)? onTapItem;
  final void Function(ItemRef<TaskSummary> ref)? onDeleteItem;
  final void Function(ItemRef<TaskSummary> ref)? onEditItem;
  final void Function(String value)? onSearchTextChanged;

  @override
  Widget build(BuildContext context) {
    final onDeleteItem = this.onDeleteItem;
    final onEditItem = this.onEditItem;

    return ItemListViewer<TaskSummary>(
      items: summaries,
      getItemId: (item) => item.taskId,
      title: context.texts.labelTasks,
      titleStyle: titleStyle,
      showSearchField: onSearchTextChanged != null,
      searchText: searchText,
      searchFieldHintText: context.texts.labelSearchPlaceholderTaskEntry,
      onTapItem: onTapItem,
      onSearchTextChanged: onSearchTextChanged,
      tileBuilder: (context, ref, onTap) {
        final item = ref.item;

        return ItemTile(
          key: keyItemTile,
          ref: ref,
          title: item.refId,
          subTitle: item.name,
          footNote: context.texts.labelDuration(item.time.asHHMM),
          onTap: onTap,
          actions: [
            LocalItemAction(
              key: keyItemActionCopy,
              icon: IconUtils.copy(context),
              onPressed: (_) {
                Clipboard.setData(ClipboardData(text: item.fullName()));
              },
            ),
            if (onDeleteItem != null)
              LocalItemAction(
                key: keyItemActionDelete,
                icon: IconUtils.trashCan(context),
                onPressed: onDeleteItem,
              ),
            if (onEditItem != null)
              LocalItemAction(
                key: keyItemActionEdit,
                icon: IconUtils.edit(context),
                onPressed: onEditItem,
              ),
          ],
        );
      },
    );
  }
}
