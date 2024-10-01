import 'package:collection/collection.dart';
import 'package:simple_task_mate/services/api.dart';

Duration getPresentnessTime(List<Stamp> stamps) {
  final start = stamps
      .firstWhereOrNull((element) => element.type == StampType.arrival)
      ?.time;
  final end = stamps
      .lastWhereOrNull((element) => element.type == StampType.departure)
      ?.time;

  return start != null && end != null ? end.difference(start) : Duration.zero;
}

Duration getWorkTime(List<Stamp> stamps) {
  Duration sum = Duration.zero;

  DateTime? start;
  for (int i = 0; i < stamps.length; i++) {
    final stamp = stamps[i];
    if (stamp.type == StampType.arrival) {
      start = stamp.time;
    } else if (stamp.type == StampType.departure && start != null) {
      sum += stamp.time.difference(start);
      start = null;
    }
  }

  return sum;
}

Duration getPauseTime(List<Stamp> stamps) {
  Duration sum = Duration.zero;

  DateTime? start;
  for (int i = 0; i < stamps.length; i++) {
    final stamp = stamps[i];
    if (stamp.type == StampType.departure) {
      start = stamp.time;
    } else if (stamp.type == StampType.arrival && start != null) {
      sum += stamp.time.difference(start);
      start = null;
    }
  }

  return sum;
}
