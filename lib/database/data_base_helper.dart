import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class DataBaseHelper {
  DataBaseHelper({required this.dataBasePath});

  final String dataBasePath;

  Future<Database> openConnection() =>
      databaseFactoryFfi.openDatabase(dataBasePath);

  Future<T?> dbAction<T>(Future<T?> Function(Database db) action) async {
    Database? db;
    try {
      db = await openConnection();
      return action(db);
    } on Exception catch (_) {
    } finally {
      db?.close();
    }

    return null;
  }
}
