import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/date_time_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/widgets/content_box.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';

class TaskEntryViewer extends StatelessWidget {
  const TaskEntryViewer({
    required this.title,
    required this.taskEntries,
    this.titleStyle = TitleStyle.header,
    this.locale = const Locale('en'),
    this.showDate = false,
    this.onDelete,
    this.onEdit,
    super.key,
  });

  static Key get keyItemTile => Key('$TaskEntryViewer/itemTile');
  static Key get keyItemActionCopy => Key('$TaskEntryViewer/itemActionCopy');
  static Key get keyItemActionDelete =>
      Key('$TaskEntryViewer/itemActionDelete');
  static Key get keyItemActionEdit => Key('$TaskEntryViewer/itemActionEdit');

  final String title;
  final List<TaskEntry> taskEntries;
  final TitleStyle titleStyle;
  final Locale locale;
  final bool showDate;
  final void Function(TaskEntry taskEntry)? onDelete;
  final void Function(TaskEntry taskEntry)? onEdit;

  static Widget buildFromModels({
    required BuildContext context,
    required String title,
    required List<TaskEntry> taskEntries,
    TitleStyle titleStyle = TitleStyle.header,
    final bool showDate = false,
    final void Function(TaskEntry taskEntry)? onDelete,
    final void Function(TaskEntry taskEntry)? onEdit,
    Key? key,
  }) {
    final config = context.watch<ConfigModel>();

    return TaskEntryViewer(
      title: title,
      taskEntries: taskEntries,
      titleStyle: titleStyle,
      locale: config.getValue<Locale>(settingLanguage),
      showDate: showDate,
      onDelete: onDelete,
      onEdit: onEdit,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onEdit = this.onEdit;
    final onDelete = this.onDelete;

    final languageCode = locale.languageCode;

    return ItemListViewer<TaskEntry>(
      items: taskEntries,
      title: title,
      titleStyle: titleStyle,
      tileBuilder: (context, item, onSelect) {
        return ItemTile(
          key: keyItemTile,
          item: item,
          subTitle: item.info,
          footNote:
              '${showDate ? '${CustomDateFormats.yMMdd(item.date, languageCode)} | ' : ''}'
              '${showDate ? '${languageCode == 'de' ? 'KW' : 'CW'} ${getWeekNumber(item.date)} | ' : ''}'
              '${context.texts.labelDuration(item.time().asHHMM)}',
          onSelect: onSelect,
          actions: [
            ItemTileAction(
              key: keyItemActionCopy,
              icon: IconUtils.copy(context),
              onPressed: (_) {
                Clipboard.setData(ClipboardData(text: item.info ?? ''));
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
