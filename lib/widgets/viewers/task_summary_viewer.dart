import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/viewers/item_viewer.dart';

class TaskSummaryViewer extends StatelessWidget {
  const TaskSummaryViewer({
    required this.summaries,
    this.hideHeader = false,
    this.searchText,
    this.isExtendedSearchEnabled = false,
    this.locale = const Locale('en'),
    this.durationFormat = DurationFormat.standard,
    this.onAddItem,
    this.onTapItem,
    this.onDeleteItem,
    this.onEditItem,
    this.onSearchTextChanged,
    this.onSearchSettingChanged,
    super.key,
  });

  static Key get keyItemTile => Key('$TaskSummaryViewer/itemTile');
  static Key get keyItemActionCopy => Key('$TaskSummaryViewer/itemActionCopy');
  static Key get keyItemActionDelete =>
      Key('$TaskSummaryViewer/itemActionDelete');
  static Key get keyItemActionEdit => Key('$TaskSummaryViewer/itemActionEdit');

  final List<TaskSummary> summaries;
  final bool hideHeader;
  final String? searchText;
  final bool isExtendedSearchEnabled;
  final Locale locale;
  final DurationFormat durationFormat;
  final void Function()? onAddItem;
  final void Function(ItemRef<TaskSummary> ref, TapInfo info)? onTapItem;
  final void Function(ItemRef<TaskSummary> ref)? onDeleteItem;
  final void Function(ItemRef<TaskSummary> ref)? onEditItem;
  final void Function(String value)? onSearchTextChanged;
  final void Function(bool value)? onSearchSettingChanged;

  @override
  Widget build(BuildContext context) {
    final onAddItem = this.onAddItem;
    final onDeleteItem = this.onDeleteItem;
    final onEditItem = this.onEditItem;

    String getTimeText(Duration time) =>
        durationFormat == DurationFormat.decimal
            ? time.asDecimal(locale.languageCode)
            : time.asHHMM;

    return ItemListViewer<TaskSummary>(
      items: summaries,
      getItemId: (item) => item.taskId,
      title: context.texts.labelTasks,
      hideHeader: hideHeader,
      showSearchField: onSearchTextChanged != null,
      searchText: searchText,
      searchFieldHintText: context.texts.labelSearchPlaceholderTaskEntry,
      decorateSearchField: (context, searchField) {
        return Column(
          children: [
            searchField,
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isExtendedSearchEnabled,
                    onChanged: onSearchSettingChanged != null
                        ? (value) =>
                            onSearchSettingChanged?.call(value ?? false)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.texts.labelSearchIncludeEntries,
                    style: secondaryTextStyleFrom(context),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      onSearchTextChanged: onSearchTextChanged,
      onTapItem: onTapItem,
      actions: [
        if (onAddItem != null)
          GlobalItemsAction(
            icon: IconUtils.add(context),
            label: context.texts.buttonAdd,
            onPressed: (_) => onAddItem(),
          ),
      ],
      tileBuilder: (context, ref, onTap) {
        final item = ref.item;

        return ItemTile(
          key: keyItemTile,
          ref: ref,
          title: item.refId,
          subTitle: item.name,
          footNote: context.texts.labelDuration(getTimeText(item.time)),
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
