import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:simple_task_mate/database/stamp_contract.dart';
import 'package:simple_task_mate/database/task_contract.dart';
import 'package:simple_task_mate/database/task_entry_contract.dart';

class DatabBaseMigrationHelper {
  DatabBaseMigrationHelper._();

  static const dataBaseVersion = 1;

  static Future<void> init(String dataBasePath) async {
    await databaseFactoryFfi.openDatabase(
      dataBasePath,
      options: OpenDatabaseOptions(
        version: dataBaseVersion,
        onCreate: (db, version) => upgrade(db, 0, version),
        onUpgrade: (db, oldVersion, newVersion) =>
            upgrade(db, oldVersion, newVersion),
      ),
    );
  }

  static Future<void> upgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    for (int version = oldVersion; version < newVersion; version++) {
      switch (version + 1) {
        case 1:
          await updateToVersion1(db);
          break;
      }
    }
  }

  static Future<void> updateToVersion1(Database db) async {
    final stampContract = StampContract();
    final taskContract = TaskContract();
    final taskEntryContract = TaskEntryContract();

    await db.execute(stampContract.createTableQuery);
    await db.execute(taskContract.createTableQuery);
    await db.execute(taskEntryContract.createTableQuery);

    final indexQueries = [
      ...?stampContract.indexQueries,
      ...?taskContract.indexQueries,
      ...?taskEntryContract.indexQueries,
    ];

    for (final indexQuery in indexQueries) {
      await db.execute(indexQuery);
    }
  }
}
