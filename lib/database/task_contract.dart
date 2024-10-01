import 'package:simple_task_mate/database/data_base_contract.dart';

class TaskContract implements IDataBaseContract {
  static const _tableName = 'task';

  static const columnId = 'id';
  static const columnRefId = 'refid';
  static const columnName = 'name';
  static const columnInfo = 'info';
  static const columnCreated = 'created';
  static const columnModified = 'modified';

  static const columnIdDef = '$columnId INTEGER PRIMARY KEY AUTOINCREMENT';
  static const columnRefIdDef = '$columnRefId TEXT';
  static const columnNameDef = '$columnName TEXT NOT NULL';
  static const columnInfoDef = '$columnInfo TEXT';
  static const columnCreatedDef = '$columnCreated INTEGER NOT NULL';
  static const columnModifiedDef = '$columnModified INTEGER';

  static const _createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $_tableName (
      $columnIdDef,
      $columnRefIdDef,
      $columnNameDef,
      $columnInfoDef,
      $columnCreatedDef,
      $columnModifiedDef
    )
  ''';
  static const _deleteQuery =
      'DELETE FROM $_tableName WHERE $columnId = \'{0}\'';
  static const _selectQuery =
      'SELECT * FROM $_tableName WHERE $columnId = \'{0}\'';

  @override
  String get version => '1.0';

  @override
  String get tableName => _tableName;

  @override
  List<String> get columnNames => [
        columnId,
        columnRefId,
        columnName,
        columnInfo,
        columnCreated,
        columnModified,
      ];

  @override
  Map<String, String> get columnDefinitions => {
        columnId: columnIdDef,
        columnRefId: columnRefIdDef,
        columnName: columnNameDef,
        columnInfo: columnInfoDef,
        columnCreated: columnCreated,
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
