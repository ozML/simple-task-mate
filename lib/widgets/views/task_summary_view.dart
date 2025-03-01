import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/models/task_summary_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/dialog_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/viewers/task_entry_viewer.dart';
import 'package:simple_task_mate/widgets/viewers/task_summary_viewer.dart';
import 'package:simple_task_mate/widgets/task_edit_panel.dart';

class SelectedTaskBand extends StatelessWidget {
  const SelectedTaskBand({
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onBack,
    super.key,
  });

  final Task task;
  final void Function(Task task) onEdit;
  final void Function(Task task) onDelete;
  final void Function() onBack;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);

    final refId = task.refId;

    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 110),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(height: 1, color: primaryColor),
              ),
              if (refId != null)
                Text(
                  refId,
                  style: primaryTextStyleFrom(context, bold: true),
                  textAlign: TextAlign.center,
                ),
              Text(
                task.name,
                style: primaryTextStyleFrom(context),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(height: 1, color: primaryColor),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: IconUtils.arrowLeft(context),
                onPressed: onBack,
              ),
              IconButton(
                icon: IconUtils.trashCan(context),
                onPressed: () => onDelete(task),
              ),
              IconButton(
                icon: IconUtils.edit(context),
                onPressed: () => onEdit(task),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TaskSummaryView extends StatefulWidget {
  const TaskSummaryView({super.key});

  @override
  State<StatefulWidget> createState() => TaskSummaryViewState();
}

class TaskSummaryViewState extends State<TaskSummaryView> {
  String _searchText = '';
  bool _extendedSearch = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskSummaryModel>().clearTask();
      _refresh();
    });
  }

  Future<void> _refresh([bool? success]) async {
    if (success == null || success) {
      if (!mounted) {
        return;
      }
      final summaryModel = context.read<TaskSummaryModel>();

      await summaryModel.loadSummaries(
        searchText: _searchText,
        searchInEntryInfo: _extendedSearch,
      );

      final selectedTask = summaryModel.task;
      if (selectedTask != null) {
        await summaryModel.loadFilledTask(selectedTask.id ?? -1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void openEntryDialog({Task? task}) {
      bool? success;

      final dialogContent = EditTaskPanel.dialog(
        task: task,
        onApply: (value) async {
          final summaryModel = context.read<TaskSummaryModel>();

          if (task != null) {
            success = await summaryModel.updateTask(value);
          } else {
            success = (await summaryModel.addTask(value)).$1;
          }
        },
        onClose: () {
          Navigator.pop(context);
          _refresh(success);
        },
      );

      showDialog(context: context, builder: (context) => dialogContent);
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            color: primaryColorFrom(context),
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: IconButton(
                icon: IconUtils.arrowLeft(
                  context,
                  color: inversePrimaryColorFrom(context),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<TaskSummaryModel>(
                builder: (context, value, _) {
                  final task = value.task;

                  final Widget content;
                  if (task != null) {
                    content = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectedTaskBand(
                          task: task,
                          onEdit: (task) => openEntryDialog(task: task),
                          onDelete: (task) => confirmDeleteTask(
                            context: context,
                            task: task,
                            action: () async {
                              final summaryModel =
                                  context.read<TaskSummaryModel>();
                              final success =
                                  await summaryModel.deleteTask(task);

                              if (success) {
                                summaryModel.clearTask();
                                _refresh();
                              }
                            },
                          ),
                          onBack: () => value.clearTask(),
                        ),
                        Expanded(
                          child: TaskEntryViewer.buildFromModels(
                            context: context,
                            title: '',
                            hideHeader: true,
                            showDate: true,
                            taskEntries: task.entries ?? [],
                          ),
                        ),
                      ],
                    );
                  } else {
                    content = TaskSummaryViewer(
                      summaries: value.summaries,
                      hideHeader: true,
                      searchText: _searchText,
                      isExtendedSearchEnabled: _extendedSearch,
                      onAddItem: () => openEntryDialog(),
                      onTapItem: (summary, _) =>
                          value.loadFilledTask(summary.item.taskId),
                      onDeleteItem: (summary) => confirmDeleteTask(
                        context: context,
                        task: summary.item.toRef(),
                        action: () => context
                            .read<TaskSummaryModel>()
                            .deleteTask(summary.item.toRef())
                            .then(_refresh),
                      ),
                      onSearchTextChanged: (value) {
                        _searchText = value;
                        _refresh();
                      },
                      onSearchSettingChanged: (value) {
                        setState(() {
                          _extendedSearch = value;
                          _refresh();
                        });
                      },
                    );
                  }

                  return content;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
