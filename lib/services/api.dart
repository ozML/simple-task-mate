import 'package:equatable/equatable.dart';
import 'package:simple_task_mate/extensions/date_time.dart';
import 'package:simple_task_mate/extensions/object_extension.dart';

enum StampType {
  undefined,
  arrival,
  departure;

  StampType get opposite => switch (this) {
        StampType.arrival => StampType.departure,
        StampType.departure => StampType.arrival,
        _ => StampType.undefined,
      };
}

class Stamp with EquatableMixin {
  Stamp({
    required this.type,
    required this.time,
    this.createdAt,
    this.modifiedAt,
    this.id,
  });

  final int? id;
  final StampType type;
  final DateTime time;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  @override
  List<Object?> get props => [id, type, time, createdAt, modifiedAt];

  static Stamp fromMap(Map map) => Stamp(
        id: map['id'],
        type: switch (map['type']) {
          1 => StampType.arrival,
          2 => StampType.departure,
          _ => StampType.undefined,
        },
        time: DateTimeExtension.fromSecondsSinceEpoch(map['time']),
        createdAt: (map['created'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
        modifiedAt: (map['modified'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'type': type.index,
        'time': time.secondsSinceEpoch,
        'created': createdAt?.secondsSinceEpoch,
        'modified': modifiedAt?.secondsSinceEpoch,
      };

  Stamp copyWith({
    int? id,
    StampType? type,
    DateTime? time,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) =>
      Stamp(
        id: id ?? this.id,
        type: type ?? this.type,
        time: time ?? this.time,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );

  Stamp changeDateTo(DateTime date) {
    final targetDate = date.date;

    return copyWith(
      time: time.copyWith(
        year: targetDate.year,
        month: targetDate.month,
        day: targetDate.day,
      ),
    );
  }
}

class Task with EquatableMixin {
  Task({
    required this.name,
    this.refId,
    this.info,
    this.hRef,
    this.entries,
    this.createdAt,
    this.modifiedAt,
    this.id,
  });

  final int? id;
  final String? refId;
  final String name;
  final String? info;
  final String? hRef;
  final List<TaskEntry>? entries;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  @override
  List<Object?> get props => [
        id,
        refId,
        name,
        info,
        hRef,
        entries,
        createdAt,
        modifiedAt,
      ];

  static Task fromMap(Map map, {Map<String, String>? alias}) => Task(
        id: map[alias?['id'] ?? 'id'],
        refId: map[alias?['refid'] ?? 'refid'],
        name: map[alias?['name'] ?? 'name'],
        info: map[alias?['info'] ?? 'info'],
        hRef: map[alias?['href'] ?? 'href'],
        createdAt: (map[alias?['created'] ?? 'created'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
        modifiedAt: (map[alias?['modified'] ?? 'modified'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'refId': refId,
        'name': name,
        'info': info,
        'href': hRef,
        'created': createdAt?.secondsSinceEpoch,
        'modified': modifiedAt?.secondsSinceEpoch,
      };

  String fullName({String separator = ' - '}) =>
      [refId, name].nonNulls.join(separator);

  Duration time() =>
      entries?.fold<Duration>(
        Duration.zero,
        (previousValue, element) => previousValue + element.time(),
      ) ??
      Duration.zero;

  Task copyWith({
    int? id,
    String? refId,
    String? name,
    String? info,
    String? hRef,
    List<TaskEntry>? entries,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) =>
      Task(
        id: id ?? this.id,
        refId: refId ?? this.refId,
        name: name ?? this.name,
        info: info ?? this.info,
        hRef: hRef ?? this.hRef,
        entries: entries ?? this.entries,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );
}

class TaskEntry with EquatableMixin {
  TaskEntry({
    required this.taskId,
    required this.date,
    this.startTime,
    this.endTime,
    this.duration,
    this.info,
    this.createdAt,
    this.modifiedAt,
    this.id,
  }) : assert((startTime != null && endTime != null) ^ (duration != null));

  final int? id;
  final int taskId;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final Duration? duration;
  final String? info;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  @override
  List<Object?> get props => [
        id,
        taskId,
        date,
        startTime,
        endTime,
        duration,
        info,
        createdAt,
        modifiedAt,
      ];

  static TaskEntry fromMap(Map map, {Map<String, String>? alias}) => TaskEntry(
        id: map[alias?['id'] ?? 'id'],
        taskId: map[alias?['taskid'] ?? 'taskid'],
        date: DateTimeExtension.fromSecondsSinceEpoch(
          map[alias?['date'] ?? 'date'],
        ),
        startTime: (map[alias?['starttime'] ?? 'starttime'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
        endTime: (map[alias?['endtime'] ?? 'endtime'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
        duration: Duration(seconds: map[alias?['duration'] ?? 'duration']),
        info: map[alias?['info'] ?? 'info'],
        createdAt: (map[alias?['created'] ?? 'created'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
        modifiedAt: (map[alias?['modified'] ?? 'modified'] as int?)
            ?.mapTo(DateTimeExtension.fromSecondsSinceEpoch),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'taskid': taskId,
        'date': date.secondsSinceEpoch,
        'starttime': startTime?.secondsSinceEpoch,
        'endtime': endTime?.secondsSinceEpoch,
        'duration': duration?.inSeconds,
        'info': info,
        'created': createdAt?.secondsSinceEpoch,
        'modified': modifiedAt?.secondsSinceEpoch,
      };

  Duration time() {
    final duration = this.duration;
    final startTime = this.startTime;
    final endTime = this.endTime;

    if (duration != null) {
      return duration;
    } else if (startTime != null && endTime != null) {
      return endTime.difference(startTime);
    }

    return Duration.zero;
  }

  TaskEntry copyWith({
    int? id,
    int? taskId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    String? info,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) =>
      TaskEntry(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        duration: duration ?? this.duration,
        info: info ?? this.info,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );

  TaskEntry changeDateTo(DateTime date) {
    final targetDate = date.date;

    return copyWith(
      date: targetDate,
      startTime: startTime?.copyWith(
        year: targetDate.year,
        month: targetDate.month,
        day: targetDate.day,
      ),
      endTime: endTime?.copyWith(
        year: targetDate.year,
        month: targetDate.month,
        day: targetDate.day,
      ),
    );
  }
}

class StampSummary with EquatableMixin {
  StampSummary({required this.date, required this.duration});

  final DateTime date;
  final Duration duration;

  @override
  List<Object?> get props => [date, duration];
}

class TaskSummary with EquatableMixin {
  TaskSummary({
    required this.taskId,
    required this.name,
    required this.time,
    this.refId,
  });

  final int taskId;
  final String? refId;
  final String name;
  final Duration time;

  @override
  List<Object?> get props => [taskId, refId, name, time];

  String fullName({String separator = ' - '}) =>
      [refId, name].nonNulls.join(separator);

  Task toRef() => Task(id: taskId, refId: refId, name: name);
}
