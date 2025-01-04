import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:simple_task_mate/database/stamp_contract.dart';
import 'package:simple_task_mate/database/stamp_data_base_helper.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/data_base_utils.dart';

class StampModel extends ChangeNotifier {
  List<Stamp> _stamps = [];
  bool _isLoading = false;

  List<Stamp> get stamps => UnmodifiableListView(_stamps);
  bool get isLoading => _isLoading;

  Future<void> loadStampsForDate(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    _stamps = await StampDataBaseHelper.instance.loadStampsForDate(
      date,
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

  Future<(bool, int)> addStamp(Stamp stamp) async {
    final id = await StampDataBaseHelper.instance.insertStamp(stamp);

    return (id > 0, id);
  }

  Future<bool> updateStamp(Stamp stamp) async {
    final success = await StampDataBaseHelper.instance.updateStamp(stamp) > 0;

    return success;
  }

  Future<bool> updateStamps(List<Stamp> stamps) async {
    final success = await StampDataBaseHelper.instance.updateStamps(stamps) > 0;

    return success;
  }

  Future<bool> deleteStamp(Stamp stamp) async {
    final success = await StampDataBaseHelper.instance.deleteStamp(stamp) > 0;

    return success;
  }

  Future<bool> deleteStamps(List<Stamp> stamps) async {
    final success = await StampDataBaseHelper.instance.deleteStamps(stamps) > 0;

    return success;
  }
}
