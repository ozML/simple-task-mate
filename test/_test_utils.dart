import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/services/api.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestApp extends StatelessWidget {
  const TestApp({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: child,
      );
}

/// Week 42, 2024, Mo - So
final testWeek = [
  DateTime(2024, 10, 14),
  DateTime(2024, 10, 15),
  DateTime(2024, 10, 16),
  DateTime(2024, 10, 17),
  DateTime(2024, 10, 18),
  DateTime(2024, 10, 19),
  DateTime(2024, 10, 20),
];

final testDateTime = testWeek.last.copyWith(hour: 20, minute: 30);

final testStamps = [
  Stamp(type: StampType.arrival, time: testWeek.first.copyWith(hour: 8)),
  Stamp(
    type: StampType.departure,
    time: testWeek.first.copyWith(hour: 12, minute: 30),
  ),
  Stamp(type: StampType.arrival, time: testWeek.first.copyWith(hour: 13)),
  Stamp(
    type: StampType.departure,
    time: testWeek.first.copyWith(hour: 16, minute: 30),
  ),
];

final testFullTasks = [
  Task(
    id: 0,
    name: 'task0',
    refId: 'ref0',
    info: 'First task',
    entries: [
      TaskEntry(
        id: 0,
        taskId: 0,
        date: testWeek.first,
        duration: const Duration(hours: 4),
        info: 'First entry',
      ),
      TaskEntry(
        id: 1,
        taskId: 0,
        date: testWeek.first,
        duration: const Duration(hours: 2, minutes: 30),
      ),
    ],
  ),
  Task(
    id: 1,
    name: 'task1',
    entries: [
      TaskEntry(
        id: 2,
        taskId: 1,
        date: testWeek.first,
        duration: const Duration(minutes: 15),
      ),
    ],
  ),
];

final testTaskSummaries = [
  TaskSummary(
    taskId: 0,
    refId: 'ref0',
    name: 'task0',
    time: const Duration(hours: 6, minutes: 30),
  ),
  TaskSummary(
    taskId: 1,
    name: 'task1',
    time: const Duration(minutes: 15),
  ),
];

extension WidgetTesterExtension on WidgetTester {
  Future<void> hoverOver(Finder finder) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await pump();
    await gesture.moveTo(getCenter(finder));
    await pumpAndSettle();
  }
}
