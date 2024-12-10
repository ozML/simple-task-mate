import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/task_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/widgets/task_viewer.dart';

class TaskSelector extends StatefulWidget {
  const TaskSelector({this.onClose, super.key}) : isDialog = false;

  const TaskSelector._dialog({this.onClose}) : isDialog = true;

  final bool isDialog;
  final void Function(Task? task)? onClose;

  static Future<Task?> openDialog(BuildContext context) {
    final dialogContent = ChangeNotifierProvider(
      create: (_) => TaskModel()..loadTasks(),
      lazy: false,
      builder: (context, _) {
        return TaskSelector._dialog(
          onClose: (Task? task) => Navigator.pop(context, task),
        );
      },
    );

    return showDialog(context: context, builder: (context) => dialogContent);
  }

  @override
  State<TaskSelector> createState() => TaskSelectorState();
}

class TaskSelectorState extends State<TaskSelector> {
  Task? _selectedTask;

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final selectedTask = _selectedTask;

    final content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: TaskViewer.buildFromModels(
              highlightedTasks: [if (selectedTask != null) selectedTask],
              context: context,
              hideHeader: true,
              hideDurations: true,
              hideCopyButton: true,
              onTapItem: (ref) {
                setState(() => _selectedTask = ref.item);
              },
              onSearchTextChanged: (value) {
                context.read<TaskModel>().loadTasks(searchText: value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(context.texts.buttonCancel),
                  onPressed: () => widget.onClose?.call(null),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  label: Text(context.texts.buttonOk),
                  onPressed: () => widget.onClose?.call(selectedTask),
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
              height: 650,
              child: Padding(padding: const EdgeInsets.all(10), child: content),
            ),
          )
        : content;
  }
}
