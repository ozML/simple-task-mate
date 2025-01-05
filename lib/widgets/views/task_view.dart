import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/stamp_model.dart';
import 'package:simple_task_mate/models/task_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/dialog_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/page_navigation_utils.dart';
import 'package:simple_task_mate/utils/string_utils.dart';
import 'package:simple_task_mate/utils/time_summary_utils.dart';
import 'package:simple_task_mate/widgets/date_selector.dart';
import 'package:simple_task_mate/widgets/edit_task_entry_panel.dart';
import 'package:simple_task_mate/widgets/page_scaffold.dart';
import 'package:simple_task_mate/widgets/task_entry_viewer.dart';
import 'package:simple_task_mate/widgets/task_selector.dart';
import 'package:simple_task_mate/widgets/title_bands.dart';
import 'package:simple_task_mate/widgets/time_ticker.dart';
import 'package:simple_task_mate/widgets/task_viewer.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<StatefulWidget> createState() => TaskViewState();
}

class TaskViewState extends State<TaskView> {
  Task? _selectedTask;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh([bool? success]) async {
    if (success == null || success) {
      if (!mounted) {
        return;
      }
      final date = context.read<DateTimeModel>().selectedDate;
      final taskModel = context.read<TaskModel>();
      final stampModel = context.read<StampModel>();

      await taskModel.loadFilledTasksForDate(date);
      await stampModel.loadStampsForDate(date);

      final selectedTask = _selectedTask;
      if (selectedTask != null) {
        setState(() {
          _selectedTask = taskModel.tasks.firstWhereOrNull(
            (element) => element.id == _selectedTask?.id,
          );
        });
      }
    }
  }

  void _copyTaskInfos({bool fullCopy = false}) {
    String result = '';

    final tasks = context.read<TaskModel>().tasks;
    for (final task in tasks) {
      if (result.isNotEmpty) {
        result += '\n\n';
      }

      result += task.fullName();

      if (fullCopy) {
        final entries = task.entries ?? [];
        for (final entry in entries) {
          if (entry.info case String info) {
            result += '\n\t> $info';
          }
        }
      }
    }

    Clipboard.setData(ClipboardData(text: result));
  }

  void _copyEntryInfos({List<TaskEntry> entries = const []}) {
    final targetIds = entries.map((e) => e.id);

    var selectedTaskEntries = _selectedTask?.entries;
    if (selectedTaskEntries != null) {
      if (targetIds.isNotEmpty) {
        selectedTaskEntries = selectedTaskEntries
            .where((element) => targetIds.contains(element.id))
            .toList();
      }

      if (selectedTaskEntries.isEmpty) {
        return;
      }

      Clipboard.setData(
        ClipboardData(
          text: selectedTaskEntries
              .where((element) => element.info?.isNotEmpty == true)
              .map((e) => e.info ?? '')
              .join(', '),
        ),
      );
    }
  }

  void _clearSelectedTask() {
    setState(() => _selectedTask = null);
  }

  @override
  Widget build(BuildContext context) {
    void openEntryDialog({
      Task? task,
      TaskEntry? taskEntry,
    }) {
      final dialogContent = MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: context.read<DateTimeModel>(),
          ),
          ChangeNotifierProvider(
            create: (context) => TaskModel()..loadTasks(),
            lazy: false,
          ),
        ],
        builder: (context, _) {
          return EditTaskEntryPanel.dialog(
            task: task,
            taskEntry: taskEntry,
            onClose: () {
              Navigator.pop(context);
              _refresh();
            },
          );
        },
      );

      showDialog(context: context, builder: (context) => dialogContent);
    }

    final selectedTask = _selectedTask;

    final header = Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: IconUtils.table(context),
            onPressed: () {
              Navigator.of(context).push(taskSummaryViewRoute);
            },
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: IconUtils.circleQuestion(context),
            onPressed: () => PackageInfo.fromPlatform().then(
              (value) {
                if (context.mounted) {
                  showAboutDialog(
                    context: context,
                    applicationVersion: value.version,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    var content = Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: DateSelector.buildFromModels(
                  context: context,
                  onUpdate: () {
                    _clearSelectedTask();
                    _refresh();
                  },
                ),
              ),
            ),
            Expanded(
              child:
                  Center(child: TimeTicker.buildFromModels(context: context)),
            ),
            Expanded(child: Container()),
          ],
        ),
        Consumer2<TaskModel, StampModel>(
          builder: (context, value1, value2, _) => BookedTimeSummaryBand(
            workTime: getWorkTime(value2.stamps),
            tasks: value1.tasks,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final alignVertical = constraints.maxWidth < 960;

                final showGlobalTaskActions = context.select<TaskModel, bool>(
                  (value) => value.tasks.isNotEmpty,
                );

                return Flex(
                  direction: alignVertical ? Axis.vertical : Axis.horizontal,
                  children: [
                    Expanded(
                      child: TaskViewer.buildFromModels(
                        context: context,
                        onAddItem: openEntryDialog,
                        onCopy: showGlobalTaskActions ? _copyTaskInfos : null,
                        onCopyAll: showGlobalTaskActions
                            ? () => _copyTaskInfos(fullCopy: true)
                            : null,
                        onTapItem: (task) {
                          setState(() => _selectedTask = task.item);
                        },
                      ),
                    ),
                    if (selectedTask != null)
                      const SizedBox.square(dimension: 15),
                    if (selectedTask != null)
                      Expanded(
                        child: Stack(
                          children: [
                            TaskEntryViewer.buildFromModels(
                              context: context,
                              title: context.texts.labelEntries,
                              subTitle: StringUtils.join(
                                  [selectedTask.refId, selectedTask.name],
                                  separator: ' - '),
                              taskEntries: selectedTask.entries ?? [],
                              showSelectOption: true,
                              onAddItem: () =>
                                  openEntryDialog(task: selectedTask),
                              onCopy: (refs) => _copyEntryInfos(
                                entries: refs.map((e) => e.item).toList(),
                              ),
                              onDelete: (refs) {
                                final selection =
                                    refs.map((e) => e.item).toList();

                                confirmDeleteSelectedTaskEntries(
                                  context: context,
                                  task: selectedTask,
                                  action: () => context
                                      .read<TaskModel>()
                                      .deleteTaskEntries(selection)
                                      .then(_refresh),
                                );
                              },
                              onChangeDate: (refs) async {
                                final dateModel = context.read<DateTimeModel>();

                                final date = dateModel.date;
                                final sourceDate = dateModel.selectedDate;

                                final targetDate = await showDatePicker(
                                  context: context,
                                  currentDate: sourceDate,
                                  firstDate: DateTime(1900),
                                  lastDate: date.add(
                                    const Duration(days: 365 * 5),
                                  ),
                                );

                                if (targetDate == null ||
                                    targetDate == sourceDate) {
                                  return;
                                }

                                final selection =
                                    refs.map((e) => e.item).toList();

                                final List<TaskEntry> entryUpdates = selection
                                    .map((e) => e.changeDateTo(targetDate))
                                    .toList();

                                if (!context.mounted) {
                                  return;
                                }

                                final confirmed =
                                    await confirmMoveSelectedTaskEntriesToDate(
                                  context: context,
                                  task: selectedTask,
                                  action: () => context
                                      .read<TaskModel>()
                                      .updateTaskEntries(entryUpdates)
                                      .then(_refresh),
                                );
                                if (!confirmed) {
                                  return;
                                }
                                if (!context.mounted) {
                                  return;
                                }

                                confirmJumpToDate(
                                  context: context,
                                  action: () {
                                    dateModel.selectDate(targetDate);
                                    _refresh();
                                  },
                                );
                              },
                              onChangeTask: (refs) async {
                                final targetTask =
                                    await TaskSelector.openDialog(context);

                                final sourceTaskId = refs.first.item.taskId;
                                if (targetTask == null ||
                                    targetTask.id == sourceTaskId) {
                                  return;
                                }

                                final selection =
                                    refs.map((e) => e.item).toList();

                                final List<TaskEntry> entryUpdates = selection
                                    .map((e) =>
                                        e.copyWith(taskId: targetTask.id))
                                    .toList();

                                if (!context.mounted) {
                                  return;
                                }

                                await confirmMoveSelectedTaskEntriesToTask(
                                  context: context,
                                  task: selectedTask,
                                  action: () => context
                                      .read<TaskModel>()
                                      .updateTaskEntries(entryUpdates)
                                      .then(_refresh),
                                );
                              },
                              onEditItem: (taskEntry) =>
                                  openEntryDialog(taskEntry: taskEntry.item),
                              onDeleteItem: (taskEntry) =>
                                  confirmDeleteTaskEntry(
                                context: context,
                                taskEntry: taskEntry.item,
                                action: () => context
                                    .read<TaskModel>()
                                    .deleteTaskEntry(taskEntry.item)
                                    .then(_refresh),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: const EdgeInsets.only(
                                top: 5,
                                right: 5,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: IconUtils.close(context),
                                    onPressed: _clearSelectedTask,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: PageScaffold(
        selectedPageIndex: 1,
        child: Stack(
          children: [content, header],
        ),
      ),
    );
  }
}
