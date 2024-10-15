import 'package:simple_task_mate/database/data_base_contract.dart';

class StampContract implements IDataBaseContract {
  static const _tableName = 'stamp';

  static const columnId = 'id';
  static const columnType = 'type';
  static const columnTime = 'time';
  static const columnCreated = 'created';
  static const columnModified = 'modified';

  @override
  String get tableName => _tableName;

  @override
  List<String> get columnNames => [
        columnId,
        columnType,
        columnTime,
        columnCreated,
        columnModified,
      ];
}
