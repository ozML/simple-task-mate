import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:simple_task_mate/extensions/date_time.dart';

class DateTimeModel extends ChangeNotifier {
  DateTimeModel() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTime(),
    );
  }

  late final Timer _timer;
  DateTime _dateTime = DateTime.now();
  DateTime? _selectedDate;

  DateTime get dateTime => _dateTime;
  DateTime get date => _dateTime.date;
  DateTime get selectedDate => _selectedDate ?? date;

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  void selectDate(DateTime date) {
    _selectedDate = date.date;
    notifyListeners();
  }

  void clearDateSelection() {
    _selectedDate = null;
    notifyListeners();
  }

  void _updateTime() {
    _dateTime = DateTime.now();
    notifyListeners();
  }
}
