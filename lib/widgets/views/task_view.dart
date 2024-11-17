import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/stamp_model.dart';
import 'package:simple_task_mate/models/task_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/dialog_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/page_navigation_utils.dart';
import 'package:simple_task_mate/utils/time_summary_utils.dart';
import 'package:simple_task_mate/widgets/content_box.dart';
import 'package:simple_task_mate/widgets/date_selector.dart';
import 'package:simple_task_mate/widgets/edit_task_entry_panel.dart';
import 'package:simple_task_mate/widgets/page_scaffold.dart';
import 'package:simple_task_mate/widgets/task_entry_viewer.dart';
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

  void _copyEntryInfos() {
    final selectedTaskEntries = _selectedTask?.entries;
    if (selectedTaskEntries != null) {
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
            child: Consumer<TaskModel>(builder: (context, value, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Flex(
                    direction: constraints.maxWidth >= 960
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            TaskViewer(
                              tasks: value.tasks,
                              onSelect: (task) {
                                setState(() => _selectedTask = task);
                              },
                              onDelete: (task) => confirmDeleteTaskEntries(
                                context: context,
                                task: task,
                                action: () => value
                                    .deleteTaskEntriesForDate(
                                      task,
                                      context
                                          .read<DateTimeModel>()
                                          .selectedDate,
                                    )
                                    .then(_refresh),
                              ),
                              onAdd: (task) => openEntryDialog(task: task),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 2, right: 5),
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: IconUtils.copyAll(context),
                                    onPressed: () => _copyTaskInfos(
                                      fullCopy: true,
                                    ),
                                  ),
                                  IconButton(
                                    icon: IconUtils.copy(context),
                                    onPressed: _copyTaskInfos,
                                  ),
                                  IconButton(
                                    icon: IconUtils.add(context),
                                    onPressed: openEntryDialog,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (selectedTask != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 15,
                              right: 15,
                            ),
                            child: Stack(
                              children: [
                                TaskEntryViewer.buildFromModels(
                                  context: context,
                                  title:
                                      selectedTask.refId ?? selectedTask.name,
                                  taskEntries: selectedTask.entries ?? [],
                                  titleStyle: TitleStyle.floating,
                                  onEdit: (taskEntry) =>
                                      openEntryDialog(taskEntry: taskEntry),
                                  onDelete: (taskEntry) =>
                                      confirmDeleteTaskEntry(
                                    context: context,
                                    taskEntry: taskEntry,
                                    action: () => value
                                        .deleteTaskEntry(taskEntry)
                                        .then(_refresh),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: IconUtils.copy(context),
                                        onPressed: _copyEntryInfos,
                                      ),
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
                          ),
                        )
                    ],
                  );
                },
              );
            }),
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
