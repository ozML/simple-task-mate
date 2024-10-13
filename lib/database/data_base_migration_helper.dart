import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    const createStampTableQuery = '''
    CREATE TABLE IF NOT EXISTS stamp (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type INTEGER NOT NULL,
      time INTEGER NOT NULL,
      created INTEGER NOT NULL,
      modified INTEGER
    )
  ''';

    const createTaskTableQuery = '''
    CREATE TABLE IF NOT EXISTS task (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      refid TEXT,
      name TEXT NOT NULL,
      info TEXT,
      created INTEGER NOT NULL,
      modified INTEGER
    )
  ''';

    const createTaskEntryTableQuery = '''
    CREATE TABLE IF NOT EXISTS taskentry (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskid INTEGER NOT NULL,
      date INTEGER NOT NULL,
      starttime INTEGER,
      endtime INTEGER,
      duration INTEGER,
      info TEXT,
      created INTEGER NOT NULL,
      modified INTEGER
    )
  ''';

    final indexQueries = [
      'CREATE INDEX IF NOT EXISTS idx_taskentry_taskid ON taskentry(taskid)'
    ];

    await db.execute(createStampTableQuery);
    await db.execute(createTaskTableQuery);
    await db.execute(createTaskEntryTableQuery);

    for (final indexQuery in indexQueries) {
      await db.execute(indexQuery);
    }
  }

  static Future<void> updateToVersion2(Database db) async {
    const alterTaskTableQuery = '''
    ALTER TABLE task
    ADD 
    ''';

    await db.execute(alterTaskTableQuery);
  }
}
