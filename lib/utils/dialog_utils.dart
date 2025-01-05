import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/object_extension.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

Future<bool> confirmedAction({
  required BuildContext context,
  required String titleText,
  required VoidCallback action,
  String? infoText,
  String? confirmText,
  String? cancelText,
}) async {
  assert(confirmText != null || cancelText != null);

  final result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(titleText, style: primaryTextStyleFrom(context)),
        content: infoText != null
            ? Text(infoText, style: secondaryTextStyleFrom(context))
            : null,
        actions: [
          if (cancelText != null)
            TextButton(
              child: Text(cancelText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          if (confirmText != null)
            FilledButton(
              child: Text(confirmText),
              onPressed: () => Navigator.of(context).pop(true),
            ),
        ],
        actionsAlignment: MainAxisAlignment.end,
      );
    },
  );

  if (result) {
    action.call();
  }

  return result;
}

Future<bool> confirmDeleteStamp({
  required BuildContext context,
  required Stamp stamp,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleStampDelete,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: () {
        final type = switch (stamp.type) {
          StampType.arrival => context.texts.labelArrive,
          StampType.departure => context.texts.labelLeave,
          _ => '?',
        };
        final time = DateFormat('HH:mm').format(stamp.time);

        return context.texts.dialogInfoStampDelete(type, time);
      }(),
      action: action,
    );

Future<bool> confirmDeleteSelectedStamps({
  required BuildContext context,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleStampDeleteSelected,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoStampDeleteSelected,
      action: action,
    );

Future<bool> confirmChangeStampType({
  required BuildContext context,
  required Stamp stamp,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleStampChangeType,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: () {
        final type = switch (stamp.type) {
          StampType.arrival => context.texts.labelArrive,
          StampType.departure => context.texts.labelLeave,
          _ => '?',
        };
        final targetType = switch (stamp.type) {
          StampType.arrival => context.texts.labelLeave,
          StampType.departure => context.texts.labelArrive,
          _ => '?',
        };
        final time = DateFormat('HH:mm').format(stamp.time);

        return context.texts.dialogInfoStampChangeType(type, time, targetType);
      }(),
      action: action,
    );

Future<bool> confirmMoveSelectedStampsToDate({
  required BuildContext context,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleStampMoveToDateSelected,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoStampMoveToDateSelected,
      action: action,
    );

Future<bool> confirmDeleteTask({
  required BuildContext context,
  required Task task,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleTaskDelete,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoTaskDelete(task.fullName()),
      action: action,
    );

Future<bool> confirmDeleteTaskEntry({
  required BuildContext context,
  required TaskEntry taskEntry,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleTaskEntryDelete,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: () {
        final infoPart = taskEntry.info?.mapTo(
          (e) => e.length <= 60 ? e : '${e.substring(0, 60)}...',
        );

        return context.texts.dialogInfoTaskEntryDelete(infoPart ?? '');
      }(),
      action: action,
    );

Future<bool> confirmDeleteSelectedTaskEntries({
  required BuildContext context,
  required Task task,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleTaskEntryDeleteSelected,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoTaskEntryDeleteSelected(
        task.fullName(),
      ),
      action: action,
    );

Future<bool> confirmMoveSelectedTaskEntriesToDate({
  required BuildContext context,
  required Task task,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleTaskEntryMoveToDateSelected,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoTaskEntryMoveToDateSelected(
        task.fullName(),
      ),
      action: action,
    );

Future<bool> confirmMoveSelectedTaskEntriesToTask({
  required BuildContext context,
  required Task task,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleTaskEntryMoveToTaskSelected,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoTaskEntryMoveToTaskSelected(
        task.fullName(),
      ),
      action: action,
    );

Future<bool> confirmConfigChangeRestart({
  required BuildContext context,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleRestart,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoRestart,
      action: action,
    );

Future<bool> confirmConfigReset({
  required BuildContext context,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleResetSettings,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      infoText: context.texts.dialogInfoRestart,
      action: action,
    );

Future<bool> confirmJumpToDate({
  required BuildContext context,
  required VoidCallback action,
}) =>
    confirmedAction(
      context: context,
      titleText: context.texts.dialogTitleJumpToDate,
      confirmText: context.texts.buttonOk,
      cancelText: context.texts.buttonCancel,
      action: action,
    );
