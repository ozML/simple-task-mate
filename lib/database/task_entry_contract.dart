import 'package:simple_task_mate/database/data_base_contract.dart';

class TaskEntryContract implements IDataBaseContract {
  static const _tableName = 'taskentry';

  static const columnId = 'id';
  static const columnTaskId = 'taskid';
  static const columnDate = 'date';
  static const columnStartTime = 'starttime';
  static const columnEndTime = 'endtime';
  static const columnDuration = 'duration';
  static const columnInfo = 'info';
  static const columnCreated = 'created';
  static const columnModified = 'modified';

  @override
  String get tableName => _tableName;

  @override
  List<String> get columnNames => [
        columnId,
        columnTaskId,
        columnDate,
        columnStartTime,
        columnEndTime,
        columnDuration,
        columnInfo,
        columnCreated,
        columnModified,
      ];
}
