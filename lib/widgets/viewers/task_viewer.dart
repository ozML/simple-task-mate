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
import 'package:simple_task_mate/widgets/viewers/item_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskViewer extends StatelessWidget {
  const TaskViewer({
    required this.tasks,
    this.highlightedTasks = const [],
    this.hideHeader = false,
    this.searchText,
    this.hideCopyButton = false,
    this.hideDurations = false,
    this.autoLinkGroups,
    this.onAddItem,
    this.onCopy,
    this.onCopyAll,
    this.onTapItem,
    this.onDeleteItem,
    this.onAddItemEntry,
    this.onInspectItem,
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
  final List<Task> highlightedTasks;
  final bool hideHeader;
  final String? searchText;
  final bool hideCopyButton;
  final bool hideDurations;
  final List<Tuple<String, String>>? autoLinkGroups;
  final void Function()? onAddItem;
  final void Function()? onCopy;
  final void Function()? onCopyAll;
  final void Function(ItemRef<Task> ref, TapInfo info)? onTapItem;
  final void Function(ItemRef<Task> ref)? onDeleteItem;
  final void Function(ItemRef<Task> ref)? onAddItemEntry;
  final void Function(ItemRef<Task> ref)? onInspectItem;
  final void Function(String value)? onSearchTextChanged;

  static Widget buildFromModels({
    required BuildContext context,
    List<Task> highlightedTasks = const [],
    bool hideHeader = false,
    String? searchText,
    bool hideCopyButton = false,
    bool hideDurations = false,
    List<Tuple<String, String>>? autoLinkGroups,
    void Function()? onAddItem,
    void Function()? onCopy,
    void Function()? onCopyAll,
    void Function(ItemRef<Task> ref, TapInfo info)? onTapItem,
    void Function(ItemRef<Task> ref)? onDeleteItem,
    void Function(ItemRef<Task> ref)? onAddItemEntry,
    void Function(ItemRef<Task> ref)? onInspectItem,
    void Function(String value)? onSearchTextChanged,
  }) {
    final config = context.watch<ConfigModel>();
    final autoLinksEnabled = config.getValue<bool>(settingAutoLinks);

    final tasks = context.watch<TaskModel>().tasks;

    return TaskViewer(
      tasks: tasks,
      highlightedTasks: highlightedTasks,
      hideHeader: hideHeader,
      searchText: searchText,
      hideCopyButton: hideCopyButton,
      hideDurations: hideDurations,
      autoLinkGroups: autoLinksEnabled
          ? config.getValue<List<Tuple<String, String>>>(settingAutoLinkGroups)
          : null,
      onAddItem: onAddItem,
      onCopy: onCopy,
      onCopyAll: onCopyAll,
      onTapItem: onTapItem,
      onDeleteItem: onDeleteItem,
      onAddItemEntry: onAddItemEntry,
      onInspectItem: onInspectItem,
      onSearchTextChanged: onSearchTextChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onAddItem = this.onAddItem;
    final onCopy = this.onCopy;
    final onCopyAll = this.onCopyAll;
    final onDeleteItem = this.onDeleteItem;
    final onAddItemEntry = this.onAddItemEntry;
    final onInspectItem = this.onInspectItem;

    final autoLinkGroups = this.autoLinkGroups;

    return ItemListViewer<Task>(
      items: tasks,
      getItemId: (item) => item.id!,
      title: context.texts.labelTasks,
      hideHeader: hideHeader,
      searchText: searchText,
      showSearchField: onSearchTextChanged != null,
      searchFieldHintText: context.texts.labelSearchPlaceholderTaskEntry,
      onTapItem: onTapItem,
      onSearchTextChanged: onSearchTextChanged,
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
            onPressed: (_) => onCopy(),
          ),
        if (onCopyAll != null)
          GlobalItemsAction(
            icon: IconUtils.copyAll(context),
            label: context.texts.buttonCopyAll,
            onPressed: (_) => onCopyAll(),
          ),
      ],
      tileBuilder: (context, ref, onTap) {
        final item = ref.item;

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

        final isHighlighted =
            highlightedTasks.any((element) => element.id == item.id);

        return ItemTile(
          key: keyItemTile,
          ref: ref,
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
          isHighlighted: isHighlighted,
          onTap: onTap,
          actions: [
            if (!hideCopyButton)
              LocalItemAction(
                key: keyItemActionCopy,
                icon: IconUtils.copy(context),
                onPressed: (_) {
                  Clipboard.setData(ClipboardData(text: item.fullName()));
                },
              ),
            if (onInspectItem != null)
              LocalItemAction(
                key: keyItemActionDelete,
                icon: IconUtils.magnifier(context),
                onPressed: onInspectItem,
              ),
            if (onDeleteItem != null)
              LocalItemAction(
                key: keyItemActionDelete,
                icon: IconUtils.trashCan(context),
                onPressed: onDeleteItem,
              ),
            if (onAddItemEntry != null)
              LocalItemAction(
                key: keyItemActionAdd,
                icon: IconUtils.add(context),
                onPressed: onAddItemEntry,
              ),
          ],
        );
      },
    );
  }
}
