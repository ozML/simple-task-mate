import 'package:simple_task_mate/database/data_base_contract.dart';

class StampContract implements IDataBaseContract {
  static const _tableName = 'stamp';

  static const columnId = 'id';
  static const columnType = 'type';
  static const columnTime = 'time';
  static const columnCreated = 'created';
  static const columnModified = 'modified';

  static const columnIdDef = '$columnId INTEGER PRIMARY KEY AUTOINCREMENT';
  static const columnTypeDef = '$columnType INTEGER NOT NULL';
  static const columnTimeDef = '$columnTime INTEGER NOT NULL';
  static const columnCreatedDef = '$columnCreated INTEGER NOT NULL';
  static const columnModifiedDef = '$columnModified INTEGER';

  static const _createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $_tableName (
      $columnIdDef,
      $columnTypeDef,
      $columnTimeDef,
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
        columnType,
        columnTime,
        columnCreated,
        columnModified,
      ];

  @override
  Map<String, String> get columnDefinitions => {
        columnId: columnIdDef,
        columnType: columnTypeDef,
        columnTime: columnTimeDef,
        columnCreated: columnCreatedDef,
        columnModified: columnModifiedDef,
      };

  @override
  String get createTableQuery => _createTableQuery;

  @override
  List<String>? get indexQueries => null;

  @override
  String get selectQuery => _selectQuery;

  @override
  String get deleteQuery => _deleteQuery;

  @override
  String getColumnDefinition(String columnName) =>
      columnDefinitions[columnName] ?? '';
}
