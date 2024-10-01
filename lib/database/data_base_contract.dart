abstract interface class IDataBaseContract {
  String get version;
  String get tableName;
  List<String> get columnNames;
  Map<String, String> get columnDefinitions;
  String get createTableQuery;
  List<String>? get indexQueries;
  String get selectQuery;
  String get deleteQuery;

  String getColumnDefinition(String columnName);
}
