import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:simple_task_mate/database/stamp_contract.dart';
import 'package:simple_task_mate/database/stamp_data_base_helper.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/data_base_utils.dart';
import 'package:simple_task_mate/utils/date_time_utils.dart';

class StampSummaryModel extends ChangeNotifier {
  List<StampSummary> _summaries = [];
  bool _isLoading = false;

  List<StampSummary> get summaries => UnmodifiableListView(_summaries);
  bool get isLoading => _isLoading;

  Future<void> loadSummariesForWeek(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    final weekDates = getWeekDates(date);

    _summaries = await StampDataBaseHelper.instance.loadSummaries(
      start: weekDates.first,
      end: weekDates.last.add(const Duration(days: 1)),
      orderBy: OrderBy(
        columnOrders: [
          ColumnOrder.asc(StampContract.columnTime),
          ColumnOrder.asc(StampContract.columnId),
        ],
      ),
    );

    _isLoading = false;
    notifyListeners();
  }
}
