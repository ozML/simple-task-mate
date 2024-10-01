import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:simple_task_mate/database/task_data_base_helper.dart';
import 'package:simple_task_mate/services/api.dart';

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => UnmodifiableListView(_tasks);
  bool get isLoading => _isLoading;

  Future<void> loadFilledTask(int taskId) async {
    _isLoading = true;
    notifyListeners();

    final task = await TaskDataBaseHelper.instance.loadFilledTask(
      taskId: taskId,
    );

    _tasks = [if (task != null) task];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTasks({String? searchText}) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await TaskDataBaseHelper.instance.loadTasks(
      searchText: searchText,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFilledTasksForDate(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await TaskDataBaseHelper.instance.loadFilledTasksForDate(date);

    _isLoading = false;
    notifyListeners();
  }

  Future<(bool, int)> addTask(Task task) async {
    final id = await TaskDataBaseHelper.instance.insertTask(task);

    return (id > 0, id);
  }

  Future<(bool, int)> addTaskEntry(TaskEntry taskEntry) async {
    final id = await TaskDataBaseHelper.instance.insertTaskEntry(taskEntry);

    return (id > 0, id);
  }

  Future<bool> updateTaskEntry(TaskEntry taskEntry) async {
    final success =
        await TaskDataBaseHelper.instance.updateTaskEntry(taskEntry) > 0;

    return success;
  }

  Future<bool> deleteTaskEntry(TaskEntry taskEntry) async {
    final success =
        await TaskDataBaseHelper.instance.deleteTaskEntry(taskEntry) > 0;

    return success;
  }

  Future<bool> deleteTaskEntriesForDate(Task task, DateTime date) async {
    final success = await TaskDataBaseHelper.instance.deleteTaskEntriesForDate(
          task,
          date,
        ) >
        0;

    return success;
  }
}
