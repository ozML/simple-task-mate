import 'package:simple_task_mate/database/data_base_contract.dart';

class TaskContract implements IDataBaseContract {
  static const _tableName = 'task';

  static const columnId = 'id';
  static const columnRefId = 'refid';
  static const columnName = 'name';
  static const columnInfo = 'info';
  static const columnHRef = 'href';
  static const columnCreated = 'created';
  static const columnModified = 'modified';

  @override
  String get tableName => _tableName;

  @override
  List<String> get columnNames => [
        columnId,
        columnRefId,
        columnName,
        columnInfo,
        columnHRef,
        columnCreated,
        columnModified,
      ];
}
