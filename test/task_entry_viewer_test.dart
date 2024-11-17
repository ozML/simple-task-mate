import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';
import 'package:simple_task_mate/widgets/task_entry_viewer.dart';

import '_test_utils.dart';

void main() {
  group('TaskEntryViewer -', () {
    testWidgets('Validate', (tester) async {
      Object? copiedTaskEntryData;
      int? deletedTaskEntryId;
      int? editTaskEntryId;

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (message) {
          if (message.method == 'Clipboard.setData') {
            copiedTaskEntryData = message.arguments['text'];
            return Future.value(message.arguments);
          }

          return null;
        },
      );

      await tester.pumpWidget(
        TestApp(
          child: TaskEntryViewer(
            title: testFullTasks.first.hRef ?? '',
            taskEntries: testFullTasks.first.entries?.toList() ?? [],
            onDelete: (taskEntry) => deletedTaskEntryId = taskEntry.id,
            onEdit: (taskEntry) => editTaskEntryId = taskEntry.id,
          ),
        ),
      );

      expect(find.byKey(TaskEntryViewer.keyItemTile), findsNWidgets(2));
      expect(find.byKey(ItemTile.keyTitle), findsNothing);
      expect(find.byKey(ItemTile.keySubTitle), findsOneWidget);
      expect(find.byKey(ItemTile.keyFootNote), findsNWidgets(2));

      expect(
        tester
            .widgetList<Text>(find.byKey(ItemTile.keySubTitle))
            .map((e) => e.data),
        ['First entry'],
      );
      expect(
        tester
            .widgetList<Text>(find.byKey(ItemTile.keyFootNote))
            .map((e) => e.data),
        ['Duration: 04:00', 'Duration: 02:30'],
      );

      expect(find.byKey(TaskEntryViewer.keyItemActionCopy), findsNothing);
      expect(find.byKey(TaskEntryViewer.keyItemActionDelete), findsNothing);
      expect(find.byKey(TaskEntryViewer.keyItemActionEdit), findsNothing);

      await tester.hoverOver(find.byKey(TaskEntryViewer.keyItemTile).first);

      expect(find.byKey(TaskEntryViewer.keyItemActionCopy), findsOneWidget);
      expect(find.byKey(TaskEntryViewer.keyItemActionDelete), findsOneWidget);
      expect(find.byKey(TaskEntryViewer.keyItemActionEdit), findsOneWidget);

      await tester.tap(find.byKey(TaskEntryViewer.keyItemActionCopy));
      expect(copiedTaskEntryData, 'First entry');

      await tester.tap(find.byKey(TaskEntryViewer.keyItemActionDelete));
      expect(deletedTaskEntryId, 0);

      await tester.tap(find.byKey(TaskEntryViewer.keyItemActionEdit));
      expect(editTaskEntryId, 0);
    });

    testWidgets('With date', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: TaskEntryViewer(
            title: testFullTasks.first.hRef ?? '',
            taskEntries: testFullTasks.first.entries?.toList() ?? [],
            showDate: true,
          ),
        ),
      );

      expect(
        tester
            .widgetList<Text>(find.byKey(ItemTile.keyFootNote))
            .map((e) => e.data),
        [
          '10/14/2024 | CW 42 | Duration: 04:00',
          '10/14/2024 | CW 42 | Duration: 02:30',
        ],
      );
    });
  });
}
