import 'package:properties/properties.dart';
import 'package:simple_task_mate/database/data_base_helper.dart';
import 'package:simple_task_mate/database/stamp_contract.dart';
import 'package:simple_task_mate/extensions/date_time.dart';
import 'package:simple_task_mate/extensions/object_extension.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/data_base_utils.dart';
import 'package:simple_task_mate/utils/time_summary_utils.dart';

class StampDataBaseHelper extends DataBaseHelper {
  StampDataBaseHelper._({required super.dataBasePath});

  static StampDataBaseHelper? _instance;

  final contract = StampContract();

  static StampDataBaseHelper get instance {
    final properties = Properties.fromFile(propertiesPath);
    init(properties.get(settingDbFilePath) ?? '');

    final instance = _instance;
    if (instance == null) {
      throw Exception('Stamp db helper not initialized');
    }

    return instance;
  }

  static init(String dataBasePath) {
    _instance ??= StampDataBaseHelper._(dataBasePath: dataBasePath);
  }

  Future<List<Stamp>> loadStamps({
    DateTime? start,
    DateTime? end,
    OrderBy orderBy = const OrderBy.none(),
  }) =>
      dbAction<List<Stamp>>(
        (db) async {
          final startDate = start?.date;
          final endDate = end?.date;

          const columnTime = StampContract.columnTime;
          final tableName = contract.tableName;

          final where = [
            if (startDate != null)
              '$columnTime >= ${startDate.secondsSinceEpoch}',
            if (endDate != null) '$columnTime < ${endDate.secondsSinceEpoch}',
          ].join(' AND ').mapTo((e) => e.isNotEmpty ? 'WHERE $e' : '');

          final query = '''
            SELECT *
            FROM $tableName
            $where
            ${orderBy.statement}
          ''';

          final data = await db.rawQuery(query);

          return data.map(Stamp.fromMap).toList();
        },
      ).then((value) => value ?? []);

  Future<List<Stamp>> loadStampsForDate(
    DateTime date, {
    OrderBy orderBy = const OrderBy.none(),
  }) =>
      loadStamps(
        start: date,
        end: date.add(const Duration(days: 1)),
        orderBy: orderBy,
      );

  Future<int> insertStamp(Stamp stamp) => dbAction<int>(
        (db) async {
          final tableName = contract.tableName;

          return db.insert(
            tableName,
            stamp.copyWith(createdAt: DateTime.now()).toMap(),
          );
        },
      ).then((value) => value ?? 0);

  Future<int> deleteStamp(Stamp stamp) => dbAction<int>(
        (db) async {
          const columnId = StampContract.columnId;
          final tableName = contract.tableName;

          return db.delete(
            tableName,
            where: '$columnId = ?',
            whereArgs: [stamp.id],
          );
        },
      ).then((value) => value ?? 0);

  Future<List<StampSummary>> loadSummaries({
    required DateTime start,
    required DateTime end,
  }) =>
      dbAction<List<StampSummary>>(
        (db) async {
          final startDate = start.date;
          final endDate = end.date;
          final dates = [
            for (int i = 0; i < endDate.difference(start).inDays; i++)
              startDate.add(Duration(days: i))
          ];

          const columnTime = StampContract.columnTime;
          final tableName = contract.tableName;

          final batch = db.batch();

          for (final currentStartDate in dates) {
            final currentEndDate = currentStartDate.add(
              const Duration(days: 1),
            );

            final query = '''
              SELECT *
              FROM $tableName
              WHERE $columnTime >= ${currentStartDate.secondsSinceEpoch}
              AND $columnTime < ${currentEndDate.secondsSinceEpoch}
            ''';

            batch.rawQuery(query);
          }

          final batchResult = await batch.commit();

          final result = <StampSummary>[];
          for (int i = 0; i < dates.length; i++) {
            final date = dates[i];
            final stamps =
                (batchResult[i] as List<Map>).map(Stamp.fromMap).toList();

            result.add(StampSummary(date: date, duration: getWorkTime(stamps)));
          }

          return result;
        },
      ).then((value) => value ?? []);

  Future<List<StampSummary>> loadSummariesForDate(
    DateTime date,
  ) =>
      loadSummaries(
        start: date,
        end: date.add(const Duration(days: 1)),
      );
}
