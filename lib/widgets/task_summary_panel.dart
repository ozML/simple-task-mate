import 'package:flutter/material.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/page_navigation_utils.dart';
import 'package:simple_task_mate/widgets/viewers/task_entry_viewer.dart';
import 'package:simple_task_mate/widgets/views/task_summary_view.dart';

class TaskSummaryPanel extends StatelessWidget {
  const TaskSummaryPanel({
    required this.task,
    this.onEdit,
    this.onDelete,
    this.onClose,
    super.key,
  });

  final Task task;
  final void Function(Task task)? onEdit;
  final void Function(Task task)? onDelete;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SelectedTaskBand(
          task: task,
          onEdit: onEdit,
          onDelete: onDelete,
          onBack: onClose,
        ),
        Expanded(
          child: TaskEntryViewer.buildFromModels(
            context: context,
            title: '',
            hideHeader: true,
            showDate: true,
            taskEntries: task.entries ?? [],
            onInspectItem: (ref) {
              Navigator.of(context).pushAndRemoveUntil(
                taskViewForTaskAtDateRoute(
                  taskId: ref.item.taskId,
                  date: ref.item.date,
                ),
                (_) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}
