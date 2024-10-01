import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/task_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class EditTaskPanel extends StatefulWidget {
  const EditTaskPanel({
    required this.onApply,
    this.task,
    super.key,
  })  : isDialog = false,
        onClose = null;

  const EditTaskPanel.dialog({
    required this.onApply,
    this.task,
    this.onClose,
    super.key,
  }) : isDialog = true;

  final Task? task;
  final bool isDialog;

  final Future<void> Function(Task value) onApply;
  final VoidCallback? onClose;

  @override
  State<EditTaskPanel> createState() => EditTaskPanelState();
}

class EditTaskPanelState extends State<EditTaskPanel> {
  late final _taskRefIdController = TextEditingController.fromValue(
    TextEditingValue(text: widget.task?.refId ?? ''),
  );
  late final _taskTitleController = TextEditingController.fromValue(
    TextEditingValue(text: widget.task?.name ?? ''),
  );
  late final _taskInfoController = TextEditingController.fromValue(
    TextEditingValue(text: widget.task?.info ?? ''),
  );

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    final Widget details = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            task != null
                ? context.texts.labelEditEntry
                : context.texts.labelAddEntry,
            style: primaryTextStyleFrom(context, bold: true),
          ),
        ),
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
                ),
              ),
            ),
          ],
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
      ],
    );

    final content = Consumer<TaskModel>(builder: (context, model, _) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: details),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: FilledButton.icon(
                    label: Text(
                      task == null
                          ? context.texts.buttonAdd
                          : context.texts.buttonSave,
                    ),
                    onPressed: () async {
                      final refId = _taskRefIdController.text;
                      final title = _taskTitleController.text;
                      final info = _taskInfoController.text;
                      if (title.isEmpty) {
                        return;
                      }

                      final result = task?.copyWith(
                            refId: refId,
                            name: title,
                            info: info,
                          ) ??
                          Task(refId: refId, name: title, info: info);

                      await widget.onApply(result);

                      if (widget.isDialog) {
                        widget.onClose?.call();
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });

    return widget.isDialog
        ? Dialog(
            child: SizedBox(
              width: 900,
              height: 350,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: content,
                  ),
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
