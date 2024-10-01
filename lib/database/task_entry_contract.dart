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

  static const columnIdDef = '$columnId  INTEGER PRIMARY KEY AUTOINCREMENT';
  static const columnTaskIdDef = '$columnTaskId  INTEGER NOT NULL';
  static const columnDateDef = '$columnDate  INTEGER NOT NULL';
  static const columnStartTimeDef = '$columnStartTime  INTEGER';
  static const columnEndTimeDef = '$columnEndTime  INTEGER';
  static const columnDurationDef = '$columnDuration  INTEGER';
  static const columnInfoDef = '$columnInfo  TEXT';
  static const columnCreatedDef = '$columnCreated  INTEGER NOT NULL';
  static const columnModifiedDef = '$columnModified  INTEGER';

  static const _createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $_tableName (
      $columnIdDef,
      $columnTaskIdDef,
      $columnDateDef,
      $columnStartTimeDef,
      $columnEndTimeDef,
      $columnDurationDef,
      $columnInfoDef,
      $columnCreatedDef,
      $columnModifiedDef
    )
  ''';

  static const _deleteQuery = 'DELETE FROM $_tableName WHERE $columnId = {0}';
  static const _selectQuery = 'SELECT * FROM $_tableName WHERE $columnId = {0}';

  @override
  String get version => '1.0';

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

  @override
  Map<String, String> get columnDefinitions => {
        columnId: columnIdDef,
        columnTaskId: columnTaskIdDef,
        columnDate: columnDateDef,
        columnStartTime: columnStartTimeDef,
        columnEndTime: columnEndTimeDef,
        columnDuration: columnDurationDef,
        columnInfo: columnInfoDef,
        columnCreated: columnCreatedDef,
        columnModified: columnModifiedDef,
      };

  @override
  String get createTableQuery => _createTableQuery;

  @override
  List<String>? get indexQueries => [
        'CREATE INDEX IF NOT EXISTS idx_${_tableName}_$columnTaskId ON $_tableName($columnTaskId)'
      ];

  @override
  String get selectQuery => _selectQuery;

  @override
  String get deleteQuery => _deleteQuery;

  @override
  String getColumnDefinition(String columnName) =>
      columnDefinitions[columnName] ?? '';
}
