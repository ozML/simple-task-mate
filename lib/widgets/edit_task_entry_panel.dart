import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/extensions/object_extension.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/task_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/viewers/task_viewer.dart';
import 'package:simple_task_mate/widgets/time_input_field.dart';

class EditTaskEntryPanel extends StatefulWidget {
  const EditTaskEntryPanel({
    this.task,
    this.taskEntry,
    super.key,
  })  : isDialog = false,
        onClose = null;

  const EditTaskEntryPanel.dialog({
    this.task,
    this.taskEntry,
    this.onClose,
    super.key,
  }) : isDialog = true;

  final Task? task;
  final TaskEntry? taskEntry;
  final bool isDialog;

  final VoidCallback? onClose;

  @override
  State<EditTaskEntryPanel> createState() => EditTaskEntryPanelState();
}

class EditTaskEntryPanelState extends State<EditTaskEntryPanel> {
  late final _taskTitleController = TextEditingController();
  late final _taskRefIdController = TextEditingController();
  late final _taskInfoController = TextEditingController();
  late final _taskHRefController = TextEditingController();
  late final _entryInfoController = TextEditingController.fromValue(
    TextEditingValue(text: widget.taskEntry?.info ?? ''),
  );
  late final _timeController = TextEditingController.fromValue(
    TextEditingValue(text: widget.taskEntry?.time().asHHMM ?? ''),
  );

  bool _addNewTask = false;
  Task? _selectedTask;

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final selectedTask = _selectedTask;
    final taskEntry = widget.taskEntry;

    void clearControllers() {
      _taskTitleController.clear();
      _taskRefIdController.clear();
      _taskInfoController.clear();
      _taskHRefController.clear();
      _entryInfoController.clear();
      _timeController.clear();
    }

    final isCreateDialog = task == null && taskEntry == null;

    final Widget details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_addNewTask) ...[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _taskRefIdController,
                  decoration: textInputDecoration(
                    context,
                    labelText: context.texts.labelTaskRefId,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _taskTitleController,
                  decoration: textInputDecoration(
                    context,
                    labelText: context.texts.labelTaskTitle,
                    suffixLabelText: '*',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _taskHRefController,
            decoration: textInputDecoration(
              context,
              labelText: context.texts.labelTaskHRef,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _taskInfoController,
            minLines: 3,
            maxLines: null,
            decoration: textInputDecoration(
              context,
              labelText: context.texts.labelTaskInfo,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(indent: 10, endIndent: 10, height: 0.5),
          ),
        ] else if (isCreateDialog) ...[
          Center(
            child: Text(
              context.texts.labelSelectedTask,
              style: secondaryTextStyleFrom(context),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              selectedTask?.fullName() ?? '',
              style: primaryTextStyleFrom(context),
            ),
          ),
          const SizedBox(height: 20),
        ],
        TextField(
          controller: _entryInfoController,
          minLines: 3,
          maxLines: null,
          decoration: textInputDecoration(
            context,
            labelText: context.texts.labelTaskEntryInfo,
          ),
        ),
        const SizedBox(height: 15),
        TimeInputField(
          controller: _timeController,
          decoration: textInputDecoration(
            context,
            labelText: context.texts.labelTaskEntryDuration,
            suffixLabelText: '*',
          ),
        ),
      ],
    );

    final content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            context.texts.labelAddEntry,
            style: primaryTextStyleFrom(context, bold: true),
          ),
          const SizedBox(height: 20),
          if (isCreateDialog && _selectedTask == null) ...[
            CheckboxListTile(
              title: Text(context.texts.labelNewTask),
              value: _addNewTask,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _addNewTask = value;
                    clearControllers();
                  });
                }
              },
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: isCreateDialog && !_addNewTask && _selectedTask == null
                ? TaskViewer.buildFromModels(
                    context: context,
                    hideHeader: true,
                    searchText: searchText,
                    hideDurations: true,
                    hideCopyButton: true,
                    onTapItem: (task, _) {
                      setState(() => _selectedTask = task.item);
                    },
                    onSearchTextChanged: (value) {
                      searchText = value;
                      context.read<TaskModel>().loadTasks(searchText: value);
                    },
                  )
                : details,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: _selectedTask == null
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (isCreateDialog && _selectedTask != null)
                  TextButton(
                    child: Text(context.texts.buttonBack),
                    onPressed: () {
                      setState(() {
                        _selectedTask = null;
                        clearControllers();
                      });
                    },
                  ),
                FilledButton.icon(
                  label: Text(
                    taskEntry == null
                        ? context.texts.buttonAdd
                        : context.texts.buttonSave,
                  ),
                  onPressed: () async {
                    final taskModel = context.read<TaskModel>();
                    final date = context.read<DateTimeModel>().selectedDate;

                    final time = _timeController.text.mapTo((e) {
                      final regex = RegExp(r'^\d{2}:\d{2}$');
                      if (regex.hasMatch(e)) {
                        final parts = e.split(':');

                        return Duration(
                          hours: parts[0].mapTo(int.parse),
                          minutes: parts[1].mapTo(int.parse),
                        );
                      }

                      return null;
                    });
                    if (time == null) {
                      return;
                    }

                    final infoText = _entryInfoController.text
                        .mapTo((e) => e.isNotEmpty ? e : null);

                    if (taskEntry == null) {
                      final int taskId;
                      if (task == null) {
                        if (_addNewTask) {
                          final title = _taskTitleController.text;
                          if (title.isEmpty) {
                            return;
                          }

                          final refId = _taskRefIdController.text
                              .mapTo((e) => e.isNotEmpty ? e : null);
                          final info = _taskInfoController.text
                              .mapTo((e) => e.isNotEmpty ? e : null);
                          final hRef = _taskHRefController.text
                              .mapTo((e) => e.isNotEmpty ? e : null);

                          final result = await taskModel.addTask(
                            Task(
                              name: title,
                              refId: refId,
                              info: info,
                              hRef: hRef,
                            ),
                          );

                          if (!result.$1) {
                            return;
                          }

                          taskId = result.$2;
                        } else {
                          final selectedTaskId = selectedTask?.id;
                          if (selectedTaskId == null) {
                            return;
                          }

                          taskId = selectedTaskId;
                        }
                      } else {
                        final givenTaskId = task.id;
                        if (givenTaskId == null) {
                          return;
                        }

                        taskId = givenTaskId;
                      }

                      await taskModel.addTaskEntry(
                        TaskEntry(
                          taskId: taskId,
                          info: infoText,
                          date: date,
                          duration: time,
                        ),
                      );
                    } else {
                      await taskModel.updateTaskEntry(
                        taskEntry.copyWith(info: infoText, duration: time),
                      );
                    }

                    if (widget.isDialog) {
                      widget.onClose?.call();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );

    return widget.isDialog
        ? Dialog(
            child: SizedBox(
              width: 900,
              height: isCreateDialog ? 650 : 350,
              child: Stack(
                children: [
                  Padding(padding: const EdgeInsets.all(10), child: content),
                  Container(
                    margin: const EdgeInsets.only(top: 7.5, right: 7.5),
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: IconUtils.close(context),
                      onPressed: widget.onClose,
                    ),
                  ),
                ],
              ),
            ),
          )
        : content;
  }
}
