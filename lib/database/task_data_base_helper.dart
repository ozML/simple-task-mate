import 'package:collection/collection.dart';
import 'package:properties/properties.dart';
import 'package:simple_task_mate/database/data_base_helper.dart';
import 'package:simple_task_mate/database/task_contract.dart';
import 'package:simple_task_mate/database/task_entry_contract.dart';
import 'package:simple_task_mate/extensions/date_time.dart';
import 'package:simple_task_mate/extensions/object_extension.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/data_base_utils.dart';

class TaskDataBaseHelper extends DataBaseHelper {
  TaskDataBaseHelper._({required super.dataBasePath});

  static TaskDataBaseHelper? _instance;

  final taskContract = TaskContract();
  final entryContract = TaskEntryContract();

  static TaskDataBaseHelper get instance {
    final properties = Properties.fromFile(propertiesPath);
    init(properties.get(settingDbFilePath) ?? '');

    final instance = _instance;
    if (instance == null) {
      throw Exception('Task db helper not initialized');
    }

    return instance;
  }

  static init(String dataBasePath) {
    _instance ??= TaskDataBaseHelper._(dataBasePath: dataBasePath);
  }

  Future<Task?> loadFilledTask({required int taskId}) => dbAction<Task>(
        (db) async {
          final taskTableName = taskContract.tableName;
          final taskColumnId = '$taskTableName.${TaskContract.columnId}';
          final taskColumnAlias = <String, String>{
            for (final columnName in taskContract.columnNames)
              columnName: '$taskTableName.$columnName',
          };

          final entryTableName = entryContract.tableName;
          final entryColumnTaskId =
              '$entryTableName.${TaskEntryContract.columnTaskId}';
          final entryColumnDate =
              '$entryTableName.${TaskEntryContract.columnDate}';
          final entryColumnAlias = <String, String>{
            for (final columnName in entryContract.columnNames)
              columnName: '$entryTableName.$columnName',
          };

          final selectColumnNames = [
            ...taskColumnAlias.values,
            ...entryColumnAlias.values
          ].map((e) => '$e AS `$e`').join(',');

          final query = '''
            SELECT $selectColumnNames
            FROM $taskTableName
            LEFT JOIN $entryTableName ON $entryColumnTaskId=$taskColumnId
            WHERE $taskColumnId = $taskId
            ORDER BY $entryColumnDate DESC
          ''';

          final data = await db.rawQuery(query);
          final groupedData = data.groupListsBy(
            (element) => element[taskColumnId],
          );
          final group = groupedData.values.first;

          final task = Task.fromMap(group.first, alias: taskColumnAlias);
          final taskEntries = group
              .where((element) => element[entryColumnTaskId] != null)
              .map((e) => TaskEntry.fromMap(e, alias: entryColumnAlias))
              .toList();

          return task.copyWith(entries: taskEntries);
        },
      );

  Future<List<Task>> loadTasks({String? searchText}) => dbAction<List<Task>>(
        (db) async {
          final taskTableName = taskContract.tableName;
          final taskColumnId = '$taskTableName.${TaskContract.columnId}';
          final taskColumnRefId = '$taskTableName.${TaskContract.columnRefId}';
          final taskColumnName = '$taskTableName.${TaskContract.columnName}';
          final taskColumnAlias = <String, String>{
            for (final columnName in taskContract.columnNames)
              columnName: '$taskTableName.$columnName',
          };

          final entryTableName = entryContract.tableName;
          final entryColumnTaskId =
              '$entryTableName.${TaskEntryContract.columnTaskId}';
          final entryColumnModified =
              '$entryTableName.${TaskEntryContract.columnModified}';
          final entryColumnCreated =
              '$entryTableName.${TaskEntryContract.columnCreated}';

          final selectColumnNames =
              [...taskColumnAlias.values].map((e) => '$e AS `$e`').join(',');

          final searchQueryParts = searchText != null && searchText.isNotEmpty
              ? searchText.split(r'\s+').map((e) => '%$e%').toList()
              : null;
          final searchQuery = searchQueryParts
              ?.expandIndexed((i, e) => [
                    '$taskColumnRefId LIKE ?${i + 1}',
                    '$taskColumnName LIKE ?${i + 1}',
                  ])
              .join(' OR ');

          final where = searchQuery?.mapTo((e) => 'WHERE $e') ?? '';

          final query = '''
            SELECT $selectColumnNames
            FROM $taskTableName
            LEFT JOIN $entryTableName ON $entryColumnTaskId=$taskColumnId
            $where
            GROUP BY $taskColumnId
            ORDER BY
              MAX($entryColumnCreated) DESC,
              MAX($entryColumnModified) DESC
          ''';

          final data = await db.rawQuery(query, searchQueryParts);

          return data
              .map((e) => Task.fromMap(e, alias: taskColumnAlias))
              .toList();
        },
      ).then((value) => value ?? []);

  Future<List<Task>> loadFilledTasks({
    DateTime? start,
    DateTime? end,
    OrderBy orderBy = const OrderBy.none(),
  }) =>
      dbAction<List<Task>>(
        (db) async {
          final startDate = start?.date;
          final endDate = end?.date;

          final taskTableName = taskContract.tableName;
          final taskColumnId = '$taskTableName.${TaskContract.columnId}';
          final taskColumnRefId = '$taskTableName.${TaskContract.columnRefId}';
          final taskColumnName = '$taskTableName.${TaskContract.columnName}';
          final taskColumnAlias = <String, String>{
            for (final columnName in taskContract.columnNames)
              columnName: '$taskTableName.$columnName',
          };

          final entryTableName = entryContract.tableName;
          final entryColumnId = '$entryTableName.${TaskEntryContract.columnId}';
          final entryColumnTaskId =
              '$entryTableName.${TaskEntryContract.columnTaskId}';
          final entryColumnDate =
              '$entryTableName.${TaskEntryContract.columnDate}';
          final entryColumnAlias = <String, String>{
            for (final columnName in entryContract.columnNames)
              columnName: '$entryTableName.$columnName',
          };

          final selectColumnNames = [
            ...taskColumnAlias.values,
            ...entryColumnAlias.values
          ].map((e) => '$e AS `$e`').join(',');

          final String order;
          if (!orderBy.isEmpty) {
            order = orderBy.statement;
          } else {
            order = '''
              ORDER BY
                $taskColumnRefId ASC,
                $taskColumnName ASC,
                $entryColumnId ASC
          ''';
          }

          final where = [
            if (startDate != null)
              '$entryColumnDate >= ${startDate.secondsSinceEpoch}',
            if (endDate != null)
              '$entryColumnDate < ${endDate.secondsSinceEpoch}',
          ].join(' AND ').mapTo((e) => e.isNotEmpty ? 'WHERE $e' : '');
          final query = '''
            SELECT $selectColumnNames
            FROM $taskTableName
            LEFT JOIN $entryTableName ON $entryColumnTaskId=$taskColumnId
            $where
            $order
          ''';

          final data = await db.rawQuery(query);
          final groupedData = data.groupListsBy(
            (element) => element[taskColumnId],
          );

          final result = <Task>[];
          for (final group in groupedData.values) {
            final task = Task.fromMap(group.first, alias: taskColumnAlias);
            final taskEntries = group
                .where((element) => element[entryColumnTaskId] != null)
                .map((e) => TaskEntry.fromMap(e, alias: entryColumnAlias))
                .toList();

            result.add(task.copyWith(entries: taskEntries));
          }

          return result;
        },
      ).then((value) => value ?? []);

  Future<List<Task>> loadFilledTasksForDate(
    DateTime date, {
    OrderBy orderBy = const OrderBy.none(),
  }) =>
      loadFilledTasks(
        start: date,
        end: date.add(const Duration(days: 1)),
      );

  Future<int> insertTask(Task task) => dbAction<int>(
        (db) async {
          final tableName = taskContract.tableName;

          return db.insert(
            tableName,
            task.copyWith(createdAt: DateTime.now()).toMap(),
          );
        },
      ).then((value) => value ?? 0);

  Future<int> updateTask(Task task) => dbAction<int>(
        (db) async {
          const columnId = TaskContract.columnId;
          final tableName = taskContract.tableName;

          return db.update(
            tableName,
            task.copyWith(modifiedAt: DateTime.now()).toMap(),
            where: '$columnId = ?',
            whereArgs: [task.id],
          );
        },
      ).then((value) => value ?? 0);

  Future<int> deleteTask(Task task) => dbAction<int>(
        (db) async {
          const entryColumnTaskId = TaskEntryContract.columnTaskId;
          final entryTableName = entryContract.tableName;

          return db.delete(
            entryTableName,
            where: '$entryColumnTaskId = ?',
            whereArgs: [task.id],
          );
        },
      ).then(
        (_) => dbAction<int>(
          (db) async {
            const taskColumnId = TaskContract.columnId;
            final taskTableName = taskContract.tableName;

            return db.delete(
              taskTableName,
              where: '$taskColumnId = ?',
              whereArgs: [task.id],
            );
          },
        ).then((value) => value ?? 0),
      );

  Future<int> insertTaskEntry(TaskEntry taskEntry) => dbAction<int>(
        (db) async {
          final tableName = entryContract.tableName;

          return db.insert(
            tableName,
            taskEntry.copyWith(createdAt: DateTime.now()).toMap(),
          );
        },
      ).then((value) => value ?? 0);

  Future<int> updateTaskEntry(TaskEntry taskEntry) => dbAction<int>(
        (db) async {
          const columnId = TaskEntryContract.columnId;
          final tableName = entryContract.tableName;

          return db.update(
            tableName,
            taskEntry.copyWith(modifiedAt: DateTime.now()).toMap(),
            where: '$columnId = ?',
            whereArgs: [taskEntry.id],
          );
        },
      ).then((value) => value ?? 0);

  Future<int> deleteTaskEntry(TaskEntry taskEntry) => dbAction<int>(
        (db) async {
          const columnId = TaskEntryContract.columnId;
          final tableName = entryContract.tableName;

          return db.delete(
            tableName,
            where: '$columnId = ?',
            whereArgs: [taskEntry.id],
          );
        },
      ).then((value) => value ?? 0);

  Future<int> deleteTaskEntries(List<TaskEntry> taskEntries) => dbAction<int>(
        (db) async {
          if (taskEntries.isEmpty) {
            return 0;
          }

          const columnId = TaskEntryContract.columnId;
          final tableName = entryContract.tableName;

          final targetIds =
              taskEntries.map((e) => e.id).whereNotNull().toList().join(',');

          return db.delete(
            tableName,
            where: '$columnId IN ($targetIds)',
          );
        },
      ).then((value) => value ?? 0);

  Future<int> deleteTaskEntriesInRange({
    required Task task,
    DateTime? start,
    DateTime? end,
    OrderBy orderBy = const OrderBy.none(),
  }) =>
      dbAction<int>(
        (db) async {
          final startDate = start?.date;
          final endDate = end?.date;

          final entryTableName = entryContract.tableName;
          final entryColumnTaskId =
              '$entryTableName.${TaskEntryContract.columnTaskId}';
          final entryColumnDate =
              '$entryTableName.${TaskEntryContract.columnDate}';

          final where = [
            '$entryColumnTaskId == ${task.id}',
            if (startDate != null)
              '$entryColumnDate >= ${startDate.secondsSinceEpoch}',
            if (endDate != null)
              '$entryColumnDate < ${endDate.secondsSinceEpoch}',
          ].join(' AND ');

          return db.delete(entryTableName, where: where);
        },
      ).then((value) => value ?? 0);

  Future<int> deleteTaskEntriesForDate(Task task, DateTime date) =>
      deleteTaskEntriesInRange(
        task: task,
        start: date,
        end: date.add(const Duration(days: 1)),
      );

  Future<List<TaskSummary>> loadSummaries({
    String? searchText,
  }) =>
      dbAction<List<TaskSummary>>(
        (db) async {
          final taskTableName = taskContract.tableName;
          final taskColumnId = '$taskTableName.${TaskContract.columnId}';
          final taskColumnRefId = '$taskTableName.${TaskContract.columnRefId}';
          final taskColumnName = '$taskTableName.${TaskContract.columnName}';
          final taskColumnAlias = <String, String>{
            for (final columnName in taskContract.columnNames)
              columnName: '$taskTableName.$columnName',
          };

          final entryTableName = entryContract.tableName;
          final entryColumnId = '$entryTableName.${TaskEntryContract.columnId}';
          final entryColumnTaskId =
              '$entryTableName.${TaskEntryContract.columnTaskId}';
          final entryColumnAlias = <String, String>{
            for (final columnName in entryContract.columnNames)
              columnName: '$entryTableName.$columnName',
          };

          final selectColumnNames = [
            ...taskColumnAlias.values,
            ...entryColumnAlias.values
          ].map((e) => '$e AS `$e`').join(',');

          final searchQueryParts = searchText != null && searchText.isNotEmpty
              ? searchText.split(r'\s+').map((e) => '%$e%').toList()
              : null;
          final searchQuery = searchQueryParts
              ?.expandIndexed((i, e) => [
                    '$taskColumnRefId LIKE ?${i + 1}',
                    '$taskColumnName LIKE ?${i + 1}',
                  ])
              .join(' OR ');

          final where = searchQuery?.mapTo((e) => 'WHERE $e') ?? '';

          final query = '''
            SELECT $selectColumnNames
            FROM $taskTableName
            LEFT JOIN $entryTableName ON $entryColumnTaskId=$taskColumnId
            $where
            ORDER BY
                $taskColumnRefId ASC,
                $taskColumnName ASC,
                $entryColumnId ASC
          ''';

          final data = await db.rawQuery(query, searchQueryParts);
          final groupedData = data.groupListsBy(
            (element) => element[taskColumnId],
          );

          final result = <TaskSummary>[];
          for (final group in groupedData.values) {
            final task = Task.fromMap(group.first, alias: taskColumnAlias);
            final taskEntries = group
                .where((element) => element[entryColumnTaskId] != null)
                .map((e) => TaskEntry.fromMap(e, alias: entryColumnAlias))
                .toList();

            result.add(
              TaskSummary(
                taskId: task.id ?? 0,
                refId: task.refId,
                name: task.name,
                time: taskEntries.fold(
                  Duration.zero,
                  (previousValue, element) => previousValue + element.time(),
                ),
              ),
            );
          }

          return result;
        },
      ).then((value) => value ?? []);
}
