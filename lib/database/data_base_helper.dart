import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class DataBaseHelper {
  DataBaseHelper({required this.dataBasePath});

  static int accessCounter = 0;

  final String dataBasePath;

  Future<Database> openConnection() =>
      databaseFactoryFfi.openDatabase(dataBasePath);

  Future<T?> dbAction<T>(Future<T?> Function(Database db) action) async {
    Database? db;
    try {
      accessCounter++;

      db = await openConnection();
      return action(db);
    } on Exception catch (_) {
    } finally {
      accessCounter--;

      if (accessCounter == 0) {
        db?.close();
      } else if (accessCounter < 0) {
        if (kDebugMode) {
          print('db access counter became negative');
        }
      }
    }

    return null;
  }
}
