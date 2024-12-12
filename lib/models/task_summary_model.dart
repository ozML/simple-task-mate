import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:simple_task_mate/database/task_data_base_helper.dart';
import 'package:simple_task_mate/services/api.dart';

class TaskSummaryModel extends ChangeNotifier {
  List<TaskSummary> _summaries = [];
  Task? _task;
  bool _isLoading = false;

  List<TaskSummary> get summaries => UnmodifiableListView(_summaries);
  Task? get task => _task;
  bool get isLoading => _isLoading;

  Future<(bool, int)> addTask(Task task) async {
    final id = await TaskDataBaseHelper.instance.insertTask(task);

    return (id > 0, id);
  }

  Future<bool> updateTask(Task task) async {
    final success = await TaskDataBaseHelper.instance.updateTask(task) > 0;

    return success;
  }

  Future<bool> deleteTask(Task task) async {
    final success = await TaskDataBaseHelper.instance.deleteTask(task) > 0;

    return success;
  }

  Future<void> loadSummaries({
    String? searchText,
    bool searchInEntryInfo = false,
  }) async {
    _isLoading = true;
    notifyListeners();

    _summaries = await TaskDataBaseHelper.instance.loadSummaries(
      searchText: searchText,
      searchInEntryInfo: searchInEntryInfo,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFilledTask(int taskId) async {
    _isLoading = true;
    notifyListeners();

    _task = await TaskDataBaseHelper.instance.loadFilledTask(
      taskId: taskId,
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearTask() {
    _task = null;
    notifyListeners();
  }
}
