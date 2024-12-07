import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/date_time_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';

class TaskEntryViewer extends StatelessWidget {
  const TaskEntryViewer({
    required this.title,
    required this.taskEntries,
    this.subTitle,
    this.hideHeader = false,
    this.locale = const Locale('en'),
    this.showDate = false,
    this.showSelectOption = false,
    this.onAddItem,
    this.onCopy,
    this.onDelete,
    this.onDeleteItem,
    this.onEditItem,
    super.key,
  });

  static Key get keyItemTile => Key('$TaskEntryViewer/itemTile');
  static Key get keyItemActionCopy => Key('$TaskEntryViewer/itemActionCopy');
  static Key get keyItemActionGroupAdditional =>
      Key('$TaskEntryViewer/groupAdditional');
  static Key get keyItemActionDelete =>
      Key('$TaskEntryViewer/itemActionDelete');
  static Key get keyItemActionEdit => Key('$TaskEntryViewer/itemActionEdit');

  final String title;
  final String? subTitle;
  final List<TaskEntry> taskEntries;
  final bool hideHeader;
  final Locale locale;
  final bool showDate;
  final bool showSelectOption;
  final void Function()? onAddItem;
  final void Function(List<ItemRef<TaskEntry>> refs)? onCopy;
  final void Function()? onDelete;
  final void Function(ItemRef<TaskEntry> ref)? onDeleteItem;
  final void Function(ItemRef<TaskEntry> ref)? onEditItem;

  static Widget buildFromModels({
    required BuildContext context,
    required String title,
    required List<TaskEntry> taskEntries,
    String? subTitle,
    bool hideHeader = false,
    bool showDate = false,
    bool showSelectOption = false,
    void Function()? onAddItem,
    void Function(List<ItemRef<TaskEntry>> refs)? onCopy,
    void Function()? onDelete,
    void Function(ItemRef<TaskEntry> ref)? onDeleteItem,
    void Function(ItemRef<TaskEntry> ref)? onEditItem,
    Key? key,
  }) {
    final config = context.watch<ConfigModel>();

    return TaskEntryViewer(
      title: title,
      subTitle: subTitle,
      taskEntries: taskEntries,
      hideHeader: hideHeader,
      locale: config.getValue<Locale>(settingLanguage),
      showDate: showDate,
      showSelectOption: showSelectOption,
      onAddItem: onAddItem,
      onCopy: onCopy,
      onDelete: onDelete,
      onDeleteItem: onDeleteItem,
      onEditItem: onEditItem,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onAddItem = this.onAddItem;
    final onCopy = this.onCopy;
    final onDelete = this.onDelete;
    final onEditItem = this.onEditItem;
    final onDeleteItem = this.onDeleteItem;

    final languageCode = locale.languageCode;

    return ItemListViewer<TaskEntry>(
      items: taskEntries,
      getItemId: (item) => item.id!,
      title: title,
      subTitle: subTitle,
      headerColor: primaryFixedColorFrom(context),
      hideHeader: hideHeader,
      actions: [
        if (onAddItem != null)
          GlobalItemsAction(
            icon: IconUtils.add(context),
            label: context.texts.buttonAdd,
            onPressed: (_) => onAddItem(),
          ),
        if (onCopy != null)
          GlobalItemsAction(
            icon: IconUtils.copy(context),
            label: context.texts.buttonCopy,
            onPressed: onCopy,
          ),
        if (onDelete != null)
          GlobalItemsAction(
            icon: IconUtils.trashCan(context),
            label: context.texts.buttonDelete,
            onPressed: (_) => onDelete(),
          ),
        if (showSelectOption)
          GlobalItemsGroup(
            icon: IconUtils.check(context),
            label: context.texts.buttonSelection,
            items: [
              GlobalItemsAction(
                icon: IconUtils.squareCheck(context),
                label: context.texts.buttonSelectAll,
                onPressed: (refs) {
                  for (var element in refs) {
                    element.onSelect?.call(true);
                  }
                },
              ),
              GlobalItemsAction(
                icon: IconUtils.square(context),
                label: context.texts.buttonDeselectAll,
                onPressed: (refs) {
                  for (var element in refs) {
                    element.onSelect?.call(false);
                  }
                },
              ),
            ],
          ),
      ],
      tileBuilder: (context, ref, onTap) {
        final item = ref.item;

        return ItemTile(
          key: keyItemTile,
          ref: ref,
          subTitle: item.info,
          footNote:
              '${showDate ? '${CustomDateFormats.yMMdd(item.date, languageCode)} | ' : ''}'
              '${showDate ? '${languageCode == 'de' ? 'KW' : 'CW'} ${getWeekNumber(item.date)} | ' : ''}'
              '${context.texts.labelDuration(item.time().asHHMM)}',
          onTap: onTap,
          actions: [
            LocalItemAction(
              key: keyItemActionCopy,
              icon: IconUtils.copy(context),
              onPressed: (_) {
                Clipboard.setData(ClipboardData(text: item.info ?? ''));
              },
            ),
            LocalItemsGroup(
              key: keyItemActionGroupAdditional,
              icon: IconUtils.ellipsisVertical(context),
              items: [
                if (onEditItem != null)
                  LocalItemAction(
                    key: keyItemActionEdit,
                    icon: IconUtils.edit(context),
                    label: context.texts.buttonEdit,
                    onPressed: onEditItem,
                  ),
                if (showSelectOption)
                  LocalItemAction(
                    icon: ref.isSelected
                        ? IconUtils.square(context)
                        : IconUtils.squareCheck(context),
                    label: ref.isSelected
                        ? context.texts.buttonDeselect
                        : context.texts.buttonSelect,
                    onPressed: (ref) => ref.onSelect?.call(!ref.isSelected),
                  ),
                if (onDeleteItem != null)
                  LocalItemAction(
                    key: keyItemActionDelete,
                    icon: IconUtils.trashCan(context),
                    label: context.texts.buttonDelete,
                    onPressed: onDeleteItem,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
