import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/extensions/date_time.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/widgets/viewers/stamp_entry_viewer.dart';
import 'package:simple_task_mate/widgets/time_input_field.dart';

import '_test_utils.dart';

void main() {
  group('StampEntryViewer -', () {
    testWidgets('Validate', (tester) async {
      bool toggledMode = false;
      bool savedStamp = false;

      await tester.pumpWidget(
        TestApp(
          child: StampEntryViewer(
            stamps: testStamps,
            date: testStamps.first.time.date,
            getTime: () => testStamps.last.time.add(const Duration(hours: 2)),
            isManualMode: false,
            onModeChanged: (value) => toggledMode = true,
            onSaveStamp: (stamp) => savedStamp = true,
          ),
        ),
      );

      expect(find.byKey(StampEntryViewer.keyButtonArrive), findsOneWidget);
      expect(find.byKey(StampEntryViewer.keyButtonLeave), findsOneWidget);
      expect(find.byKey(StampEntryViewer.keyManualTimeInput), findsNothing);
      expect(find.byKey(StampEntryTile.keyActionDelete), findsNothing);

      expect(find.byKey(StampEntryViewer.keyItemTile), findsNWidgets(4));
      expect(
        tester
            .widgetList<Text>(find.byKey(StampEntryTile.keyTypeText))
            .map((e) => e.data),
        ['Arrive', 'Leave', 'Arrive', 'Leave'],
      );
      expect(
        tester
            .widgetList<Text>(find.byKey(StampEntryTile.keyTimeText))
            .map((e) => e.data),
        ['08:00', '12:30', '13:00', '16:30'],
      );

      await tester.tap(find.byKey(StampEntryViewer.keyButtonArrive));
      expect(savedStamp, true);

      savedStamp = false;

      await tester.tap(find.byKey(StampEntryViewer.keyButtonLeave));
      expect(savedStamp, true);

      await tester.tap(find.byKey(StampEntryViewer.keyToggleStampMode));
      expect(toggledMode, true);

      await tester.hoverOver(find.byKey(StampEntryViewer.keyItemTile).first);
      expect(find.byKey(StampEntryTile.keyActionDelete), findsNothing);
    });

    testWidgets('Manual mode', (tester) async {
      bool toggledMode = false;
      StampType? savedStampMode;
      bool deletedStamp = false;

      await tester.pumpWidget(
        TestApp(
          child: StampEntryViewer(
            stamps: testStamps,
            date: testStamps.first.time.date,
            getTime: () => testStamps.last.time.add(const Duration(hours: 2)),
            onModeChanged: (value) => toggledMode = true,
            onDeleteStamp: (stamp) => deletedStamp = true,
          ),
        ),
      );

      expect(find.byKey(StampEntryViewer.keyButtonArrive), findsOneWidget);
      expect(find.byKey(StampEntryViewer.keyButtonLeave), findsOneWidget);
      expect(find.byKey(StampEntryViewer.keyManualTimeInput), findsOneWidget);
      expect(find.byKey(StampEntryTile.keyActionDelete), findsNothing);

      expect(find.byKey(StampEntryViewer.keyItemTile), findsNWidgets(4));

      await tester.tap(find.byKey(StampEntryViewer.keyToggleStampMode));
      expect(toggledMode, true);

      final gesture = await tester
          .hoverOver(find.byKey(StampEntryViewer.keyItemTile).first);
      expect(find.byKey(StampEntryTile.keyActionDelete), findsOneWidget);

      await tester.tap(find.byKey(StampEntryTile.keyActionDelete));
      expect(deletedStamp, true);

      await gesture.removePointer();
      await tester.pump();

      var inputField = tester.widget<TimeInputField>(
        find.byKey(StampEntryViewer.keyManualTimeInput),
      );
      expect(inputField.controller.text, isEmpty);

      await tester.tap(find.byKey(StampEntryViewer.keyButtonArrive));
      await tester.tap(find.byKey(StampEntryViewer.keyButtonLeave));
      expect(savedStampMode, isNull);

      // TODO: Find a way to test manual input and button interaction.
    });

    testWidgets('12 Hours format', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: StampEntryViewer(
            stamps: testStamps,
            date: testStamps.first.time.date,
            getTime: () => testStamps.last.time.add(const Duration(hours: 2)),
            clockTimeFormat: ClockTimeFormat.twelveHours,
          ),
        ),
      );

      expect(
        tester
            .widgetList<Text>(find.byKey(StampEntryTile.keyTimeText))
            .map((e) => e.data),
        ['08:00 AM', '12:30 PM', '01:00 PM', '04:30 PM'],
      );
    });

    testWidgets('Loading', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: StampEntryViewer(
            stamps: testStamps,
            date: testStamps.first.time.date,
            getTime: () => testStamps.last.time.add(const Duration(hours: 2)),
            isLoading: true,
          ),
        ),
      );

      expect(find.byKey(StampEntryViewer.keyItemTile), findsNothing);
      expect(find.byKey(StampEntryViewer.keyLoadingIndicator), findsOneWidget);
    });
  });
}
